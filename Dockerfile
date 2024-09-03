# Use debian:latest as the base image
FROM debian:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages, including common ones and additional tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sudo \
    xterm \
    git \
    curl \
    wget \
    vim \
    nano \
    htop \
    unzip \
    tar \
    net-tools \
    clang \
    openjdk-11-jdk \
    inotify-tools \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Node.js and npm from NodeSource
RUN curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install wetty globally
RUN npm install -g wetty

# Create a user with root privileges
RUN useradd -m -s /bin/bash terminal_user && \
    echo 'terminal_user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set the user to the non-root user
USER terminal_user

# Expose port 3000 for wetty
EXPOSE 3000

# Start wetty on port 3000 with bash as the default shell
CMD ["wetty", "--port", "3000", "--command", "/bin/bash"]
