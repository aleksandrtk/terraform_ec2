provider "aws" {
  region = "us-west-1"

}


resource "aws_iam_instance_profile" "my_instance_profile" {
  name = "my-ec2-instance-profile"
  role = "MySystemsManagerRole"
}

resource "aws_key_pair" "terraform_ec2_key" {
  key_name   = "terraform_ec2_key"
  public_key = file("terraform_ec2_key.pub")
}

resource "aws_instance" "web" {
  ami                    = "ami-0bd4d695347c0ef88"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data              = file("user_data.sh")
  iam_instance_profile   = aws_iam_instance_profile.my_instance_profile.name
  key_name               = "terraform_ec2_key"


  tags = {
    Name = "WEB-instance"
  }

}

resource "aws_security_group" "my_webserver" {
  name        = "Webserver security group"
  description = "My SG"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


}











output "ec2_global_ips" {
  value = ["${aws_instance.web.*.public_ip}"]
}
