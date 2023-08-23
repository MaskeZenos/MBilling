# MBilling

Ce script permet aux joueurs d'envoyer et de gérer des factures dans leur serveur FiveM utilisant le framework ESX.

## Fonctionnalités

- Les joueurs peuvent envoyer des factures à d'autres joueurs en spécifiant une raison et un montant.
- Les joueurs peuvent consulter la liste des factures qu'ils ont reçues.
- Les joueurs peuvent consulter la liste des factures de leur job (uniquement pour les jobs ayant les permissions nécessaires).
- Les joueurs peuvent payer les factures qu'ils ont reçues (uniquement si le montant a été payé).

## Installation

1. Téléchargez le script depuis le dépôt GitHub.
2. Placez le dossier `mBilling` dans le dossier `resources` de votre serveur FiveM.
3. Importez le fichier SQL `mbilling.sql` dans votre base de données.
4. Ajoutez `start mBilling` dans votre fichier `server.cfg` pour démarrer le script.

## Utilisation

- Pour ouvrir le menu de facturation, les joueurs peuvent utiliser la commande `/billing` ou appuyer sur une touche prédéfinie (à configurer dans le fichier `client.lua`).
- Les joueurs peuvent envoyer des factures en spécifiant une raison et un montant.
- Les joueurs peuvent consulter la liste des factures qu'ils ont reçues et les payer si nécessaire.
- Les joueurs ayant les permissions nécessaires peuvent consulter et supprimer les factures de leur job.

## Configuration

Dans le fichier `client.lua`, vous pouvez modifier la touche pour ouvrir le menu de facturation.

## Crédits

Ce script a été créé par [vSync](https://github.com/vSyncDev).
