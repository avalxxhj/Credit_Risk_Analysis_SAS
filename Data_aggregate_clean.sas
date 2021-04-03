/*append data*/
data tu;
	set a.tu_part1 a.tu_part2;
run;

/*select rows*/
data tu_first200;
	set a.tu;

	if _N_<=200;
run;

data tmp;
	set a.tu;

	if _N_=10 then
		delete;
run;

data tmp;
	set a.tu;

	if pid='A0000004' then
		delete;
run;

data tmp;
	set a.tu;
	drop num_trade_auto_1y;
run;

/*select column*/
data tmp;
	set a.tu;
	keep num_trade_auto_1y;
run;

/*random sampling*/
proc surveyselect data=a.tu out=tu_sample samprate=0.2;
run;

/*missing value imputation*/
data tmp;
	set a.tu;
	where wrst_dq_sts_3m=-999;
run;

proc means data=a.tu (where=(wrst_dq_sts_3m ne -999));
	var wrst_dq_sts_3m;
	output out=findmedian median=median;
run;

data tmp;
	set a.tu;

	if wrst_dq_sts_3m=-999 then
		wrst_dq_sts_3m=0;
run;

/*univariate analysis*/

proc univariate data=a.tu;
	var wrst_dq_sts_3m acq_score;
run;

proc univariate data=a.tu;
	var wrst_dq_sts_3m acq_score num_tot_trade_1y dti trade_util;
run;

