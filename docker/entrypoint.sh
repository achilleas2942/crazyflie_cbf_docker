#!/bin/bash
set -e

# Source the ROS setup
source /opt/ros/noetic/setup.bash

# Pull the latest updates from the repositories
cd /root/catkin_ws/src
if [ -d "crazyflie_ros" ]; then
    cd crazyflie_ros && git pull && cd ..
else
    git clone git@github.com:whoenig/crazyflie_ros.git && \
    { cd /root/catkin_ws/src/crazyflie_ros && git submodule init && git submodule update; }
fi

cd /root/catkin_ws/src
if [ -d "cf_cbf" ]; then
    cd cf_cbf && git pull && cd ..
else
    git clone git@github.com:viswans2132/cf_cbf.git
fi

if [ -d "libviconstream" ]; then
    cd libviconstream && git pull && cd ..
else
    git clone git@github.com:LTU-RAI/libviconstream.git
fi

if [ -d "ros_viconstream" ]; then
    cd ros_viconstream && git pull && cd ..
else
    git clone git@github.com:LTU-RAI/ros_viconstream.git
fi

# Build the workspace
cd /root/catkin_ws/
catkin_make

# Source the workspace
source /root/catkin_ws/devel/setup.bash

# Export ROS_MASTER_URI
export ROS_MASTER_URI=http://192.168.50.219:11311

# Automatically detect and export the host IP for ROS_IP
export ROS_IP=$(ip route | grep default | awk '{print $3}')

# Execute the provided command
exec "$@"
