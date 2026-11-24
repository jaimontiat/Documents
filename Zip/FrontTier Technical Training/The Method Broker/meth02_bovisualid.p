
{i-global.i}
{defvar.i}

FIND FIRST tquote_bo
     WHERE tquote_bo.quote_number = 'Test-2'
     EXCLUSIVE-LOCK NO-ERROR.
     
IF AVAILABLE tquote_bo THEN
DO:
  FIND business_object_instance OF tquote_bo NO-LOCK NO-ERROR.
  
  IF AVAILABLE business_object_instance THEN
  DO:
    ASSIGN tquote_bo.DESCRIPTION = 'Manual update'.
    
    {methrun.i &OBJECT-TYPE    = 'B/O'
               &OBJECT-ID      = 'TQUOTE'
               &METHOD         = 'UPDATE'
               &METHOD-STYLE   = 'NOCONFIRM'
               &ATTRIBUTE      = 'VISUALID'
               &INPUT-ROWID-A  = ROWID(business_object_instance)
             }
  END.
END.
