if ROLE in('INPUT', 'REJECTED') then do;
if upcase(NAME) in(
'AGE'
'BREAST'
'BREAST_QUAD'
'DEG_MALIG'
'INV_NODES'
'IRRADIAT'
'MENOPAUSE'
'NODE_CAPS'
'TUMOR_SIZE'
) then ROLE='INPUT';
else delete;
end;
