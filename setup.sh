#!/bin/bash

vagrant up
ssh-keygen -f ~/.ssh/known_hosts -R jenkins-1
ssh-keygen -f ~/.ssh/known_hosts -R jenkins-2
ssh-keygen -f ~/.ssh/known_hosts -R jenkins-3
