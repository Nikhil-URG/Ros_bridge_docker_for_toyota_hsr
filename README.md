# HSR ROS 1/ROS 2 Bridge Setup Guide

This repository contains the necessary files and scripts to build a customized ROS 1-ROS 2 Dynamic Bridge capable of understanding the Toyota HSR's custom message types (tmc_msgs).

This setup allows you to run the official HSR ROS 1 Gazebo simulation and control/monitor it using ROS 2 tools (like ros2 topic echo, ros2 run rviz2, etc.) on your host machine.

Prerequisites

Operating System: Ubuntu 22 (Jammy)

Docker: Docker Engine and Docker CLI installed.

ROS 2: A ROS 2 distribution (Foxy, Galactic, or Humble) installed and sourced on your host machine.

X Server: To run the GUI (Gazebo).

## Clone the official simulation repository and start simulator
```sh
git clone --recursive https://github.com/hsr-project/tmc_wrs_docker.git
cd tmc_wrs_docker
```

Download all of the images necessary for running the simulator.
As you will be downloading a large amount of data,
please execute the following command in an environment that is connected to a high speed network.

```sh
./pull-images.sh
```

Starting the simulator
----------------------

Please input the following command and start the simulator.

```sh
docker-compose up
```

go to: 

The simulator's screen http://localhost:3000

and click on the play button to start the topics

Topics like /joint_states and /tf will now begin publishing in the ROS 1 network.

# Launching the Dynamic Bridge (ROS 2)


## Clone this bridge repository in a new terminal
```sh
git clone https://github.com/Nikhil-URG/Ros_bridge_docker_for_toyota_hsr.git
cd hsr_ros2_bridge
```

Run the Bridge Script

```sh
sudo ./run_bridge.sh
```

The run_bridge.sh script automatically detects the running simulation container, figures out its IP address and hostname, and launches the custom bridge container with the correct network configuration.

## Make sure the script is executable (if not already)
```sh
chmod +x run_bridge.sh
```

The script will first build the custom-hsr-bridge Docker image (this is a one-time process) and then launch the container. The bridge will then start piping all ROS 1 topics to the ROS 2 domain.

## Verification
----------------------
With the simulation running and the bridge container running, you can now use standard ROS 2 commands on your host terminal.

## Check Topic List

You should see ROS 1 topics, now available as ROS 2 topics:

## On your host terminal (where you sourced your ROS 2 environment)
```sh
ros2 topic list
```

Expected topics: /joint_states, /tf, /tf_static, and specific HSR topics like /hsrb/joint_trajectory_controller/command.

## Echo a Topic

Echoing a topic should now display messages in real-time, confirming the connection is working:

```sh
ros2 topic echo /joint_states
```

If you see joint position, velocity, and effort data streaming, your setup is complete!