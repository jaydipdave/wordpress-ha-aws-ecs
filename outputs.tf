output "ecr_repository" {
  value = "${aws_ecr_repository.ecr.repository_url}"
}

output "elb_dns" {
  value = "${aws_alb.main.dns_name}"
}
