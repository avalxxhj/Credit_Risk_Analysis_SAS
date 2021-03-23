%macro test;
	proc print data=a.tu_bad;
	run;

%mend;

%test;

/*debugging*/
%macro test;
	%let a=1;

	data temp;
		x=&a;
	run;

	proc print data=temp;
	run;

%mend;

options mprint nomlogic;
%test;
options nomprint mlogic;
%test;

/*using Macro parameters*/
options mprint mlogic;

/* use parameter list */
%macro test1;
	proc sql;
		create table &dsn_out. as select &varlist.
from &dsn_in.
order by &id.;
	quit;

%mend;

%let dsn_in=a.tu_bad;
%let dsn_out=temp;
%let varlist=ssn, acq_score, bad;
%let id=pid;
%test1;

/* Positional parameters: when the macro is
called, the parameters have to be in the same
order, but only the values are required */
%macro test2(dsn_in, dsn_out, varlist, id);
	proc sql;
		create table &dsn_out. as select &id., &varlist.
from &dsn_in.
order by &id.;
	quit;

%mend;

%test2(a.tu_bad, temp, %bquote(ssn,acq_score,bad), pid);

/* Keyword parameters: the parameters are
referenced by name, so the order does not
matter, but the name has to be specified */
%macro test3(dsn_in=, dsn_out=, varlist=, id=);
	proc sql;
		create table &dsn_out. as select &id., &varlist.
from &dsn_in.
order by &id.;
	quit;

%mend;

%test3(id=pid, varlist=%bquote(ssn,acq_score,bad), dsn_in=a.tu_bad, 
	dsn_out=temp);