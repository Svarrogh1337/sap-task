## Location to install dependencies to
LOCALBIN ?= $(shell pwd)/bin
$(LOCALBIN):
	mkdir -p $(LOCALBIN)
####################
# -- Terraform
####################
TERRAFORM         := $(LOCALBIN)/terraform
TERRAFORM_VERSION := 1.13.3
OS                ?= $(shell uname | tr '[:upper:]' '[:lower:]')
ARCH              ?= $(shell arch)
terraform:
	@test -s $(TERRAFORM) && $(TERRAFORM) --version | grep -q $(TERRAFORM_VERSION) || \
	(curl -sSL https://releases.hashicorp.com/terraform/1.13.3/terraform_1.13.3_$(OS)_$(ARCH).zip -o terraform.zip && \
	unzip terraform.zip 'terraform' -d $(LOCALBIN) && \
	rm -f terraform.zip);
.PHONY: terraform init plan apply destroy docker-build docker-login docker-push app-build test-curl
init: terraform
	$(TERRAFORM) -chdir=infra init -migrate-state
plan: terraform init
	$(TERRAFORM) -chdir=infra plan
apply: terraform init
	$(TERRAFORM) -chdir=infra apply -auto-approve -lock=false
destroy: terraform init
	$(TERRAFORM) -chdir=infra destroy -auto-approve -lock=false

####################
# -- App build
####################
docker-login:
	@aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 852087449769.dkr.ecr.eu-west-1.amazonaws.com && \
	 aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 852087449769.dkr.ecr.eu-central-1.amazonaws.com
app-build: docker-build docker-push
docker-push: docker-login
	@docker push 852087449769.dkr.ecr.eu-central-1.amazonaws.com/sap-infra-primary-app:go-app && \
    docker push 852087449769.dkr.ecr.eu-west-1.amazonaws.com/sap-infra-secondary-app:go-app

docker-build:
	@docker build \
	--tag 852087449769.dkr.ecr.eu-central-1.amazonaws.com/sap-infra-primary-app:go-app \
	--tag 852087449769.dkr.ecr.eu-west-1.amazonaws.com/sap-infra-secondary-app:go-app \
	--platform linux/amd64 app/

####################
# -- E2E setup
####################
e2e-build: apply app-build

####################
# -- Test
####################
test-curl:
	@for ((i=1;i<=100000;i++)); do curl http://app.eko.dev/health; echo; done