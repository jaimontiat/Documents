&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : pbm-TQUOTE.p
    Purpose     : Procedure to handle All Method Calls For Business Object
    Syntax      :
    Description :
    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
/* THE FOLLOWING ARE INCLUDED AS METHOD-LIBRARIES ...... */
/* {objfunct.i} STANDARD FUNCTIONS FOR OBJECT MANIPULATION */
/* {bomethod.i}  STANDARD METHODS FOR BUSINESS OBJECT MANIPULATION */
/* ***************************  Definitions  ************************** */
{i-global.i} /* HANDLES OF METHOD-BROKER ETC. */
{definput.i} /* STANDARD INCLUDE FOR METHOD CALLS */
DEFINE VARIABLE is-okay as logical NO-UNDO.
DEFINE VARIABLE bo-data-rowid as ROWID NO-UNDO.
DEFINE VARIABLE bo-object-rowid as ROWID NO-UNDO.
/* DIALOG FOR BO MAINTENANCE */
DEFINE VARIABLE bo-dialog as CHARACTER initial "dbm_tquote.w" NO-UNDO.
/* DIALOG FOR BO SEARCHING */
DEFINE VARIABLE search-dialog AS CHARACTER initial "" NO-UNDO.
/* WINDOW FOR OPENING IN OUTLOOK SCREEN */
DEFINE VARIABLE bo-window AS CHARACTER initial "wbm-generic_bo.w" NO-UNDO.

DEFINE VARIABLE bo-desc as character initial "TQUOTE".
&SCOPED-DEFINE BO-OBJECT tquote_bo
&SCOPED-DEFINE BO-DISPLAY 'Quote:' + tquote_bo.quote_number
/*  NONVISUALID IF APPLICABLE
&SCOPED-DEFINE BO-HIDDEN generic_bo.description
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 10.24
         WIDTH              = 43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */
{objfunct.i}
{bo-stdmethod.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


{bomain.i}
/* DESCRIPTION OF bomain.i FUNCTIONALITY:
    If Method is not "New" the B/O Instance Record and the associated Data Record
    are found and following variables are populated:
        bo-data-rowid   = ROWID of Data record e.g. people_object
        bo-object-rowid = ROWID of Object record e.g. business_object_instance
        out-objectnum   = from businss_object_instance
        out-objectseq   = from business_object-instance
        
     DISPATCH SYSTEM CALLS INTERNAL PROCEDURE FOR METHOD-STYLE COMBINATION
     AND LOOKS FOR LOCAL VERSION
     */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-CTI-AMEND-FORM) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CTI-AMEND-FORM Procedure 
PROCEDURE CTI-AMEND-FORM :
/*------------------------------------------------------------------------------
  Purpose:     
------------------------------------------------------------------------------*/

  MESSAGE 'Do you really wish to AMEND this quote?'
          VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL
          UPDATE lOk AS LOGICAL.
          
  IF lOk 
  THEN RUN CTI-AMEND-NOCONFIRM.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CTI-AMEND-NOCONFIRM) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CTI-AMEND-NOCONFIRM Procedure 
PROCEDURE CTI-AMEND-NOCONFIRM :
/*------------------------------------------------------------------------------
  Purpose:     
------------------------------------------------------------------------------*/

  RUN CTI-NEW-VERSION IN THIS-PROCEDURE.
  
  /* update the business object status */
  FIND FIRST business_object_instance
       WHERE rowid(business_object_instance) = out-rowida
       EXCLUSIVE-LOCK NO-ERROR.
  
  IF AVAILABLE(business_object_instance) THEN
  DO:
    ASSIGN business_object_instance.busObjStatus = 'AMENDMENT'.
    FIND CURRENT business_object_instance NO-LOCK NO-ERROR.
  END.
  
  ASSIGN out-result = 'REFRESH'.
  RETURN ''.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CTI-NEW-VERSION) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CTI-NEW-VERSION Procedure 
