#########################################################################
######## PROJET: ETUDE DE L'INDICE DES PRIX A LA CONSOMMATION
########
######## Auteur :  SOULAMA Moussa
#########################################################################


### La commande ci dessous permet d'importer notre jeu de donnees
### Il suffit juste de l'excecuter ensuite indiquer le chemin la ou 
### se trouve votre fichier csv.

jeu = read.csv2(file.choose())

library(forecast)

### Apres avoir importer notre jeu de donnees,nous avons maintenant
### creer notre serie indice des prix.

serie <-ts(jeu[,2],start = c(2015,1) , end=c(2023,5) , frequency=12)
J <- window(serie,start=c(2015,1),end=c(2022,12))
valobs  <- window(serie,start=c(2023,1),end=c(2023,5),frequency=12) 


###  Presentation de la serie :
###  Il s'agit d'une serie de l'evolution des prix des biens et services 
###  de Janvier 2015 ?? Janvier de 2023 de Burkina Faso.
par(bg="yellow",col.axis="black",col.lab="black",
    col.main="blue",col.sub="black",fg="blue")
plot(J, main="Evolution de l'indice global des prix \n au Burkina Faso",
     lwd=2,
     xlab="Mois",ylab="Indice_prix")
 
par(bg="white",col.axis="black",col.lab="black",
    col.main="blue",col.sub="black",fg="black")
plot(window(J,start=c(2015,1),end=c(2018,12),frequency=12))
lines(window(J,start=c(2015,1),end=c(2018,1),frequency=1),col=5,type="b")
lines(window(J,start=c(2015,8),end=c(2018,8),frequency=1),col=2,type="b")
legend("topleft",c("indiceGprix","indiceJanvier","indiceAout"),
       lty=c(1,1,1),col=c("black","blue","red"),lwd=c(1,1,1),
       text.col =c("black","blue","red"))

### Apres une bonne visualisation du graphique precedent, il est
### clairement visible au premier coup d'oeil que la forme de la courbe
### n'est pas uniforme au fil des temps. En observant l'evolution du prix
### pour un mois donne sur chaque annee, on constate qu'il n' ya pas de 
### saisonnalite.

###Par ailleurs,l'indice des prix de facon generale n'est pas diractement 
###liee aux saisons,car il est determine par des facteurs economiques telle
### l'offre et la demande,les politiques monetaires et fisacales,les couts
### de productions etc...

### Il est aussi visible clairemnet que la serie a une tendance croissante
### cela est due au fait que l'indice des prix augmente de facon generale 
### au cours du temps. Il est tres difficile de lutter significativement
### contre l'inflation.
### Le modele est additif car l'impact des evenements sur les prix a la 
## consommation est constant et independant de la valeur de l'indice actuel


plot(J)
lines(window(J,start=c(2016,3),frequency=1), type="b",col=2)
lines(window(J,start=c(2015,8),frequency=1), type="b",col=3)
lines(window(J,start=c(2015,12),frequency=1), type="b",col=4)
legend("top",
       c("SerieIndicePrix","Mars","Aout","Decembre"),
       lwd=rep(2,3), col=c(1,2,3,4),
       text.col =c(1,2,3,4),
       title.cex=0.1,
       bty="7")



###########################################################################
############# PREVISION PAR LISSAGE EXPONENTIEL
###########################################################################

## 1) Le lissage exponentiel double est le lissage approprie car notre serie 
##    a une tendance croissante et sans saisonnalite.
## le modele est additif cest pourquoi nous prenons "AAN" pour dire que la
## la tendance et les erreurs sont additifs et N pour dire qu'il n ya
## pas de saisonnalitte.

L_E_D <- ets(J,model="AAN")
h <-5
led.pred <- predict(L_E_D ,h, level = 95)
plot(led.pred)
points(valobs , type='l' , col="darkgreen" , lwd=2)
legend('top' , c("valeurs observees" ,"predictions"), 
       col=c("darkgreen", "blue",lty=rep(1,2),lwd=rep(2,2)))
                                                            
#### VALIDATION DU MODELE ####
resd <- led.pred$residuals
acf(resid)

### Les residus sont donc non autocorreles
t.test(resd)
shapiro.test(resd)

## les residus suivent une loi normale 
## Donc Nous avons des bruits blanc 

##### EURREUR QUADRATIQUE #########

valpred <- ad.vector(led.pred$mean)
quad <- mean((valpred-valobs)^2)
quad

##### COUVERTURE MOYENNE #########

vraiP <- rep(NA , h)
Couv <- length(which(vraiP==TRUE))/h
Couv




