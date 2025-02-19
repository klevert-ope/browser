# Use a base image with a headless browser
FROM selenium/standalone-chrome:latest

# Install noVNC and dependencies
RUN --mount=type=cache,target=/var/cache/apt \
    sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends \
        git \
        python3-pip \
        websockify \
        x11vnc && \
    rm -rf /var/lib/apt/lists/* && \
    sudo pip3 install --no-cache-dir numpy && \
    git clone https://github.com/novnc/noVNC.git /opt/noVNC && \
    ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# Expose VNC and noVNC ports
EXPOSE 5900 6080

# Start VNC and noVNC
CMD ["bash", "-c", "x11vnc -forever -create -rfbport 5900 & /opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 6080"]
