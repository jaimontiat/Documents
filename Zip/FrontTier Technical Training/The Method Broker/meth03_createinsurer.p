
{i-global.i}

DEFINE BUFFER entity_boi FOR business_object_instance.

{defvar.i}


OPEN QUERY qEntity
FOR EACH entity_bo NO-LOCK
    WHERE entity_bo.NAME BEGINS 'Sherwood International Inc'
  ,
    FIRST business_object_inst_view NO-LOCK
    WHERE business_object_inst_view.businessobjectnum = entity_bo.businessobjectnum 
    AND   business_object_inst_view.viewtype          = 'INSURER'.
    
GET FIRST qEntity NO-LOCK.
IF QUERY qEntity:QUERY-OFF-END THEN RETURN.

FIND entity_boi OF entity_bo NO-LOCK NO-ERROR.
IF NOT AVAILABLE entity_boi THEN RETURN.


FIND FIRST tquote_bo
     WHERE tquote_bo.quote_number = 'Test-2'
     NO-LOCK NO-ERROR.
     
IF AVAILABLE tquote_bo THEN
DO:
  FIND business_object_instance OF tquote_bo NO-LOCK NO-ERROR.
  
  IF AVAILABLE business_object_instance THEN
  DO:
    {methrun.i &OBJECT-TYPE     = 'P/O'
               &OBJECT-ID       = 'TINSURER'
               &METHOD          = 'NEW'
               &METHOD-STYLE    = 'NOCONFIRM'
               &INPUT-ROWID-C   = ROWID(business_object_instance)
               &INPUT-LINKLEVEL = 'B/O'
               &INPUT-LINKROWID = ROWID(entity_boi)
               &INPUT-LINKVIEW  = 'INSURER'
             }
  END.
END.
