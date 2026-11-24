

{i-global.i}
{defvar.i}

FIND FIRST tquote_bo
     WHERE tquote_bo.quote_number = 'Test-2'
     NO-LOCK NO-ERROR.

FIND FIRST business_object_obj_inst
     WHERE business_object_obj_inst.businessobjectnum = tquote_bo.businessobjectnum
     AND   business_object_obj_inst.busobjsequence    = tquote_bo.busobjsequence
     AND   business_object_obj_inst.objecttypeid      = 'TINSURER'
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE business_object_obj_inst THEN RETURN ''.

IF AVAILABLE tquote_bo THEN
DO:
  FIND business_object_instance OF tquote_bo NO-LOCK NO-ERROR.
  
  IF AVAILABLE business_object_instance THEN
  DO:
    {methrun.i &OBJECT-TYPE     = 'P/O'
               &OBJECT-ID       = 'TINSURER'
               &METHOD          = 'DELETE'
               &METHOD-STYLE    = 'NOCONFIRM'
               &INPUT-ROWID-A   = ROWID(business_object_obj_inst)
             }
             
  END.
END.

