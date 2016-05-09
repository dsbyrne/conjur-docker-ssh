#!/usr/bin/env bash
set -e

docker-compose up -d &>/dev/null

echo "Clearing known_hosts..."
ssh-keygen -R "[$(docker-machine ip default)]:9022" &>/dev/null
ssh-keygen -R "[$(docker-machine ip default)]:9023" &>/dev/null

echo "Creating ssh_config..."
target_container=`docker-compose ps | grep target | awk '{print $1}'`
internal_ip=`docker inspect $target_container | jq -r '.[0]["NetworkSettings"]["Networks"]["bridge"]["IPAddress"]'`

cat <<- EOF > ssh_config
Host bastion.itp.myorg.com
    Port 9022
    HostName $(docker-machine ip default)

Host analytics-001.itr.myorg.com
    HostName $internal_ip
    ProxyCommand ssh %r@$(docker-machine ip default) -p 9022 nc $internal_ip 22
EOF