&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-INSURER_NAME) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE INSURER_NAME Procedure 
PROCEDURE INSURER_NAME :
/*------------------------------------------------------------------------------
  Purpose:     
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER lParameters AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER lFieldValue AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE lRowid AS ROWID      NO-UNDO.
  
  RUN getTableRowid (
      INPUT '',
      INPUT '',
      INPUT 'business_object_obj_inst',
      INPUT 'TQUOTE_TINSURER',
      OUTPUT lROWID
  ).
  
  FIND business_object_obj_inst
       WHERE ROWID(business_object_obj_inst) = lROWID
       NO-LOCK NO-ERROR.
       
  IF NOT AVAILABLE business_object_obj_inst THEN
  DO:
    RUN writeErrorLog("Unable to find TINSURER booi").
    RETURN ''.
  END.
  
  FIND FIRST business_ooinst_links OF business_object_obj_inst NO-LOCK NO-ERROR.
  
  IF AVAILABLE business_ooinst_links
  THEN FIND entity_bo
            WHERE entity_bo.businessobjectnum = business_ooinst_links.link_bobjectnum
            AND   entity_bo.busobjsequence    = business_ooinst_links.link_busobjsequence
            NO-LOCK NO-ERROR.
            
  IF AVAILABLE entity_bo 
  THEN ASSIGN lFieldValue = entity_bo.NAME.
  
  RETURN ''.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

