
libname natation "/home/u59286873/M2_SAS/Projet_nat"; /*créer une bibli permanente pour enregistrer les données*/
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



/*Visualiser les données */

/*autre en groupant par nageur par département*/
Proc sql ;
	create table &lib..carte_1 as
	select 
		distinct id_dep as id, departement, nom_prenom, count(distinct nom_prenom) as nb_nag
	From &lib..bdd
	group by id_dep;
quit ;

proc sql ; /*jointure avec la carte de france pour représenter les données*/
	create table &lib..carte_2 as
	select distinct c.id,  f.id, c.nb_nag 
	from &lib..carte_1 as c
		left join maps.france as f on c.id=f.id;
quit ;

/*
data &lib..carte_3;
	set &lib..carte_2;
	nb = nb_nag;
	if nb=. then nb=0;
run;*/


title1 'Carte: Nombre de nageurs par départements';
/*carte des régions*/             /*Mieux*/
proc gmap data = &lib..carte_2 map=maps.france all;
  id id;
/*   by EPREUVE; */
  choro nb_nag;
  label nb_nag = "Nombre de nageur par département";
run;





/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*autre en groupant par temps moyen sur le département*/
Proc sql ;
	create table &lib..carte_tps as
	select 
		distinct id_dep as id, departement, nom_prenom, round(avg(distinct time),0.01) as temps_nag
	From &lib..bdd
	group by id_dep;
quit ;

proc sql ; /*jointure avec la carte de france pour représenter les données*/
	create table &lib..carte_tps as
	select distinct c.id,  f.id, c.temps_nag 
	from &lib..carte_tps as c
		left join maps.france as f on c.id=f.id;
quit ;

title1 'Carte: temps moyen par département';
/*carte des régions*/             /*Mieux*/
proc gmap data = &lib..carte_tps map=maps.france all;
  id id;
/*   by EPREUVE; */
  choro temps_nag;
  label temps_nag = "Temps moyen par département";
run;










/* Autre méthode sur QJIS  */

/* On exporte la base */
PROC EXPORT DATA=&lib..carte_2
     OUTFILE="/home/u59286873/M2_SAS/Projet_nat/Export_carte.csv"
     DBMS=csv
     REPLACE;
RUN;






/*supprimer la librairie*/
libname &lib. clear;

