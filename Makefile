# Variables
IMAGE_NAME = custom-nginx-lab
TAG = v1
CLUSTER_NAME = lab
NAMESPACE = default
PORT_FORWARD = 8081:80

.PHONY: all build import deploy clean test access forward stop-forward help

all: build import deploy ## Tout faire : build + import + deploy

build: ## Builder l'image Packer
	packer init nginx-custom.pkr.hcl
	packer validate nginx-custom.pkr.hcl
	packer build nginx-custom.pkr.hcl

import: ## Importer l'image dans k3d
	k3d image import $(IMAGE_NAME):$(TAG) -c $(CLUSTER_NAME)

deploy: ## Déployer via Ansible
	ansible-playbook deploy-nginx.yaml

clean: ## Nettoyer le déploiement (supprime deployment + service + pods)
	kubectl delete deployment nginx-custom --ignore-not-found=true
	kubectl delete service nginx-custom --ignore-not-found=true
	kubectl delete pod -l app=nginx-custom --force --grace-period=0 --ignore-not-found=true

test: ## Vérifications rapides
	kubectl get pods -l app=nginx-custom
	kubectl get svc nginx-custom
	kubectl get deployment nginx-custom

access: forward ## Ouvrir l'accès (port-forward + ouvre navigateur si Codespaces)
	@echo "Ouvre l'onglet PORTS dans Codespaces et rends public le port $(PORT_FORWARD)"

forward: ## Lance port-forward en background
	kubectl port-forward svc/nginx-custom $(PORT_FORWARD) >/dev/null 2>&1 &

stop-forward: ## Arrête tous les port-forwards
	pkill -f "port-forward.*nginx-custom" || true

help: ## Affiche cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
