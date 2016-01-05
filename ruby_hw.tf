# Create a Virtual Machine

# One can provide the Digital Ocean access token via numerous methods
# including passing a variable (from another file, a file passed from the CLI)
# or as an environment variable: export DIGITALOCEAN_TOKEN='xxxx'
#provider "digitalocean" {
#    token = "${var.do_token}"
#}

#  Provision via external ansible, but create the inventory
resource "digitalocean_droplet" "ruby-hw" {
    image = "ubuntu-14-04-x64"
    name = "ruby-hw"
    region = "sfo1"
    size = "512mb"
    ssh_keys = ["778729"]
}

# If you don't already have a domain defined in Digital Ocean

#resource "digitalocean_domain" "opsits-com" {
#    name = "opsits.com"
#}

# Add a pointer to the new IP address
# Note that the default TTYL is 1800 seconds, so it will take
# up to 30 minutes in this enviornment for the record to time out.

resource "digitalocean_floating_ip" "ruby-hw-ip" {
    droplet_id = "${digitalocean_droplet.ruby-hw.id}"
    region = "${digitalocean_droplet.ruby-hw.region}"
}

resource "digitalocean_record" "ruby-hw" {
    domain = "opsits.com"
    type = "A"
    name = "ruby-hw"
    value = "${digitalocean_floating_ip.ruby-hw-ip.ip_address}"
}

# For OpenStack, as with Digital Ocean, access credentials are needed
# They can be provided in a fashion similar to DO, passed as variables
# or via the terraform CLI as parameters, but they also can be passed
# as environment variables.  The standard "openrc.sh" file includes
# all the prerequisite parameters including OS_AUTH_URL, OS_PASSWORD
# OS_USERNAME, OS_TENANT_NAME, and OS_REGION_NAME.  The simplest is
# often to source the openrc file to set these variables, or set them
# in the provdier as follows:

#provider "openstack" {
#    user_name  = "admin"
#    tenant_name = "admin"
#    password  = "pwd"
#    auth_url  = "http://myauthurl:5000/v2.0"
#}

# resource "openstack_compute_instance_v2" "ruby-os" {
#   name = "ruby-os.opsits.com"
#   image_id = "7f85f7b3-eb20-4bef-8bad-bb3583a9a2fd"
#   flavor_id = "3"
#   key_pair = "rhs"
#    provisioner "local-exec" {
#      command = "echo ${openstack_compute_instance_v2.ruby-os.access_ip_v4} ansible_connection=ssh ansible_ssh_user=centos >> inventory"
#    }
# }
#

# Designate is not currently supported, so this example leverages the
# Digital Ocean DNS service from the other example to provide DNS
# support.  Note that this is one of the values of Terraform, the ability
# to leverage multiple services as desired.

# resource "digitalocean_record" "ruby-os" {
#     domain = "opsits.com"
#     type = "A"
#     name = "ruby-os"
#     value = "${openstack_compute_instance_v2.ruby-os.access_ip_v4}"
# }
