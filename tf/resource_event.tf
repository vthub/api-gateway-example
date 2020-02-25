resource "aws_api_gateway_resource" "event" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id = aws_api_gateway_rest_api.api.root_resource_id
  path_part = "events"
}

// OPTIONS

module "event_options" {
  source = "./options"

  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.event.id
}

// POST

resource "aws_api_gateway_method" "event_post" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.event.id
  api_key_required = true
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "event_post" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.event.id
  http_method = aws_api_gateway_method.event_post.http_method
  type = "MOCK"

  request_templates = {
    "application/json" = <<EOF
{
  "statusCode": 200,
  "body" : $input.json('$')
}
EOF
  }
}

resource "aws_api_gateway_method_response" "event_post" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.event.id
  http_method = aws_api_gateway_method.event_post.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "event_post" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.event.id
  http_method = aws_api_gateway_method.event_post.http_method
  status_code = aws_api_gateway_method_response.event_post.status_code
  selection_pattern = "-"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

    response_templates = {
      "application/json" = <<EOF
{
  "status": "success"
}
EOF
    }
}

// GET

resource "aws_api_gateway_method" "event_get" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.event.id
  api_key_required = true
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "event_get" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.event.id
  http_method = aws_api_gateway_method.event_get.http_method
  type = "MOCK"

  request_templates = {
    "application/json" = <<EOF
{
  "statusCode": 200,
  "body" : $input.json('$')
}
EOF
  }
}

resource "aws_api_gateway_method_response" "event_get" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.event.id
  http_method = aws_api_gateway_method.event_get.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "event_get" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.event.id
  http_method = aws_api_gateway_method.event_get.http_method
  status_code = aws_api_gateway_method_response.event_get.status_code
  selection_pattern = "-"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = <<EOF
[
  {
    "id": "AEy-Zvg-nXS-b1D",
    "message": "Server restart successful",
    "timestamp": "1582602230"
  },
  {
    "id": "L1X-2Am-Bm6-oaQ",
    "message": "Cache load successful",
    "timestamp": "1582602257"
  }
]
EOF
  }
}
