#Keypair to get our Windows passwords
resource "aws_key_pair" "grr-win-key" {
  key_name   = "grr-win-deploy"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDwJtZfFh0a7MaPVHoqSsm2aMY8476+hueVIc8TNymiXtzzi4H4B4YuZm7yHx06EzLDr2g1AQHaEmTCzT26FsBJvLj5kJd4yeDKRduayoNrq13xKqKSc8aw/P8o4a3mkfk6dnZS1zYjw+yyfU0pyGUMbOqf4DQSq890Yg9F8dppYOxvfehldEp82VWgzUeOyLY0RKfhYvOGY32Pdtijf+2QoSFmSayo91PVqc2yusy26Dzw5fqSJ/PgkuLtWCeWsi6NpbDXAQnFxdQbrdXkvB7qLi5RG4ScuOpVRLI29lgd9YmrZvKFBK/0UbNN7iSpTXV6PUCAnPRieOi4cZGlPaAN khronos@yggdrasil" 
}

#Keypair to SSH
resource "aws_key_pair" "grr-nix-key" {
  key_name   = "grr-nix-deploy"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDr/jCVyr1Egfhkh0Wmgx9w7BRweulbb766DgbFoZA++3m5CAiheN2hAOH6D1jc2/FFKvy5c8NsptCstDefsqdxv7oiOJN7VrQr5fEQjobpMwyFt6niID2O5hrFN27FJOJawcJAzucFMMD6Zlp9bZ0DqKjBA6eZ4FXoVcb8J46pIHnCeoNxovrRCmfr4bD35BCuBeMCWOo8DzS3FZZiPgBq6Nys/CNMkcca54mqKiQOdkJk6RQizfd8Tdet69H6903cU0xX1mFOiyfbrSfeKMMy1nMiF2/8QcvinyGRl3TpiU2u/9Fez1rX1jP1M2IbKIgial4mKnorFhSNZPic3wwV khronos@yggdrasil" 
}

#Bastion host
resource "aws_instance" "grr-bastion-host" {
  ami                         = "ami-c9deafb1"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.grr-sg-external.id}"]
  subnet_id                   = "${aws_subnet.grr-pub-subnet.id}"
  associate_public_ip_address = true
  key_name                    = "${aws_key_pair.grr-win-key.id}"

  tags {
    Name                      = "GRR Bastion"
  }
}

#GRR server
resource "aws_instance" "grr-server" {
  ami                         = "ami-db710fa3"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.grr-sg-internal.id}"]
  subnet_id                   = "${aws_subnet.grr-priv-subnet.id}"
  key_name                    = "${aws_key_pair.grr-nix-key.id}"

  tags {
    Name                      = "GRR Server"
  }
}

#GRR client
resource "aws_instance" "grr-client-host" {
  ami                         = "ami-c9deafb1"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.grr-sg-internal.id}"]
  subnet_id                   = "${aws_subnet.grr-priv-subnet.id}"
  key_name                    = "${aws_key_pair.grr-win-key.id}"

  tags {
    Name                      = "GRR Test Client"
  }
}
