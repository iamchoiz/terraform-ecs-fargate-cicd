owner                      = "dcc"
env                        = "ap-dev"
region                     = "ap-northeast-2"
aws_account_id             = ""

########################## ECS Cluster
ecs_cluster_name           = "ecs-cluster"
container_insights         = true
capacity_providers         = ["FARGATE", "FARGATE_SPOT"]
ecs_cluster_tags           = {}

########################## ECS Task Definition
family                     = "ecs-task"
requires_compatibilities   = ["FARGATE"]
image_name                 = "dev-pipeline-demo"
image_tag                  = "1"
execution_role_arn         = ""
network_mode               = "awsvpc"
container_definitions_path = "task-definitions/service.json"
cpu                        = 256
memory                     = 512

########################## ECS Service
service_name               = "ecs-demo-service"
scheduling_strategy        = "REPLICA"
force_new_deployment       = true
desired_count              = 1
container_name             = "demo"
container_port             = 80
capacity_provider          = "FARGATE_SPOT"
capacity_provider_weight   = 100
capacity_provider_base     = 1
deployment_controller      = "CODE_DEPLOY"
// deployment_controller   = "ECS"

########################## ALB
load_balancer_type         = "application"
target_type                = "ip"
backend_protocol           = "HTTP"
backend_port               = "80"
alb_name                   = "alb"
http_tcp_listeners = [
  {
    port        = 80
    protocol    = "HTTP"
    action_type = "fixed-response"
    fixed_response = {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "403"
    }
  },
  {
    port        = 8080
    protocol    = "HTTP"
    action_type = "fixed-response"
    fixed_response = {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "403"
    }
  }

]
http_tcp_listener_rules = [
  {
    http_listener_index = 0
    actions = [{
      type               = "forward"
      target_group_index = 0
    }]
    conditions = [{
      path_patterns = ["/*"]
    }]
  },
  {
    http_listener_index = 0
    actions = [{
      type               = "forward"
      target_group_index = 0
    }]
    conditions = [{
      path_patterns = ["/*"]
    }]
  }

]
########################## Security Group
http_sg_description        = "HTTP Security group for ALB"
http_ingress_cidr_blocks   = ["0.0.0.0/0"]
http_ingress_rules         = ["http-80-tcp"]
http_egress_rules          = ["all-all"]