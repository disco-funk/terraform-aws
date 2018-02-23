provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "phud_instance" {
  ami = "ami-6d263d09"
  // Amazon Linux 2 LTS Candidate AMI 2017.12.0 (HVM), SSD Volume Type
  instance_type = "t2.micro"
  key_name = "phud_keypair"
  security_groups = [
    "${aws_security_group.phud_ssh.name}"]
  tags {
    Name = "Phil Hudson Terraform"
  }
  provisioner "remote-exec" {
    script = "./cluster/configure.sh"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("~/.ssh/phud_keypair.pem")}"
    }
  }

  provisioner "file" {
    source = "~/.ssh/phud_keypair.pub"
    destination = "/home/ec2-user/.ssh/id_rsa.pub"
    connection {
      type = "ssh"
      user = "ec2-user"
      agent = false
      private_key = "${file("~/.ssh/phud_keypair.pem")}"
    }
  }
  provisioner "file" {
    source = "~/.aws/credentials"
    destination = "/home/ec2-user/.aws/credentials"
    connection {
      type = "ssh"
      user = "ec2-user"
      agent = false
      private_key = "${file("~/.ssh/phud_keypair.pem")}"
    }
  }
}

resource "aws_security_group" "phud_ssh" {
  name = "phud_ssh"
  description = "Phil Hudson - Allow ssh traffic"
  vpc_id = "vpc-2b946242"

  tags {
    Name = "Phil Hudson Terraform"
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

output "ec2dns" {
  value = "${aws_instance.phud_instance.public_dns}"
}