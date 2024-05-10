FROM ubuntu:jammy

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y git python3-pip python3-dev python3-openstackclient libffi-dev libssl-dev gcc vim curl nano\
    && pip install 'ansible-core>=2.14,<2.16'

RUN pip install git+https://opendev.org/openstack/kolla-ansible@17.2.0

RUN kolla-ansible install-deps

COPY ansible.cfg /etc/ansible/
# COPY id_rsa ~/.ssh/
