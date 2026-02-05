packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = "~> 1"
    }
  }
}

source "docker" "nginx" {
  image   = "nginx:alpine"
  commit  = true
  changes = [
    "WORKDIR /usr/share/nginx/html",
    "EXPOSE 80",
    #"ENTRYPOINT [\"nginx\", \"-g\", \"daemon off;\"]"
  ]
}

build {
  name = "nginx-custom"
  sources = ["source.docker.nginx"]

  provisioner "file" {
    source      = "index.html"
    destination = "/usr/share/nginx/html/index.html"
  }

  # Optionnel : tu peux ajouter un provisioner shell si tu veux customiser plus (ex: ajouter du CSS, etc.)
  # provisioner "shell" {
  #   inline = ["echo 'Custom build OK' > /built-with-packer.txt"]
  # }

  post-processor "docker-tag" {
    repository = "custom-nginx-lab"
    tags       = ["v1", "latest", "${replace(timestamp(), ":", "-")}"]
  }
}
