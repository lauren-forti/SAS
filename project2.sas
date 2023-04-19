*/  Lauren Forti
	DSCI 307 
	8/29/2022
	Project 2
*/



*******************************
** PROBLEM 1: Export Dataset **
*******************************;

* create a libname ;
libname Week2 '/home/u62096251/folders/myfolders/Week2';

* read in data ;
data Week2.death_count;
	infile '/home/u62096251/folders/myfolders/Week2/2010-2015-Age65above Final Death Count.csv' dsd firstobs=2;
	input year month gender $ age ICD10 $ death;
run;

*get data from 2015;
data death_2015;
	set Week2.death_count;
	where year=2015;
run;

* export as csv w/ proc export;
proc export data=death_2015
	outfile='/home/u62096251/folders/myfolders/Week2/death_2015.csv'
    dbms=csv
    replace;
run;



*******************************
**   PROBLEM 2: PROC MEANS   **
*******************************;

* read in data;
data death_count;
	infile '/home/u62096251/folders/myfolders/Week2/2010-2015-Age65above Final Death Count.csv' dsd firstobs=2;
	input year month gender $ age ICD10 $ death;
run;

* sort data by year;
proc sort data=death_count;
	by year;
run;
* calc sum of the variable death by year w/ class;
proc means data=death_count sum nonobs maxdec=0;
     class year;
     var  death;
     title 'Deaths by Year';
run;

* sort data by month;
proc sort data=death_count;
	by month;
run;
* calc mean and std of the variable death by month w/ class;
proc means data=death_count mean std nonobs maxdec=0;
     class month;
     var  death;
     output out=death_by_month;
     title 'Deaths by Month';
run;

* sort data by gender;
proc sort data=death_count;
	by gender;
run;
* calc sum of the variable death by gender;
proc means data=death_count sum maxdec=0;
	var death;
	by gender;
	title 'Deaths by Gender';
run;



*******************************
**   PROBLEM 3: PROC FREQ    **
*******************************;

* generate freq dist for death and year;
proc freq data=death_count;
	table death year;
	title 'Frequency Distributions for Death and Year';
run;

* generate 2-way freq dist for gender*month;
proc freq data=death_count;
	table gender*month;
	title 'Two-Way Frequency Distribution for Gender by Month';
run;