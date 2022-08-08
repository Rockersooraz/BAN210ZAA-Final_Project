***********************************;
*** Begin Scoring Code for Neural;
***********************************;
DROP _DM_BAD _EPS _NOCL_ _MAX_ _MAXP_ _SUM_ _NTRIALS;
 _DM_BAD = 0;
 _NOCL_ = .;
 _MAX_ = .;
 _MAXP_ = .;
 _SUM_ = .;
 _NTRIALS = .;
 _EPS =                1E-10;
LENGTH _WARN_ $4 
      I_class  $ 20
      U_class  $ 20
;
      label S_REP_deg_malig = 'Standard: REP_deg_malig' ;

      label age30_39 = 'Dummy: age=30-39' ;

      label age40_49 = 'Dummy: age=40-49' ;

      label age50_59 = 'Dummy: age=50-59' ;

      label age60_69 = 'Dummy: age=60-69' ;

      label breastleft = 'Dummy: breast=left' ;

      label breast_quad_ = 'Dummy: breast_quad=?' ;

      label breast_quadcentral = 'Dummy: breast_quad=central' ;

      label breast_quadleft_low = 'Dummy: breast_quad=left_low' ;

      label breast_quadleft_up = 'Dummy: breast_quad=left_up' ;

      label breast_quadright_low = 'Dummy: breast_quad=right_low' ;

      label inv_nodes0_2 = 'Dummy: inv_nodes=0-2' ;

      label inv_nodes15_17 = 'Dummy: inv_nodes=15-17' ;

      label inv_nodes24_26 = 'Dummy: inv_nodes=24-26' ;

      label inv_nodes44625 = 'Dummy: inv_nodes=44625' ;

      label inv_nodes44720 = 'Dummy: inv_nodes=44720' ;

      label irradiatno = 'Dummy: irradiat=no' ;

      label menopausege40 = 'Dummy: menopause=ge40' ;

      label menopauselt40 = 'Dummy: menopause=lt40' ;

      label node_caps_ = 'Dummy: node_caps=?' ;

      label node_capsno = 'Dummy: node_caps=no' ;

      label tumor_size0_4 = 'Dummy: tumor_size=0-4' ;

      label tumor_size15_19 = 'Dummy: tumor_size=15-19' ;

      label tumor_size20_24 = 'Dummy: tumor_size=20-24' ;

      label tumor_size25_29 = 'Dummy: tumor_size=25-29' ;

      label tumor_size30_34 = 'Dummy: tumor_size=30-34' ;

      label tumor_size35_39 = 'Dummy: tumor_size=35-39' ;

      label tumor_size40_44 = 'Dummy: tumor_size=40-44' ;

      label tumor_size44690 = 'Dummy: tumor_size=44690' ;

      label tumor_size44848 = 'Dummy: tumor_size=44848' ;

      label tumor_size45_49 = 'Dummy: tumor_size=45-49' ;

      label H11 = 'Hidden: H1=1' ;

      label H12 = 'Hidden: H1=2' ;

      label H13 = 'Hidden: H1=3' ;

      label I_class = 'Into: class' ;

      label U_class = 'Unnormalized Into: class' ;

      label P_classrecurrence_events = 'Predicted: class=recurrence-events' ;

      label P_classno_recurrence_events = 
'Predicted: class=no-recurrence-events' ;

      label  _WARN_ = "Warnings"; 

*** Generate dummy variables for age ;
drop age30_39 age40_49 age50_59 age60_69 ;
*** encoding is sparse, initialize to zero;
age30_39 = 0;
age40_49 = 0;
age50_59 = 0;
age60_69 = 0;
if missing( age ) then do;
   age30_39 = .;
   age40_49 = .;
   age50_59 = .;
   age60_69 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm5 $ 5; drop _dm5 ;
   _dm5 = put( age , $5. );
   %DMNORMIP( _dm5 )
   _dm_find = 0; drop _dm_find;
   if _dm5 <= '50-59'  then do;
      if _dm5 <= '40-49'  then do;
         if _dm5 = '30-39'  then do;
            age30_39 = 1;
            _dm_find = 1;
         end;
         else do;
            if _dm5 = '40-49'  then do;
               age40_49 = 1;
               _dm_find = 1;
            end;
         end;
      end;
      else do;
         if _dm5 = '50-59'  then do;
            age50_59 = 1;
            _dm_find = 1;
         end;
      end;
   end;
   else do;
      if _dm5 = '60-69'  then do;
         age60_69 = 1;
         _dm_find = 1;
      end;
      else do;
         if _dm5 = '70-79'  then do;
            age30_39 = -1;
            age40_49 = -1;
            age50_59 = -1;
            age60_69 = -1;
            _dm_find = 1;
         end;
      end;
   end;
   if not _dm_find then do;
      age30_39 = .;
      age40_49 = .;
      age50_59 = .;
      age60_69 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for breast ;
