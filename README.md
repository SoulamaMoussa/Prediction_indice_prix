# Prediction_indice_prix
Prédiction de l'indice des prix

---
title: "Prévision de l'indice des prix au Burkina Faso"
---

# Contexte et problématique

L'évolution des prix à la consommation est un indicateur important pour analyser l'inflation et ses implications pour le pouvoir d'achat des ménages.

Ce projet, réalisé dans le cadre d'un cours de séries temporelles, étudie l'évolution de l'indice global des prix à la consommation au Burkina Faso à partir de données de l'Institut national de la statistique et de la démographie (INSD).

L'objectif est de caractériser la dynamique de la série, de construire des modèles de prévision et de comparer leurs résultats.

## Données

- **Source :** INSD, Burkina Faso.
- **Périodicité :** mensuelle.
- **Période :** janvier 2015 à mai 2023.
- **Indicateur :** indice global des prix à la consommation, base 100 en 2014.

L'indice décrit l'évolution des prix d'un panier de biens et services. Il ne mesure pas directement le coût total de la vie pour chaque ménage.

## Démarche statistique

### 1. Analyse exploratoire

Étude graphique de l'évolution de la série, de sa tendance et de la présence éventuelle d'une saisonnalité.

### 2. Lissage exponentiel

Estimation d'un modèle de lissage exponentiel avec tendance additive, adapté à une série présentant une tendance sans saisonnalité nette.

### 3. Régression sur une sous-période

Estimation d'une tendance par régression linéaire sur une portion de la série, puis production de prévisions.

### 4. Modélisation ARIMA

Étude de la stationnarité, application d'une première différence, examen des corrélogrammes et comparaison de modèles candidats à l'aide du critère BIC.

### 5. Validation

Analyse des résidus et comparaison des erreurs de prévision ainsi que de la couverture des intervalles.

## Résultats du rapport académique

Le rapport fait ressortir une tendance globalement croissante de l'indice sur la période étudiée et ne relève pas de saisonnalité nette.

Les erreurs quadratiques moyennes rapportées sont de 4,98 pour le lissage exponentiel double, 13,95 pour la régression sur une sous-période et 5,14 pour le modèle ARIMA(10,1,1).

Ces valeurs sont reprises du rapport initial. Les calculs de validation et de couverture doivent être revérifiés avant de tirer une conclusion définitive sur la performance comparative des modèles.

## Compétences mobilisées

- Programmation statistique avec R.
- Analyse exploratoire de séries temporelles.
- Étude de la stationnarité et différenciation.
- Modélisation par lissage exponentiel, régression et ARIMA.
- Diagnostic des résidus et évaluation des prévisions.

## Limites et pistes d'amélioration

Le projet repose sur des données historiques arrêtées en mai 2023. Les prévisions du rapport correspondent à l'exercice académique réalisé en 2023 et ne sont pas des prévisions actualisées.

Une suite possible consiste à corriger et documenter l'évaluation des modèles, à utiliser une validation chronologique et à comparer les prévisions à une méthode de référence.

