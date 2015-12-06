#!/bin/bash

#Install prerequisites

sudo yum install -y git httpd ruby-devel rubygems epel-release pygpgme curl

# Install the bundler gem so that we can acquire our ruby libraries
sudo gem install bundler

# Add the phusionsoft passenger RPM repository so that we can install the
# Apache passenger module
sudo curl --fail -sSLo /etc/yum.repos.d/passenger.repo \
 https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo

# Install Passenger + Apache module
sudo yum install -y mod_passenger

# get the ruby environment from passenger
# export ruby-cmd=`passenger-config about ruby-command | awk '/Command:/ {print $2}'

# create our app configuration:

sudo tee /etc/httpd/conf.d/ruby_hw.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName *

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

sudo git clone https://github.com/rstarmer/ruby_hw /var/www/ruby_hw
$(cd /var/www/ruby_hw; bundle install)

sudo systemctl restart httpd.service