drop breastleft ;
if missing( breast ) then do;
   breastleft = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm5 $ 5; drop _dm5 ;
   _dm5 = put( breast , $5. );
   %DMNORMIP( _dm5 )
   if _dm5 = 'LEFT'  then do;
      breastleft = 1;
   end;
   else if _dm5 = 'RIGHT'  then do;
      breastleft = -1;
   end;
   else do;
      breastleft = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for breast_quad ;
drop breast_quad_ breast_quadcentral breast_quadleft_low breast_quadleft_up 
        breast_quadright_low ;
*** encoding is sparse, initialize to zero;
breast_quad_ = 0;
breast_quadcentral = 0;
breast_quadleft_low = 0;
breast_quadleft_up = 0;
breast_quadright_low = 0;
if missing( breast_quad ) then do;
   breast_quad_ = .;
   breast_quadcentral = .;
   breast_quadleft_low = .;
   breast_quadleft_up = .;
   breast_quadright_low = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm9 $ 9; drop _dm9 ;
   %DMNORMCP( breast_quad , _dm9 )
   if _dm9 = 'LEFT_LOW'  then do;
      breast_quadleft_low = 1;
   end;
   else if _dm9 = 'LEFT_UP'  then do;
      breast_quadleft_up = 1;
   end;
   else if _dm9 = 'RIGHT_UP'  then do;
      breast_quad_ = -1;
      breast_quadcentral = -1;
      breast_quadleft_low = -1;
      breast_quadleft_up = -1;
      breast_quadright_low = -1;
   end;
   else if _dm9 = 'CENTRAL'  then do;
      breast_quadcentral = 1;
   end;
   else if _dm9 = 'RIGHT_LOW'  then do;
      breast_quadright_low = 1;
   end;
   else if _dm9 = '?'  then do;
      breast_quad_ = 1;
   end;
   else do;
      breast_quad_ = .;
      breast_quadcentral = .;
      breast_quadleft_low = .;
      breast_quadleft_up = .;
      breast_quadright_low = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for inv_nodes ;
drop inv_nodes0_2 inv_nodes15_17 inv_nodes24_26 inv_nodes44625 inv_nodes44720 
        ;
*** encoding is sparse, initialize to zero;
inv_nodes0_2 = 0;
inv_nodes15_17 = 0;
inv_nodes24_26 = 0;
inv_nodes44625 = 0;
inv_nodes44720 = 0;
if missing( inv_nodes ) then do;
   inv_nodes0_2 = .;
   inv_nodes15_17 = .;
   inv_nodes24_26 = .;
   inv_nodes44625 = .;
   inv_nodes44720 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm5 $ 5; drop _dm5 ;
   _dm5 = put( inv_nodes , $5. );
   %DMNORMIP( _dm5 )
   if _dm5 = '0-2'  then do;
      inv_nodes0_2 = 1;
   end;
   else if _dm5 = '44625'  then do;
      inv_nodes44625 = 1;
   end;
   else if _dm5 = '15-17'  then do;
      inv_nodes15_17 = 1;
   end;
   else if _dm5 = '44815'  then do;
      inv_nodes0_2 = -1;
      inv_nodes15_17 = -1;
      inv_nodes24_26 = -1;
      inv_nodes44625 = -1;
      inv_nodes44720 = -1;
   end;
   else if _dm5 = '44720'  then do;
      inv_nodes44720 = 1;
   end;
   else if _dm5 = '24-26'  then do;
      inv_nodes24_26 = 1;
   end;
   else do;
      inv_nodes0_2 = .;
      inv_nodes15_17 = .;
      inv_nodes24_26 = .;
      inv_nodes44625 = .;
      inv_nodes44720 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for irradiat ;
drop irradiatno ;
if missing( irradiat ) then do;
   irradiatno = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm3 $ 3; drop _dm3 ;
   _dm3 = put( irradiat , $3. );
   %DMNORMIP( _dm3 )
   if _dm3 = 'NO'  then do;
      irradiatno = 1;
   end;
   else if _dm3 = 'YES'  then do;
      irradiatno = -1;
   end;
   else do;
      irradiatno = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for menopause ;
