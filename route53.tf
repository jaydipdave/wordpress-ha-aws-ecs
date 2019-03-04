resource "aws_route53_zone" "wordpress_ael" {
  name          = "wordpress.ael."
  vpc {
    vpc_id        = "${aws_vpc.vpc_wordpress.id}"
  }
}

resource "aws_route53_record" "db_wordpress_ael" {
    zone_id = "${aws_route53_zone.wordpress_ael.zone_id}"
    name    = "${var.db_fqdn}"
    type    = "CNAME"
    ttl     = "300"
    records = [
        "${aws_db_instance.rds.address}"
    ]
}


variable "db_fqdn" {
  default = "db.wordpress.ael"
}

