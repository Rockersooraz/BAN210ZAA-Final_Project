if NAME="deg_malig" then do;
ROLE="REJECTED";
COMMENT= "Replaced by Repl";
end;
else
if NAME="REP_deg_malig" then do;
ROLE="INPUT";
LEVEL="INTERVAL";
end;
