#!/bin/bash

#Install prerequisites

sudo yum install -y git httpd ruby-devel rubygems rubygem-bundler epel-release pygpgme curl

# Add the phusionsoft passenger RPM repository so that we can install the
# Apache passenger module
sudo curl --fail -sSLo /etc/yum.repos.d/passenger.repo \
 https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo

# Install Passenger + Apache module
sudo yum install -y mod_passenger

# create our app configuration:

sudo git clone https://github.com/rstarmer/ruby_hw -b develop /var/www/ruby_hw
sudo chown -R centos: /var/www/ruby_hw

(cd /var/www/ruby_hw; bundle install --deployment --without development test)

# get IP address from eth0
ip_address=`ip a s eth0 | grep 'inet ' | head -n 1 | awk '/ inet / {print $2}' | cut -d\/ -f1`
sudo tee /etc/httpd/conf.d/ruby_hw.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName localhost
    ServerAlias ${ip_address}

    # Tell Apache and Passenger where your app's 'public' directory is
    DocumentRoot /var/www/ruby_hw/public

    PassengerRuby /usr/bin/ruby
    # Relax Apache security settings
    <Directory /var/www/ruby_hw/public>
      Allow from all
      Options -MultiViews
      # Uncomment this if you're on Apache >= 2.4:
      Require all granted
    </Directory>
</VirtualHost>
EOF

sudo systemctl restart httpd.service


# Update firewall on centos to allow http/https
sudo firewall-cmd --zone=public --add-service=http
sudo firewall-cmd --zone=public --add-service=https
