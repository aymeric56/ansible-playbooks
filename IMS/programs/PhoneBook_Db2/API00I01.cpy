      * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * This file contains the generated API information structure
      * which is passed to the Host API via the BAQEXEC call.
      * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         01 BAQ-API-INFO-API00I01.
           03 BAQ-API-INFO-EYE            PIC X(4)
              VALUE 'BAQA'.
           03 BAQ-API-INFO-LENGTH         PIC 9(9) COMP-5 SYNC
              VALUE 1052.
           03 BAQ-API-INFO-VERSION        PIC 9(9) COMP-5 SYNC
              VALUE 1.
           03 BAQ-API-INFO-RESERVED01     PIC 9(9) COMP-5 SYNC
              VALUE 0.
           03 BAQ-API-NAME                PIC X(255)
              VALUE 'archivedContacts_OpenAPI3_v1.0'.
           03 BAQ-API-NAME-LEN            PIC 9(9) COMP-5 SYNC
              VALUE 30.
           03 BAQ-API-PATH                PIC X(255)
              VALUE '%2FarchivedContacts'.
           03 BAQ-API-PATH-LEN            PIC 9(9) COMP-5 SYNC
              VALUE 19.
           03 BAQ-API-METHOD              PIC X(255)
              VALUE 'POST'.
           03 BAQ-API-METHOD-LEN          PIC 9(9) COMP-5 SYNC
              VALUE 4.
           03 BAQ-API-OPERATION           PIC X(255)
              VALUE 'archivedContacts.create'.
           03 BAQ-API-OPERATION-LEN       PIC 9(9) COMP-5 SYNC
              VALUE 23.