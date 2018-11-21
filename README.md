
export or set variables

export AWS_ACCESS_KEY_ID=<id>
export AWS_SECRET_ACCESS_KEY=<secret>
export AWS_DEFAULT_REGION=<region>
export KUBECONFIG=config

cd eks-getting-started
terraform apply

terraform output kubeconfig | tee ../config
terraform output config_map_aws_auth | tee ../config_map_aws_auth.yaml

KUBECONFIG=config kubectl  apply -f config_map_aws_auth.yaml

