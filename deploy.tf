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
  image = "debian-8-x64"
  name = "blog"
  region = "nyc3"
  size = "512mb"

  ssh_keys = ["${digitalocean_ssh_key.blog.id}"]
}

resource "null_resource" "blog-provision" {
  depends_on = ["digitalocean_droplet.blog"]

  triggers {
    host = "${digitalocean_droplet.blog.ipv4_address}"
  }

  connection {
    type = "ssh"
    user = "root"
    host = "${digitalocean_droplet.blog.ipv4_address}"
    private_key = "${file("~/.ssh/id_rsa.blog")}"
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get upgrade -y",
      "apt-get install -y curl",
      "curl https://get.docker.com/ | sh -",
      "systemctl enable docker",
      "systemctl start docker || true"
    ]
  }
}

resource "cloudflare_record" "www" {
  domain = "${var.cloudflare_domain}"
  name = "www"
  value = "${digitalocean_droplet.blog.ipv4_address}"
  type = "A"
  ttl = 1
  proxied = true
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

resource "template_file" "blog-service" {
  template = <<EOF
[Unit]
After=docker.service
Wants=docker.service
After=network-online.target
Wants=network-online.target

[Service]
ExecStartPre=-/usr/bin/docker pull ${docker_image}
ExecStartPre=-/usr/bin/docker rm -f blog
ExecStart=/usr/bin/docker run --rm --name blog -p 80:80 -p 443:443 -v /var/lib/caddy:/root/.caddy -e DOMAIN=www.${domain} -e REPO=${repo} -e TLS=${tls} -e HOOK_SECRET=${hook_secret} ${docker_image}
Restart=always

[Install]
WantedBy=multi-user.target
EOF

  vars {
    domain = "${var.cloudflare_domain}"
    repo = "${var.git_remote}"
    tls = "${var.letsencrypt_email}"
    hook_secret = "${var.hook_secret}"
    docker_image = "${var.docker_image}"
  }
}

resource "null_resource" "blog-docker" {
  depends_on = ["null_resource.blog-image", "template_file.blog-service"]

  triggers {
    host = "${digitalocean_droplet.blog.ipv4_address}"
    docker = "${sha1(file("Dockerfile"))}"
    caddy = "${sha1(file("Caddyfile"))}"
    domain = "${var.cloudflare_domain}"
    repo = "${var.git_remote}"
    tls = "${var.letsencrypt_email}"
    secret = "${var.hook_secret}"
    service = "${sha1(template_file.blog-service.rendered)}"
  }

  connection {
    type = "ssh"
    user = "root"
    host = "${digitalocean_droplet.blog.ipv4_address}"
    private_key = "${file("~/.ssh/id_rsa.blog")}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${base64encode(template_file.blog-service.rendered)} | base64 -d > /etc/systemd/system/blog.service",
      "systemctl daemon-reload",
      "systemctl enable blog",
      "systemctl restart blog"
    ]
  }
}
