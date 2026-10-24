# Prévision de l'indice des prix à la consommation au Burkina Faso

Comparaison de trois méthodes de prévision (lissage exponentiel, régression, ARIMA) sur l'indice mensuel des prix, avec **R**.

## En bref

- **Question :** quelle méthode statistique prévoit le mieux l'évolution de l'indice des prix sur les mois suivants ?
- **Données :** indice global des prix à la consommation (base 100 en 2014), mensuel, janvier 2015 – mai 2023, source INSD.
- **Méthodes :** lissage exponentiel double, régression linéaire sur une sous-période, modèle ARIMA.
- **Évaluation :** apprentissage sur janvier 2015 – décembre 2022 (96 mois), test sur janvier – mai 2023 (5 mois).
- **Résultat principal :** sur ce jeu de test, le lissage exponentiel double a la plus faible erreur quadratique moyenne (4,98).
- **Cadre :** projet de groupe réalisé dans un cours de séries temporelles, rapport rendu en juin 2023.

## Contexte

L'indice des prix à la consommation mesure l'évolution moyenne des prix d'un panier de biens et services achetés par les ménages. Il permet de suivre l'inflation, sans suffire à mesurer à lui seul le coût de la vie. Le projet cherche à décrire la dynamique de cet indice au Burkina Faso, puis à comparer plusieurs approches de prévision sur des mois que les modèles n'ont pas vus.

## Démarche

1. **Analyse exploratoire :** tracé de la série, tendance croissante, comparaison d'un même mois d'une année à l'autre pour chercher une saisonnalité (aucune saisonnalité nette).
2. **Lissage exponentiel double :** modèle à tendance additive et sans saisonnalité, adapté à une série qui monte sans cycle annuel. Résidus vérifiés par leur autocorrélation et des tests de normalité.
3. **Décomposition et régression :** tendance estimée par régression linéaire sur une sous-période (août – décembre 2022), résidus examinés (autocorrélation, moyenne, normalité).
4. **ARIMA :**
   - test de Dickey-Fuller : série non stationnaire ; après une différenciation, stationnarité acceptée au seuil de 5 % (p ≈ 0,041) ;
   - choix des ordres à partir des corrélogrammes ACF et PACF ;
   - comparaison de modèles candidats par le critère BIC, modèle final ARIMA(10,1,1) ;
   - diagnostic des résidus : Ljung-Box, QQ-plot, test de Shapiro-Wilk.
5. **Comparaison :** erreur quadratique moyenne sur les 5 mois de test.

## Résultats

| Méthode | Erreur quadratique moyenne (janv. – mai 2023) |
|---|---:|
| Lissage exponentiel double | **4,98** |
| Régression sur une sous-période | 13,95 |
| ARIMA(10,1,1) | 52,14 (1) |

(1) Le rapport indique 5,14. Recalculée à partir des valeurs prévues et observées du tableau 6 du rapport, l'erreur est de 52,14 ; le classement reste le même.

**Lecture :** la série est globalement croissante, sans saisonnalité nette. Les prévisions du lissage exponentiel et de la régression baissent légèrement alors que l'indice observé monte (121 puis 124,08) : leur erreur grandit avec l'horizon. L'ARIMA(10,1,1), lui, surestime la hausse, avec un écart de 9,5 points au cinquième mois.

## Limites et ce que j'en retiens

- **Jeu de test très court :** 5 mois et une seule origine de prévision. Le classement des méthodes est donc fragile.
- **Régression sur 5 observations :** la sous-série d'août à décembre 2022 est descendante et ne contient que 5 points. Le test sur la moyenne des résidus n'apporte aucune information, car il est toujours satisfait par une régression avec constante.
- **ARIMA(10,1,1) :** 12 paramètres pour 96 observations, avec un risque de surajustement.
- **Couverture des intervalles de prévision :** les valeurs du rapport (0,2 ; 0 ; 0,2) ne correspondent pas aux intervalles publiés dans ses tableaux. Je ne les retiens pas ici ; elles sont à recalculer.
- **Prévisions de juin à décembre 2023 :** elles datent de l'exercice de 2023 et ne sont pas des prévisions actuelles.

## Pistes d'amélioration

- Évaluer chaque méthode sur plusieurs fenêtres chronologiques (validation à origine glissante) plutôt que sur 5 mois.
- Ajouter une prévision de référence simple (dernière valeur, ou marche aléatoire avec dérive) pour juger si les modèles apportent quelque chose.
- Choisir les ordres ARIMA de façon plus parcimonieuse et comparer avec une sélection automatique.
- Recalculer la couverture des intervalles de prévision à partir des vrais intervalles.

## Reproduire

Prérequis : R et les packages `forecast` et `tseries`.

1. Récupérer la série de l'indice global des prix sur le site de l'INSD, ou utiliser le fichier `dataPrix.csv` du dépôt (séparateur `;`, indice en 2e colonne).
2. Ouvrir `ScriptIndicePrix.R` dans R ou RStudio et l'exécuter ; le script demande le chemin du fichier CSV.


## Source des données

Institut national de la statistique et de la démographie (INSD), Burkina Faso. Les données sont à utiliser dans le respect de leurs conditions de diffusion.
