*/  Lauren Forti
	DSCI 307 
	9/26/2022
	Project 6
*/



*******************************
**         PROBLEM 1         **
*******************************;

* create macro var;
%LET ClassAge = Pre-K 4;

* read in data;
data final ClassAge_final;
	infile '/home/u62096251/folders/myfolders/Week6/school 1 final.csv' dsd firstobs=2;
	input ClassID ChildID Gender $ 'ClassAge'n $ Language $ f1 f2 f3 f4;
	output final;
	if ClassAge = "&ClassAge" then output ClassAge_final;
run;

* print subset;
proc print data=ClassAge_final;
	title "&ClassAge Data";
run;

* create macro;
%MACRO average (category=, question=);
	proc sort data=final;
		by &question;
	run;
	proc means data=final noprint;
		var &question;
		class &category;
		output out=averagescore (drop=_type_ _freq_) mean= ;
	run;
	proc print data=averagescore (firstobs=2 obs=100);
		title "&question by &category";
	run;
%MEND average;

* invoke macro;
%average(category=Gender, question=f1);
%average(category=ClassAge, question=f3);



*******************************
**         PROBLEM 2         **
*******************************;

* read in data;
data death_count;
	infile '/home/u62096251/folders/myfolders/Week6/2010-2015-Age65above Final Death Count.csv' dsd firstobs=2;
	input year month gender $ age ICD10 $ death;
run;

* sort data;
proc sort data=death_count;
	by year;
run;
* calc total death of each year;
proc means data=death_count noprint;
	var death;
	class year;
	output out=total_death_count (drop=_type_ _freq_) sum=;
run;
* bar chart;
proc sgplot data=total_death_count;
	hbar year / response=death;
    label year = 'Year';
    label death = 'Deaths';
    title 'Total Death Count by Year';
run;


* sort data;
proc sort data=death_count;
	by ICD10;
run;
* calc total death by ICD10 code;
proc means data=death_count noprint;
	var death;
	class ICD10;
	output out=total_death_count_code sum=;
run;
ods listing gpath='/home/u62096251/folders/myfolders/Week6';
ods graphics / reset
	imagename='Scatter plot total death by Death Code'
	outputfmt=png
	height=3in width=6in;
* scatter plot;
proc sgplot data=total_death_count_code;
    scatter x=ICD10 y=death;
    label ICD10 = 'Death Code';
    label death = 'Total Death';
    title 'Total Death Count by ICD10';
run;
ods listing close;

* histogram for ICD10 52;
proc sgplot data=total_death_count_code (where=(ICD10='52'));
    histogram death / nbins=10 showbins;
    title 'Total Death Count for ICD10 52';
    label death = 'Deaths';
run;


* vertical box plot;
proc sgplot data=death_count;
	vbox death / category=gender;
	label death = 'Deaths';
	label gender = 'Gender';
	title 'Total Death Count by Gender';
run;


ods listing gpath='/home/u62096251/folders/myfolders/Week6';
ods graphics / reset
	imagename='Boxplot death by month'
	outputfmt=png
	height=3in width=6in;
* horizontal box plot;
proc sgplot data=death_count;
	hbox death / category=month;
	label death = 'Deaths';
	label month = 'Month';
	title 'Total Death Count by Month';
run;
ods listing close;