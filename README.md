
# PrintedData - Suivi et gestion des impressions

## Description

**PrintedData** est une application iOS qui vous permet de mieux gérer vos impressions. Elle vous aide à :
- Chronométrer vos impressions pour savoir exactement quand elles sont terminées.
- Enregistrer et suivre les données de chaque impression réalisée pour une meilleure organisation et analyse.

Cette application est particulièrement utile pour les utilisateurs qui gèrent plusieurs impressions à la fois, souhaitent optimiser leur flux de travail ou simplement garder une trace de leurs impressions pour une consultation future.

## Fonctionnalités

- **Minuteur d'impression** : Définissez un minuteur personnalisé pour chaque impression et recevez des notifications lorsque l'impression est terminée.
- **Historique des impressions** : Enregistrez les informations essentielles de chaque impression, y compris la durée, le type de papier utilisé, l'imprimante et d'autres détails pertinents.
- **Données d'impression détaillées** : Affichez et exportez l'historique de vos impressions avec toutes les données enregistrées pour analyse.
- **Notifications intelligentes** : Recevez des rappels et des alertes lorsque vos impressions sont sur le point de se terminer.
- **Statistiques** : Analysez la fréquence, la durée moyenne et d'autres statistiques utiles à propos de vos impressions. (in-progress)

### Prérequis

- iOS 14.0 ou version ultérieure
- Connexion à Internet pour synchroniser les données (optionnel)

## Utilisation

### 1. Créer une nouvelle impression
- Lancez l'application et appuyez sur **Nouvelle Impression**.
- Entrez les détails de l'impression, comme le nom, l'imprimante utilisée, et la durée estimée.
- Démarrez le minuteur pour suivre le temps restant.

### 2. Suivre l'impression en temps réel
- Pendant que l'impression est en cours, l'application affichera le temps restant.
- Vous recevrez une notification une fois l'impression terminée.

### 3. Enregistrer les données de l'impression
- À la fin de chaque impression, vous pouvez choisir de sauvegarder les détails.
- Consultez l'historique de vos impressions dans l'onglet **Anciens Prints**.

### 4. Accéder aux statistiques
- Accédez à l'onglet **Anciens Prints** pour visualiser des informations agrégées sur vos impressions passées.

## Technologies utilisées

- **Swift** : Langage principal utilisé pour développer l'application.
- **Core Data** : Pour la gestion de la base de données locale des impressions.
- **User Notifications** : Pour gérer les notifications de fin d'impression.
- **UIKit** : Interface utilisateur simple et intuitive.

## Contributions

Les contributions sont les bienvenues ! Si vous souhaitez participer au projet :
1. Forkez le dépôt.
2. Créez une branche avec un descriptif clair de votre fonctionnalité (`git checkout -b feature/NouvelleFonctionnalité`).
3. Effectuez vos changements et testez-les.
4. Envoyez une pull request.

N'hésitez pas à soumettre des suggestions d'amélioration ou à signaler des problèmes en ouvrant une issue.

## Aprecus
![alt text] (./Images/Screenshot1.png)
![alt text] (./Images/Screenshot2.png)
![alt text] (./Images/Screenshot3.png)

## Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.
