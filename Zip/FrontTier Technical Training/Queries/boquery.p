
CURRENT-WINDOW:WIDTH-CHARS = 120.

FOR EACH  tdriver_po NO-LOCK
    WHERE tdriver_po.driver_name BEGINS 'Michael'
  ,
    FIRST business_object_obj_inst NO-LOCK
    WHERE business_object_obj_inst.businessobjectnum = tdriver_po.businessobjectnum
    AND   business_object_obj_inst.databusinessobjsequence = tdriver_po.busobjsequence
    AND   business_object_obj_inst.objectnum         = tdriver_po.objectnum
    AND   business_object_obj_inst.objecttypeid      = 'TDRIVER'
  ,
    FIRST business_object_instance OF business_object_obj_inst NO-LOCK
    WHERE business_object_instance.businessobjectid = 'TQUOTE'
  ,
    FIRST tquote_bo OF business_object_instance NO-LOCK
    
    BREAK BY business_object_instance.businessobjectnum
:
    IF FIRST-OF(business_object_instance.businessobjectnum) 
    THEN DISPLAY tdriver_po.driver_name FORMAT 'x(30)'
                 tquote_bo.quote_number FORMAT 'x(20)'
                 WITH WIDTH 100.
END.

