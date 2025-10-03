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
.PHONY: terraform init plan apply destroy
init: terraform
	$(TERRAFORM) -chdir=infra init -migrate-state
plan: terraform init
	$(TERRAFORM) -chdir=infra plan
apply: terraform init
	$(TERRAFORM) -chdir=infra apply -auto-approve
destroy: terraform init
	$(TERRAFORM) -chdir=infra destroy -auto-approve