PROCEDURE CTI-NEW-VERSION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  {defvar.i &pre=tt}
  
  DEF VAR new-bo-rowid      AS ROWID   NO-UNDO.
  DEF VAR is-okay           AS LOGICAL NO-UNDO.
  DEF VAR old-bo-data-rowid AS ROWID   NO-UNDO.
  DEF VAR copy-done         AS LOG     NO-UNDO.
  
  DEF BUFFER boi FOR business_object_instance.
  
  mainBlock:
  DO ON ERROR UNDO mainBlock, LEAVE mainBlock
  :
    old-bo-data-rowid = bo-data-rowid.
    
    RUN CTINewVersionBO IN ghn_globals (bo-object-rowid).
    ASSIGN new-bo-rowid = TO-ROWID(RETURN-VALUE).
    IF new-bo-rowid EQ ? THEN
    DO:
        ASSIGN out-result = "New Version Failed".
        RETURN "METHOD-ERROR".
    END.
    
    
    FIND FIRST boi WHERE ROWID(boi) = new-bo-rowid NO-LOCK.
    
    FIND business_object_instance 
         WHERE ROWID(business_object_instance) = new-bo-rowid 
         NO-LOCK NO-ERROR.
        
    RUN BO-NewDataVersion IN THIS-PROCEDURE (
        INPUT  old-bo-data-rowid,
        INPUT  business_object_instance.busobjsequence,
        INPUT  business_object_instance.effective,
        INPUT  business_object_instance.current_status,
        OUTPUT bo-data-rowid
      ).
    
    {methrun.i &PRE = tt
               &OBJECT-TYPE   = 'B/O'
               &OBJECT-ID     = bo-desc
               &METHOD        = 'UPDATE'
               &METHOD-STYLE  = 'NOCONFIRM'
               &ATTRIBUTE     = 'VISUALID'
               &ASOF          = CTISessionDate()
               &INPUT-ROWID-A = rowid(business_object_instance) }
  
                     
    out-result = inp-method.
    out-rowida = new-bo-rowid.
  
  END.  /* mainBlock */

  ASSIGN out-result = "Unexpected error creating new version".
  RETURN "ERROR".
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-LOCAL-BIND-FORM) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LOCAL-BIND-FORM Procedure 
PROCEDURE LOCAL-BIND-FORM :
/*------------------------------------------------------------------------------
  Purpose:     
------------------------------------------------------------------------------*/

  MESSAGE 'Do you really wish to BIND this quote?'
          VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL
          UPDATE lOk AS LOGICAL.
          
  IF lOk 
  THEN RUN LOCAL-BIND-NOCONFIRM.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-LOCAL-BIND-NOCONFIRM) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LOCAL-BIND-NOCONFIRM Procedure 
PROCEDURE LOCAL-BIND-NOCONFIRM :
/*------------------------------------------------------------------------------
  Purpose:     
------------------------------------------------------------------------------*/
  
  IF AVAILABLE(business_object_instance) THEN
  DO:
    FIND CURRENT business_object_instance EXCLUSIVE-LOCK NO-ERROR.
    ASSIGN business_object_instance.busobjstatus = 'BOUND'.
    FIND CURRENT business_object_instance NO-LOCK NO-ERROR.
  END.
  
  out-result = inp-method.
  out-rowida = inp-rowida.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-LOCAL-NEW-FORM) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LOCAL-NEW-FORM Procedure 
PROCEDURE LOCAL-NEW-FORM :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  /* run the method for adding a new object */
  RUN CTI-NEW-FORM.
    
  /* update the business object status */
  IF AVAILABLE(business_object_instance) THEN
  DO:
    FIND CURRENT business_object_instance EXCLUSIVE-LOCK NO-ERROR.

    ASSIGN business_object_instance.busObjStatus = 'PENDING'.

    FIND CURRENT business_object_instance NO-LOCK NO-ERROR.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

