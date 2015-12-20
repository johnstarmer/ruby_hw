# Create a Virtual Machine
#  Provision via external ansible, but create the inventory
resource "digitalocean_droplet" "ruby-hw" {
    image = "centos-7-0-x64"
    name = "ruby-hw"
    region = "sfo1"
    size = "512mb"
    ssh_keys = ["778729"]
    provisioner "local-exec" {
      command = "echo ${digitalocean_droplet.ruby-hw.ipv4_address} ansible_connection=ssh ansible_ssh_user=root >> inventory"
    }
}

resource "digitalocean_domain" "ruby-hw" {
    name = "ruby-hw.opsits.com"
    ip_address = "${digitalocean_droplet.ruby-hw.ipv4_address}"
}
