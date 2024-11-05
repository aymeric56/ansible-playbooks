       CBL LIST,MAP,XREF,FLAG(I)
       IDENTIFICATION DIVISION.
       PROGRAM-ID. IVTNIMS.

      ******************************************************************

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      ******************************************************************
      *CONSTANTS
      ******************************************************************
      * RS.NEXT FAILED TO GET A ROW
       77  INVCMD         PIC  X(25) VALUE "PROCESS CODE IS NOT VALID".
       77  MOREINPUT      PIC  X(38)
                 VALUE "DATA IS NOT ENOUGH. PLEASE KEY IN MORE".
       77  NOINPUT        PIC  X(37)
                 VALUE "NO DATA WAS INPUT. PLEASE KEY IN MORE".
       77  NOLAST         PIC  X(27)
                 VALUE "LAST NAME WAS NOT SPECIFIED".
       77  DELETED        PIC  X(17) VALUE "ENTRY WAS DELETED".
       77  DELETED-AR     PIC  X(30)
                 VALUE "ENTRY WAS DELETED AND ARCHIVED".
       77  ADDED          PIC  X(15) VALUE "ENTRY WAS ADDED".
       77  CONVENDED      PIC  X(22) VALUE "NCNVERSATION HAS ENDED".
       77  DISPLAYED      PIC  X(19) VALUE "ENTRY WAS DISPLAYED".
       77  DISPLAYED-MULT PIC  X(22) VALUE "ENTRIES WERE DISPLAYED".
       77  DISPLAYED-NONE PIC  X(16) VALUE "NO ENTRIES FOUND".
       77  UPDATED        PIC  X(17) VALUE "ENTRY WAS UPDATED".

       77  DISPLAY-FAILED PIC  X(30)
                 VALUE "SPECIFIED PERSON WAS NOT FOUND".
       77  ADD-FAILED     PIC  X(28)
                 VALUE "ADDITION OF ENTRY HAS FAILED".
       77  DELETE-FAILED  PIC  X(28)
                 VALUE "DELETION OF ENTRY HAS FAILED".
       77  UPDATE-FAILED  PIC  X(26)
                 VALUE "UPDATE OF ENTRY HAS FAILED".

      * MESSAGE PROCESSING
       77  VALID-INPUT         PIC 9 VALUE 0.
       77  TERM-IO             PIC 9 VALUE 0.
       77  TERM-LOOP           PIC 9 VALUE 0.
       77  MESSAGE-EXIST       PIC X(2) VALUE 'CF'.
       77  NO-MORE-MESSAGE     PIC X(2) VALUE 'QC'.

      ******************************************************************
      *DATABASE CALL CODES
      ******************************************************************

       77  GU                  PIC  X(04)        VALUE "GU  ".
       77  GHU                 PIC  X(04)        VALUE "GHU ".
       77  GN                  PIC  X(04)        VALUE "GN  ".
       77  GHN                 PIC  X(04)        VALUE "GHN ".
       77  ISRT                PIC  X(04)        VALUE "ISRT".
       77  DLET                PIC  X(04)        VALUE "DLET".
       77  REPL                PIC  X(04)        VALUE "REPL".
       77  NEXT-CALL           PIC  X(04)        VALUE "    ".

      ******************************************************************
      *IMS STATUS CODES
      ******************************************************************

       77  GE                  PIC  X(02)        VALUE "GE".
       77  GB                  PIC  X(02)        VALUE "GB".
       77  II                  PIC  X(02)        VALUE "II".

      ******************************************************************
      *ERROR STATUS CODE AREA
      ******************************************************************

       01  BAD-STATUS.
           05  SC-MSG  PIC X(30) VALUE "BAD STATUS CODE WAS RECEIVED: ".
           05  SC             PIC X(2).

      ******************************************************************
      *SEGMENT AREAS
      ******************************************************************
       01  PHONEBOOK-SEG.
           05  LAST-NAME      PIC  X(10).
           05  FIRST-NAME     PIC  X(10).
           05  EXTENSION      PIC  X(10).
           05  ZIP-CODE       PIC  X(7).
           05  FILLER         PIC  X(3).

      ******************************************************************
      *INPUT/OUTPUT MESSAGE AREA
      ******************************************************************

       COPY IVTNIMSC.

      ******************************************************************
      *SEGMENT SEARCH ARGUMENTS
      ******************************************************************

       01  PHONEBOOK-SSA.
           05  FILLER          PIC  X(08)        VALUE "A1111111".
           05  FILLER          PIC  X(01)        VALUE ' '.

       01  PHONEBOOK-SSA1.
           05  FILLER          PIC  X(08)        VALUE "A1111111".
           05  FILLER          PIC  X(01)        VALUE "(".
           05  FILLER          PIC  X(08)        VALUE "LASTNAME".
           05  FILLER          PIC  X(02)        VALUE "= ".
           05  LAST-NAME-SSA1  PIC  X(10)        VALUE SPACES.
           05  FILLER          PIC  X(01)        VALUE ")".
           05  FILLER          PIC  X(01)        VALUE ' '.

       01  PHONEBOOK-SSA2.
           05  FILLER          PIC  X(08)        VALUE "A1111111".
           05  FILLER          PIC  X(04)        VALUE "*AG(".
           05  FILLER          PIC  X(08)        VALUE "LASTNAME".
           05  FILLER          PIC  X(02)        VALUE "GT".
           05  LAST-NAME-SSA2  PIC  X(10)        VALUE SPACES.
           05  FILLER          PIC  X(01)        VALUE ")".
           05  FILLER          PIC  X(01)        VALUE ' '.

       01  PHONEBOOK-SSA3.
           05  FILLER          PIC  X(08)        VALUE "A1111111".
           05  FILLER          PIC  X(02)        VALUE "*G".
           05  FILLER          PIC  X(01)        VALUE ' '.

      * Structure for API request
       01  REQUEST.
          COPY ARC00Q01.

      * Structure for API response
       01  RESPONSE.
          COPY ARC00P01.

      * Structure with API information
       01  API-INFO-OPER0.
          COPY ARC00I01.

      * API Requester BAQRINFO copybook
       COPY BAQRINFO.

      * Request and Response segment, used to store request and
      * response content.
       01 BAQ-REQUEST-PTR             USAGE POINTER.
       01 BAQ-REQUEST-LEN             PIC S9(9) COMP-5 SYNC.
       01 BAQ-RESPONSE-PTR            USAGE POINTER.
       01 BAQ-RESPONSE-LEN            PIC S9(9) COMP-5 SYNC.
       77 COMM-STUB-PGM-NAME          PIC X(8) VALUE 'BAQCSTUB'.
       77 COMM-TERM-PGM-NAME          PIC X(8) VALUE 'BAQCTERM'.

       LINKAGE SECTION.

       01  IOPCBA POINTER.
       01  ALTPCBA POINTER.
       01  DBPCB1 POINTER.

      ******************************************************************
      *I/O PCB
      ******************************************************************

       01  LTERMPCB.
           05  LOGTTERM        PIC  X(08).
           05  FILLER          PIC  X(02).
           05  TPSTAT          PIC  X(02).
           05  IODATE          PIC  X(04).
           05  IOTIME          PIC  X(04).
           05  FILLER          PIC  X(02).
           05  SEQNUM          PIC  X(02).
           05  MOD             PIC  X(08).

      ******************************************************************
      *ALTPCB
      ******************************************************************

       01  ALTPCB.
           05  LOGTTERM1        PIC  X(08).
           05  FILLER1          PIC  X(02).
           05  TPSTAT1          PIC  X(02).
           05  IODATE1          PIC  X(04).
           05  IOTIME1          PIC  X(04).
           05  FILLER1          PIC  X(02).
           05  SEQNUM1          PIC  X(02).
           05  MOD1             PIC  X(08).

      ******************************************************************
      *DATABASE PCB
      ******************************************************************

       01  DBPCB.
           05  DBDNAME         PIC  X(08).
           05  SEGLEVEL        PIC  X(02).
           05  DBSTAT          PIC  X(02).
           05  PROCOPTS        PIC  X(04).
           05  FILLER          PIC  9(08) COMP.
           05  SEGNAMFB        PIC  X(08).
           05  LENKEY          PIC  9(08) COMP.
           05  SENSSSEGS       PIC  9(08) COMP.
           05  KEYFB           PIC  X(20).
           05  FILLER REDEFINES KEYFB.
               07  KEYFB1      PIC  X(9).
               07  FILLER      PIC  X(11).

       PROCEDURE DIVISION.
             ENTRY "DLITCBL"
             USING  IOPCBA, ALTPCBA, DBPCB1.

       BEGIN.
      *    DISPLAY 'IOPCBA: ' IOPCBA.
      *    DISPLAY 'ALTPCBA: ' ALTPCBA.
      *    DISPLAY 'DBPCB1: ' DBPCB1.

           SET ADDRESS OF LTERMPCB TO ADDRESS OF IOPCBA.
           SET ADDRESS OF DBPCB TO ADDRESS OF DBPCB1.

           MOVE 0 TO TERM-IO.

           PERFORM WITH TEST BEFORE UNTIL TERM-IO = 1
             MOVE ZEROS TO IVTNO-INPUT-MSG
             CALL 'CBLTDLI' USING GU, LTERMPCB, IVTNO-INPUT-MSG
             IF TPSTAT  = '  ' OR TPSTAT = MESSAGE-EXIST
             THEN
      *         DISPLAY 'Après IOPCB'
               PERFORM VALIDATE-INPUT THRU VALIDATE-INPUT-END

      * INPUT WAS VALID, CONTINUE
               IF VALID-INPUT = 0
               THEN
                 EVALUATE IN-COMMAND
                   WHEN 'ADD     '
                     MOVE SPACES TO IVTNO-OUTPUT-MSG
                     PERFORM ADD-CONTACT-ENTRY
                       THRU ADD-CONTACT-ENTRY-END
                   WHEN 'DIS     '
                   WHEN 'DISPLAY '
                     MOVE SPACES TO IVTNO-OUTPUT-MSG
                     PERFORM DISPLAY-CONTACT-ENTRY
                       THRU DISPLAY-CONTACT-ENTRY-END
                   WHEN 'UPDATE  '
                   WHEN 'UPD     '
                     MOVE SPACES TO IVTNO-OUTPUT-MSG
                     PERFORM UPDATE-CONTACT-ENTRY
                       THRU UPDATE-CONTACT-ENTRY-END
                   WHEN 'DELETE  '
                   WHEN 'DEL     '
                     MOVE SPACES TO IVTNO-OUTPUT-MSG
                     PERFORM DELETE-CONTACT-ENTRY
                       THRU DELETE-CONTACT-ENTRY-END
                   WHEN 'SHOW50  '
                     MOVE SPACES TO IVTNO-OUTPUT-MSG-50
                     PERFORM SHOW50-CONTACTS
                       THRU SHOW50-CONTACTS-END
                   WHEN OTHER
                     DISPLAY 'INVALID COMMAND RECIEVED ' IN-COMMAND
                 END-EVALUATE
               END-IF

             ELSE
               IF TPSTAT = NO-MORE-MESSAGE
               THEN
                 MOVE 1 TO TERM-IO
               ELSE
                 DISPLAY 'GU FROM IOPCB FAILED WITH STATUS CODE: '
                   TPSTAT
               END-IF
             END-IF
           END-PERFORM.
             STOP RUN.

      * PROCEDURE TO UPDATE PHONEBOOK ENTRY
       UPDATE-CONTACT-ENTRY.
           MOVE IN-LAST-NAME TO LAST-NAME-SSA1.
           CALL "CBLTDLI"
             USING GHU, DBPCB, PHONEBOOK-SEG, PHONEBOOK-SSA1.
           IF DBSTAT = SPACES
           THEN
             MOVE IN-FIRST-NAME TO FIRST-NAME
             MOVE IN-EXTENSION TO EXTENSION
             MOVE IN-ZIP-CODE TO ZIP-CODE

             CALL "CBLTDLI"
               USING REPL, DBPCB, PHONEBOOK-SEG
             IF DBSTAT = SPACES
             THEN
               MOVE UPDATED TO OUT-MESSAGE
               MOVE IN-COMMAND TO OUT-COMMAND
               MOVE PHONEBOOK-SEG(1:37) TO OUT-RECORD
               MOVE '0001' TO OUT-SEGMENT-NO
             ELSE
               MOVE UPDATE-FAILED TO OUT-MESSAGE
               DISPLAY 'UPDATE-CONTACT - BAD REPL STATUS CODE: '
                 DBSTAT
             END-IF
           ELSE
             MOVE UPDATE-FAILED TO OUT-MESSAGE
             IF DBSTAT NOT = GE AND DBSTAT NOT = GB
             THEN
               DISPLAY 'UPDATE-CONTACT - BAD GHU STATUS CODE: '
                 DBSTAT
             END-IF
           END-IF.

           PERFORM INSERT-IO THRU INSERT-IO-END.
       UPDATE-CONTACT-ENTRY-END.

      * PROCEDURE TO DELETE PHONEBOOK ENTRY
       DELETE-CONTACT-ENTRY.
           MOVE IN-LAST-NAME TO LAST-NAME-SSA1.
           CALL "CBLTDLI"
             USING GHU, DBPCB, PHONEBOOK-SEG, PHONEBOOK-SSA1.
           IF DBSTAT = SPACES
           THEN
             CALL "CBLTDLI"
               USING DLET, DBPCB, PHONEBOOK-SEG
             IF DBSTAT = SPACES
             THEN
               MOVE DELETED TO OUT-MESSAGE
               PERFORM ARCHIVE-CONTACT
                 THRU ARCHIVE-CONTACT-END
               MOVE IN-COMMAND TO OUT-COMMAND
               MOVE PHONEBOOK-SEG(1:37) TO OUT-RECORD
               MOVE '0001' TO OUT-SEGMENT-NO
             ELSE
               MOVE DELETE-FAILED TO OUT-MESSAGE
               DISPLAY 'DELETE-CONTACT - BAD DLET STATUS CODE: '
                 DBSTAT
             END-IF
           ELSE
             MOVE DELETE-FAILED TO OUT-MESSAGE
             IF DBSTAT NOT = GE AND DBSTAT NOT = GB
             THEN
               DISPLAY 'DELETE-CONTACT - BAD GHU STATUS CODE: '
                 DBSTAT
             END-IF
           END-IF.

           PERFORM INSERT-IO THRU INSERT-IO-END.
       DELETE-CONTACT-ENTRY-END.

      * PROCEDURE TO ARCHIVE PHONEBOOK ENTRY
       ARCHIVE-CONTACT.
      *---------------------------------------------------------------*
      * Set up the data for the API Requester call                    *
      *---------------------------------------------------------------*
            MOVE 1 TO lastName-num IN REQUEST.
            MOVE LENGTH OF LAST-NAME TO lastName2-length IN REQUEST.
            MOVE LAST-NAME TO lastName2 IN REQUEST.
            MOVE 1 TO firstName-num IN REQUEST.
            MOVE LENGTH OF FIRST-NAME TO firstName2-length IN REQUEST.
            MOVE FIRST-NAME TO firstName2 IN REQUEST.
            MOVE 1 TO telExtension-num IN REQUEST.
            MOVE LENGTH OF EXTENSION TO telExtension2-length IN REQUEST.
            MOVE EXTENSION TO telExtension2 IN REQUEST.
            MOVE 1 TO zipCode-num IN REQUEST.
            MOVE LENGTH OF ZIP-CODE TO zipCode2-length IN REQUEST.
            MOVE ZIP-CODE TO zipCode2 IN REQUEST.

      *---------------------------------------------------------------*
      * Initialize API Requester PTRs & LENs                          *
      *---------------------------------------------------------------*
      * Use pointer and length to specify the location of
      *  request and response segment.
      * This procedure is general and necessary.
            SET BAQ-REQUEST-PTR TO ADDRESS OF REQUEST.
            MOVE LENGTH OF REQUEST TO BAQ-REQUEST-LEN.
            SET BAQ-RESPONSE-PTR TO ADDRESS OF RESPONSE.
            MOVE LENGTH OF RESPONSE TO BAQ-RESPONSE-LEN.

      *---------------------------------------------------------------*
      * Call the communication stub                                   *
      *---------------------------------------------------------------*
      * Call the subsystem-supplied stub code to send
      * API request to zCEE
            CALL COMM-STUB-PGM-NAME USING
                 BY REFERENCE   API-INFO-OPER0
                 BY REFERENCE   BAQ-REQUEST-INFO
                 BY REFERENCE   BAQ-REQUEST-PTR
                 BY REFERENCE   BAQ-REQUEST-LEN
                 BY REFERENCE   BAQ-RESPONSE-INFO
                 BY REFERENCE   BAQ-RESPONSE-PTR
                 BY REFERENCE   BAQ-RESPONSE-LEN.
      * The BAQ-RETURN-CODE field in 'BAQRINFO' indicates whether this
      * API call is successful.

      * When BAQ-RETURN-CODE is 'BAQ-SUCCESS', response is
      * successfully returned and fields in RESPONSE copybook
      * can be obtained. Display the translation result.
           IF BAQ-SUCCESS THEN
              MOVE DELETED-AR TO OUT-MESSAGE

      * Otherwise, some error happened in API, z/OS Connect EE server
      * or communication stub. 'BAQ-STATUS-CODE' and
      * 'BAQ-STATUS-MESSAGE' contain the detailed information
      *  of this error.
           ELSE
              DISPLAY "Error code: " BAQ-STATUS-CODE
              DISPLAY "Error msg:" BAQ-STATUS-MESSAGE
           END-IF.

           CALL COMM-TERM-PGM-NAME USING
                 BY REFERENCE BAQ-RESPONSE-INFO.

       ARCHIVE-CONTACT-END.

      * PROCEDURE TO DISPLAY PHONEBOOK ENTRY
       DISPLAY-CONTACT-ENTRY.
      *     DISPLAY "Debut de Display avec Lastname : " IN-LAST-NAME
           MOVE IN-LAST-NAME TO LAST-NAME-SSA1.
           CALL "CBLTDLI"
             USING GU, DBPCB, PHONEBOOK-SEG, PHONEBOOK-SSA1.
           IF DBSTAT = SPACES
           THEN
             MOVE DISPLAYED TO OUT-MESSAGE
             MOVE IN-COMMAND TO OUT-COMMAND
             MOVE PHONEBOOK-SEG(1:37) TO OUT-RECORD
             MOVE '0001' TO OUT-SEGMENT-NO
           ELSE
             MOVE DISPLAY-FAILED TO OUT-MESSAGE
             IF DBSTAT NOT = GE AND DBSTAT NOT = GB
             THEN
               DISPLAY 'DISPLAY-CONTACT - BAD GU STATUS CODE: '
                  DBSTAT
             END-IF
           END-IF.
           PERFORM INSERT-IO THRU INSERT-IO-END.
       DISPLAY-CONTACT-ENTRY-END.

      * PROCEDURE TO ADD PHONEBOOK ENTRY
       ADD-CONTACT-ENTRY.
           MOVE SPACES TO PHONEBOOK-SEG.
           MOVE IN-RECORD TO PHONEBOOK-SEG.
           CALL "CBLTDLI"
             USING ISRT, DBPCB, PHONEBOOK-SEG, PHONEBOOK-SSA.
           IF DBSTAT = SPACES
           THEN
             MOVE ADDED TO OUT-MESSAGE
             MOVE IN-COMMAND TO OUT-COMMAND
             MOVE IN-LAST-NAME TO OUT-LAST-NAME
             MOVE IN-FIRST-NAME TO OUT-FIRST-NAME
             MOVE IN-EXTENSION TO OUT-EXTENSION
             MOVE IN-ZIP-CODE TO OUT-ZIP-CODE
             MOVE '0001' TO OUT-SEGMENT-NO
           ELSE
             MOVE ADD-FAILED TO OUT-MESSAGE
             IF DBSTAT NOT = II
             THEN
               DISPLAY 'ADD-CONTACT - BAD ISRT STATUS CODE: '
                 DBSTAT
             END-IF
           END-IF.
           PERFORM INSERT-IO THRU INSERT-IO-END.
       ADD-CONTACT-ENTRY-END.

      * PROCEDURE TO SHOW 50  PHONEBOOK RECORDS
      * - RETURN FIRST 50  RECORDS OF THE DATABASE IF
      *   NO IN-LAST-NAME PROVIDED
      * - RETURN NEXT 50  RECORDS OF THE DATABASE
      *   AFTER FINDING THE PROVIDED IN-LAST-NAME
      *
      * THIS ROUTINE ASSUMES ORDERED LASTNAME
      * IN THE DATABASE (HIDAM DATABASE).
      *
       SHOW50-CONTACTS.
           MOVE 0 TO TERM-LOOP.
           MOVE 0 TO OUT-NUM-RECORDS.

           MOVE IN-LAST-NAME TO LAST-NAME-SSA2.
           MOVE IN-COMMAND TO OUT-COMMAND.

           CALL "CBLTDLI"
             USING GN, DBPCB, PHONEBOOK-SEG, PHONEBOOK-SSA2.
           IF DBSTAT = SPACES
           THEN
             ADD 1 TO OUT-NUM-RECORDS
             MOVE PHONEBOOK-SEG(1:37)
               TO OUT-RECORD-50(OUT-NUM-RECORDS)

             PERFORM WITH TEST AFTER UNTIL TERM-LOOP = 1
               CALL "CBLTDLI"
                 USING GN, DBPCB, PHONEBOOK-SEG, PHONEBOOK-SSA3
               IF DBSTAT = SPACES
               THEN
                 ADD 1 TO OUT-NUM-RECORDS
                 MOVE PHONEBOOK-SEG(1:37)
                   TO OUT-RECORD-50(OUT-NUM-RECORDS)
               ELSE
                 MOVE 1 TO TERM-LOOP
                 IF DBSTAT NOT = GE AND DBSTAT NOT = GB
                 THEN
                   MOVE DISPLAY-FAILED TO OUT-MESSAGE-50
                   DISPLAY 'SHOW50-CONTACTS - BAD GN STATUS CODE: '
                     DBSTAT
                 ELSE
                   MOVE DISPLAYED-MULT TO OUT-MESSAGE-50
                 END-IF
               END-IF

               IF OUT-NUM-RECORDS = 50
               THEN
                 MOVE DISPLAYED-MULT TO OUT-MESSAGE-50
                 MOVE 1 TO TERM-LOOP
               END-IF
             END-PERFORM
           ELSE
             IF DBSTAT NOT = GE AND DBSTAT NOT = GB
             THEN
               MOVE DISPLAY-FAILED TO OUT-MESSAGE-50
               DISPLAY 'SHOW50-CONTACTS - BAD GN STATUS CODE: '
                  DBSTAT
             ELSE
               MOVE DISPLAYED-NONE TO OUT-MESSAGE-50
             END-IF
           END-IF.

           PERFORM INSERT-IO-50 THRU INSERT-IO-50-END.
       SHOW50-CONTACTS-END.

      * PROCEDURE TO VALIDATE TRANSACTION INPUT
       VALIDATE-INPUT.
           MOVE 0 TO VALID-INPUT.

           IF IN-LL < 32
           THEN
             MOVE 1 TO VALID-INPUT
             MOVE MOREINPUT TO OUT-MESSAGE
             PERFORM INSERT-IO THRU INSERT-IO-END
           END-IF.

           IF VALID-INPUT = 0
           THEN
             IF IN-COMMAND = 'DIS     ' OR
                IN-COMMAND = 'DISPLAY ' OR
                IN-COMMAND = 'DEL     ' OR
                IN-COMMAND = 'DELETE  ' OR
                IN-COMMAND = 'SHOW50  '
             THEN
               IF IN-LL < 25
               THEN
                 MOVE 1 TO VALID-INPUT
                 IF IN-COMMAND NOT = 'SHOW50  '
                 THEN
                   MOVE MOREINPUT TO OUT-MESSAGE
                   PERFORM INSERT-IO THRU INSERT-IO-END
                 ELSE
                   MOVE MOREINPUT TO OUT-MESSAGE-50
                   PERFORM INSERT-IO-50 THRU INSERT-IO-50-END
                 END-IF
               END-IF
             ELSE
               IF IN-COMMAND = 'UPD     ' OR
                  IN-COMMAND = 'UPDATE ' OR
                  IN-COMMAND = 'ADD     '
               THEN
                 IF IN-LL < 53
                 THEN
                   MOVE 1 TO VALID-INPUT
                   MOVE MOREINPUT TO OUT-MESSAGE
                   PERFORM INSERT-IO THRU INSERT-IO-END
                 END-IF
               ELSE
                 MOVE 1 TO VALID-INPUT
                 MOVE INVCMD TO OUT-MESSAGE
                 PERFORM INSERT-IO THRU INSERT-IO-END
               END-IF
             END-IF
           END-IF.

           IF VALID-INPUT = 0
             IF IN-LAST-NAME = ZEROS OR
                IN-LAST-NAME = SPACES AND
                IN-COMMAND NOT = 'SHOW50  '
             THEN
               MOVE 1 TO VALID-INPUT
               MOVE NOLAST TO OUT-MESSAGE
               PERFORM INSERT-IO THRU INSERT-IO-END
             END-IF
           END-IF.
       VALIDATE-INPUT-END.

      * PROCEDURE INSERT-IO : INSERT FOR IOPCB REQUEST HANDLER

       INSERT-IO.
           COMPUTE OUT-LL = LENGTH OF IVTNO-OUTPUT-MSG.
           MOVE 0 TO OUT-ZZ.
           CALL 'CBLTDLI' USING ISRT, LTERMPCB, IVTNO-OUTPUT-MSG.

           IF TPSTAT NOT = SPACES
             THEN
             DISPLAY 'INSERT TO IOPCB FAILED WITH STATUS CODE: '
                TPSTAT
           END-IF.
       INSERT-IO-END.

       INSERT-IO-50.
           COMPUTE OUT-LL-50 = LENGTH OF IVTNO-OUTPUT-MSG-50.
           MOVE 0 TO OUT-ZZ-50.
           CALL 'CBLTDLI' USING ISRT, LTERMPCB, IVTNO-OUTPUT-MSG-50.

           IF TPSTAT NOT = SPACES
             THEN
             DISPLAY 'INSERT TO IOPCB FAILED WITH STATUS CODE: '
                TPSTAT
           END-IF.
       INSERT-IO-50-END.