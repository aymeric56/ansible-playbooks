      * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * This file contains the generated language structure(s) for
      *  request JSON schema
      *  'archivedContactsCloudant.create_request.json'.
      * This structure was generated using 'DFHJS2LS' at mapping level
      *  '5.0'.
      * 
      *  
      *   01 BAQBASE-API00Q01.
      *     03 requestBody.
      * 
      *  
      * JSON schema keyword 'requestBody->lastName' is optional. The
      *  existence of the field is indicated by field
      *  'lastName-existence'.
      *       06 lastName-existence            PIC S9(9) COMP-5 SYNC.
      * 
      *  
      *       06 lastName.
      * 
      * Comments for field 'lastName2':
      * This field represents the value of JSON schema keyword
      *  'requestBody->lastName'.
      * JSON schema type: 'string'.
      * This field contains a varying length array of characters or
      *  binary data.
      *         09 lastName2-length              PIC S9999 COMP-5 SYNC.
      *         09 lastName2                     PIC X(255).
      * 
      *  
      * JSON schema keyword 'requestBody->firstName' is optional. The
      *  existence of the field is indicated by field
      *  'firstName-existence'.
      *       06 firstName-existence           PIC S9(9) COMP-5 SYNC.
      * 
      *  
      *       06 firstName.
      * 
      * Comments for field 'firstName2':
      * This field represents the value of JSON schema keyword
      *  'requestBody->firstName'.
      * JSON schema type: 'string'.
      * This field contains a varying length array of characters or
      *  binary data.
      *         09 firstName2-length             PIC S9999 COMP-5 SYNC.
      *         09 firstName2                    PIC X(255).
      * 
      *  
      * JSON schema keyword 'requestBody->telExtension' is optional.
      *  The existence of the field is indicated by field
      *  'telExtension-existence'.
      *       06 telExtension-existence        PIC S9(9) COMP-5 SYNC.
      * 
      *  
      *       06 telExtension.
      * 
      * Comments for field 'telExtension2':
      * This field represents the value of JSON schema keyword
      *  'requestBody->telExtension'.
      * JSON schema type: 'string'.
      * This field contains a varying length array of characters or
      *  binary data.
      *         09 telExtension2-length          PIC S9999 COMP-5 SYNC.
      *         09 telExtension2                 PIC X(255).
      * 
      *  
      * JSON schema keyword 'requestBody->zipCode' is optional. The
      *  existence of the field is indicated by field
      *  'zipCode-existence'.
      *       06 zipCode-existence             PIC S9(9) COMP-5 SYNC.
      * 
      *  
      *       06 zipCode.
      * 
      * Comments for field 'zipCode2':
      * This field represents the value of JSON schema keyword
      *  'requestBody->zipCode'.
      * JSON schema type: 'string'.
      * This field contains a varying length array of characters or
      *  binary data.
      *         09 zipCode2-length               PIC S9999 COMP-5 SYNC.
      *         09 zipCode2                      PIC X(255).
      * 
      *  
      * JSON schema keyword 'requestBody->loopbackcontactsarchived' is
      *  optional. The existence of the field is indicated by field
      *  'loopbackcontacts-existence'.
      *       06 loopbackcontacts-existence    PIC S9(9) COMP-5 SYNC.
      * 
      *  
      *       06 loopbackcontactsarchived.
      * 
      * Comments for field 'loopbackcontactsarchived2':
      * This field represents the value of JSON schema keyword
      *  'requestBody->loopbackcontactsarchived'.
      * JSON schema type: 'string'.
      * This field contains a varying length array of characters or
      *  binary data.
      *         09 loopbackcontactsarch-length   PIC S9999 COMP-5 SYNC.
      *         09 loopbackcontactsarchived2     PIC X(255).
      * 
      *  
      * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
          01 BAQBASE-API00Q01.
            03 requestBody.
 
              06 lastName-existence            PIC S9(9) COMP-5 SYNC.
 
              06 lastName.
                09 lastName2-length              PIC S9999 COMP-5 SYNC.
                09 lastName2                     PIC X(255).
 
              06 firstName-existence           PIC S9(9) COMP-5 SYNC.
 
              06 firstName.
                09 firstName2-length             PIC S9999 COMP-5 SYNC.
                09 firstName2                    PIC X(255).
 
              06 telExtension-existence        PIC S9(9) COMP-5 SYNC.
 
              06 telExtension.
                09 telExtension2-length          PIC S9999 COMP-5 SYNC.
                09 telExtension2                 PIC X(255).
 
              06 zipCode-existence             PIC S9(9) COMP-5 SYNC.
 
              06 zipCode.
                09 zipCode2-length               PIC S9999 COMP-5 SYNC.
                09 zipCode2                      PIC X(255).
 
              06 loopbackcontacts-existence    PIC S9(9) COMP-5 SYNC.
 
              06 loopbackcontactsarchived.
                09 loopbackcontactsarch-length   PIC S9999 COMP-5 SYNC.
                09 loopbackcontactsarchived2     PIC X(255).
 