########################################################################
#####             MODELISATION PAR DECOMPOSITION                   #####
########################################################################


## Tendance : Nous avons une tendance croissante

## 2) Soit Yt note serie, notre serie est explique par la tendance 
##       Zt et les residus e.Donc    
             
##                  Yt = Zt + e
       
### Notre serie de tendance croissante en moyenne subit des chocs 
### au fil du temps a cause des differents evenements(quetion 2)
### qu'a traverse le pays.
### Nous allons donc diviser la serie en plusieurs parties pour mener notre etude

### Ainsi la partie retenue pour la modelisation est la sous serie J3 de aout
### a Decembre 2023

### La sous serie J3 a une tendance croissante exponentielle.Nous allons donc
## la lineariser en utilisant la serie logarithme.
 
J3 <-(window(J, start=c(2022,8),end=c(2022,12)))

###Nous devons determiner les coefficient de regression
### a et b tels que Zt= a*t+b

t1<-time(J3)
reg <-lm(J3~t1)
summary(reg)
          ## Test de bruits blancs ##

##Test d'autoccorelation
AUTOCORRELATION_DES_RESIDUS <-reg$residuals 

acf(AUTOCORRELATION_DES_RESIDUS)
Box.test(AUTOCORRELATION_DES_RESIDUS,lag=4)

##Les residus sont donc non autocorreles

##Test de nulite de la moyenne
t.test(AUTOCORRELATION_DES_RESIDUS)

## Test de normalite des residus
shapiro.test(AUTOCORRELATION_DES_RESIDUS)

##Nos residus sont non autorreles et en moyenne nulle
### nous pouvons valider notre  modele.
### 

###             PREVISION DES 5 PROCHAINS MOIS                ###

periode <- c(2023+(0:4)/12)

Yt <- as.numeric(reg$coefficients[1] + reg$coefficients[2] * periode)
res <- summary(reg)
b<-qnorm(0.975)*res$sigma
inf <- Yt -b
sup <- Yt +b
prev <- (cbind(Yt,inf,sup))
prev

 par(bg="white",col.axis="blue",col.lab="blue",
     col.main="black",col.sub="blue",fg="blue")
 plot(J, main="Evolution de l'indice global des prix \n au Burkina Faso",
      xlim= c(2015,2024),ylim=c(80,150),lwd=2,
      xlab="Mois",ylab="Indice_prix")
 lines(periode,prev[,1],lwd=2,col="red")
 lines(periode,prev[,2],col="green",lwd=2)
 lines(periode,prev[,3],
       col="green", lwd=2)
 legend("topleft",
        c("SerieIndicePrix","prediction","IC a 95%"),
        lwd=rep(2,3), col=c("blue","red","green"),
        text.col =c("blue","red","green"),
        title.cex=0.1,
        bty="7")
 par(bg="white",col.axis="black",col.lab="black",
     col.main="black",col.sub="black",fg="black")
 
 
######## ERREUR QUADRATIQUE ##########
 
 valpred <- prev[,1]
 quad <- mean(((valpred-valobs)^2))
 quad  
 
##### COUVERTURE MOYENNE ######
 h <-4
 vraiP <- rep(NA,h)
 for(i in 1:h){
   vraiP[i] <- valobs[i]%between%IC[c(i,i+1)]
 }
 Couv <- length(which(vraiP==TRUE))/h
 Couv
 
 

###################################################################
#######            MODELISATION STOCHASTIQUE                #######    
###################################################################
 
library(tseries)
library(forecast)

## Pour la modelisation Stochastique, l'objectif vise est de trouver une
## serie stationnaire.


### Test de DICKEY FULLER
adf.test(J)

## D'apres le test p-value>.05 donc la serie J n'est pas stationnaire.

##Nous procedons donc a une premiere difference et verifier ensuite
## la stationnarite
J1 <- diff(J)

##Test de Dickey Fuller
adf.test(J1)

##Nous avons a present une p_value=.041<.05 donc J1 est stationnaire.
##Une fois que nous avons une serie stationnaire, il faut maintenant
## verifier que l'indice moyen des prix est constant 

## Test de Student 
t.test(J1)

# Nous avons notre p_value=.10>.05 alors on accepte l'hypothese au seuil de 5%
# Donc la moyenne de la serie J1 est constante au seuil de 5%.

# Test de l'autocorrelation
Box.test(J1,lag=2)
Box.test(J1,lag=5)
Box.test(J1,lag=7)
Box.test(J1,lag=9)
Box.test(J1,lag=10)

