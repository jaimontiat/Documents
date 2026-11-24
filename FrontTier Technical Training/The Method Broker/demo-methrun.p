{defvar.i &PRE=tt}

DEFINE VAR v-quotenum AS CHAR NO-UNDO.
DEFINE VAR v-vehiclemake AS CHAR NO-UNDO.
DEFINE VAR v-vehiclemodel AS CHAR NO-UNDO.
DEFINE VAR v-vehicleyear AS CHAR NO-UNDO.
DEFINE VAR v-drivername AS CHAR NO-UNDO.
DEFINE VAR lin-line AS INT NO-UNDO.
DEFINE VAR lre-newquoteboi AS ROWID NO-UNDO.
DEFINE VAR lre-newvehiclebooi AS ROWID NO-UNDO.
DEFINE VAR lre-newdriverbooi AS ROWID NO-UNDO.
DEFINE VAR lin-vehicleobjectnum AS DEC NO-UNDO.

DEFINE STREAM inpSTM.

INPUT STREAM inpSTM FROM VALUE("demo-methrun.d") NO-ECHO.
/*
Skip the title line
*/
IMPORT STREAM inpSTM DELIMITER "," v-quotenum v-vehiclemake v-vehiclemodel v-vehicleyear v-drivername.
ASSIGN lin-line = 1.
REPEAT:
    ASSIGN v-quotenum     = ""
           v-vehiclemake  = ""
           v-vehiclemodel = ""
           v-vehicleyear  = ""
           v-drivername   = ""
           lin-line = lin-line + 1.
    IMPORT STREAM inpSTM DELIMITER "," v-quotenum v-vehiclemake v-vehiclemodel v-vehicleyear v-drivername.
    /*
    No Quote Information
    */
    IF v-quotenum = "" THEN
        NEXT.

    /*
    Create Quote
    */
    
    ASSIGN lre-newquoteboi = ?.
    FOR EACH tquote_bo NO-LOCK
       WHERE tquote_bo.quote_number = v-quotenum,
       FIRST business_object_instance NO-LOCK
       WHERE business_object_instance.businessobjectnum = tquote_bo.businessobjectnum
         AND business_object_instance.busobjsequence    = tquote_bo.busobjsequence:
        ASSIGN lre-newquoteboi = ROWID(business_object_instance).
        LEAVE.
    END.
    IF lre-newquoteboi = ? THEN DO TRANSACTION: /* No Quote Exist > Create new quote */
        {methrun.i 
            &PRE=tt
            &OBJECT-TYPE   = 'B/O'
            &OBJECT-ID     = 'TQUOTE'
            &METHOD        = 'NEW'
            &METHOD-STYLE  = 'NOCONFIRM'
            &INPUT-ROWID-A = ?
            &INPUT-ROWID-B = ?
            &INPUT-ROWID-C = ? }
        IF ttout-result = "CANCEL" OR RETURN-VALUE = "METHOD-ERROR" THEN DO:
            MESSAGE lin-line "> Error on creating Quote"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            UNDO, RETURN.
        END.
        /*
        out-rowidA = rowid of BOI
        out-rowidB = rowid of data record
        */
        FIND tquote_bo WHERE ROWID(tquote_bo) = ttout-rowidB EXCLUSIVE-LOCK NO-ERROR.
        FIND business_object_instance
            WHERE ROWID(business_object_instance) = ttout-rowidA EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE tquote_bo OR NOT AVAILABLE business_object_instance THEN DO:
            MESSAGE lin-line "> Did not create Quote Data or Instance Record"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            UNDO, RETURN.
        END.

        ASSIGN tquote_bo.quote_number = v-quotenum
               tquote_bo.jurisdiction = "PQ".

        /*
        Update the BOI.visualid
        */
        {methrun.i 
            &PRE=tt
            &OBJECT-TYPE   = 'B/O'
            &OBJECT-ID     = 'TQUOTE'
            &METHOD        = 'UPDATE'
            &METHOD-STYLE  = 'NOCONFIRM'
            &ATTRIBUTE     = 'VISUALID'
            &INPUT-ROWID-A = ROWID(business_object_instance)
            &INPUT-ROWID-B = ?
            &INPUT-ROWID-C = ? }
        
        FIND CURRENT tquote_bo NO-LOCK.
        FIND CURRENT business_object_instance NO-LOCK.
        ASSIGN lre-newquoteboi = ROWID(business_object_instance).
    END.

    /*
    No Vehicle Information
    */
    IF v-vehiclemake = "" AND v-vehiclemodel = "" THEN
        NEXT.

    /*
    Create Vehicle
    */
    ASSIGN lre-newvehiclebooi = ?
           lin-vehicleobjectnum = 0.
    FOR EACH business_object_obj_inst NO-LOCK
        WHERE business_object_obj_inst.businessobjectnum = business_object_instanc.businessobjectnum
          AND business_object_obj_inst.busobjsequence    = business_object_instance.busobjsequence
          AND business_object_obj_inst.objecttypeid      = "TVEHICLE",
        FIRST tvehicle_po NO-LOCK
        WHERE tvehicle_po.businessobjectnum = business_object_obj_inst.businessobjectnum
          AND tvehicle_po.busobjsequence    = business_object_obj_inst.busobjsequence
          AND tvehicle_po.objectnum         = business_object_obj_inst.objectnum
          AND tvehicle_po.vehicle_make      = v-vehiclemake
          AND tvehicle_po.vehicle_model     = v-vehiclemodel
          AND tvehicle_po.vehicle_year      = INTEGER(v-vehicleyear):
        ASSIGN lre-newvehiclebooi = ROWID(business_object_obj_inst)
               lin-vehicleobjectnum = business_object_obj_inst.objectnum.
        LEAVE.
    END.
    IF lre-newvehiclebooi = ? THEN DO TRANSACTION: /* No Quote Exist > Create new quote */
        {methrun.i 
            &PRE=tt
            &OBJECT-TYPE   = 'P/O'
            &OBJECT-ID     = 'TVEHICLE'
            &METHOD        = 'NEW'
            &METHOD-STYLE  = 'NOCONFIRM'
            &INPUT-ROWID-A = ?
            &INPUT-ROWID-B = ?
            &INPUT-ROWID-C = lre-newquoteboi }
        IF ttout-result = "CANCEL" OR RETURN-VALUE = "METHOD-ERROR" THEN DO:
            MESSAGE lin-line "> Error on creating Vehicle"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            UNDO, RETURN.
        END.
        /*
        out-rowidA = rowid of BOOI
        out-rowidB = rowid of data record
        */
        FIND tvehicle_po WHERE ROWID(tvehicle_po) = ttout-rowidB EXCLUSIVE-LOCK NO-ERROR.
        FIND business_object_obj_inst
            WHERE ROWID(business_object_obj_inst) = ttout-rowidA EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE tvehicle_po OR NOT AVAILABLE business_object_obj_inst THEN DO:
            MESSAGE lin-line "> Did not create Vehicle Data or Instance Record"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            UNDO, RETURN.
        END.

        ASSIGN tvehicle_po.vehicle_make  = v-vehiclemake
               tvehicle_po.vehicle_model = v-vehiclemodel
               tvehicle_po.vehicle_year  = INTEGER(v-vehicleyear).

        /*
        Update the BOOI.visualid
        */
        {methrun.i 
            &PRE=tt
            &OBJECT-TYPE   = 'P/O'
            &OBJECT-ID     = 'TVEHICLE'
            &METHOD        = 'UPDATE'
            &METHOD-STYLE  = 'NOCONFIRM'
            &ATTRIBUTE     = 'VISUALID'
            &INPUT-ROWID-A = ROWID(business_object_obj_inst)
            &INPUT-ROWID-B = ?
            &INPUT-ROWID-C = ? }
        
        FIND CURRENT tvehicle_po NO-LOCK.
        FIND CURRENT business_object_obj_inst NO-LOCK.
        ASSIGN lre-newvehiclebooi = ROWID(business_object_obj_inst)
               lin-vehicleobjectnum = business_object_obj_inst.objectnum.
    END.
        
    /*
    No Driver Information
    */
    IF v-drivername = "" THEN
        NEXT.

    /*
    Create Driver
    */
    ASSIGN lre-newdriverbooi = ?.
    FOR EACH business_object_obj_inst NO-LOCK
        WHERE business_object_obj_inst.businessobjectnum = business_object_instanc.businessobjectnum
          AND business_object_obj_inst.busobjsequence    = business_object_instance.busobjsequence
          AND business_object_obj_inst.PARENT_objectnum  = lin-vehicleobjectnum /* Parent vehicle */
          AND business_object_obj_inst.objecttypeid      = "TDRIVEFR",
        FIRST tdriver_po NO-LOCK
        WHERE tdriver_po.businessobjectnum = business_object_obj_inst.businessobjectnum
          AND tdriver_po.busobjsequence    = business_object_obj_inst.busobjsequence
          AND tdriver_po.objectnum         = business_object_obj_inst.objectnum
          AND tdriver_po.driver_name       = v-drivername:
        ASSIGN lre-newdriverbooi = ROWID(business_object_obj_inst).
        LEAVE.
    END.
    IF lre-newdriverbooi = ? THEN DO TRANSACTION: /* No Quote Exist > Create new quote */
        {methrun.i 
            &PRE=tt
            &OBJECT-TYPE   = 'P/O'
            &OBJECT-ID     = 'TDRIVER'
            &METHOD        = 'NEW'
            &METHOD-STYLE  = 'NOCONFIRM'
            &INPUT-ROWID-A = ?
            &INPUT-ROWID-B = lre-newvehiclebooi
            &INPUT-ROWID-C = lre-newquoteboi }
        IF ttout-result = "CANCEL" OR RETURN-VALUE = "METHOD-ERROR" THEN DO:
            MESSAGE lin-line "> Error on creating Driver"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            UNDO, RETURN.
        END.
        /*
        out-rowidA = rowid of BOOI
        out-rowidB = rowid of data record
        */
        FIND tdriver_po WHERE ROWID(tdriver_po) = ttout-rowidB EXCLUSIVE-LOCK NO-ERROR.
        FIND business_object_obj_inst
            WHERE ROWID(business_object_obj_inst) = ttout-rowidA EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE tdriver_po OR NOT AVAILABLE business_object_obj_inst THEN DO:
            MESSAGE lin-line "> Did not create Driver Data or Instance Record"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            UNDO, RETURN.
        END.

        ASSIGN tdriver_po.driver_name = v-drivername.

        /*
        Update the BOOI.visualid
        */
        {methrun.i 
            &PRE=tt
            &OBJECT-TYPE   = 'P/O'
            &OBJECT-ID     = 'TDRIVER'
            &METHOD        = 'UPDATE'
            &METHOD-STYLE  = 'NOCONFIRM'
            &ATTRIBUTE     = 'VISUALID'
            &INPUT-ROWID-A = ROWID(business_object_obj_inst)
            &INPUT-ROWID-B = ?
            &INPUT-ROWID-C = ? }
        
        FIND CURRENT tdriver_po NO-LOCK.
        FIND CURRENT business_object_obj_inst NO-LOCK.
    END.
END.
INPUT STREAM inpSTM CLOSE.
