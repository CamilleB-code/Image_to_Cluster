Etapes détaillées du travail réalisé 

La mission (acceptée) : Créez une **image applicative customisée à l'aide de Packer** (Image de base Nginx embarquant le fichier index.html présent à la racine de ce Repository), puis déployer cette image customisée sur votre **cluster K3d** via **Ansible**, le tout toujours dans **GitHub Codespace**.  

**Architecture cible :** Ci-dessous, l'architecture cible souhaitée.   
  
![Screenshot Actions](Architecture_cible.png)   
  
---------------------------------------------------  
###Les objectifs de la mission 
Cet atelier vise à industrialiser le cycle de vie d'une application web simple en passant par :
- Création d'une image Docker customisée (Nginx + index.html personnel) avec **Packer**
- Import de l'image dans un cluster Kubernetes local (**k3d**)
- Déploiement automatisé sur le cluster via **Ansible**
- Le tout dans un environnement reproductible : **GitHub Codespaces**

L'idée est de maîtriser une chaîne IaC (Infrastructure as Code) complète : build d'image → import → déploiement.

Image_to_Cluster/
├── index.html                  # La page web personnalisée
├── nginx-custom.pkr.hcl        # Template Packer pour construire l'image Nginx custom
├── deploy-nginx.yaml           # Playbook Ansible pour déployer sur k3d
├── k8s/
│   ├── deployment.yaml         # Manifest Deployment
│   └── service.yaml            # Manifest Service NodePort
├── Makefile                    # Automatisation des étapes (bonus)
└── README.md                   # Ce fichier

###Travail réalisé

1. Créer le cluster k3d
2. Construire l'image avec Packer
3. Importer l'image dans le cluster k3d
4. Déployer l'application avec Ansible
5. Accéder à l'application
6. Vérification du bon fonctionnement
7. Automatisation du déploiement avec Makefile

---------------------------------------------------

###Pour lancer ce projet 

1. Prérequis (à faire qu'une seule fois)
# Installer k3d si pas déjà fait
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Créer le cluster (peut être refait si besoin)
k3d cluster create lab --servers 1 --agents 2

2. Lancer le programme en une seule commande  et accéder à la page associée ensuite : 
make all && make forward

Cela va automatiquement :
- construire une image
- importer cette image dans le cluster 
- déployer le Deployment et Service

Puis via l'onglet PORTS de Codespaces, vous pouvez accéder à la page web associée (Open in Browser).

Autres commandes utiles : 
make help          # Affiche la liste complète des commandes
make build         # Seulement construire l’image Packer
make import        # Seulement importer l’image dans k3d
make deploy        # Seulement déployer avec Ansible
make test          # Vérifier rapidement pods + services
make clean         # Supprimer le déploiement (pods + service)
make stop-forward  # Arrêter le port-forward si besoin
