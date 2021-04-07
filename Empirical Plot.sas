proc sql;
	create table inq as select num_inquiries_3m, sum(bad)/count(*) as bad_rate 
		from a.tu_bad group by num_inquiries_3m;
quit;

proc sgplot data=inq;
	vline num_inquiries_3m/response=bad_rate;
run;

proc sql;
	create table age as select age_oldest_trade, sum(bad)/count(*) as bad_rate 
		from a.tu_bad group by age_oldest_trade;
quit;

proc sgplot data=age;
	vline age_oldest_trade / response=bad_rate;
run;