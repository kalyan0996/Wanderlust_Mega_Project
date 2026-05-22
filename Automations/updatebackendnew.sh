#!/bin/bash

# Get public IP automatically - no hardcoding needed
ipv4_address=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

# File path
file_to_find="../backend/.env.docker"
alreadyUpdate=$(sed -n "4p" ../backend/.env.docker)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Show the IP we found
echo -e " ${GREEN}System Public Ipv4 address ${NC} : ${ipv4_address}"

# Check if already updated
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
