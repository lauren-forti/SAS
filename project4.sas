*/  Lauren Forti
	DSCI 307 
	9/12/2022
	Project 4
*/



*******************************
**         PROBLEM 1         **
*******************************;

* set lib;
libname Week4 '/home/u62096251/folders/myfolders/Week4';

* create table with city and high temps in C;
* then sort high to low;
proc sql;
title 'worldtemps';
select City, (AvgHigh - 32) * 5/9 as HighTempC format = 4.1
from Week4.worldtemps
order by HighTempC desc;
quit;



*******************************
**         PROBLEM 2         **
*******************************;

* set lib;
libname Week4 '/home/u62096251/folders/myfolders/Week4';

* create table w/ postal codes for Illionis, Ohio, and North Carolina;
proc sql;
	title 'postalcodes';
	select 'In United States', 'Postal code for', 'of', Name label='#', 'is', Code label='#'
	from Week4.postalcodes
	where Name in ('Illinois', 'Ohio', 'North Carolina');
quit;



*******************************
**         PROBLEM 3         **
*******************************;

* set lib;
libname Week4 '/home/u62096251/folders/myfolders/Week4';

* create table with City, AvgHigh in C, AvgLow in C and temp range;
* that only contains cities with range bt/wn 38.0 and 40.0;
* then order asc by range;

proc sql;
	title 'worldtemps2';
	select City, 
			(AvgHigh - 32) * 5/9 as AvgH format=5.1,
			(AvgLow - 32) * 5/9 as AvgL format=5.1,
			(calculated AvgH - calculated  AvgL) as RangeC format=5.1
	from Week4.worldtemps
	where calculated RangeC between 38.0 and 40.0
	order by calculated RangeC;
quit;
