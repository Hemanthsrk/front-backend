provider "aws" {
  region = "ap-south-1a"
}

resource "aws_instance" "minikube_server" {
  ami           = "ami-03753afda9b8ba740" 
  instance_type = "t2.medium"
  key_name      =       

  tags = {
    Name = "Minikube-Server"
  }

  # User data script for setting up Docker and Minikube on Amazon Linux 2
  user_data = <<-EOF
    #!/bin/bash
    # Update and install necessary packages
    sudo yum update -y
    sudo amazon-linux-extras install docker -y
    sudo yum install -y curl conntrack

    # Start Docker service
    sudo systemctl enable docker
    sudo systemctl start docker

    # Add ec2-user to the docker group
    sudo usermod -aG docker ec2-user

    # Install Minikube
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    chmod +x minikube
    sudo mv minikube /usr/local/bin/

    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/

    # Start Minikube with the none driver
    sudo minikube start --driver=none

    # Enable Minikube Ingress Addon
    sudo minikube addons enable ingress

    # Adjust permissions for ec2-user to access Minikube
    sudo chown -R ec2-user:ec2-user /home/ec2-user/.minikube
    sudo chown -R ec2-user:ec2-user /home/ec2-user/.kube
  EOF

  # Allow instance to reboot if needed (e.g., user permissions)
  lifecycle {
    ignore_changes = [user_data]
  }
}

output "13.201.60.236" {
  value = aws_instance.minikube_server.public_ip
}

