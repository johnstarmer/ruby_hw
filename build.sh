#!/bin/bash

terraform plan

if [[ $? eq 0 ]]; then
  terraform apply
fi

if [[ $? ]]; then
  ansible-playbook playbook.yml -i inventory
fi

terraform show