drop menopausege40 menopauselt40 ;
if missing( menopause ) then do;
   menopausege40 = .;
   menopauselt40 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm7 $ 7; drop _dm7 ;
   _dm7 = put( menopause , $7. );
   %DMNORMIP( _dm7 )
   if _dm7 = 'PREMENO'  then do;
      menopausege40 = -1;
      menopauselt40 = -1;
   end;
   else if _dm7 = 'GE40'  then do;
      menopausege40 = 1;
      menopauselt40 = 0;
   end;
   else if _dm7 = 'LT40'  then do;
      menopausege40 = 0;
      menopauselt40 = 1;
   end;
   else do;
      menopausege40 = .;
      menopauselt40 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for node_caps ;
drop node_caps_ node_capsno ;
if missing( node_caps ) then do;
   node_caps_ = .;
   node_capsno = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm3 $ 3; drop _dm3 ;
   %DMNORMCP( node_caps , _dm3 )
   if _dm3 = 'NO'  then do;
      node_caps_ = 0;
      node_capsno = 1;
   end;
   else if _dm3 = 'YES'  then do;
      node_caps_ = -1;
      node_capsno = -1;
   end;
   else if _dm3 = '?'  then do;
      node_caps_ = 1;
      node_capsno = 0;
   end;
   else do;
      node_caps_ = .;
      node_capsno = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for tumor_size ;
drop tumor_size0_4 tumor_size15_19 tumor_size20_24 tumor_size25_29 
        tumor_size30_34 tumor_size35_39 tumor_size40_44 tumor_size44690 
        tumor_size44848 tumor_size45_49 ;
*** encoding is sparse, initialize to zero;
tumor_size0_4 = 0;
tumor_size15_19 = 0;
tumor_size20_24 = 0;
tumor_size25_29 = 0;
tumor_size30_34 = 0;
tumor_size35_39 = 0;
tumor_size40_44 = 0;
tumor_size44690 = 0;
tumor_size44848 = 0;
tumor_size45_49 = 0;
if missing( tumor_size ) then do;
   tumor_size0_4 = .;
   tumor_size15_19 = .;
   tumor_size20_24 = .;
   tumor_size25_29 = .;
   tumor_size30_34 = .;
   tumor_size35_39 = .;
   tumor_size40_44 = .;
   tumor_size44690 = .;
   tumor_size44848 = .;
   tumor_size45_49 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm5 $ 5; drop _dm5 ;
   %DMNORMCP( tumor_size , _dm5 )
   _dm_find = 0; drop _dm_find;
   if _dm5 <= '35-39'  then do;
      if _dm5 <= '20-24'  then do;
         if _dm5 <= '15-19'  then do;
            if _dm5 = '0-4'  then do;
               tumor_size0_4 = 1;
               _dm_find = 1;
            end;
            else do;
               if _dm5 = '15-19'  then do;
                  tumor_size15_19 = 1;
                  _dm_find = 1;
               end;
            end;
         end;
         else do;
            if _dm5 = '20-24'  then do;
               tumor_size20_24 = 1;
               _dm_find = 1;
            end;
         end;
      end;
      else do;
         if _dm5 <= '30-34'  then do;
            if _dm5 = '25-29'  then do;
               tumor_size25_29 = 1;
               _dm_find = 1;
            end;
            else do;
               if _dm5 = '30-34'  then do;
                  tumor_size30_34 = 1;
                  _dm_find = 1;
               end;
            end;
         end;
         else do;
            if _dm5 = '35-39'  then do;
               tumor_size35_39 = 1;
               _dm_find = 1;
            end;
         end;
      end;
   end;
   else do;
      if _dm5 <= '44848'  then do;
         if _dm5 <= '44690'  then do;
            if _dm5 = '40-44'  then do;
               tumor_size40_44 = 1;
               _dm_find = 1;
            end;
            else do;
               if _dm5 = '44690'  then do;
                  tumor_size44690 = 1;
                  _dm_find = 1;
               end;
            end;
         end;
         else do;
            if _dm5 = '44848'  then do;
               tumor_size44848 = 1;
               _dm_find = 1;
            end;
         end;
      end;
      else do;
         if _dm5 = '45-49'  then do;
            tumor_size45_49 = 1;
            _dm_find = 1;
         end;
         else do;
            if _dm5 = '50-54'  then do;
               tumor_size0_4 = -1;
               tumor_size15_19 = -1;
               tumor_size20_24 = -1;
               tumor_size25_29 = -1;
               tumor_size30_34 = -1;
               tumor_size35_39 = -1;
               tumor_size40_44 = -1;
               tumor_size44690 = -1;
               tumor_size44848 = -1;
               tumor_size45_49 = -1;
               _dm_find = 1;
            end;
         end;
      end;
   end;
   if not _dm_find then do;
      tumor_size0_4 = .;
      tumor_size15_19 = .;
      tumor_size20_24 = .;
      tumor_size25_29 = .;
      tumor_size30_34 = .;
      tumor_size35_39 = .;
      tumor_size40_44 = .;
      tumor_size44690 = .;
      tumor_size44848 = .;
      tumor_size45_49 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** *************************;
