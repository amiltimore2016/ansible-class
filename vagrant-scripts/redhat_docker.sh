#!/bin/bash
sudo yum-config-manager --enable docker-ce-stable
sudo yum makecache fast
sudo yum remove -y docker-ce
sudo yum install -y  docker-ce
sudo systemctl enable docker
sudo systemctl start docker
# https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
