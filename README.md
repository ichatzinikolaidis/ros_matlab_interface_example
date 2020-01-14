# How to launch ROS nodes and publish custom ROS messages via MATLAB

This is a kinda hackey way to launch ROS nodes inside MATLAB during development, if you don't want to constantly switch to terminal...

## Requirements

Please ensure you have configured the following first:

1. Install the [ROS Toolbox](https://www.mathworks.com/products/ros.html).

2. Install [ROS Custom Message Support](https://www.mathworks.com/help/ros/ug/ros-custom-message-support.html) through Add-Ons.

3. Build the package inside the _catkin_ws_ folder, e.g. by running `catkin build`.

4. [Follow this guide](https://www.mathworks.com/help/ros/ug/create-custom-messages-from-ros-package.html) to generate the messages so that we can populate them in MATLAB. Essentially, you need to run `rosgenmsg('custom_msgs')`, paste the output lines to _javaclassspath.txt_, and restart MATLAB.

These steps need to be performed once only.

Afterwards, check the file _ros_matlab_example.m_ for a concrete example, making sure that everything is in MATLAB's PATH before running the script.

## Extra notes

- The demonstrated example is a hopper robot where we set a sinusoidal base motion and visualize it in [rviz](https://wiki.ros.org/rviz).

- The robot model is included in the [xpp](https://wiki.ros.org/xpp) package.

- The process was tested on MATLAB R2019b.
