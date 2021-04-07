proc print data=a.bad_def;
run;

/*Missing 3 payments at least once within 12 months*/
data create_bad;
	set a.bad_def;
	by pid month;
	retain max_dq;

	if first.pid then
		max_dq=dq_status;
	else
		max_dq=max(max_dq, dq_status);
run;

data create_bad_final (drop=dq_status);
	set create_bad;
	by pid month;

	if max_dq >=3 then
		bad=1;
	else
		bad=0;

	if last.pid;
run;

/*Missing 4 payments at least once within 9 months*/
data create_bad;
	set a.bad_def2;
	by pid month;
	retain max_dq;

	if first.pid then
		max_dq=dq_status;
	else
		max_dq=max(max_dq, dq_status);
run;

data create_bad_final
(drop=dq_status);
	set create_bad;
	by pid month;

	if max_dq>=4 then
		bad=1;
	else
		bad=0;

	if month=9;
run;