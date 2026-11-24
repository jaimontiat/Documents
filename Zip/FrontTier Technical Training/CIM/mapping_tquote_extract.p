
{i-global.i}
{defvar.i}

FIND FIRST tquote_bo
     WHERE tquote_bo.quote_number = 'Test-2'
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE tquote_bo THEN RETURN ''.

FIND business_object_instance OF tquote_bo NO-LOCK NO-ERROR.
IF NOT AVAILABLE business_object_instance THEN RETURN ''.

inp-attrib = 'MAPPING_ID = Training.TQUOTE' + CHR(1)
           + 'EXPORT_FORMAT=Progress Export Format' + CHR(1)
           + 'FIELD_DELIMITER=,' + CHR(1)
           + 'EXPORT_FILE=z' + CHR(1)
           + 'LOG_FILE=z.log' + CHR(1)
           + 'ERROR_FILE=z.error' .

{methrun.i &OBJECT-TYPE   = 'B/O'
           &OBJECT-ID     = 'TQUOTE'
           &METHOD        = 'EXTRACT'
           &METHOD-STYLE  = 'NOCONFIRM'
           &INPUT-ROWID-A = ROWID(business_object_instance)
         }
