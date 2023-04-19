*/  Lauren Forti
	DSCI 307 
	9/17/2022
	Project 5
*/



*******************************
**         PROBLEM 1         **
*******************************;

* set lib;
libname Week5 '/home/u62096251/folders/myfolders/Week5';

* create table w/ continent, total population, and # of countries per continent;
proc sql;
    create table Week5.ContinentData as
	select Continent,
		   sum(Population) as Total_population format=comma14.,
		   count(*) as N_countries
	from Week5.countries
	where Continent is not missing
	group by Continent;
quit;
* display table;
proc print data=Week5.ContinentData;
	title 'Contintent Information';
run;

* create subset that only includes the continents with < 40 countries;
data Week5.ContinentUnder40;
	set Week5.ContinentData (where=(N_countries < 40));
run;
* create table w/ continent, total population, and # of countries per continent w/ < 40 countries;
proc print data=Week5.Continentunder40;
	title 'Continents with Under 40 Countries';
run;



*******************************
**         PROBLEM 2         **
*******************************;

* create table w/ all states in US w/ state, state code, capital, latitude, and longitude;
proc sql;
	create table States as
	select u.Name, p.Code as State_code, u.Capital, c.Latitude, c.Longitude
	from Week5.unitedstates u, Week5.postalcodes p, Week5.uscitycoords c
	where u.Capital = c.City and u.Name = p.Name and p.Code = c.State;
quit;
* display table;
proc print data=States;
	title 'State Information';
run;


*******************************
**         PROBLEM 3         **
*******************************;

* compare DATA step match-merges with PROC SQL joins. 
  create a table w/ FLD_ID, Farmer, and Crop by joining two tables;

* read in data;
data Week5.FLDFarmers;
	input Field_id Farmer $;
datalines;
12678 Farmer_A
12678 Farmer_A
11857 Farmer_B
11857 Farmer_B
10446 Farmer_A
10446 Farmer_C
14789 Farmer_G
;
run;
data Week5.FLDCrops;
	input Field_id Crop $;
datalines;
12678 Corn
12678 Soybeans
11857 Wheat
11857 Corn
13229 Soybeans
13229 Wheat
10889 Corn
10446 Soybeans
15668 Wheat
;
run;

* sort tables;
proc sort data=Week5.FLDFarmers nodupkey;
	by Field_id;
run;
proc sort data=Week5.FLDCrops nodupkey;
	by Field_id;
run;

* create tables w/ FLD_ID, Farmer, and Crop;
** DATA METHOD;
data Week5.FarmerCrops1;
	merge Week5.FLDFarmers Week5.FLDCrops;
	by Field_id;
run;
* display table;
proc print data=Week5.FarmerCrops1;
	title 'Farmers and Crops by DATA Method';
run;

** SQL METHOD;
proc sql;
	create table Week5.FarmerCrops2 as
	select coalesce(f.Field_id, r.Field_id) as Field_id, f.Farmer, r.Crop
	from Week5.FLDFarmers f full join Week5.FLDCrops r
	on f.Field_id = r.Field_id;
quit;
* display table;
proc print data=Week5.FarmerCrops2;
	title 'Farmers and Crops by SQL Method';
run;
