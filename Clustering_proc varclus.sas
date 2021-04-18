%let varlist = active_bk age_oldest_trade dti num_inquiries_1y 
num_inquiries_3m num_inquiries_6m num_tot_trade_1y 
num_trade_auto_1y num_trade_card_1y num_trade_co_3y 
num_trade_mtg_1y tot_trade_limit tot_trade_open trade_util
wrst_dq_sts_1y wrst_dq_sts_3m;

proc corr data=a.tu_bad outp=tu_bad_corr noprob;
	var &varlist;
run;

/*proc varclus*/
proc varclus data=a.tu_bad;
	var &varlist.;
run;

/*restrict the number of clusters*/
proc varclus data=a.tu_bad maxclusters=5;
	var &varlist.;
	ods output rsquare=r2;
run;