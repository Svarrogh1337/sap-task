## Location to install dependencies to
LOCALBIN ?= $(shell pwd)/bin
$(LOCALBIN):
	mkdir -p $(LOCALBIN)
####################
# -- Globals
####################
OS                ?= $(shell uname | tr '[:upper:]' '[:lower:]')
ARCH              ?= $(shell arch)
####################
# -- Terraform
####################
TERRAFORM         := $(LOCALBIN)/terraform
TERRAFORM_VERSION := 1.13.3
terraform:
	@test -s $(TERRAFORM) && $(TERRAFORM) --version | grep -q $(TERRAFORM_VERSION) || \
	echo https://releases.hashicorp.com/terraform/1.13.3/terraform_1.13.3_$(OS)_$(ARCH).zip -o terraform.zip && \
	(curl -sSL https://releases.hashicorp.com/terraform/1.13.3/terraform_1.13.3_$(OS)_$(ARCH).zip -o terraform.zip && \
	unzip terraform.zip 'terraform' -d $(LOCALBIN) && \
	rm -f terraform.zip);
.PHONY: terraform init plan apply destroy docker-build docker-login docker-push app-build test-curl docs e2e-deploy
init: terraform
	$(TERRAFORM) -chdir=infra init -migrate-state
plan: terraform init
	$(TERRAFORM) -chdir=infra plan
apply: terraform init
	$(TERRAFORM) -chdir=infra apply -auto-approve -lock=false
destroy: terraform init
	$(TERRAFORM) -chdir=infra destroy -auto-approve -lock=false
fmt: terraform
	$(TERRAFORM) -chdir=infra fmt -recursive
####################
# -- App build
####################
docker-login:
	@aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 852087449769.dkr.ecr.eu-west-1.amazonaws.com && \
	 aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 852087449769.dkr.ecr.eu-central-1.amazonaws.com

docker-push: docker-login
	@docker push 852087449769.dkr.ecr.eu-central-1.amazonaws.com/sap-infra-primary-app:go-app && \
    docker push 852087449769.dkr.ecr.eu-west-1.amazonaws.com/sap-infra-secondary-app:go-app

docker-build:
	@docker build \
	--tag 852087449769.dkr.ecr.eu-central-1.amazonaws.com/sap-infra-primary-app:go-app \
	--tag 852087449769.dkr.ecr.eu-west-1.amazonaws.com/sap-infra-secondary-app:go-app \
	--platform linux/amd64 app/

app-build: docker-build docker-push
####################
# -- E2E setup
####################
e2e-deploy: apply app-build

####################
# -- Test
####################
test-curl:
	@for ((i=1;i<=100000;i++)); do curl http://app.eko.dev/health; echo; done

####################
# -- Docs
####################
TERRAFORM-DOCS         := $(LOCALBIN)/terraform-docs
TERRAFORM-DOCS_VERSION := v0.20.0
OS                ?= $(shell uname | tr '[:upper:]' '[:lower:]')
ARCH              ?= $(shell arch)
docs:
	@test -s $(TERRAFORM-DOCS) && $(TERRAFORM-DOCS) --version | grep -q $(TERRAFORM-DOCS_VERSION) || \
	(curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.20.0/terraform-docs-v0.20.0-$(OS)-$(ARCH).tar.gz && \
	tar -xzf terraform-docs.tar.gz -C $(LOCALBIN) terraform-docs && \
	rm -f terraform-docs.tar.gz);
generate-docs: docs
	$(TERRAFORM-DOCS) markdown table --output-file README.md --output-mode inject infra/modules/ecs

