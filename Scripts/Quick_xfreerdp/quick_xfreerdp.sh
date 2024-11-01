#!/bin/bash

#IP of target
read -p "Enter IP: " IP

#Login username
read -p "Enter Username: " Username

#Login Password
read -p "Enter Password: " Password
echo "xfreerdp /v:$IP /u:$Username /p:$Password /dynamic-resolution" 

#Use parameters and try to RDP
xfreerdp /v:$IP /u:$Username /p:$Password /dynamic-resolution