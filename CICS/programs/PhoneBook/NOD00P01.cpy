      * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * This file contains the generated language structure(s) for
      *  response JSON schema 'get Status Server_response.json'.
      * This structure was generated using 'DFHJS2LS' at mapping level
      *  '5.0'.
      * 
      *  
      *   01 BAQBASE-NOD00P01.
      *     03 responseHeaders.
      * 
      *  
      * JSON schema keyword 'responseHeaders->set-cookie' is optional.
      *  The existence of the field is indicated by field
      *  'set-cookie-existence'.
      *       06 set-cookie-existence          PIC S9(9) COMP-5 SYNC.
      * 
      *  
      *       06 set-cookie.
      * 
      * Comments for field 'set-cookie2':
      * This field represents the value of JSON schema keyword
      *  'responseHeaders->set-cookie'.
      * JSON schema type: 'string'.
      * This field contains a varying length array of characters or
      *  binary data.
      *         09 set-cookie2-length            PIC S9999 COMP-5 SYNC.
      *         09 set-cookie2                   PIC X(255).
      * 
      *  
      * Data area 'responseCode200-dataarea' contains 0 or 1 instances
      *  of structure 'NOD00P01-responseCode200', each of which
      *  represents an instance of JSON schema keyword
      *  'responseCode200'. The Data area must be read from and
      *  written to in BIT mode.
      *     03 responseCode200-existence     PIC S9(9) COMP-5 SYNC.
      *     03 responseCode200-dataarea      PIC X(16).
      * 
      *  
      *  
      * This structure describes one instance of the data in Data Area
      *  'responseCode200-dataarea'.
      *  01 NOD00P01-responseCode200.
      *    03 responseCode200.
      * 
      *  
      * JSON schema keyword 'responseCode200->Status' is optional. The
      *  existence of the field is indicated by field
      *  'XStatus-existence'.
      *      06 XStatus-existence             PIC S9(9) COMP-5 SYNC.
      * 
      *  
      *      06 XStatus.
      * 
      * Comments for field 'XStatus2':
      * This field represents the value of JSON schema keyword
      *  'responseCode200->Status'.
      * JSON schema type: 'string'.
      * This field contains a varying length array of characters or
      *  binary data.
      *        09 XStatus2-length               PIC S9999 COMP-5 SYNC.
      *        09 XStatus2                      PIC X(255).
      * 
      *  
      * JSON schema keyword 'responseCode200->Date' is optional. The
      *  existence of the field is indicated by field
      *  'XDate-existence'.
      *      06 XDate-existence               PIC S9(9) COMP-5 SYNC.
      * 
      *  
      *      06 XDate.
      * 
      * Comments for field 'XDate2':
      * This field represents the value of JSON schema keyword
      *  'responseCode200->Date'.
      * JSON schema type: 'string'.
      * JSON schema keyword 'format' value: 'date-time'.
      * This field contains a varying length array of characters or
      *  binary data.
      *        09 XDate2-length                 PIC S9999 COMP-5 SYNC.
      *        09 XDate2                        PIC X(40).
      * 
      * Comments for field 'filler':
      * This is a filler entry to ensure the correct padding for a
      *  structure. These slack bytes do not contain any application
      *  data.
      *      06 filler                        PIC X(2).
      * 
      *  
      * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
          01 BAQBASE-NOD00P01.
            03 responseHeaders.
 
              06 set-cookie-existence          PIC S9(9) COMP-5 SYNC.
 
              06 set-cookie.
                09 set-cookie2-length            PIC S9999 COMP-5 SYNC.
                09 set-cookie2                   PIC X(255).
 
            03 responseCode200-existence     PIC S9(9) COMP-5 SYNC.
            03 responseCode200-dataarea      PIC X(16).
 
 
         01 NOD00P01-responseCode200.
           03 responseCode200.
 
             06 XStatus-existence             PIC S9(9) COMP-5 SYNC.
 
             06 XStatus.
               09 XStatus2-length               PIC S9999 COMP-5 SYNC.
               09 XStatus2                      PIC X(255).
 
             06 XDate-existence               PIC S9(9) COMP-5 SYNC.
 
             06 XDate.
               09 XDate2-length                 PIC S9999 COMP-5 SYNC.
               09 XDate2                        PIC X(40).
             06 filler                        PIC X(2).
 
