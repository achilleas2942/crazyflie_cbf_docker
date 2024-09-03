# FROM ros:noetic as base
FROM ros:noetic-ros-core-focal

# ros required dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    python3-rosdep \
    python3-rosinstall \
    python3-vcstools \
    && rm -rf /var/lib/apt/lists/*

# minimal required dependencies
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
    curl ca-certificates gnupg udev lsb-release wget udev \
    sockstat pip git nano vim net-tools iputils-ping iproute2 htop \
    libeigen3-dev netcat iperf3 libusb-1.0-0-dev \
    linux-tools-common linux-tools-generic linux-tools-$(uname -r)

RUN pip3 install cvxpy

# setup ssh key
ARG SSH_PRIVATE_KEY
ARG SSH_PRIVATE_KEY_PUB

# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan github.com > /root/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa && \
    echo "$SSH_PRIVATE_KEY_PUB" > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub

RUN echo "IdentityFile /root/.ssh/id_rsa" >> /etc/ssh/ssh_config

# catkin build
RUN mkdir -p /root/catkin_ws/src && cd /root/catkin_ws/

# Setup crazyflie udev rules
RUN echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="7777", MODE="0664", GROUP="plugdev"' | sudo tee /etc/udev/rules.d/99-crazyradio.rules && \
    echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="0101", MODE="0664", GROUP="plugdev"' | sudo tee -a /etc/udev/rules.d/99-crazyradio.rules
RUN echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", MODE="0664", GROUP="plugdev"' | sudo tee /etc/udev/rules.d/99-crazyflie.rules

# Initialize rosdep
RUN rosdep init && \
    rosdep update --rosdistro $ROS_DISTRO

# Install ROS base packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-noetic-tf2 \
    ros-noetic-tf \
    ros-noetic-tf-conversions \
    ros-noetic-ros-base=1.5.0-1* \
    && rm -rf /var/lib/apt/lists/*

# Create an entrypoint script to pull the latest updates and build the workspace
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

# Source ROS and workspace setup files
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
RUN echo "source /root/catkin_ws/devel/setup.bash" >> ~/.bashrc

# Set the entrypoint
ENTRYPOINT ["/root/entrypoint.sh"]

# Default command (can be overridden)
CMD ["bash"]