      *****************************************************************
      *
      *
      * Licensed Materials - Property of IBM
      *
      * Restricted Materials of IBM
      *
      * 5655-CE3
      *
      * (C) Copyright IBM Corp. 2017, 2021
      *
      * US Government Users Restricted Rights - Use, duplication or
      * disclosure restricted by GSA ADP Schedule Contract with
      * IBM Corp.
      *****************************************************************
      * This file contains the generated language structure(s) for    *
      * Request and Response Info                                     *
      *****************************************************************
      *
      * BAQ-REQUEST-INFO-COMP-LEVEL permitted values
      *    VALUE
      *      0    Base support
      *      1    Added support for BAQ-OAUTH
      *      2    Added support for BAQ-TOKEN (JWT)
      *      3    Added support for setting z/OS Connect EE server URI
      *      4    Added support for BAQ-OAUTH-EXT
      *****************************************************************
       01  BAQ-REQUEST-INFO.
         03 BAQ-REQUEST-INFO-COMP-LEVEL  PIC S9(9) COMP-5 SYNC VALUE 4.
         03 BAQ-REQUEST-INFO-USER.
            05 BAQ-OAUTH.
               07 BAQ-OAUTH-USERNAME           PIC X(256).
               07 BAQ-OAUTH-USERNAME-LEN       PIC S9(9) COMP-5 SYNC
                                                 VALUE 0.
               07 BAQ-OAUTH-PASSWORD           PIC X(256).
               07 BAQ-OAUTH-PASSWORD-LEN       PIC S9(9) COMP-5 SYNC
                                                 VALUE 0.
               07 BAQ-OAUTH-CLIENTID           PIC X(256).
               07 BAQ-OAUTH-CLIENTID-LEN       PIC S9(9) COMP-5 SYNC
                                                 VALUE 0.
               07 BAQ-OAUTH-CLIENT-SECRET      PIC X(256).
               07 BAQ-OAUTH-CLIENT-SECRET-LEN  PIC S9(9) COMP-5 SYNC
                                                 VALUE 0.
               07 BAQ-OAUTH-SCOPE-PTR          USAGE POINTER.
               07 BAQ-OAUTH-SCOPE-LEN          PIC S9(9) COMP-5 SYNC
                                                 VALUE 0.
            05 BAQ-AUTHTOKEN.
               07 BAQ-TOKEN-USERNAME           PIC X(256).
               07 BAQ-TOKEN-USERNAME-LEN       PIC S9(9) COMP-5 SYNC
                                                 VALUE 0.
               07 BAQ-TOKEN-PASSWORD           PIC X(256).
               07 BAQ-TOKEN-PASSWORD-LEN       PIC S9(9) COMP-5 SYNC
                                                 VALUE 0.
            05 BAQ-ZCON-SERVER-URI             PIC X(256)
                                                 VALUE SPACES.
            05 BAQ-OAUTH-EXT.
               07 BAQ-OAUTH-RESOURCE-PTR       USAGE POINTER.
               07 BAQ-OAUTH-RESOURCE-LEN       PIC S9(9) COMP-5 SYNC
                                                 VALUE 0.
               07 BAQ-OAUTH-AUDIENCE-PTR       USAGE POINTER.
               07 BAQ-OAUTH-AUDIENCE-LEN       PIC S9(9) COMP-5 SYNC
                                                 VALUE 0.
               07 BAQ-OAUTH-CUSTOM-PARMS-PTR   USAGE POINTER.
               07 BAQ-OAUTH-CUSTOM-PARMS-LEN   PIC S9(9) COMP-5 SYNC
                                                 VALUE 0.

       01  BAQ-RESPONSE-INFO.
         03 BAQ-RESPONSE-INFO-COMP-LEVEL PIC S9(9) COMP-5 SYNC VALUE 0.
         03 BAQ-STUB-NAME                PIC X(8).
         03 BAQ-RETURN-CODE              PIC S9(9) COMP-5 SYNC.
            88 BAQ-SUCCESS                 VALUE 0.
            88 BAQ-ERROR-IN-API            VALUE 1.
            88 BAQ-ERROR-IN-ZCEE           VALUE 2.
            88 BAQ-ERROR-IN-STUB           VALUE 3.
            88 BAQ-ERROR-NO-RESPONSE       VALUE 4.
         03 BAQ-STATUS-CODE              PIC S9(9) COMP-5 SYNC.
         03 BAQ-STATUS-MESSAGE           PIC X(1024).
         03 BAQ-STATUS-MESSAGE-LEN       PIC S9(9) COMP-5 SYNC.