*** Checking missing input Interval
*** *************************;

IF NMISS(
   REP_deg_malig   ) THEN DO;
   SUBSTR(_WARN_, 1, 1) = 'M';

   _DM_BAD = 1;
END;
*** *************************;
*** Writing the Node intvl ;
*** *************************;
IF _DM_BAD EQ 0 THEN DO;
   S_REP_deg_malig  =    -2.68808602012898 +     1.34404301006449 * 
        REP_deg_malig ;
END;
ELSE DO;
   IF MISSING( REP_deg_malig ) THEN S_REP_deg_malig  = . ;
   ELSE S_REP_deg_malig  =    -2.68808602012898 +     1.34404301006449 * 
        REP_deg_malig ;
END;
*** *************************;
*** Writing the Node nom ;
*** *************************;
*** *************************;
*** Writing the Node H1 ;
*** *************************;
IF _DM_BAD EQ 0 THEN DO;
   H11  =     1.29967673953753 * S_REP_deg_malig ;
   H12  =     0.77557932218669 * S_REP_deg_malig ;
   H13  =     0.93861734109454 * S_REP_deg_malig ;
   H11  = H11  +    -1.89372871343458 * age30_39  +     1.18159083875833 * 
        age40_49  +    -0.57559912145065 * age50_59  +     0.31042061420126 * 
        age60_69  +     0.56619109372632 * breastleft
          +     1.36896142238565 * breast_quad_  +     0.21779831783121 * 
        breast_quadcentral  +    -0.73295582617479 * breast_quadleft_low
          +    -1.06669093387924 * breast_quadleft_up
          +    -0.21242656921669 * breast_quadright_low
          +    -1.23619982942799 * inv_nodes0_2  +     0.02462988713114 * 
        inv_nodes15_17  +     0.72502982044539 * inv_nodes24_26
          +     0.87268312051735 * inv_nodes44625  +     0.78653355770398 * 
        inv_nodes44720  +    -0.47220474424347 * irradiatno
          +     0.02918884968034 * menopausege40  +     0.49548647655557 * 
        menopauselt40  +    -0.21771818662549 * node_caps_
          +     0.34207511738672 * node_capsno  +    -0.25759794857211 * 
        tumor_size0_4  +     0.06070260861424 * tumor_size15_19
          +    -0.11304351627301 * tumor_size20_24  +      1.5540780601561 * 
        tumor_size25_29  +     0.21361719394588 * tumor_size30_34
          +    -1.03142801038156 * tumor_size35_39  +    -0.01717462712527 * 
        tumor_size40_44  +    -0.77373145085077 * tumor_size44690
          +    -1.67679450843088 * tumor_size44848  +     -0.8651042227298 * 
        tumor_size45_49 ;
   H12  = H12  +     0.06884357533829 * age30_39  +    -0.56691097865869 * 
        age40_49  +    -0.36045254602412 * age50_59  +    -0.06498825288945 * 
        age60_69  +    -0.12988742430684 * breastleft
          +    -1.23590863994246 * breast_quad_  +    -0.58866870110724 * 
        breast_quadcentral  +    -0.77016750190741 * breast_quadleft_low
          +    -0.05541145822809 * breast_quadleft_up
          +     1.06031463214452 * breast_quadright_low
          +      0.9900301084414 * inv_nodes0_2  +    -1.49860847474921 * 
        inv_nodes15_17  +     -0.5679948428652 * inv_nodes24_26
          +     1.34677523660967 * inv_nodes44625  +    -0.37318615410526 * 
        inv_nodes44720  +    -0.72398863264201 * irradiatno
          +    -0.75855801811773 * menopausege40  +     0.08375395231908 * 
        menopauselt40  +     1.82983523525421 * node_caps_
          +     0.09630010197492 * node_capsno  +     1.07067110087746 * 
        tumor_size0_4  +    -0.23395224211477 * tumor_size15_19
          +     0.05786191231766 * tumor_size20_24  +    -0.44650429056006 * 
        tumor_size25_29  +    -2.82450583016768 * tumor_size30_34
          +    -0.21439553569815 * tumor_size35_39  +     0.41256268346618 * 
        tumor_size40_44  +     0.49053243663712 * tumor_size44690
          +     1.13109356273131 * tumor_size44848  +     0.43329679504995 * 
        tumor_size45_49 ;
   H13  = H13  +    -0.23234156974234 * age30_39  +      1.0453809577246 * 
        age40_49  +     -1.1504489715378 * age50_59  +      0.7291309680577 * 
        age60_69  +    -2.08405804299412 * breastleft
          +     0.31082180764289 * breast_quad_  +      0.6476098103614 * 
        breast_quadcentral  +    -1.27138438353605 * breast_quadleft_low
          +      -1.009485406465 * breast_quadleft_up
          +     0.62890071564239 * breast_quadright_low
          +    -0.73615560860124 * inv_nodes0_2  +     0.42203816182367 * 
        inv_nodes15_17  +     0.27803140853519 * inv_nodes24_26
          +     0.35949201634582 * inv_nodes44625  +    -0.42535257558671 * 
        inv_nodes44720  +     -1.3892809236171 * irradiatno
          +    -1.46889950459836 * menopausege40  +    -1.17916866693018 * 
        menopauselt40  +    -0.16702066164127 * node_caps_
          +     1.33367831970141 * node_capsno  +     -0.6036963995967 * 
        tumor_size0_4  +    -0.45004817016056 * tumor_size15_19
          +     1.65495374032886 * tumor_size20_24  +    -0.70762461266355 * 
        tumor_size25_29  +    -1.40476101029433 * tumor_size30_34
          +     0.05674606572907 * tumor_size35_39  +     1.74232452638987 * 
        tumor_size40_44  +    -0.41196520167185 * tumor_size44690
          +    -0.74923948169842 * tumor_size44848  +    -0.35151710343101 * 
        tumor_size45_49 ;
   H11  =    -1.53737817308102 + H11 ;
   H12  =     0.22368104037921 + H12 ;
   H13  =     0.71788270115108 + H13 ;
   H11  = TANH(H11 );
   H12  = TANH(H12 );
   H13  = TANH(H13 );
