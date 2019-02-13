#!/bin/bash

port_name=
volume_name=

openstack port delete $port_name
openstack volume delete $volume_name
