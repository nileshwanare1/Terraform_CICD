provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "jenkins_sg" {
  name = "jenkins-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_ec2" {
  ami                         = "ami-0388e3ada3d9812da"
  instance_type               = "t3.micro"
  key_name                    = "wind_KP"
  subnet_id                   = "subnet-07527a7ae34677335"
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install openjdk-17-jdk -y
              apt install nginx -y

                sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
				https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
				echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
				https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
				/etc/apt/sources.list.d/jenkins.list > /dev/null

              apt update -y
              apt install jenkins -y

              systemctl start jenkins
              systemctl enable jenkins
              systemctl start nginx
              EOF

  tags = {
    Name = "Jenkins-Server"
  }
}