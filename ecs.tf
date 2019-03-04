#  The name of the container to run
variable "container_name" {
  default = "app"
}

# The minimum number of containers that should be running.
# Must be at least 1.
# used by both autoscale-perf.tf and autoscale.time.tf
# For production, consider using at least "2".
variable "ecs_autoscale_min_instances" {
  default = "3"
}

# The maximum number of containers that should be running.
# used by both autoscale-perf.tf and autoscale.time.tf
variable "ecs_autoscale_max_instances" {
  default = "50"
}



resource "aws_ecs_cluster" "ecs" {
  name = "wordpress-cluster"
}

# resource "aws_ecs_service" "ecs" {
#   name = "wordpress-service"
#   cluster = "${aws_ecs_cluster.ecs.id}"
#   desired_count = 1
#   task_definition = "${aws_ecs_task_definition.ecs.family}"
# }
resource "aws_ecs_service" "ecs" {
  name            = "wordpress-service"
  cluster         = "${aws_ecs_cluster.ecs.id}"
  launch_type     = "FARGATE"
  task_definition = "${aws_ecs_task_definition.ecs.arn}"
  desired_count   = "2"

  network_configuration {
    security_groups = ["${aws_security_group.ecs.id}", "${aws_security_group.ec2_egress.id}"]
    subnets         = ["${aws_subnet.private_subnet_zoneA.id}", "${aws_subnet.private_subnet_zoneB.id}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.main.id}"
    container_name   = "wordpress"
    container_port   = "80"
  }

  # workaround for https://github.com/hashicorp/terraform/issues/12634
  depends_on = [
    "aws_alb_listener.http",
  ]

  # [after initial apply] don't override changes made to task_definition
  # from outside of terrraform (i.e.; fargate cli)
  lifecycle {
    ignore_changes = ["task_definition"]
  }
}



