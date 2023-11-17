      * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * This file contains the generated language structure(s) for
      *  request JSON schema 'get Status Server_request.json'.
      * This structure was generated using 'DFHJS2LS' at mapping level
      *  '5.0'.
      * 
      *  
      *   01 BAQBASE-NOD00Q01.
      *     03 requestCookies.
      * 
      * Comments for field 'darvaCookie':
      * This field represents the value of JSON schema keyword
      *  'requestCookies->darvaCookie'.
      * JSON schema type: 'string'.
      * JSON schema keyword 'minLength' value: '0'.
      * JSON schema keyword 'maxLength' value: '255'.
      * This field contains a varying length array of characters or
      *  binary data.
      *       06 darvaCookie-length            PIC S9999 COMP-5 SYNC.
      *       06 darvaCookie                   PIC X(255).
      * 
      *  
      * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
          01 BAQBASE-NOD00Q01.
            03 requestCookies.
              06 darvaCookie-length            PIC S9999 COMP-5 SYNC.
              06 darvaCookie                   PIC X(255).
 
