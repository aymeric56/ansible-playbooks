      * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * This file contains the generated language structure(s) for
      *  request JSON schema 'get Second Appel_request.json'.
      * This structure was generated using 'DFHJS2LS' at mapping level
      *  '5.0'.
      * 
      *  
      *   01 BAQBASE-NOD01Q01.
      *     03 requestCookies.
      * 
      * Comments for field 'CookTest':
      * This field represents the value of JSON schema keyword
      *  'requestCookies->CookTest'.
      * JSON schema type: 'string'.
      * JSON schema keyword 'minLength' value: '0'.
      * JSON schema keyword 'maxLength' value: '300'.
      * This field contains a varying length array of characters or
      *  binary data.
      *       06 CookTest-length               PIC S9999 COMP-5 SYNC.
      *       06 CookTest                      PIC X(300).
      * 
      * Comments for field 'CookTestPlus':
      * This field represents the value of JSON schema keyword
      *  'requestCookies->CookTestPlus'.
      * JSON schema type: 'string'.
      * JSON schema keyword 'minLength' value: '0'.
      * JSON schema keyword 'maxLength' value: '300'.
      * This field contains a varying length array of characters or
      *  binary data.
      *       06 CookTestPlus-length           PIC S9999 COMP-5 SYNC.
      *       06 CookTestPlus                  PIC X(300).
      * 
      *  
      * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
          01 BAQBASE-NOD01Q01.
            03 requestCookies.
              06 CookTest-length               PIC S9999 COMP-5 SYNC.
              06 CookTest                      PIC X(300).
              06 CookTestPlus-length           PIC S9999 COMP-5 SYNC.
              06 CookTestPlus                  PIC X(300).
 
