#!/bin/bash
docker exec `docker ps | awk '/ruby-hw/ {print $1}'` sudo -u app -H /home/app/ruby_hw/update.sh
