*/  Lauren Forti
	DSCI 307 
	10/8/2022
	Final Project
*/



*******************************
**         PROBLEM 1         **
*******************************;

* read in data;
data house_price;
	infile '/home/u62096251/folders/myfolders/Week8/Bay Area House Price.csv' dsd firstobs=2;
	input address $ info $ z_address $ bathrooms bedrooms finishedsqft lastsolddate:mmddyy10. lastsoldprice latitude longitude neighborhood $ totalrooms usecode $ yearbuilt zestimate zipcode zpid;
run;



*******************************
**         PROBLEM 2         **
*******************************;

* drop cols w/ data statement;
data house_price(replace=yes);
	set house_price;
	drop address info z_address neighborhood;
run;

* drop cols w/ SQL;
proc sql;
	alter table house_price 
	drop latitude, longitude, zpid;
quit;



*******************************
**         PROBLEM 3         **
*******************************;

* add new var w/ data statement;
data house_price (replace=yes);
	set house_price;
	price_per_square_foot = lastsoldprice/finishedsqft;
run;

* add new var w/ SQL;
proc sql;
	update house_price
	set price_per_square_foot=lastsoldprice/finishedsqft;
quit;



*******************************
**         PROBLEM 4         **
*******************************;

* sort data;
proc sort data=house_price;
	by zipcode;
run;
* find avg of lastsoldprice by zipcode w/ data statement;
proc means data=house_price mean;
	var lastsoldprice;
	class zipcode;
	title 'Average Price by Zipcode - Data Statement';
run;

* find avg of lastsoldprice by zipcode w/ SQL;
proc sql;
	title 'Average Price by Zipcode - SQL';
	select zipcode, mean(lastsoldprice) as avg_price
	from house_price
	group by zipcode;
quit;



*******************************
**         PROBLEM 5         **
*******************************;

* sort data;
proc sort data=house_price;
	by usecode totalrooms bedrooms;
run;
* find avg of lastsoldprice by zipcode w/ data statement;
proc means data=house_price mean;
	var lastsoldprice;
	class usecode totalrooms bedrooms;
	title 'Average Price - Data Statement';
run;


* find avg of lastsoldprice by zipcode w/ SQL;
proc sql;
	title 'Average Price - SQL';
	select zipcode, usecode, totalrooms, bedrooms, mean(lastsoldprice) as avg_price
	from house_price
	group by zipcode, usecode, totalrooms, bedrooms;
quit;



*******************************
**         PROBLEM 6         **
*******************************;

* bar plot of bathrooms;
proc sgplot data=house_price;
	vbar bathrooms;
    label bathrooms = 'Bathrooms';
    title 'Number of Bathrooms';
run;

ods listing gpath='/home/u62096251/folders/myfolders/Week8';
ods graphics / reset
	imagename='bedrooms'
	outputfmt=png
	height=3in width=6in;
* bar plot of bedrooms;
proc sgplot data=house_price;
	vbar bedrooms;
    label bedrooms = 'Bedrooms';
    title 'Number of Bedrooms';
run;
ods listing close;

* bar plot of usecode;
proc sgplot data=house_price;
	vbar usecode;
    label usecode = 'Usecodes';
    title 'Number of Usecodes';
run;

* bar plot of totalrooms;
proc sgplot data=house_price;
	vbar totalrooms;
    label totalrooms = 'Total Rooms';
    title 'Number of Total Rooms';
run;



*******************************
**         PROBLEM 7         **
*******************************;

* sort data;
proc sort data=house_price;
	by lastsoldprice;
run;
* plot histogram;
proc sgplot data=house_price;
	histogram lastsoldprice;
    label lastsoldprice = 'Last Sold Price';
    title 'Last Sold Price';
run;

* plot box plot;
proc sgplot data=house_price;
	vbox zestimate;
	label zestimate = 'Zestimate';
	title 'Zestimate';
run;

*** Conclusion ***;
* Both variables are skewed.;

* calc medians;
proc means data=house_price median;
	title 'Median of Last Sold Price';
	var lastsoldprice;
run;
proc means data=house_price median;
	title 'Median of Zestimate';
	var zestimate;
run;

* Median of lastsoldprice:  990000.00;
* Median of zestimate:     1230758.00;



*******************************
**         PROBLEM 8         **
*******************************;

* calc correlation coefficients of all numerical vars w/ zestimate and plot scatter;
proc corr data=house_price plots(maxpoints=none)=scatter rank;
    with zestimate;
    title 'Correlations of Numerical Variables with Zestimate';
run;

* plot matrix;
proc corr data=house_price plots(maxpoints=none)=matrix rank;
    with zestimate;
    title 'Correlations of Numerical Variables with Zestimate';
run;



*******************************
**         PROBLEM 9         **
*******************************;

* Find a regression model for zestimate with the first three most correlated variables;
proc reg data=house_price plots(maxpoints=none) ;
	Model1: model zestimate=lastsoldprice finishedsqft bathrooms;
	title 'Model1';
run;



*******************************
**         PROBLEM 10        **
*******************************;

* Find a regression model for zestimate with the first three most correlated variables;
proc reg data=house_price outest=regout plots(maxpoints=none);
	Model2: model zestimate=lastsoldprice finishedsqft bathrooms bedrooms yearbuilt;
	title 'Model2';
run;



*******************************
**         PROBLEM 11        **
*******************************;

* Model1 R^2: 0.8320;
* Model2 R^2: 0.8329;

*** Conclusion ***;
* The models are very close in R^2 score, however Model2, with the five
* most correlated variables has a slightly higher R^2 score, making
* it the better model.;



*******************************
**         PROBLEM 12        **
*******************************;

* create new data to test;
data new_data;
	input lastsoldprice finishedsqft bathrooms bedrooms yearbuilt;
	datalines;
	400000 2500 2 2 1900
	300000 1800 1 1 1855
	750000 3000 3 3 2020
	185000 985 1 1 1998
;
run;

* make predictions;
proc score data=new_data score=regout out=NewPred type=parms nostd predict;
	var lastsoldprice finishedsqft bathrooms bedrooms yearbuilt;
run;

* output results;
proc print data=NewPred;
	title 'Predicted Zestimate for Four Houses';
run;



*******************************
**         PROBLEM 13        **
*******************************;

* export predictions as Excel file;
proc export data=NewPred
	outfile='/home/u62096251/folders/myfolders/Week8/prediction.xlsx'
    dbms=xlsx
    replace;
run;



*******************************
**         PROBLEM 14        **
*******************************;

* create macro;
%MACRO average (category=, price=);
	proc sort data=house_price;
		by &price;
	run;
	proc means data=house_price noprint;
		var &price;
		class &category;
		output out=averageprice;
	run;
	proc print data=averageprice (firstobs=2 obs=100);
		title "&price by &category";
	run;
%MEND average;



*******************************
**         PROBLEM 15        **
*******************************;

* invoke macro;
%average(category=zipcode, price=price_per_square_foot);



*******************************
**         PROBLEM 16        **
*******************************;

* invoke macro;
%average(category=totalrooms, price=zestimate);


