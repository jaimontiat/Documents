
{i-global.i}
{defvar.i}

FIND FIRST mapping_so
     WHERE mapping_so.mapping_id = 'Training.TQUOTE'
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE mapping_so THEN RETURN ''.

FIND system_object_instance OF mapping_so NO-LOCK NO-ERROR.
IF NOT AVAILABLE system_object_instance THEN RETURN ''.

inp-attrib = 'EXPORT_FORMAT=Progress Export Format' + CHR(1)
           + 'FIELD_DELIMITER=,' + CHR(1)
           + 'EXPORT_FILE=y' + CHR(1)
           + 'LOG_FILE=y.log' + CHR(1)
           + 'ERROR_FILE=y.error' .

{methrun.i &OBJECT-TYPE   = 'S/O'
           &OBJECT-ID     = 'MAPPING'
           &METHOD        = 'EXTRACT'
           &METHOD-STYLE  = 'NOCONFIRM'
           &INPUT-ROWID-A = ROWID(system_object_instance)
         }
