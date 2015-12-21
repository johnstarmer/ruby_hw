#!/bin/bash

terraform plan

if [[ $? -eq 0 ]]; then
  terraform apply
fi

sleep 15

if [[ $? -eq 0 ]]; then
  ansible-playbook playbook.yml -i inventory
fi

terraform show
