*/  Lauren Forti
	DSCI 307 
	9/5/2022
	Project 3
*/



*******************************
**         PROBLEM 1         **
*******************************;

* read in school 1 midterm ;
data s1m;
	infile '/home/u62096251/folders/myfolders/Week3/school 1 midterm.csv'  DSD  firstobs=2;
	input ClassID ChildID Gender $ 'ClassAge'n $ Language $ m1 m2 m3 m4;
run;

* read in school 2 midterm ;
data s2m;
	infile '/home/u62096251/folders/myfolders/Week3/school 2 midterm.csv'  DSD  firstobs=2;
	input ClassID ChildID Gender $ ClassAge $ m1 m2 m3 m4;
run;

* read in school 1 final ;
data s1f;
	infile '/home/u62096251/folders/myfolders/Week3/school 1 final.csv'  DSD  firstobs=2;
	input ClassID ChildID Gender $ 'ClassAge'n $ Language $ f1 f2 f3 f4;
run;

* read in school 2 final ;
data s2f;
	infile '/home/u62096251/folders/myfolders/Week3/school 2 final.csv'  DSD  firstobs=2;
	input ClassID ChildID Gender $ ClassAge $ f1 f2 f3 f4;
run;



*******************************
**         PROBLEM 2         **
*******************************;

* sort s1m by ChildID;
proc sort data=s1m;
    by ChildID;
run;

* sort s2m by ChildID;
proc sort data=s2m;
	by ChildID;
run;

* interleave s1m and s2m by ChildID;
data midterm;
	set s1m s2m;
	by ChildID;
run;

* output results;
proc print data=midterm;
    title 'Interleaved Midterm Data';
run;



*******************************
**         PROBLEM 3         **
*******************************;

* sort s1f by ChildID;
proc sort data=s1f;
    by ChildID;
run;

* sort s2f by ChildID;
proc sort data=s2f;
	by ChildID;
run;

* interleave s1f and s2f by ChildID;
data final;
	set s1f s2f;
	by ChildID;
run;

* output results;
proc print data=final;
    title 'Interleaved Final Data';
run;




*******************************
**         PROBLEM 4         **
*******************************;

* sort midterm data by ChildID;
proc sort data=midterm;
	by ChildID;
run;

* sort final data by ChildID;
proc sort data=final;
	by ChildID;
run;

* merge midterm and final by ChildID;
data assess;
	merge midterm final;
	by ChildID;
run;

* output results;
proc print data=assess;
	title 'All Data Merged';
run;



*******************************
**         PROBLEM 5         **
*******************************;

* sort data by ChildID;
proc sort data=assess;
	by ChildID;
run;

* calc mean of numerical values in assess;
proc means data=assess mean nonobs maxdec=2;
     title 'Mean Values of Numerical Values';
run;



*******************************
**         PROBLEM 6         **
*******************************;

* regroup assess into 4 data sets;
data PREK3 PREK4 Female Male;
	set assess;
	* create data sets for class ages;
	if ClassAge='Pre-K 4' then output PREK4;
	else output PREK3;
	* create data sets for gender;
	if Gender='Female' then output Female;
	else output Male;
run;

* print the 4 datasets;
proc print data=Female;
	title 'Females';
run;
proc print data=Male;
	title 'Males';
run;
proc print data=PREK3;
	title 'Pre-K 3';
run;
proc print data=PREK4;
	title 'Pre-K 4';
run;



*******************************
**         PROBLEM 7         **
*******************************;

* select variables m2 and f2 from assess;
data select_m2_f2;
	set assess;
	keep m2 f2;
run;

* print first 5 observations;
proc print data=select_m2_f2 (obs=5);
	title 'First Five Observations of select_m2_f2';
run;



*******************************
**         PROBLEM 8         **
*******************************;

* select variables m3 and f3 from assess;
data select_m3_f3;
	set assess;
	keep m3 f3;
run;

* print observations from 50th row to 100th;
proc print data=select_m3_f3 (firstobs=50 obs=100);
	title '50th to 100th Observations of select_m3_f3';
run;



*******************************
**         PROBLEM 9         **
*******************************;

* add two variables to assess;
data assess;
	set assess;
	d1 = f1 - m1;
	d2 = f2 - m2;
run;

* select data;
data improvement;
	set assess (where=(d1 > 0 and d2 > 0));
run;

* print selection;
proc print data=improvement;
	title 'Improvement Data';
run;


