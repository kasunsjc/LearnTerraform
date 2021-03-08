#!/bin/bash
sudo hostnamectl set-hostname ${nodename} &&
curl -sfL https://get.k3s.io | sh -s - server \
  --datastore-endpoint="mysql://${dbuser}:${dbpass}@tcp(${db_endpoint}:3306)/${db_name}" \
  --write-kubeconfig-mode 644