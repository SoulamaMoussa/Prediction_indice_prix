# Prévision de l'indice des prix à la consommation au Burkina Faso

## En bref

- **Question :** quelle méthode statistique prévoit le mieux l'évolution de l'indice des prix sur les mois suivants ?
- **Données :** indice global des prix à la consommation (base 100 en 2014), mensuel, janvier 2015 – mai 2023, source INSD.
- **Méthodes :** lissage exponentiel double, régression linéaire sur une sous-période, modèle ARIMA.
- **Évaluation :** apprentissage sur janvier 2015 – décembre 2022 (96 mois), test sur janvier – mai 2023 (5 mois).
- **Résultat principal :** sur ce jeu de test, le lissage exponentiel double a la plus faible erreur quadratique moyenne.

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

 
**Ce que les données racontent**
 
1. **La situation.** Un panier de biens et services qui coûtait 100 en 2014 coûte 124,08 en mai 2023, soit 24 % de plus. L'indice était resté stable pendant des années.
2. **La rupture.** Depuis 2021, la hausse s'accélère : pic proche de 129 fin 2022, repli, puis nouvelle remontée de 121 à 124,08 entre janvier et mai 2023. Pour les ménages, cela se traduit par une perte de pouvoir d'achat.
3. **Ce que la prévision apporte.** Le lissage exponentiel double est la méthode la plus précise : son écart typique est d'environ 2,2 points d'indice sur 5 mois, soit moins de 2 % du niveau de l'indice. La régression s'écarte d'environ 3,7 points et l'ARIMA(10,1,1) d'environ 7,2 points. Le modèle le plus simple est donc aussi le plus fiable ici, car l'ARIMA, avec 12 paramètres pour 96 observations, surestime la hausse. Le lissage sous-estime tout de même la remontée de début 2023 (4 points d'écart en mai).
**Ce que cela permet de faire**
 
- **Pour la prévision :** utiliser le lissage exponentiel double comme outil d'alerte à court terme, mis à jour chaque mois avec les nouvelles données de l'INSD, et le comparer à d'autres méthodes sur plusieurs fenêtres avant tout usage opérationnel.
- **Pour l'action publique, selon les recommandations du rapport :** subventionner certains produits de première nécessité (gaz et autres combustibles, produits alimentaires) et consacrer une part importante du budget à la relance de l'économie.
Les causes de la hausse sont des éléments de contexte tirés du rapport : l'étude statistique décrit et prévoit l'indice sans démontrer ses causes.
 
Ce projet m'a permis de mener une étude de bout en bout : explorer une série, tester sa stationnarité, construire et valider plusieurs modèles, puis les comparer sur des données mises de côté.

## Limites et ce que j'en retiens

- **Jeu de test très court :** 5 mois et une seule origine de prévision. Le classement des méthodes est donc fragile.
- **Régression sur 5 observations :** la sous-série d'août à décembre 2022 est descendante et ne contient que 5 points. Le test sur la moyenne des résidus n'apporte aucune information, car il est toujours satisfait par une régression avec constante.
- **ARIMA(10,1,1) :** 12 paramètres pour 96 observations, avec un risque de surajustement.
- **Prévisions de juin à décembre 2023 :** elles datent de l'exercice de 2023 et ne sont pas des prévisions actuelles.
  

## Limites et pistes d'amélioration
 
- Le jeu de test est court (5 mois) : le classement des méthodes mériterait d'être confirmé.
- Piste 1 : évaluer chaque méthode sur plusieurs fenêtres chronologiques (validation à origine glissante).
- Piste 2 : ajouter une prévision de référence simple (dernière valeur, marche aléatoire avec dérive) pour mesurer l'apport réel des modèles.
- Piste 3 : tester un ARIMA plus parcimonieux.

## Reproduire

Prérequis : R et les packages `forecast` et `tseries`.

1. Récupérer la série de l'indice global des prix sur le site de l'INSD, ou utiliser le fichier `dataPrix.csv` du dépôt (séparateur `;`, indice en 2e colonne).
2. Ouvrir `ScriptIndicePrix.R` dans R ou RStudio et l'exécuter ; le script demande le chemin du fichier CSV.


## Source des données

Institut national de la statistique et de la démographie (INSD), Burkina Faso. Les données sont à utiliser dans le respect de leurs conditions de diffusion.
