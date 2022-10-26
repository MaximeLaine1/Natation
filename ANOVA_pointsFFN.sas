%let lib="C:\Users\laine\Desktop\piscine";
libname piscine &lib.;
proc contents data=piscine.bdd;
run;
proc means data=piscine.bdd;
	var time rang points_ffn annee_naissance;
run;
proc freq data=piscine.bdd order=freq;
tables annee_naissance genre nationalite departement /plot=freqplot;
run;

/********************************************************************************************************/
/*boxplot*/
PROC SGPLOT  DATA = piscine.bdd;
   VBOX points_ffn / category = genre;
RUN; 
/*distribution dans les deux groupes des points ffn*/
proc univariate data = piscine.bdd noprint;
var points_ffn;
where genre="F";
histogram points_ffn
/ 
normal ( 
   mu = est
   sigma = est
   color = red
   w = 2.5 
)
barlabel = percent;
run;

proc univariate data = piscine.bdd noprint;
var points_ffn;
where genre="M";
histogram points_ffn
/ 
normal ( 
   mu = est
   sigma = est
   color = blue
   w = 2.5 
)
barlabel = percent;
run;
/*on rejette la normalité des données mais pas loin*/
PROC UNIVARIATE DATA=piscine.bdd NORMAL PLOT;
VAR points_ffn;
WHERE genre='M';
RUN;

PROC UNIVARIATE DATA=piscine.bdd NORMAL PLOT;
VAR points_ffn;
WHERE genre='F';
RUN;
/*comparaison de médianes : les deux groupes diffèrent d'un paramètre d'échelle*/
proc npar1way wilcoxon correct=no data=piscine.bdd median plots=(wilcoxonboxplot medianplot);
   class genre;
   var points_ffn;
run;
PROC ANOVA DATA=piscine.bdd;
CLASS genre;
MODEL points_ffn=genre;
MEANS genre / tukey cldiff alpha=0.05;
RUN;
/*les points ffn ne permettent pas de donner une équité ou dans ce meeting ou  les filles sont moins fortes que les garçons. 
/*supprimer la librairie*/

libname piscine clear;
