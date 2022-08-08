*------------------------------------------------------------*;
* Reg: Create decision matrix;
*------------------------------------------------------------*;
data WORK.class(label="class");
  length   class                            $  32
           COUNT                                8
           DATAPRIOR                            8
           TRAINPRIOR                           8
           DECPRIOR                             8
           DECISION1                            8
           DECISION2                            8
           ;

  label    COUNT="Level Counts"
           DATAPRIOR="Data Proportions"
           TRAINPRIOR="Training Proportions"
           DECPRIOR="Decision Priors"
           DECISION1="RECURRENCE-EVENTS"
           DECISION2="NO-RECURRENCE-EVENTS"
           ;
class="RECURRENCE-EVENTS"; COUNT=33; DATAPRIOR=0.29203539823008; TRAINPRIOR=0.29203539823008; DECPRIOR=.; DECISION1=1; DECISION2=0;
output;
class="NO-RECURRENCE-EVENTS"; COUNT=80; DATAPRIOR=0.70796460176991; TRAINPRIOR=0.70796460176991; DECPRIOR=.; DECISION1=0; DECISION2=1;
output;
;
run;
proc datasets lib=work nolist;
modify class(type=PROFIT label=class);
label DECISION1= 'RECURRENCE-EVENTS';
label DECISION2= 'NO-RECURRENCE-EVENTS';
run;
quit;
data EM_DMREG / view=EM_DMREG;
set EMWS1.Trans_TRAIN(keep=
REP_deg_malig age breast breast_quad class inv_nodes irradiat menopause
node_caps tumor_size );
run;
*------------------------------------------------------------* ;
* Reg: DMDBClass Macro ;
*------------------------------------------------------------* ;
%macro DMDBClass;
    age(ASC) breast(ASC) breast_quad(ASC) class(DESC) inv_nodes(ASC) irradiat(ASC)
   menopause(ASC) node_caps(ASC) tumor_size(ASC)
%mend DMDBClass;
*------------------------------------------------------------* ;
* Reg: DMDBVar Macro ;
*------------------------------------------------------------* ;
%macro DMDBVar;
    REP_deg_malig
%mend DMDBVar;
*------------------------------------------------------------*;
* Reg: Create DMDB;
*------------------------------------------------------------*;
proc dmdb batch data=WORK.EM_DMREG
dmdbcat=WORK.Reg_DMDB
maxlevel = 513
;
class %DMDBClass;
var %DMDBVar;
target
class
;
run;
quit;
*------------------------------------------------------------*;
* Reg: Run DMREG procedure;
*------------------------------------------------------------*;
proc dmreg data=EM_DMREG dmdbcat=WORK.Reg_DMDB
validata = EMWS1.Trans_VALIDATE
outest = EMWS1.Reg_EMESTIMATE
outterms = EMWS1.Reg_OUTTERMS
outmap= EMWS1.Reg_MAPDS namelen=200
;
class
class
age
breast
breast_quad
inv_nodes
irradiat
menopause
node_caps
tumor_size
;
model class =
REP_deg_malig
age
breast
breast_quad
inv_nodes
irradiat
menopause
node_caps
tumor_size
/level=nominal
coding=DEVIATION
nodesignprint
;
;
score data=EMWS1.Trans_TEST
out=_null_
outfit=EMWS1.Reg_FITTEST
role = TEST
;
code file="D:\\BAN210PA\Workspaces\EMWS1\Reg\EMPUBLISHSCORE.sas"
group=Reg
;
code file="D:\\BAN210PA\Workspaces\EMWS1\Reg\EMFLOWSCORE.sas"
group=Reg
residual
;
run;
quit;
