#Building EC2 Instance
resource "aws_lightsail_instance" "wordpress_instance" {
  name              = var.instance_name
  availability_zone = "us-east-1a"
  blueprint_id      = var.blueprint_id
  bundle_id         = "nano_3_0"
}

#Creating Static IP
resource "aws_lightsail_static_ip" "static_ip" {
  name = "${var.instance_name}_ip"
}

#Attaching Static IP to Instance
resource "aws_lightsail_static_ip_attachment" "ip_attachment" {
  static_ip_name = aws_lightsail_static_ip.static_ip.name
  instance_name  = aws_lightsail_instance.wordpress_instance.name
}

#Create DNS Zone
resource "aws_route53_zone" "primary" {
  name = var.domain_name
}
#Creating DNS Record for www.cloud-corner.com
resource "aws_route53_record" "www_DNS" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = [aws_lightsail_static_ip.static_ip.ip_address]
}
#Creating DNS Record for cloud-corner.com
resource "aws_route53_record" "apex_DNS" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = "300"
  records = [aws_lightsail_static_ip.static_ip.ip_address]
}

#Creating domain entry resource 
resource "aws_lightsail_domain" "domain_entry" {
  domain_name = "cloud-corner.com"
}
#Point DNS Record for www.cloud-corner.com to instance 
resource "aws_lightsail_domain_entry" "Cloud-Corner" {
  domain_name = aws_lightsail_domain.domain_entry.domain_name
  name        = "www"
  type        = "A"
  target      = aws_lightsail_static_ip.static_ip.ip_address
}
#Point DNS Record for cloud-corner.com to instance 
resource "aws_lightsail_domain_entry" "www-Cloud-Corner" {
  domain_name = aws_lightsail_domain.domain_entry.domain_name
  name        = ""
  type        = "A"
  target      = aws_lightsail_static_ip.static_ip.ip_address
}

#FireWall Rules. 
resource "aws_lightsail_instance_public_ports" "public_ports" {
  instance_name = aws_lightsail_instance.wordpress_instance.name

  port_info {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
  }

  port_info {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
  }
  port_info {
    protocol = "tcp"
    from_port = 22
    to_port =  22
  }
}


