# Base image with a GUI
FROM ubuntu:20.04

# Install graphical utilities, browser, and VNC
RUN apt-get update && apt-get install -y \
    firefox \
    tigervnc-standalone-server \
    fluxbox \
    novnc \
    x11vnc \
    xvfb

# Create a non-root user for security
RUN useradd -m browseruser

# Set up VNC password and directories
RUN mkdir -p /home/browseruser/.vnc && \
    echo "vncpassword" | vncpasswd -f > /home/browseruser/.vnc/passwd && \
    chmod 600 /home/browseruser/.vnc/passwd && \
    chown -R browseruser:browseruser /home/browseruser/.vnc

# Switch to non-root user
USER browseruser
WORKDIR /home/browseruser

# Start VNC server, window manager, and noVNC
CMD ["sh", "-c", "Xvfb :1 -screen 0 1024x768x16 & fluxbox & x11vnc -display :1 -forever -usepw -shared & websockify --web /usr/share/novnc/ 8080 localhost:5900"]
