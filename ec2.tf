# securrity group that allows ssh
module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "user-service"
  description = "Security group for nethermind host machine"
  vpc_id      = aws_vpc.main.id


  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh to instance"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8545
      to_port     = 8545
      protocol    = "tcp"
      description = "access to nethermind node"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      description = "allow all traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

}


# get latest ubuntu ami
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "nethermind-instance"

  ami                         = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.temp_keypair.key_name
  monitoring                  = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = aws_subnet.main.id

  user_data = file("${path.module}/script.sh")

  root_block_device = [{
    volume_size = 30
    volume_type = "gp3"
  }]

  tags = {
    Terraform   = "true"
    Environment = "Nethermind"
  }
}