      * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * This file contains the generated language structure(s) for
      *  response JSON schema
      *  'archivedContactsCloudant.create_response.json'.
      * This structure was generated using 'DFHJS2LS' at mapping level
      *  '5.0'.
      * 
      *  
      *   01 BAQBASE-API00P01.
      * 
      *  
      * Data area 'responseCode201-dataarea' contains 0 or 1 instances
      *  of structure 'API00P01-responseCode201', each of which
      *  represents an instance of JSON schema keyword
      *  'responseCode201'. The Data area must be read from and
      *  written to in BIT mode.
      *     03 responseCode201-existence     PIC S9(9) COMP-5 SYNC.
      *     03 responseCode201-dataarea      PIC X(16).
      * 
      *  
      *  
      * This structure describes one instance of the data in Data Area
      *  'responseCode201-dataarea'.
      *  01 API00P01-responseCode201.
      *    03 responseCode201.
      * 
      *  
      * JSON schema keyword 'responseCode201->ok' is optional. The
      *  existence of the field is indicated by field 'ok-existence'.
      *      06 ok-existence                  PIC S9(9) COMP-5 SYNC.
      * 
      *  
      * Comments for field 'ok':
      * This field represents the value of JSON schema keyword
      *  'responseCode201->ok'.
      * JSON schema type: 'boolean'.
      * The value x'00' implies false, x'01' implies true.
      *      06 ok                            PIC X DISPLAY.
      * 
      *  
      * JSON schema keyword 'responseCode201->id' is optional. The
      *  existence of the field is indicated by field 'Xid-existence'.
      *      06 Xid-existence                 PIC S9(9) COMP-5 SYNC.
      * 
      *  
      *      06 Xid.
      * 
      * Comments for field 'Xid2':
      * This field represents the value of JSON schema keyword
      *  'responseCode201->id'.
      * JSON schema type: 'string'.
      * This field contains a varying length array of characters or
      *  binary data.
      *        09 Xid2-length                   PIC S9999 COMP-5 SYNC.
      *        09 Xid2                          PIC X(255).
      * 
      *  
      * JSON schema keyword 'responseCode201->rev' is optional. The
      *  existence of the field is indicated by field 'rev-existence'.
      *      06 rev-existence                 PIC S9(9) COMP-5 SYNC.
      * 
      *  
      *      06 rev.
      * 
      * Comments for field 'rev2':
      * This field represents the value of JSON schema keyword
      *  'responseCode201->rev'.
      * JSON schema type: 'string'.
      * This field contains a varying length array of characters or
      *  binary data.
      *        09 rev2-length                   PIC S9999 COMP-5 SYNC.
      *        09 rev2                          PIC X(255).
      * 
      * Comments for field 'filler':
      * This is a filler entry to ensure the correct padding for a
      *  structure. These slack bytes do not contain any application
      *  data.
      *      06 filler                        PIC X(3).
      * 
      *  
      * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
          01 BAQBASE-API00P01.
 
            03 responseCode201-existence     PIC S9(9) COMP-5 SYNC.
            03 responseCode201-dataarea      PIC X(16).
 
 
         01 API00P01-responseCode201.
           03 responseCode201.
 
             06 ok-existence                  PIC S9(9) COMP-5 SYNC.
 
             06 ok                            PIC X DISPLAY.
 
             06 Xid-existence                 PIC S9(9) COMP-5 SYNC.
 
             06 Xid.
               09 Xid2-length                   PIC S9999 COMP-5 SYNC.
               09 Xid2                          PIC X(255).
 
             06 rev-existence                 PIC S9(9) COMP-5 SYNC.
 
             06 rev.
               09 rev2-length                   PIC S9999 COMP-5 SYNC.
               09 rev2                          PIC X(255).
             06 filler                        PIC X(3).
 
