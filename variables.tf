variable "region" {
  description = "AWS region"
  default     = "eu-west-2"
}

variable "instance_type" {
  description = "Type of an EC2 instance to provision"
  default     = "t2.micro"
}

variable "instance_name" {
  description = "EC2 instance name"
  default     = "richjam"
}

variable "instance_ami" {
  description = "AMI ID"
  default           = "ami-08095fbc7037048f3"
}

/*CentOS 8 (x86_64) - with Updates HVM ami-08095fbc7037048f3*/