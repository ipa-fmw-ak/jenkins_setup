#!/bin/sh

echo "\n***APT-PROXY***"
APT_PROXY_ADDRESS="http://cob-jenkins-server:3142"
sh -c 'echo "Acquire::http { Proxy \"'$APT_PROXY_ADDRESS'\"; };" > /etc/apt/apt.conf.d/01proxy'
cat /etc/apt/apt.conf.d/01proxy
echo "\n***UPDATE***"
cat /etc/apt/sources.list
apt-get update
echo "\n***UPGRADE***"
apt-get dist-upgrade -y
echo "\n***INSTALL HELPER***"
apt-get install -y \
    python-setuptools ccache wget curl curl-ssl sudo git-buildpackage dput \
    python-yaml python-pip python-support python-apt git-core mercurial subversion \
    python-all gccxml python-empy python-nose python-mock python-minimock \
    lsb-release python-numpy python-wxgtk2.8 python-argparse python-networkx \
    graphviz python-sphinx doxygen python-epydoc cmake pkg-config openssh-client

echo "\n***GET KEY***"
wget http://packages.ros.org/ros.key -O - | apt-key add -
echo "\n***WRITE SOURCE***"
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu '$1' main" > /etc/apt/sources.list.d/ros-latest.list'
cat /etc/apt/sources.list.d/ros-latest.list

echo "\n***UPDATE***"
apt-get update
echo "\n***INSTALL ROS***"
apt-get install -y ros-$2-ros
echo "\n***INSTALL ROSINSTALL***"
pip install -U rosinstall

echo "\n***INSTALL ROS VERSION SPECIFIC PACKAGES***"
case $2 in
    electric)
        echo "ELECTRIC: catkin-pkg and rospkg"
        pip install -U catkin-pkg rospkg
        ;;
    fuerte)
        echo "FUERTE: rospkg and rosdep"
        pip install -U rospkg rosdep
        ;;
    groovy)
        echo "GROOVY: python-catkin-pkg and python-rosdistro"
        apt-get install python-catkin-pkg python-rosdistro --yes
        ;;
esac
