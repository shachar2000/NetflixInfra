terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.55"
    }
  }
  backend "s3" {
    bucket = "shachar-terraform-bucket"
    key    = "tfstate.json"
    region = "eu-north-1"
    # optional: dynamodb_table = "<table-name>"
  }

  required_version = ">= 1.7.0"
}

provider "aws" {
  region  = var.region  # Use variable for region
  profile = "default"   # Change in case you want to work with another AWS account profile
}


# Security Group for EC2 Instance
resource "aws_security_group" "netflix_app_sg" {
  name        = "serverSG-netflix-app-sg"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic on port 80
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic on port 80
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance for Netflix App
resource "aws_instance" "netflix_app" {
  ami             = var.ami_id  # Use variable for AMI ID
  instance_type   = var.instance_type  # Use variable for instance type
  key_name        = var.key_name
  security_groups = [aws_security_group.netflix_app_sg.name]
  availability_zone = var.avalibilty_zone
  user_data = file("./deploy.sh")
  }

# Create a 5GB EBS Volume
resource "aws_ebs_volume" "netflix_app_volume" {
  availability_zone = var.avalibilty_zone
  size              = 5  # Size in GB

  tags = {
    Name = "netflix-app-volume"
  }
}

# Attach the EBS Volume to the EC2 Instance
resource "aws_volume_attachment" "netflix_app_volume_attachment" {
  device_name = "/dev/sdf"  # Device name to attach the volume as
  volume_id   = aws_ebs_volume.netflix_app_volume.id
  instance_id = aws_instance.netflix_app.id

  depends_on = [aws_instance.netflix_app]  # Ensure the volume is attached after the instance is created
}

resource "aws_s3_bucket" "shachar_netflix_app" {
  bucket = var.s3_bucket

}