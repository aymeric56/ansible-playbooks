      * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * This file contains the generated language structure(s) for
      *  response JSON schema 'archivedContacts.create_response.json'.
      * This structure was generated using 'DFHJS2LS' at mapping level
      *  '5.0'.
      *
      *
      *   01 BAQBASE-API00P01.
      *
      *
      * Data area 'responseCode200-dataarea' contains 0 or 1 instances
      *  of structure 'API00P01-responseCode200', each of which
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
      *  01 API00P01-responseCode200.
      *    03 responseCode200.
      *
      *
      * JSON schema keyword 'responseCode200->lastName' is optional.
      *  The existence of the field is indicated by field
      *  'lastName-existence'.
      *      06 lastName-existence            PIC S9(9) COMP-5 SYNC.
      *
      *
      *      06 lastName.
      *
      * Comments for field 'lastName2':
      * This field represents the value of JSON schema keyword
      *  'responseCode200->lastName'.
      * JSON schema type: 'string'.
      * This field contains a varying length array of characters or
      *  binary data.
      *        09 lastName2-length              PIC S9999 COMP-5 SYNC.
      *        09 lastName2                     PIC X(255).
      *
      *
      * JSON schema keyword 'responseCode200->firstName' is optional.
      *  The existence of the field is indicated by field
      *  'firstName-existence'.
      *      06 firstName-existence           PIC S9(9) COMP-5 SYNC.
      *
      *
      *      06 firstName.
      *
      * Comments for field 'firstName2':
      * This field represents the value of JSON schema keyword
      *  'responseCode200->firstName'.
      * JSON schema type: 'string'.
      * This field contains a varying length array of characters or
      *  binary data.
      *        09 firstName2-length             PIC S9999 COMP-5 SYNC.
      *        09 firstName2                    PIC X(255).
      *
      *
      * JSON schema keyword 'responseCode200->telExtension' is
      *  optional. The existence of the field is indicated by field
      *  'telExtension-existence'.
      *      06 telExtension-existence        PIC S9(9) COMP-5 SYNC.
      *
      *
      *      06 telExtension.
      *
      * Comments for field 'telExtension2':
      * This field represents the value of JSON schema keyword
      *  'responseCode200->telExtension'.
      * JSON schema type: 'string'.
      * This field contains a varying length array of characters or
      *  binary data.
      *        09 telExtension2-length          PIC S9999 COMP-5 SYNC.
      *        09 telExtension2                 PIC X(255).
      *
      *
      * JSON schema keyword 'responseCode200->zipCode' is optional.
      *  The existence of the field is indicated by field
      *  'zipCode-existence'.
      *      06 zipCode-existence             PIC S9(9) COMP-5 SYNC.
      *
      *
      *      06 zipCode.
      *
      * Comments for field 'zipCode2':
      * This field represents the value of JSON schema keyword
      *  'responseCode200->zipCode'.
      * JSON schema type: 'string'.
      * This field contains a varying length array of characters or
      *  binary data.
      *        09 zipCode2-length               PIC S9999 COMP-5 SYNC.
      *        09 zipCode2                      PIC X(255).
      *
      *
      * JSON schema keyword 'responseCode200->id' is optional. The
      *  existence of the field is indicated by field 'Xid-existence'.
      *      06 Xid-existence                 PIC S9(9) COMP-5 SYNC.
      *
      *
      *      06 Xid.
      *
      * Comments for field 'Xid2':
      * This field represents the value of JSON schema keyword
      *  'responseCode200->id'.
      * JSON schema type: 'string'.
      * This field contains a varying length array of characters or
      *  binary data.
      *        09 Xid2-length                   PIC S9999 COMP-5 SYNC.
      *        09 Xid2                          PIC X(255).
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

            03 responseCode200-existence     PIC S9(9) COMP-5 SYNC.
            03 responseCode200-dataarea      PIC X(16).


         01 API00P01-responseCode200.
           03 responseCode200.

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

             06 Xid-existence                 PIC S9(9) COMP-5 SYNC.

             06 Xid.
               09 Xid2-length                   PIC S9999 COMP-5 SYNC.
               09 Xid2                          PIC X(255).
             06 filler                        PIC X(3).
