# Étapes détaillées du travail réalisé – 05/02/2026

## Mission acceptée

Créer une **image applicative customisée** à l’aide de **Packer**  
(Image de base : nginx:alpine + fichier `index.html` présent à la racine du repository)  

Puis **déployer** cette image customisée sur un **cluster k3d** via **Ansible**,  
le tout réalisé dans **GitHub Codespaces**.

**Architecture cible**  
![Architecture cible](Architecture_cible.png)

## Objectifs de l’atelier

Industrialiser le cycle de vie d’une application web simple via une chaîne IaC complète :

- Build d’image applicative → **Packer**
- Import dans cluster Kubernetes local → **k3d**
- Déploiement automatisé → **Ansible**
- Environnement reproductible → **GitHub Codespaces**

## Arborescence finale du projet
Image_to_Cluster/ <br/>
├── index.html                  # Page web personnalisée <br/>
├── nginx-custom.pkr.hcl        # Template Packer <br/>
├── deploy-nginx.yaml           # Playbook Ansible<br/>
├── k8s/<br/>
│   ├── deployment.yaml         # Manifest Deployment (avec probes + resources)<br/>
│   └── service.yaml            # Manifest Service NodePort<br/>
├── Makefile                    # Automatisation complète <br/>
└── README.md                   # Documentation<br/>

## Travail réalisé – étapes chronologiques

1. Création du cluster k3d léger (1 serveur + 2 agents)  
2. Construction de l’image customisée avec Packer    
3. Import de l’image dans le cluster k3d  
4. Déploiement via Ansible (Deployment + Service)    
5. Accès sécurisé via port-forward dans Codespaces
6. Automatisation complète via Makefile

## Pour lancer ce projet (instructions pour l’utilisateur)

Pour créer le cluster (si besoin), construire l’image, déployer et ouvrir l’accès, veuillez utiliser cette commande :
```bash
make bootstrap
```

Cela exécute successivement :
- Création du cluster si besoin (make create-cluster)
- Construction Packer (make build)
- Import image dans k3d (make import)
- Déploiement Ansible (make deploy)
- Lancement du port-forward en arrière-plan (make forward)

Accès à la page web :
Dans l’interface Codespaces → onglet PORTS (en bas)
Port 8081 apparaît → clique sur le cadenas → Public
Clique sur Open in Browser (ou sur l’URL proposée)

→ La page index.html personnalisée s’affiche.

### Commandes utiles du Makefile
```
make help           # Liste toutes les commandes disponibles
make all            # Build + import + deploy 
make forward        # Lancer port-forward (8081:80)
make clean          # Supprimer Deployment + Service 
make test           # Vérifier état pods / services
make build          # Rebuild image Packer (utile après modif index.html)
make stop-forward   # Arrêter port-forwards en cours
```
