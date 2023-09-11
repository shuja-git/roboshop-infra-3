git:
	git pull
dev-apply: git
	terraform -backend-config=env-dev/state.tfvars
	terraform apply -auto-approve -var-file=env-dev/main.tfvars
dev-destroy:
	terrform destroy -auto-approve -var-file=env-dev/main.tfvars


