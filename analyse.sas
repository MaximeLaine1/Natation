libname natation "/home/u59429648/lib"; /*créer une bibli permanente pour enregistrer les données*/
%let lib=natation;

/*importation réussie, jointures des tables*/



/*supprimer les doublons, il reste 986 obs*/
proc sort data=&lib..bdd noduprecs;
by _ALL_;
run;
/*trier les obs par id dep*/
proc sort data=&lib..bdd;
by id_dep;
run;
proc print data=&lib..bdd;
run;



proc contents DATA=&lib..bdd;
run;


/********************************/
/*Visualiser les données */
proc contents DATA=&lib..bdd;
run;



data;
set &lib..bdd;
run;

proc sql;
select * from natation.bdd;
quit;





# Univarié

# Nombre de participants par épreuve 

proc sql;
select epreuve, count(*)
from natation.bdd
group by epreuve;

PROC GCHART DATA=natation.bdd;
   HBAR epreuve / DISCRETE;
RUN;

# Nombre de participants par nationalité

proc sql;
select nationalite, count(*)
from natation.bdd
group by nationalite;

PROC GCHART DATA=natation.bdd;
   VBAR nationalite / DISCRETE;
RUN;


proc sql;
select region, count(*)
from natation.bdd
group by region;

PROC GCHART DATA=natation.bdd;
   HBAR region / DISCRETE;
RUN;


# Nombre de participants par année -> Graphique en bâton

proc sql;
select annee_naissance, count(*)
from natation.bdd
group by annee_naissance;

PROC GCHART DATA=natation.bdd;
   VBAR annee_naissance / DISCRETE;
RUN;

# Nombre de participants par genre -> Graphique en bâton

proc sql;
select genre, count(*)
from natation.bdd
group by genre;

PROC GCHART DATA=natation.bdd;
   PIE genre / DISCRETE;
RUN;

# Nombre de participants par région

proc sql;
select region, count(*)
from natation.bdd
group by region;

PROC GCHART DATA=natation.bdd;
   VBAR region / DISCRETE;
RUN;

# Meilleur/pire temps

proc sql;
select time
from natation.bdd;

# Plus jeune/vieux gagnant

proc sql;
select min(annee_naissance) as plus_vieux, max(annee_naissance) as plus_jeune, epreuve
from natation.bdd
where rang = 1
group by epreuve
order by plus_jeune, plus_vieux;

proc boxplot data=natation.bdd;
plot annee_naissance*region;
run;



# Bivarié 

# Rang moyen par region

proc sql;
select count(*) as nombre_nageurs, mean(rang) as rang_moyen, region
from natation.bdd
group by region;

PROC GCHART DATA = natation.bdd ;
  HBAR region / DISCRETE SUBGROUP = genre SUMVAR = time TYPE = mean ;
RUN ;

# Meilleur temps par region et genre

proc sql;
select min(time) as min_time, genre, epreuve
from natation.bdd
group by genre, epreuve;



PROC GCHART DATA = natation.bdd ;
HBAR epreuve / DISCRETE SUBGROUP = genre SUMVAR = time TYPE = mean ;
RUN ;


# Meilleur temps par épreuve

proc sql;
select min(time), epreuve
from natation.bdd
group by epreuve;
