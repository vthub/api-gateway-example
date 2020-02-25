# API Gateway Sample

This project describes a Mocked API Gateway setup using Terraform.

To deploy Terraform configuration do:

```shell script
cd tf/
terraform init
terraform apply
``` 

(Your AWS credentials should be located in `~/.aws/api-gateway-sample-credentials`)

To Test an API run the following:

```shell script
curl --location --request GET '[YOUR_API_URL]/default/events' \
--header 'x-api-key: [YOUR_API_KEY]' \
--header 'Content-Type: application/json'
```

or 

```shell script
curl --request POST '[YOUR_API_URL]/default/events' \
--header 'x-api-key: [YOUR_API_KEY]' \
--header 'Content-Type: application/json' \
--data-raw '{
    "message": "Server restart successful",
    "timestamp": "1582602230"
}'
```
