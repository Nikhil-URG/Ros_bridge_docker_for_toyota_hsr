FROM osrf/ros:foxy-ros1-bridge

# 1. Install build tools
RUN apt-get update && apt-get install -y \
    git \
    ros-noetic-catkin \
    python3-catkin-tools \
    ros-foxy-rmw-cyclonedds-cpp \
    && rm -rf /var/lib/apt/lists/*

# 2. Setup Workspace
RUN mkdir -p /ros1_ws/src
WORKDIR /ros1_ws/src

# 3. Clone HSR Messages
RUN git clone https://github.com/hsr-project/tmc_msgs.git

# 4. Build HSR Messages
WORKDIR /ros1_ws
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin_make_isolated --install"

# 5. Setup Entrypoint Environment
# We append the sourcing to bashrc so it happens on every shell launch
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc && \
    echo "source /ros1_ws/install_isolated/setup.bash" >> ~/.bashrc && \
    echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc

# 6. Default Command
CMD ["ros2", "run", "ros1_bridge", "dynamic_bridge", "--bridge-all-topics"]