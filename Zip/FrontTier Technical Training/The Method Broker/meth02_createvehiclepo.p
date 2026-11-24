
{i-global.i}

{defvar.i &PRE=vehicle}
{defvar.i &PRE=driver}

FIND FIRST tquote_bo
     WHERE tquote_bo.quote_number = 'Test-2'
     NO-LOCK NO-ERROR.
     
IF AVAILABLE tquote_bo THEN
DO:
  FIND business_object_instance OF tquote_bo NO-LOCK NO-ERROR.
  
  IF AVAILABLE business_object_instance THEN
  DO:
    {methrun.i &PRE=vehicle
               &OBJECT-TYPE    = 'P/O'
               &OBJECT-ID      = 'TVEHICLE'
               &METHOD         = 'NEW'
               &METHOD-STYLE   = 'NOCONFIRM'
               &INPUT-ROWID-C  = ROWID(business_object_instance)
             }
             
    IF vehicleout-result <> 'METHOD-ERROR' AND RETURN-VALUE <> 'METHOD-ERROR' THEN
    DO:
      FIND business_object_obj_inst
           WHERE ROWID(business_object_obj_inst) = vehicleout-rowidA
           NO-LOCK NO-ERROR.
           
      IF AVAILABLE business_object_obj_inst THEN
      DO:
        {methrun.i &PRE=driver
                   &OBJECT-TYPE    = 'P/O'
                   &OBJECT-ID      = 'TDRIVER'
                   &METHOD         = 'NEW'
                   &METHOD-STYLE   = 'NOCONFIRM'
                   &INPUT-ROWID-B  = ROWID(business_object_obj_inst)
                   &INPUT-ROWID-C  = ROWID(business_object_instance)
                 }
      END.
    END.
  END.
END.
