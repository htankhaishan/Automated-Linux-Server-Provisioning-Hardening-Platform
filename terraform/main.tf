terraform {
  required_providers {
    multipass = {
      source  = "larstobi/multipass"
      version = "~> 1.4"
    }
  }
}

provider "multipass" {}

resource "multipass_instance" "secvm" {
  name   = "secvm"
  image  = "22.04"
  cpus   = 1
  memory = "1G"
  disk   = "5G"
}

resource "null_resource" "bootstrap_ssh" {
  depends_on = [multipass_instance.secvm]

  provisioner "local-exec" {
    command = <<EOT
multipass exec secvm -- bash -c "mkdir -p /home/ubuntu/.ssh && \
chmod 700 /home/ubuntu/.ssh && \
echo '$(cat ~/.ssh/id_ed25519.pub)' >> /home/ubuntu/.ssh/authorized_keys && \
chmod 600 /home/ubuntu/.ssh/authorized_keys && \
chown -R ubuntu:ubuntu /home/ubuntu/.ssh"
EOT
  }
}

# Trusting in local and inject host key automatically
resource "null_resource" "trust_host" {
  triggers = {
    ip = multipass_instance.secvm.ipv4
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]

    command = <<EOT
set -e 
until nc -z ${multipass_instance.secvm.ipv4} 22; do sleep 2; done
ssh-keyscan -p 22 ${multipass_instance.secvm.ipv4} >> ~/.ssh/known_hosts
#ssh-keyscan -p 2222 ${multipass_instance.secvm.ipv4} >> ~/.ssh/known_hosts
EOT
  }
}

resource "null_resource" "ansible" {
  depends_on = [
    null_resource.bootstrap_ssh,
    null_resource.trust_host
  ]

  provisioner "local-exec" {
    command = <<EOT
cd ../ansible && \
ansible-playbook \
  -i ${multipass_instance.secvm.ipv4}, \
  playbooks/site.yml \
  -u ubuntu
EOT
  }
}