END;
ELSE DO;
   H11  = .;
   H12  = .;
   H13  = .;
END;
*** *************************;
*** Writing the Node class ;
*** *************************;
IF _DM_BAD EQ 0 THEN DO;
   P_classrecurrence_events  =     5.22644220551255 * H11
          +     -5.0201589606459 * H12  +     5.06988151887359 * H13 ;
   P_classrecurrence_events  =    -0.02383213105302 + P_classrecurrence_events
         ;
   P_classno_recurrence_events  = 0; 
   _MAX_ = MAX (P_classrecurrence_events , P_classno_recurrence_events );
   _SUM_ = 0.; 
   P_classrecurrence_events  = EXP(P_classrecurrence_events  - _MAX_);
   _SUM_ = _SUM_ + P_classrecurrence_events ;
   P_classno_recurrence_events  = EXP(P_classno_recurrence_events  - _MAX_);
   _SUM_ = _SUM_ + P_classno_recurrence_events ;
   P_classrecurrence_events  = P_classrecurrence_events  / _SUM_;
   P_classno_recurrence_events  = P_classno_recurrence_events  / _SUM_;
END;
ELSE DO;
   P_classrecurrence_events  = .;
   P_classno_recurrence_events  = .;
END;
IF _DM_BAD EQ 1 THEN DO;
   P_classrecurrence_events  =     0.29203539823008;
   P_classno_recurrence_events  =     0.70796460176991;
END;
*** *************************;
*** Writing the I_class  AND U_class ;
*** *************************;
_MAXP_ = P_classrecurrence_events ;
I_class  = "RECURRENCE-EVENTS   " ;
U_class  = "recurrence-events   " ;
IF( _MAXP_ LT P_classno_recurrence_events  ) THEN DO; 
   _MAXP_ = P_classno_recurrence_events ;
   I_class  = "NO-RECURRENCE-EVENTS" ;
   U_class  = "no-recurrence-events" ;
END;
********************************;
*** End Scoring Code for Neural;
********************************;
