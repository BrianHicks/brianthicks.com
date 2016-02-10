variable "do_token" {}
variable "cloudflare_email" {}
variable "cloudflare_token" {}
variable "cloudflare_domain" {}
variable "letsencrypt_email" {}
variable "docker_image" {}
variable "git_remote" {}
variable "hook_secret" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

resource "digitalocean_ssh_key" "blog" {
  name = "blog key"
  public_key = "${file("~/.ssh/id_rsa.blog.pub")}"
}

resource "digitalocean_droplet" "blog" {
  image = "ubuntu-14-04-x64"
  name = "blog"
  region = "nyc3"
  size = "512mb"

  ssh_keys = ["${digitalocean_ssh_key.blog.id}"]

  connection {
    type = "ssh"
    user = "root"
    private_key = "${file("~/.ssh/id_rsa.blog")}"
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y apt-transport-https ca-certificates",
      "apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D",
      "echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list",
      "apt-get update",
      "apt-get install -y linux-image-extra-$(uname -r) docker-engine",
      "service docker start || true"
    ]
  }
}

resource "cloudflare_record" "www" {
  domain = "${var.cloudflare_domain}"
  name = "www"
  value = "${digitalocean_droplet.blog.ipv4_address}"
  type = "A"
  ttl = 1
}

# docker stuff
resource "null_resource" "blog-image" {
  triggers {
    docker = "${sha1(file("Dockerfile"))}"
    caddy = "${sha1(file("Caddyfile"))}"
  }

  provisioner "local-exec" {
    command = "docker build -t ${var.docker_image} ."
  }

  provisioner "local-exec" {
    command = "docker push ${var.docker_image}"
  }
}

resource "null_resource" "blog-docker" {
  depends_on = ["null_resource.blog-image"]

  triggers {
    host = "${digitalocean_droplet.blog.ipv4_address}"
    docker = "${sha1(file("Dockerfile"))}"
    caddy = "${sha1(file("Caddyfile"))}"
    domain = "${var.cloudflare_domain}"
    repo = "${var.git_remote}"
    tls = "${var.letsencrypt_email}"
    secret = "${var.hook_secret}"
  }

  connection {
    type = "ssh"
    user = "root"
    host = "${digitalocean_droplet.blog.ipv4_address}"
    private_key = "${file("~/.ssh/id_rsa.blog")}"
  }

  provisioner "remote-exec" {
    inline = [
      "docker pull ${var.docker_image}",
      "docker rm -f blog || true",
      "docker run -d --name blog -p 80:80 -p 443:443 -e DOMAIN=www.${var.cloudflare_domain} -e REPO=${var.git_remote} -e TLS=${var.letsencrypt_email} -e HOOK_SECRET=${var.hook_secret} ${var.docker_image}"
    ]
  }
}
