data ivprep; set a.tu_bad;

if dti<=0.6 then dti=0.6;
else if dti<=0.8 then dti=0.8;
else if dti<=1.0 then dti=1.0;
else dti=2;

tot_trade_open = floor(min(tot_trade_open,4000)/500)*500;
tot_trade_limit = floor(min(tot_trade_open,12000)/3000)*3000;
trade_util = floor(min(trade_util,1.25)/0.25)*0.25;
age_oldest_trade = floor(min(age_oldest_trade,20)/5)*5;
run;

%macro iv;

proc datasets lib=work noprint; delete ivall iv; run;

proc sql noprint;
	select sum(bad), sum(1-bad), count(*)
	into :tot_bad, :tot_good, :tot_both
	from ivprep
; quit;

%do i=1 %to 16;
	
	%let var=%scan(&varlist,&i);

	proc sql; create table woe as
		select "&var" format=$20. as tablevar,
				&var, count(*) as cnt,
				sum(1-bad) as sum_good,
				sum(1-bad)/&tot_good as dist_good,
				sum(bad) as sum_bad,
				sum(bad)/&tot_bad as dist_bad,
				log((sum(bad)/&tot_bad)/(sum(1-bad)/&tot_good))*100 as woe,
				((sum(bad)/&tot_bad)-(sum(1-bad)/&tot_good))*(calculated woe/100) as pre_iv
	 	from ivprep
	 	group by &var
	 	order by &var
	; quit;

	proc sql;
		create table iv as
		select  "&var" length=20 as tablevar,
				sum(pre_iv) as iv
		from woe
	; quit; 
	
	proc append base=ivall data=iv force; run;

%end;

%mend;

%iv;