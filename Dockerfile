# Use a lightweight Python base image
FROM python:3.11-slim

# Set non-interactive mode to prevent installation prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        websockify \
        x11vnc \
        wget \
        unzip \
        xvfb \
        curl && \
    rm -rf /var/lib/apt/lists/*

# Install Chrome manually
RUN wget -q -O chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y ./chrome.deb && \
    rm chrome.deb

# Install Selenium & Python dependencies
RUN pip install --no-cache-dir selenium numpy

# Clone noVNC and setup
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC && \
    ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# Expose VNC and noVNC ports
EXPOSE 5900 6080

# Start X11 VNC and noVNC server
CMD ["bash", "-c", "x11vnc -forever -create -rfbport 5900 & /opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 6080"]
