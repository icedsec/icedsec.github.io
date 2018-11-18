#Creating the VPC for our public and private subnets
resource "aws_vpc" "grr-lab-vpc" {
    cidr_block = "10.0.0.0/16"
    
    tags {
        Name   = "GRR Lab VPC"
    }
}

#Creating the private subnet
resource "aws_subnet" "grr-priv-subnet" {
    vpc_id      = "${aws_vpc.grr-lab-vpc.id}"
    cidr_block  = "10.0.1.0/24"

    tags {
        Name    = "GRR Internal Subnet"
    }
}

#Creating the public subnet 
resource "aws_subnet" "grr-pub-subnet" {
    vpc_id      = "${aws_vpc.grr-lab-vpc.id}"
    cidr_block  = "10.0.0.0/24"

    tags {
        Name    = "GRR Public Subnet"
    }
}

#Create an internet gateway 
##This allows our bastion host in the public subnet to be accessible via a public IP
resource "aws_internet_gateway" "grr-gateway" {
    vpc_id      = "${aws_vpc.grr-lab-vpc.id}"
    
    tags {
        Name    = "GRR Gateway"
    }
}

#Define routing table to allow traffic to our gateway and associate it with the public subnet 
resource "aws_route_table" "grr-routes" {
    vpc_id         = "${aws_vpc.grr-lab-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.grr-gateway.id}"
    }

    tags {
        Name       = "GRR Routes"
    }
}

resource "aws_route_table_association" "grr-routes-assc" {
    subnet_id      = "${aws_subnet.grr-pub-subnet.id}"
    route_table_id = "${aws_route_table.grr-routes.id}"
}

