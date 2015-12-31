# See https://github.com/phusion/passenger-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/passenger-ruby22:0.9.18

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

RUN rm /etc/nginx/sites-enabled/default
ADD ruby-hw.conf /etc/nginx/sites-enabled/ruby-hw.conf


RUN sudo -u app -H git clone https://github.com/rstarmer/ruby_hw -b develop /home/app/ruby_hw
WORKDIR /home/app/ruby_hw
RUN sudo -u app -H bundle install --path vendor/bundle

RUN rm -f /etc/service/nginx/down

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
