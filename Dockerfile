FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && apt-get install -y \
    firefox \
    tigervnc-standalone-server \
    fluxbox \
    websockify \
    novnc \
    x11vnc \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# Create a user for running the browser
RUN useradd -m browseruser

# Set up a VNC password
RUN mkdir -p /home/browseruser/.vnc && \
    echo "vncpassword" | vncpasswd -f > /home/browseruser/.vnc/passwd && \
    chmod 600 /home/browseruser/.vnc/passwd && \
    chown -R browseruser:browseruser /home/browseruser/.vnc

# Switch to non-root user
USER browseruser
WORKDIR /home/browseruser

# Start VNC server and browser
CMD ["sh", "-c", "Xvfb :1 -screen 0 1024x768x16 & fluxbox & x11vnc -display :1 -forever -usepw -shared & websockify --web /usr/share/novnc/ 5901 localhost:5900"]
