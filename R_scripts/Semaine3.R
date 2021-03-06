# Introduction à la statistique avec R
# Semaine 3 ~ Test statistiques, pratique des tests statistiques

# Set working directory 
setwd("~/OneDrive/Documents/1. After-doctorate/R_projects/Introduction a la statistique avec R/working_directory")

# Liste des fichiers du directory
list.files()

# Nettoyage 
remove(list = ls())

# ---- Le principe des statistiques ----
# Est-ce que le résultat est du au hasard ?
# Importer un fichier *.csv
smp <- read.csv2("smp1.csv")
str(smp)

# Ajout d'une variable (ed.d) qui est la variable "eb" recodée:
# (Suite aux modifications de la semaine 2)
smp$ed.b <- ifelse(smp$ed > 2, 1, 0)
str(smp)

# Calcul de la correlation age des détenus et nombre d'enfants
cor(smp$age, smp$n.enfant, use = "complete.obs")

# Est-ce que le hasard explique la relation?

# "P-value" est la probabilité que le hasard puisse expliquer
# à lui seul une différence au moins aussi importante que
# celle qui a été observée.
# p varie avec la taille de l'échantillon avec de gros échantillons
# l'influense du hasard diminue considérablement.

# ---- Neyman & Pearson et les tests d'hypothèse ----
# H0 : Statut quo (pa = pb)
# H1 : le but de l'expérience (pa=/=pb)

# 2 possibilités d'erreurs 
# - a = prob(accepter H1/H0 est vraie)
# - b = prob(accepter H0/H1 est vraie)

# Objectif : règle de décision minimisant b pour a fixé
# en général à 0,05.
# Si "p" < a --> alors H1 ; sinon H0.

# Avec Neyman & Pearson (prise de décision concrète et importante après l'expérience)
#       -> H1 en fonction du p (c'est binaire). 
#       Mesure des risques fixés avant.
# Avec Fisher (dans les autres situations)
        # on regarde le p 
        # (le harard a du mal à expliquer les résultats == il y a gradation).

# ---- Comparaison de deux pourcentages (test de Chi-2) ----
# Le test du "Chi-2" - l'effectif petit
# ed : niveau d’évitement du danger.
# dep.cons : existence d’un trouble dépressif (0 : non, 1 : oui).
table(smp$ed.b, smp$dep.cons, deparse.level = 2, useNA = "always")

# on veut avoir des pourcentage au lieu des effectifs :
tab <- table(smp$ed.b, smp$dep.cons, deparse.level = 2)

# Proportions
prop.table(tab, 1) # 1 signifie que nous voulons avoir le pourcentage 
                # de dépression selon que les détenus (la 2e variable du table)
                # ont ou n'ont pas un haut niveau d'évitement du danger (la première variable du table).

# Le pourcentage de détenus un haut niveau d'évitement du danger versus dépressif 
prop.table(tab, 2)

# Test de chi-2
chisq.test(smp$ed.b, smp$dep.cons, correct = FALSE) # correct = FALSE ==> sinon R propose un test avec correction de continuité
# Résultat p-value = 1.228e-12 (1,22 * 10^-12)
# Le hasard à lui tout seul ne pourrait pas expliquer une telle différence de prévalence de dépression.
# L'aternative si n est grand :
fisher.test(smp$ed.b, smp$dep.cons)

# Résultat p-value = 2.033e-12 proche du résultat

# ---- Comparaison de deux moyennes (t-student) ----
# Conditions de validité n > 30
# les variables suivent une loi normale
# les variables sont égales

# Existe-t-il en moyenne une différence significative d'age entre les
# les détenus ayant un haut niveau d'évitement du danger et les autres

hist(smp$age, main = paste("Histogramme âge"), xlab = "Age des détenus")   # Pour voir si la variable suit une loi normale.

# qqnorm == diagramme de normalité
# il faut que les points suivent la ligne pour dire que le tout suit la normalité
qqnorm(smp$age) ; qqline(smp$age)

# est-ce que les variances sont identiques dans les groupes à comparer
# la valeur de l'écart-type des deux groupes :
by(smp$age, smp$ed.b, sd, na.rm = TRUE)

# Test de student
# Two Sample t-test
t.test(smp$age ~ smp$ed.b, var.equal = TRUE)

# Si on ne peux pas utiliser le test-t :
# Le test de Mann-Whitney (Wilconson)
# Le test Wilconson est un test non-paramétrique
# Il est utilisé comme l'alternative non paramétrique du test paramétrique t de Student 
# pour deux échantillons dépendants ou appariés. 
# Un test non-paramétrique est un test ne nécessitant pas d'hypothèse sur la distribution des données
wilcox.test(smp$age ~ smp$ed.b)

# ---- Test de la nullité d'un coefficient de corrélation ----
# Correlation age et niveau de recherche de 
# Conditions de la validité il faut qu'au moins une des variables suivent une loi normale
cor.test(smp$age, smp$rs)

# Résultats p-value = 2.825e-09
# cor = -0.2227744
# L'intervalle nous dit qu'il y a 95% de chance que la vraie valeur se trouve dans cet intervalle.

# Si on a des doutes sur la normalité des variables:
cor.test(smp$age, smp$rs, method = "spearman")

# ---- Test divers (test à pariés) ----
# Comparaison d'une moyenne à une référence
t.test(smp$age, mu = 24)        # mu = ... valeur de référence.

# Test à parié : mesures avant et après ... valiables qualitatives
# McNemar
# Comparaison revenus 30ans/40ans ..
# Ceci est un exemple, pas de vrai variables ...
mcnemar.test(Variable_debut, Variable_fin)
# Test student pour population à pariée:
t.test(x.debut, x.fin, paired = TRUE)








