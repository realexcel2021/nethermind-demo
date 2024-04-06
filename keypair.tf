resource "aws_key_pair" "temp_keypair" {
  key_name   = "test_keypair"
  public_key = data.tls_public_key.private_key_pem.public_key_openssh
}

resource "tls_private_key" "ed25519" {
  algorithm = "RSA"
}

# Public key loaded from a terraform-generated private key, using the PEM (RFC 1421) format
data "tls_public_key" "private_key_pem" {
  private_key_pem = tls_private_key.ed25519.private_key_pem
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.temp_keypair.key_name}.pem"
  content = tls_private_key.ed25519.private_key_pem
}