#!/bin/bash

. .env.sh

echo "Please run this before using check.sh script:
. $openrc"

echo "Waiting for 3 seconds ..."
sleep 3

echo flavor list
openstack flavor list

echo server list
openstack server list

echo image list
openstack image list

echo network list
openstack network list

echo subnet list
openstack subnet list

echo port list
openstack port list
# openstack port show $port_id

echo security group list
openstack security group list
