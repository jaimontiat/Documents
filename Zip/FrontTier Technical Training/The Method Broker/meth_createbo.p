
{i-global.i}
{defvar.i &PRE=xx}
{defvar.i &PRE=yy}

{methrun.i &PRE=xx
           &OBJECT-TYPE    = 'B/O'
           &OBJECT-ID      = 'TQUOTE'
           &METHOD         = 'NEW'
           &METHOD-STYLE   = 'NOCONFIRM'
         }

IF xxout-result <> 'METHOD-ERROR' AND RETURN-VALUE <> 'METHOD-ERROR' THEN
DO TRANSACTION
:
  FIND business_object_instance
       WHERE ROWID(business_object_instance) = xxout-RowidA
       NO-LOCK NO-ERROR.
  
  IF AVAILABLE business_object_instance 
  THEN FIND tquote_bo
       WHERE tquote_bo.businessobjectnum = business_object_instance.businessobjectnum
       AND   tquote_bo.busobjsequence    = business_object_instance.busobjsequence
       EXCLUSIVE-LOCK NO-ERROR.
       
  IF AVAILABLE tquote_bo 
  THEN ASSIGN tquote_bo.quote_number = 'Test-2'
              tquote_bo.effective_date = TODAY
              tquote_bo.expiry_date   = DATE('09/25/2003') .
END.

ELSE MESSAGE 'Method failed' VIEW-AS ALERT-BOX ERROR.


