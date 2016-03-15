cmake_minimum_required(VERSION 2.8 FATAL_ERROR)


# ---[ Caffe project
#include(Caffe) 

find_package( OpenCV REQUIRED)

#set(Caffe_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include)

include_directories(/users/visics/kkelchte/caffe-projects/flownet-release/include /users/visics/kkelchte/caffe-projects/flownet-release/build/src ${OpenCV_INCLUDE_DIRS})

#include_directories(${GAZEBO_INCLUDE_DIRS} "/usr/include/OGRE" "/usr/include/OGRE/Paging" "/usr/include/gazebo-5.1/gazebo")

#link_directories(${GAZEBO_LIBRARY_DIRS})

#list(APPEND CMAKE_CXX_FLAGS "${GAZEBO_CXX_FLAGS}")

add_executable(flo_interpreter_jpg flo_interpreter_jpg.cc)
target_link_libraries(flo_interpreter_jpg ${OpenCV_LIBS})

add_executable(flo_interpreter flo_interpreter.cc)

