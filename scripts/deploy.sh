terraform init
terraform workspace select dev || terraform workspace new dev
terraform apply -var-file=env/dev.tfvars -auto-approve