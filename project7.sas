*/  Lauren Forti
	DSCI 307 
	10/3/2022
	Project 7
*/



* read in school 2 final ;
data s2f;
	infile '/home/u62096251/folders/myfolders/Week7/school 2 final.csv'  DSD  firstobs=2;
	input ClassID ChildID Gender $ ClassAge $ f1 f2 f3 f4;
run;



*******************************
**         PROBLEM 1         **
*******************************;

ods select Moments TestsforNormality;
proc univariate data=s2f normal;
	var f1 f2 f3 f4;
run;

** SKEWNESS **;
* Normal (-.5, .5): 				f1, f3, f4;
* Positive (Right) Skew (.5, 1): 	N/A;
* Negative (Left) Skew (-1, -.5):	f2;

** P VALUE **;
* Normal (<.05):					f1, f2, f3, f4;
* Skewed (>= .05):					;

** CONCLUSION **;
* f1, f3, and f4 are relatively normal.;
* f2 is slightly skewed left.



*******************************
**         PROBLEM 2         **
*******************************;

* plot f3;
ods select plots;
proc univariate data=s2f normal plot;
	var f3;
run;



*******************************
**         PROBLEM 3         **
*******************************;

* create new var;
data s2f;
	set s2f;
	difference = f4-f2;
run;

* analyze;
ods select Moments TestsforNormality TestsForLocation plots;
proc univariate data=s2f normal plot;
	var difference;
run;

* The mean of difference is -0.9195, not 0.;



*******************************
**         PROBLEM 4         **
*******************************;

* analyze difference by gender;
proc univariate data=s2f plots;
	var difference;
	class gender;
run;



*******************************
**         PROBLEM 5         **
*******************************;

* calc custom percentiles;
proc univariate data=s2f noprint;
    var difference;
    output out=per pctlpts= 5 to 100 by 5 pctlpre=P;
run;

* export;
proc export data=per
    dbms=xlsx 
    outfile='/home/u62096251/folders/myfolders/Week7/percentiles.xlsx' 
    replace;
run;