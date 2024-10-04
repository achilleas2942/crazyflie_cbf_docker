# Run the Docker container with the appropriate environment variables
docker run --privileged -it \
    --net=host \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -e ROS_IP=$HOST_IP \
    ghcr.io/achilleas2942/crazyflie-cbf \
    bash