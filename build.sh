#!/usr/bin/env bash
set -e

create_conjurize_script() {
    host_id="$1"
    api_key=$(conjur host rotate_api_key -h $host_id)
    mkdir -p tmp
    echo "{\"id\": \"$host_id\", \"api_key\": \"$api_key\"}" | conjurize --ssh
}

docker build \
  --build-arg conjurize="$(create_conjurize_script bastion.itp.myorg.com)" \
  -t demo-bastion:latest \
  conjurized-server &
docker build \
  --build-arg conjurize="$(create_conjurize_script analytics-001.itr.myorg.com)" \
  -t demo-bastion-target:latest \
  conjurized-server &
wait