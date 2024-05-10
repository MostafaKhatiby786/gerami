#!/bin/bash

sudo docker build -t 10.10.10.134:5002/openstack/kolla-ansible-image:17.2.0 -f kolla-ansible.dockerfile .
sudo docker login 10.10.10.134:5002
sudo docker push 10.10.10.134:5002/openstack/kolla-ansible-image:17.2.0
