% Check if this file is in PATH and if so retrieve its full path
if exist("ros_matlab_example", "file") == 2
    pkg_folder = fullfile(fileparts(which('ros_matlab_example')));
else
    error("Example file not in PATH.")
end
ros_distro = 'kinetic';

% Configure terminal commands head
term_head = ['export LD_LIBRARY_PATH="/opt/ros/"', ros_distro, '"/lib";' ...
    'export LD_LIBRARY_PATH="";' 'source ' pkg_folder ...
    '/catkin_ws/devel/setup.bash;'];

% Launch rviz with config files
[~, ~] = system([term_head, ...
    'roslaunch monoped_kinematic_viz monoped_kinematic_viz.launch & echo $!']);
pause(5) % Needs a bit of time for the nodes to come up

% Start ROS node
rosinit;

% Create task space publisher
N = 100;
f = 0.2;
state_pub = rospublisher('/xpp/state_des', 'xpp_msgs/RobotStateCartesian');
hopperArray = arrayfun( @(~) rosmessage(state_pub), zeros(1, N) );
hopper = rosmessage(state_pub);

% Add 1 limb
for i = 1:N
    hopperArray(i).EeMotion = rosmessage('xpp_msgs/StateLin3d');
    hopperArray(i).EeForces = rosmessage('geometry_msgs/Vector3');
end

% Populate messages
for i = 1:N
    % Base motion
    hopperArray(i).Base.Pose.Position.X = 0;
    hopperArray(i).Base.Pose.Position.Y = 0;
    hopperArray(i).Base.Pose.Position.Z = 0.8 + 0.2*sin(2*pi*f*i);
    hopperArray(i).Base.Pose.Orientation.X = 0;
    hopperArray(i).Base.Pose.Orientation.Y = 0;
    hopperArray(i).Base.Pose.Orientation.Z = 0;
    hopperArray(i).Base.Pose.Orientation.W = 1;

    % Limb motion
    hopperArray(i).EeMotion(1).Pos.X = 0;
    hopperArray(i).EeMotion(1).Pos.Y = 0;
    hopperArray(i).EeMotion(1).Pos.Z = 0.1;
    hopperArray(i).EeMotion(1).Vel.X = 0;
    hopperArray(i).EeMotion(1).Vel.Y = 0;
    hopperArray(i).EeMotion(1).Vel.Z = 0;

    % Limb force
    hopperArray(i).EeForces(1).X = 0;
    hopperArray(i).EeForces(1).Y = 0;
    hopperArray(i).EeForces(1).Z = (1 + (-1)^i)/2;
    hopperArray(i).EeContact = (1 + (-1)^i)/2;
end

% Publish messages
for i = 1:N-1
    send( state_pub, hopperArray(i) )

    % Pause loop
    waitfor( robotics.Rate(1/f) );
end
send( state_pub, hopperArray(N) );

% Close ROS, kill nodes and master
rosshutdown;
[~, ~] = system([term_head, 'rosnode kill -a']);
[~, ~] = system([term_head, 'killall -9 rosmaster']);
