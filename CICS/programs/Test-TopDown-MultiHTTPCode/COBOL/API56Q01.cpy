      * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * This file contains the generated language structure(s) for
      *  request JSON schema 'getCallSimple.read_request.json'.
      * This structure was generated using 'DFHJS2LS' at mapping level
      *  '5.0'.
      * 
      *  
      *   01 BAQBASE-API00Q01.
      *     03 requestQueryParameters.
      * 
      * Comments for field 'codeReponse':
      * This field represents the value of JSON schema keyword
      *  'requestQueryParameters->codeReponse'.
      * JSON schema type: 'string'.
      * JSON schema keyword 'minLength' value: '0'.
      * JSON schema keyword 'maxLength' value: '10'.
      * This field contains a varying length array of characters or
      *  binary data.
      *       06 codeReponse-length            PIC S9999 COMP-5 SYNC.
      *       06 codeReponse                   PIC X(10).
      * 
      * Comments for field 'lastName':
      * This field represents the value of JSON schema keyword
      *  'requestQueryParameters->lastName'.
      * JSON schema type: 'string'.
      * JSON schema keyword 'minLength' value: '0'.
      * JSON schema keyword 'maxLength' value: '10'.
      * This field contains a varying length array of characters or
      *  binary data.
      *       06 lastName-length               PIC S9999 COMP-5 SYNC.
      *       06 lastName                      PIC X(10).
      * 
      *  
      * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
          01 BAQBASE-API00Q01.
            03 requestQueryParameters.
              06 codeReponse-length            PIC S9999 COMP-5 SYNC.
              06 codeReponse                   PIC X(3).
              06 lastName-length               PIC S9999 COMP-5 SYNC.
              06 lastName                      PIC X(10).
 
