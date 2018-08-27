#!/usr/bin/env bash

<%= import 'ubuntu.sh' %>


apt-packages-update


sleep 5

# sudo apt-get update
# sudo apt-get -y -qq purge lxc-docker
#
sudo apt-get -y -qq install linux-image-extra-$(uname -r)
sudo apt-get -y -qq install docker-engine
sudo chmod +x /var/deploy/dockers/jenkins/tomcatdock.sh
sudo /var/deploy/dockers/jenkins/tomcatdock.sh &
sudo chmod +x /var/deploy/dockers/gitlab/gitlabstart.sh
sudo /var/deploy/dockers/gitlab/gitlabstart.sh
