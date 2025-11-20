FROM osrf/ros:foxy-ros1-bridge


# Source Noetic to build ROS 1 packages
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash"

RUN /bin/bash -c "source /opt/ros/foxy/setup.bash"

# RUN /bin/bash -c "ros2 run ros1_bridge dynamic_bridge --bridge-all-topics"