## Nous remarquons qu'avec de differents niveaux de ratard
## les p-values sont inferieur au seuil 5% cela signifie 
## les valeurs la serie J1 sont dependantes.Cela est due a la complexite
## de la realite.Toutefois il est important de savoir que cette 
## autocorrelation est pas significative.Nous allons donc continuer 
## notre etude avec la meme serie J1 vu qu'elle est deja stationnaire
## et la moyenne etant constante.

## Nous partons sur que notre serie indice des prix est une combinaison
## des indices de prix passes et de d'erreurs passees;

##La commande suivante nous permettra de faire des choix des differents
##modeles ARIMA(p,d,q)
##Le correlegramme simple nous permettra de determiner le parametre p
##et le correlegramme partiel premettra de determiner le parametre q
##le parametre d n'est rien autre que le nombre de difference.
##p correspond a la position derniere barre que l'on se fixe
##de PACF qui depassera le seuil d'autocorrelation (l'une des droites bleus).

##q correspond a la position derniere barre que l'on se fixe
## de ACF qui depassera le seuil d'autocorrelation (l'une des droites bleus).
##la premiere barre n'est pas pris en compte pour le ACF

par(mfrow=c(1,2))
acf(J1)
pacf(J1)
par(mfrow=c(1,1))

### Modeles candidats

m141 <- arima(J1,order=c(14,0,1))
m142 <- arima(J1,order=c(14,0,2))
m101 <- arima(J1,order=c(10,0,1))
m102 <- arima(J1,order=c(10,0,2))

##Pour valider chaque modele candidat,nous verifions que ses bruits sont blancs 

##tsdiag(),est la commande qui nous permettra de voir si nos residus sont 
## non autocorreles.

tsdiag(m141) 
tsdiag(m142) 
tsdiag(m101)
tsdiag(m102)

## Test de la normalite des residus

shapiro.test(m141$residuals)## les residus suivent une loi normale 
shapiro.test(m142$residuals)## les residus suivent une loi normale
shapiro.test(m101$residuals)## les residus suivent une loi normale
shapiro.test(m102$residuals)## les residus suivent une loi normale

## Tous les residus des differents modeles suivent une loi normale

## Choix du meilleur estiamteur se fait selon le critere informatique
##                   Baysien (BIC)


c(BIC(m141),BIC(m142),BIC(m101),BIC(m102))
## Le modele ayant le plus petit BIC parmi les modeles precedents est : m101
qqnorm(m101$residuals)
qqline(m101$residuals)
############## le modele final ARIMA(10,1,1) 

  m1011<- arima(J,order = c(10,1,1), method="ML") 

###### Prevision 
###### Estimation de la qualite de prevision sur h valeurs

h <-5
p.1011h <- predict(m1011,n.ahead = h)
p.1011h$icinf <-  p.1011h$pred - p.1011h$se*qnorm(.975)
p.1011h$icsup <-  p.1011h$pred + p.1011h$se*qnorm(.975)

## Representation de la serie du prix global ainsi 

par(bg="white",col.axis="black",col.lab="black",
    col.main="black",col.sub="black",fg="blue")
plot(J, main="Evolution de l'indice global des prix \n au Burkina Faso",
     xlim= c(2015,2024),ylim=c(80,150),lwd=2,
     xlab="Mois",ylab="Indice_prix")
lines(seq(2023,2023+4/12,by=1/12),p.1011h$pred,
      col="red", lwd=2)
lines(seq(2023,2023+4/12,by=1/12),p.1011h$icinf,
      col="yellow", lwd=2)
lines(seq(2023,2023+4/12,by=1/12),p.1011h$icsup,
      col="yellow", lwd=2)
lines(valobs,col="violet",lwd=2)
legend("topleft",
       c("SerieIndicePrix","prediction","IC a 95%","indiceObserve"),
       lwd=rep(2,3), col=c("blue","red","yellow","violet"),
       text.col =c("blue","red","yellow","violet"),
       title.cex=0.1,
       bty="7")


############ MOYENNE QUADRATIQUE ############

valpred <- (p.1011h$pred)
quad <- mean(((valpred-valobs)^2))
quad  

############### COUVERTURE MOYENNE   ########################

IC <- c(p.1011h$icinf ,p.1011h$icsup)
vraiP <- rep(NA,h)
for(i in 1:h){
  vraiP[i] <- valobs[i]%between%IC[c(i,i+1)]
}
Couv <- length(which(vraiP==TRUE))/h
Couv


##### PREDICTION DE L'INDICE GLOBAL DES PRIX DU RESTE DE L'ANNEE 2023#####

h=12
predictionFinal <- predict(led ,h, level = 95)
predictionFinal























