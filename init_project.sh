#!/bin/bash

# Each application is separated in it's own folder

# Stop and remove all running containers for testing purposes
# sudo docker stop $(sudo docker ps -aq) ; sudo docker rm $(sudo docker ps -aq)

# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

echo "Adding a single http factorial server"

# The code for this application is in the http_server/app folder
# This is a simple flask webserver that randomly selects a number and returns its factorial

# Building the factorial container image 
sudo docker build -t factorial http_server/app/.

# Running the factorial container image 
sudo docker run -d \
    --name factapp \
    --cpus=".05" \
    -p 5000:5000 \
    -e "REDIS_IP_ADDR=$redis_container_ip" \
    -e "REDIS_PORT=$redis_container_port" \
    factorial

echo " -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

echo "Building the load balancer and adding multiple factrial servers"

# The code for this application is in the load_balancer/app folder
# To solve this task I built a simple flask webserver that 
# listens to the requests it gets and redirects the clients
# to another webserver

# This container exposes port 8001

# Before starting the container I will define the servers that 
# are available and save them on the 'D/app/servers.json' file, 
# which will be used by the load balancer to know to what port
# redirect clients

echo '{"available_servers": ["5001", "5002", "5003", "5004", "5005"]}' > D/app/servers.json
# echo '{"available_servers": ["5001", "5002", "5003"]}' > D/app/servers.json
# echo '{"available_servers": ["5001"]}' > D/app/servers.json

# Building the balancerapp container image 
sudo docker build -t balancerapp D/app/.

# Running the balancerapp container image 
lb_container=`sudo docker run -d -p 8001:8001 --name load_balancer balancerapp`
echo $lb_container

lb_container_ip=`sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $lb_container`
echo $lb_container_ip

# I will use the previously built factorial image to spawn more containers
sudo docker run -d -p 5001:5000 --name factapp_D1 -e "LB_IP_ADDR=$lb_container_ip" -e "LB_PORT=8001" factorial
sudo docker run -d -p 5002:5000 --name factapp_D2 -e "LB_IP_ADDR=$lb_container_ip" -e "LB_PORT=8001" factorial
sudo docker run -d -p 5003:5000 --name factapp_D3 -e "LB_IP_ADDR=$lb_container_ip" -e "LB_PORT=8001" factorial
sudo docker run -d -p 5004:5000 --name factapp_D4 -e "LB_IP_ADDR=$lb_container_ip" -e "LB_PORT=8001" factorial
sudo docker run -d -p 5005:5000 --name factapp_D5 -e "LB_IP_ADDR=$lb_container_ip" -e "LB_PORT=8001" factorial

echo " -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

# Showing that all containers are up and running
sudo docker ps -a

# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

echo "DONE!"
