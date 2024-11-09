provider "aws" {
  region = "ap-south-1a"
}

resource "aws_instance" "minikube_server" {
  ami           = "ami-03753afda9b8ba740" 
  instance_type = "t2.medium"
  key_name      = "MIIEogIBAAKCAQEAvnQa+NZxWwp7acAkb4Xiu9UDW95c8EK9CCo9FjszyYztFjUK
btaoCkpQDha1WaJdLnkUymGqHVUK/7kdIZUlfL2NNpT8nnrdDdQxOuaiSp6Af7nH
SjxpBEUQWRSjE7EWkQTSKXACez0j9jNvESdHEuRv66RCO9woCxgTFXVMysQKnin8
6M/guM2mAIsF3a/PHaxhsxnuTZroAc7jN+POGAkfnAsfhzHlJVbStd3gN+OAW3ZT
T0muLSPSTZpzOSwnk5iTn2GceTGXM4yY8DZfbcF2LQel1feQQRQ87tV3C8N46e5X
AQ0wFEdz2s7bdJQU3EF6I2PS8Tz769uzN1TQAQIDAQABAoIBABuzT2j556rSL3kG
FUaTNpMTPFXUVbgsPMo/OntNSQ77jFA6jrXoSrCUdmhWLTJIRz1HJxr4cYGqqNrg
1bfYtYcbGrrhmIyEWjp0rmRevyQTQaVSJAZMGwof8WzDb6ShkSKujNKyE+pQzjY0
7OaVy+SXjR+82FVUhA55Be2NDgo/kOmwTnEej589VdF2tCQ+nAvKHnzMp9qfTRDu
a00t1udhovqmLRIo5nBkphQNF7neTlA2yMPeCuTe5373G7mbK5SIu1hf68booN7k
S/NGnud+14zErpZi6wM+Y/GRjQz6iDOkKMy40I3NEH5Ia+ZEmEhZTnFUNIQtRa1f
v82E1PECgYEA6L+YU58epv/ppoAHHGjwpdoKVdFVR3vYzvQQSPTjS+14dNrcQfBt
xStt6hP/AIbmsMpEPRKiM8TjjM0hPaYEQKvyvhUx1JLS9uHh8awttmB1ia0Ge0Kb
VdWDDW8xcniJTslgEV5ZrU/Yni7nX1iV9xD15+dmj9cC9LaQqfX3cD8CgYEA0XrX
6lnHjO4mJSJJiR8pE7bYPHfeGCzFpr6VjxmcmTr8rQC/yv6z/qOP/+zgmT8qyPJH
3k2o6HE6B+VHLuUnHjzv2uGnBXzB5TFoL9FW6qIk9AfJbb4u9q7HdVPgpOWHKJCX
0jwQgkRxdW8TXTSUjdDWuPHmi5sXfn07NnLDr78CgYBRsWYq+6/LmAmPumJEk4Tc
AdMc2hPfulWYFkxc/y+Ep/5era8fqd8tlJfI0Gnx6mewZ95ZvV+XYiUod5uSQuI9
PN0/4LqTzVEk/JXMuM12tRasU0HyI6fYEdAk+AFYF3zCXaZNkltRnLQAmZ/2dGZ2
yMo3Mp5qIGLWN/pA3aeTCwKBgDNg19hI0OLF/mEZOcQB+oc1T2/1TmnLgWbWU8RX
WctTZmngRyo4slkAMO9qX+P2VD4Y/nuNvKHWM4+AMqdT2PZXp9Sdh+OWp8/ZAF7K
D3FY94tK5aKfBNHIKG+kdPK8wRu36yTLSplIxDMzXSJ9JPprgF64Jf2Tun1xpbZD
C6/tAoGAFOwk7+2+QAycVQBav51M0l4CXzQ0u8U2XWstK+dNfAH6IBMOXg1Ab7RN
pK5KNSHmH3X9O4HxBYr/Ej2u2TTbsccoVjRlsRCPZbURcxNxbr5VDdzVamGaYyo/
kd4Jn1NBQbmLksa5DtJTwgXXs7rptbSwshdH2L3zBEe8d6he590="         

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

