/*Macro varaibles in data step*/
data _NULL_;
	set a.tu_bad end=last;
	retain maxscore;
	maxscore=max(acq_score, maxscore);

	if last then
		do;
			%let ms = maxscore;
		end;
run;

%put max score = &ms;

/*above steps not efficient*/
data _NULL_;
	set a.tu_bad end=last;
	retain maxscore;
	maxscore=max(acq_score, maxscore);

	if last then
		do;
			call symput("ms", compress(maxscore));
		end;
run;

%put max score = &ms;

/*multiple Macro variables*/
data _NULL_;
	set a.tu_bad (obs=5);
	call symput(pid, compress(acq_score));
run;

%put _user_;

/*in proc sql*/
proc sql noprint;
	select max(acq_score) into: ms from a.tu_bad;
quit;

%put max score = &ms;

/*multiple variables into one macro*/
proc sql noprint;
	select distinct acq_score into: all_scores separated by ' ' from a.tu_bad;
quit;

%put all_scores = &all_scores;