#Creating the SG that internal hosts will use
resource "aws_security_group" "grr-sg-internal" {
    name        = "GRR Internal SG"
    description = "A SG for hosts on the internal subnet to use"
    vpc_id      = "${aws_vpc.grr-lab-vpc.id}"

    #Rules to allow GRR servers and clients to connect to each other
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["10.0.1.0/24"]
    }

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["10.0.1.0/24"]
    }

    ingress {
        from_port   = 3389
        to_port     = 3389
        protocol    = "tcp"
        cidr_blocks = ["10.0.1.0/24", "10.0.0.0/24"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["10.0.1.0/24", "10.0.0.0/24"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name        = "GRR Internal SG"
    }
}

#Creating an SG that your bastion host will use
resource "aws_security_group" "grr-sg-external" {
    name        = "GRR External SG"
    description = "A SG for the bastion host to use"
    vpc_id      = "${aws_vpc.grr-lab-vpc.id}"

    #Rules to allow us to connect to the bastion host
    ingress {
        from_port   = 3389
        to_port     = 3389
        protocol    = "tcp"
        cidr_blocks = ["YOUR.PUBLIC.IP.HERE/32"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name        = "GRR External SG"
    }
}
