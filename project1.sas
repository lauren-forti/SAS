*/  Lauren Forti
	DSCI 307 
	8/24/2022
	Project 1
*/


*/ PROBLEM 1 */
* read in data with space delimiters;
data Courses;
	infile datalines;
	input Course_name $ Course_number Days $ Credits;
	datalines;
DSCI 200 . 3
DSCI 307 TT 3
MATH 371 MWE .
MATH 372 MW 3
;
run;
* print data;
proc print data=courses;
	Title 'Courses - Space Delimiters';
run;

* read in data with column input;
data Courses2;
	infile datalines;
	input Course_name $ 1-4 Course_number 5-8 Days $ 9-12 Credits 13-14;
	datalines;
DSCI 200     3 
DSCI 307 TT  3
MATH 371 MWE   
MATH 372 MW  3
;
run;
* print data;
proc print data=courses2;
	Title 'Courses - Column Input';
run;



/* PROBLEM 2 */
* read in data with pointers and informants;
data Courses3;
	infile datalines;
	input @1 Course $8.
		  @9 Days $3.
		  @13 BeginDate mmddyy11.
		  @23 EndDate mmddyy11.
		  @33 Credits $2.
		  @36 Tuition dollar7.2;
	datalines;
DSCI 200    8/26/2019 10/29/2019 3 3000.00
DSCI 307 TT 8/26/2019 12/12/2019 3 3000.00
MATH 371 MW 8/26/2019 12/11/2019   3000.00
MATH 372 MW 8/26/2019            3 3000.00
;
run;
* print data;
proc print data=courses3;
	Title 'Courses - Formatted Column Input w/ Pointers and Informats';
	format BeginDate mmddyy10. EndDate mmddyy10. Tuition dollar10.;
run;


* read in data with modified list input & and : ;
data Courses4;
	infile datalines;
	input Course : & $8.
	      Days : $10-12
	      StartDate : mmddyy10.
	      EndDate : mmddyy10.
	      Credits : $3.
	      Tuition : dollar9.2;
	datalines;
DSCI 200 . 8/26/2019 10/29/2019 3 3000.00
DSCI 307 TT 8/26/2019 12/12/2019 3 3000.00
MATH 371 MW 8/26/2019 12/11/2019 . 3000.00
MATH 372 MW 8/26/2019 . 3 3000.00
;
run;

proc print data = Courses4;
	Title 'Courses - Modified Input';
	format StartDate mmddyy10. EndDate mmddyy10. Tuition dollar9.;
run;

* read in data with informat statement ;
data Courses5;
	infile datalines;
	informat Course  $8. Days $2. StartDate mmddyy10. EndDate mmddyy10. Credits 2. Tuition dollar7.;
	input Course & $ @10 Days $ StartDate EndDate Credits Tuition ; 
	datalines;
DSCI 200 . 8/26/2019 10/29/2019 3 3000.00
DSCI 307 TT 8/26/2019 12/12/2019 3 3000.00
MATH 371 MW 8/26/2019 12/11/2019 . 3000.00
MATH 372 MW 8/26/2019 . 3 3000.00
;
run;
* print data;
proc print data = Courses5;
	Title 'Courses - Informat Statement Input';
	format StartDate mmddyy10. EndDate mmddyy10. Tuition dollar9.;
run;


/* PROBLEM 3 */
* read in data w/ infile;
data Courses6;
	infile '/home/u62096251/folders/myfolders/Week1/class_schedule.csv' dsd firstobs = 2;
	input CourseName $ CourseNumber Days $ BeginDate:mmddyy10. EndDate:mmddyy10. Credits Tuition:dollar9.;
run;
proc print data = Courses6;
	title 'Courses - Reading from CSV File w/ DATA';
	format BeginDate mmddyy10. EndDate mmddyy10. Tuition dollar9.;
run;

* read in data w/ proc input;
proc import out=Courses7
	datafile='/home/u62096251/folders/myfolders/Week1/class_schedule.xlsx'
	dbms=xlsx
	replace;
	getnames=YES;
run;

proc print data=Courses7;
	Title 'Courses - Reading from XLSX File w/ PROC import';
run;
	





