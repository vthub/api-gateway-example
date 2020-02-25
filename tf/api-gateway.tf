locals {
  api_name = "event-api"
  stage_name = "default"
}

resource "aws_api_gateway_rest_api" "api" {
  name = local.api_name
  description = "Event API"
}

resource "aws_api_gateway_stage" "default" {
  deployment_id = aws_api_gateway_deployment.default.id
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name = local.stage_name

  depends_on = [
    aws_cloudwatch_log_group.log
  ]
}

resource "aws_cloudwatch_log_group" "log" {
  name = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.api.id}/${local.stage_name}"
  retention_in_days = 1
}

resource "aws_api_gateway_deployment" "default" {
  depends_on = [
    aws_api_gateway_method.event_post,
    aws_api_gateway_integration.event_post
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  description = "Deployed at ${timestamp()}"

  // https://medium.com/coryodaniel/til-forcing-terraform-to-deploy-a-aws-api-gateway-deployment-ed36a9f60c1a
  variables = {
    deployed_at = timestamp()
  }

  // https://github.com/hashicorp/terraform/issues/10674
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_usage_plan" "plan" {
  name = "${local.api_name}-api-usage-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.api.id
    stage = aws_api_gateway_stage.default.stage_name
  }
}

resource "aws_api_gateway_api_key" "key" {
  name = "${local.api_name}-api-key"
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id = aws_api_gateway_api_key.key.id
  key_type = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.plan.id
}

resource "aws_api_gateway_method_settings" "general_settings" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name = aws_api_gateway_stage.default.stage_name
  method_path = "*/*"
  settings {
    metrics_enabled = false
    data_trace_enabled = false
    //    logging_level          = "INFO"
    throttling_rate_limit = 100
    throttling_burst_limit = 50
  }
}

output "api_endpoint" {
  value = aws_api_gateway_deployment.default.invoke_url
}

output "api_key" {
  value = aws_api_gateway_api_key.key.value
}
