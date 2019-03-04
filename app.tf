resource "aws_appautoscaling_target" "app_scale_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.ecs.name}/${aws_ecs_service.ecs.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = "${var.ecs_autoscale_max_instances}"
  min_capacity       = "${var.ecs_autoscale_min_instances}"
}


resource "aws_ecs_task_definition" "ecs" {
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "4096"
  memory                   = "16384"
  family = "wordpress"
  container_definitions = "${data.template_file.wordpress_task.rendered}"
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}

data "template_file" "wordpress_task" {
  template = "${file("files/wordpress_task.json")}"
  vars {
    repository_url = "${aws_ecr_repository.ecr.repository_url}"
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "wordpress-ecs"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/fargate/service/wordpress"
  retention_in_days = "14"
  tags              = "${var.tags}"
}
