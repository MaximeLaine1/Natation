%let lib="C:\Users\laine\Desktop\piscine";
libname piscine &lib.;

/*importation des tables*/
proc import datafile="C:\Users\laine\Desktop\piscine\regions.csv" dbms=csv
	out = piscine.regions replace;
run;
proc import datafile="C:\Users\laine\Desktop\piscine\participants.csv" dbms=csv
	out = piscine.participants replace;
run;
proc import datafile="C:\Users\laine\Desktop\piscine\structures.csv" dbms=csv
	out = piscine.structures replace;
run;
proc import datafile="C:\Users\laine\Desktop\piscine\departements-region.csv" dbms=csv
	out = piscine.departement replace;
run;
data piscine.dep_numero;
set piscine.departement;
dep_name= upcase(dep_name);
keep dep_name num_dep;
run;

/*importation réussie, jointures des tables*/

proc sql;
create table base as
select  a.structure, b.departement, c.region, nom_prenom, temps, rang, genre, annee_naissance, format_epreuve,epreuve, date_fr, points_ffn, points_fina, nationalite, num_dep as id_dep
	
from 	piscine.participants as a 
			left join piscine.structures as b on a.structure=b.structure 
			left join piscine.regions as c on b.departement = c.departement
			left join piscine.dep_numero as d on c.departement=d.dep_name
order by epreuve, format_epreuve,rang;

quit;
/*convertir temps en num, time exprimée en x minutes*/
data piscine.bdd;
set base;
minute=input(substr(temps,1,2),comma12.);
seconde=input(substr(temps,4,2),comma12.);
centieme=input(substr(temps,7,2),comma12.);
time = minute+seconde/60+centieme/600;
keep rang time epreuve format_epreuve date_fr nom_prenom genre nationalite annee_naissance points_ffn structure region departement id_dep;
 
run;
/*supprimer les doublons, il reste 986 obs*/
proc sort data=piscine.bdd noduprecs;
by _ALL_;
run;
/*trier les obs par id dep*/
proc sort data=piscine.bdd;
by id_dep;
run;
proc print data=piscine.bdd;
run;

/*supprimer la librairie*/
libname piscine clear;
