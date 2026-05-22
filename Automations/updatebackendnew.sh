#!/bin/bash

# Try multiple methods to get IP
ipv4_address=$(curl -s ifconfig.me)

# Backup method if above fails
if [ -z "$ipv4_address" ]; then
    ipv4_address=$(curl -s checkip.amazonaws.com)
fi

# Show what we got
echo "Got IP: $ipv4_address"

# Fail if still empty
if [ -z "$ipv4_address" ]; then
    echo "ERROR: Could not get IP address"
    exit 1
fi

# File path
file_to_find="../backend/.env.docker"
alreadyUpdate=$(sed -n "4p" ../backend/.env.docker)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e " ${GREEN}System Public Ipv4 address ${NC} : ${ipv4_address}"

if [[ "${alreadyUpdate}" == "FRONTEND_URL=\"http://${ipv4_address}:5173\"" ]]
then
    echo -e "${YELLOW}Already updated - skipping${NC}"
else
    if [ -f ${file_to_find} ]
    then
        echo -e "${GREEN}File found - updating...${NC}"
        sleep 2s
        sed -i -e "s|FRONTEND_URL.*|FRONTEND_URL=\"http://${ipv4_address}:5173\"|g" ${file_to_find}
        echo -e "${GREEN}Done!${NC}"
    else
        echo -e "${RED}ERROR: File not found at ${file_to_find}${NC}"
        exit 1
    fi
fi
