cmake_minimum_required(VERSION 2.8.3)
project(monoped_kinematic_viz)

add_compile_options(-std=c++11)

## Find catkin macros and libraries
## if COMPONENTS list like find_package(catkin REQUIRED COMPONENTS xyz)
## is used, also find other catkin packages
find_package(catkin REQUIRED COMPONENTS
  roscpp
  rviz
  xpp_vis
  xpp_hyq
)


###################################
## catkin specific configuration ##
###################################
catkin_package()


###########
## Build ##
###########
## Specify additional locations of header files
include_directories(
  ${catkin_INCLUDE_DIRS}
)


#############
## Install ##
#############
# Mark other files for installation
install(
  DIRECTORY launch
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)
