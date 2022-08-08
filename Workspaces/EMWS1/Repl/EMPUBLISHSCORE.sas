* ;
* Variable: deg_malig ;
* ;
Label REP_deg_malig='Replacement: deg-malig';
REP_deg_malig =deg_malig ;
if deg_malig  eq . then REP_deg_malig = . ;
else
if deg_malig <-0.232071427  then REP_deg_malig  = -0.232071427 ;
else
if deg_malig >4.2320714274  then REP_deg_malig  = 4.2320714274 ;
