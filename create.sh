#!/bin/bash

. .env.sh

cat .env.sh | grep -v '^#'

echo press enter; read

if ! openstack server list 2>/dev/null >/dev/null; then echo "Please authenticate first"; exit 1; fi

echo
echo "Will create VM in 8 seconds ..."
sleep 8

# Disk
openstack volume create --image $image --size $disk_size $host && \

# App Network Card
openstack port create --network $network_name --fixed-ip subnet="$subnet_name",ip-address=$ip $host && \
port_id=`openstack port list | grep $ip | awk -F '|' '{print $2}'` && \
openstack port show $port_id && \
icmp=`openstack security group list | grep icmp_allowed | awk -F '|' '{print $2}'` && \
echo $icmp && \
ssh=`openstack security group list | grep ssh_allowed | awk -F '|' '{print $2}'` && \
echo $ssh && \
openstack port set --security-group $icmp $host && \
openstack port set --security-group $ssh $host && \
openstack port show $host && \

echo press enter; read

# NFS Network Card
openstack port create --network $network_name_nfs --fixed-ip subnet="$subnet_name_nfs",ip-address=$ip_nfs ${host}_nfs && \
openstack port set --no-security-group --disable-port-security ${host}_nfs && \
port_id=`openstack port list | grep $ip_nfs | awk -F '|' '{print $2}'` && \
openstack port show $port_id

echo press enter; read

# Create VM
if openstack port show $port_id >/dev/null 2>/dev/null
then
  openstack server create --flavor $flavor --security-group default --security-group ssh_allowed --security-group monitoring --security-group icmp_allowed --port $host --port ${host}_nfs --volume $host $host
else
  openstack server create --flavor $flavor --security-group default --security-group ssh_allowed --security-group monitoring --security-group icmp_allowed --port $host --volume $host $host
fi

echo $?

# List VMs
openstack server list
