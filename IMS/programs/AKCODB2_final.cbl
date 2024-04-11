       CBL LIST,MAP,XREF,FLAG(I)
       IDENTIFICATION DIVISION.
       PROGRAM-ID. AKCODB2.

      ******************************************************************

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      ******************************************************************
      *CONSTANTS
      ******************************************************************
      * RS.NEXT FAILED TO GET A ROW
       77 INVCMD                    PIC  X(25)    VALUE
                                            "PROCESS CODE IS NOT VALID".
       77 MOREINPUT                 PIC  X(38)
                                                  VALUE
             "DATA IS NOT ENOUGH. PLEASE KEY IN MORE".
       77 NOINPUT                   PIC  X(37)
                                                  VALUE
             "NO DATA WAS INPUT. PLEASE KEY IN MORE".
       77 NOLAST                    PIC  X(27)
                                                  VALUE
                                          "LAST NAME WAS NOT SPECIFIED"
           .
       77 DELETED                   PIC  X(17)    VALUE
                                                    "ENTRY WAS DELETED".
       77 DELETED-AR                PIC  X(30)
                                                  VALUE
             "ENTRY WAS DELETED AND ARCHIVED".
       77 ADDED                     PIC  X(15)    VALUE
                                                      "ENTRY WAS ADDED".
       77 CONVENDED                 PIC  X(22)    VALUE
                                               "NCNVERSATION HAS ENDED".
       77 DISPLAYED                 PIC  X(19)    VALUE
                                                  "ENTRY WAS DISPLAYED".
       77 DISPLAYED-MULT            PIC  X(22)    VALUE
                                               "ENTRIES WERE DISPLAYED".
       77 DISPLAYED-NONE            PIC  X(16)    VALUE
                                                     "NO ENTRIES FOUND".
       77 UPDATED                   PIC  X(17)    VALUE
                                                    "ENTRY WAS UPDATED".

       77 DISPLAY-FAILED            PIC  X(30)
                                                  VALUE
             "SPECIFIED PERSON WAS NOT FOUND".
       77 ADD-FAILED                PIC  X(28)
                                                  VALUE
             "ADDITION OF ENTRY HAS FAILED".
       77 DELETE-FAILED             PIC  X(28)
                                                  VALUE
             "DELETION OF ENTRY HAS FAILED".
       77 UPDATE-FAILED             PIC  X(26)
                                                  VALUE
                                           "UPDATE OF ENTRY HAS FAILED".

      * MESSAGE PROCESSING
       77 VALID-INPUT               PIC 9         VALUE 0.
       77 TERM-IO                   PIC 9         VALUE 0.
       77 TERM-LOOP                 PIC 9         VALUE 0.
       77 DISP-SQLCODE              PIC +ZZZZZZZZ9.

      ******************************************************************
      *DATABASE CALL CODES
      ******************************************************************

       77 GU                        PIC  X(04)    VALUE "GU  ".
       77 GHU                       PIC  X(04)    VALUE "GHU ".
       77 GN                        PIC  X(04)    VALUE "GN  ".
       77 GHN                       PIC  X(04)    VALUE "GHN ".
       77 ISRT                      PIC  X(04)    VALUE "ISRT".
       77 DLET                      PIC  X(04)    VALUE "DLET".
       77 REPL                      PIC  X(04)    VALUE "REPL".
       77 NEXT-CALL                 PIC  X(04)    VALUE "    ".

      ******************************************************************
      *ERROR STATUS CODE AREA
      ******************************************************************

       01 BAD-STATUS.
          05 SC-MSG                 PIC X(30)     VALUE
                                       "BAD STATUS CODE WAS RECEIVED: ".
          05 SC                     PIC X(2).

      ******************************************************************
      *VARIABLES AREAS
      ******************************************************************
       01 NUMTOSTRING.
          05 NUMTOSTRINGX           PIC X(2).
          05 NUMTOSTRING9 REDEFINES NUMTOSTRINGX
                                    PIC 9(2).

      ******************************************************************
      *INPUT/OUTPUT MESSAGE AREA
      ******************************************************************

       COPY AKCODB2C.

      ******************************************************************
      *Host variables
      ******************************************************************
       01 W-HOSTVAR-IMSVIP.
          05 W-LASTNAME             PIC X(15).
          05 W-FIRSTNAME            PIC X(15).
          05 W-PHONE                PIC X(10).
          05 W-ZIPCODE              PIC X(7).
          05 W-EMAIL                PIC X(40).


           EXEC SQL INCLUDE SQLCA END-EXEC.
      *    EXEC SQL INCLUDE SYSLIB END-EXEC.
      *    EXEC SQL INCLUDE CONTACTS END-EXEC.

       LINKAGE SECTION.

       01 IOPCBA POINTER.
       01 ALTPCBA POINTER.

      ******************************************************************
      *I/O PCB
      ******************************************************************

       01 LTERMPCB.
          05 LOGTTERM               PIC  X(08).
          05 FILLER                 PIC  X(02).
          05 TPSTAT                 PIC  X(02).
             88 TPSTAT-OK                         VALUE SPACE.
             88 TPSTAT-NOMORE                     VALUE 'QC'.
             88 TPSTAT-EXIST                      VALUE 'CF'.
          05 IODATE                 PIC  X(04).
          05 IOTIME                 PIC  X(04).
          05 FILLER                 PIC  X(02).
          05 SEQNUM                 PIC  X(02).
          05 MOD                    PIC  X(08).

      ******************************************************************
      *ALTPCB
      ******************************************************************

       01 ALTPCB.
          05 LOGTTERM1              PIC  X(08).
          05 FILLER1                PIC  X(02).
          05 TPSTAT1                PIC  X(02).
          05 IODATE1                PIC  X(04).
          05 IOTIME1                PIC  X(04).
          05 FILLER1                PIC  X(02).
          05 SEQNUM1                PIC  X(02).
          05 MOD1                   PIC  X(08).

       PROCEDURE DIVISION.
           ENTRY "DLITCBL"
           USING IOPCBA
                 ALTPCBA
           .

       BEGIN.
      *    DISPLAY 'IOPCBA: ' IOPCBA.
      *    DISPLAY 'ALTPCBA: ' ALTPCBA.
      *    DISPLAY 'DBPCB1: ' DBPCB1.

           SET ADDRESS OF LTERMPCB TO ADDRESS OF IOPCBA

           MOVE 0 TO TERM-IO

           PERFORM WITH TEST BEFORE UNTIL TERM-IO = 1
               INITIALIZE CONTACTS-INPUT-MSG
               INITIALIZE CONTACTS-OUTPUT-MSG
      * We can't initialize CONTACTS-OUTPUT-MSG-50
      *                                          as it's variable-length
               INITIALIZE OUT-MESSAGE-50
               INITIALIZE OUT-COMMAND-50
               INITIALIZE OUT-NUM-RECORDS

               CALL 'CBLTDLI' USING GU
                                    LTERMPCB
                                    CONTACTS-INPUT-MSG
               EVALUATE TRUE
               WHEN TPSTAT-OK
               WHEN TPSTAT-EXIST
                    DISPLAY 'Avant Validate LN a : ' IN-LAST-NAME
                    PERFORM VALIDATE-INPUT
      * INPUT WASVALID, CONTINUE
                    IF VALID-INPUT = 0
                       EVALUATE IN-COMMAND
                       WHEN 'ADD     '
                       WHEN 'CREATE  '
                            MOVE SPACES TO CONTACTS-OUTPUT-MSG
                            PERFORM ADD-CONTACT-ENTRY
                       WHEN 'DIS     '
                       WHEN 'DISPLAY '
                            MOVE SPACES TO CONTACTS-OUTPUT-MSG
                            PERFORM DISPLAY-CONTACT-ENTRY
                       WHEN 'UPDATE  '
                       WHEN 'UPD     '
                            MOVE SPACES TO CONTACTS-OUTPUT-MSG
                            PERFORM UPDATE-CONTACT-ENTRY
                       WHEN 'DELETE  '
                       WHEN 'DEL     '
                            MOVE SPACES TO CONTACTS-OUTPUT-MSG
                            PERFORM DELETE-CONTACT-ENTRY
                       WHEN 'SHOW50  '
                       WHEN 'SHOW-50 '
                            MOVE SPACES TO CONTACTS-OUTPUT-MSG-50
                            PERFORM SHOW50-CONTACTS
                       WHEN OTHER
                            DISPLAY 'INVALID COMMAND RECIEVED: '
                                    IN-COMMAND
                            PERFORM REQUEST-NOT-RECOGNISED
                       END-EVALUATE
                    END-IF

               WHEN TPSTAT-NOMORE
                    MOVE 1 TO TERM-IO
               WHEN OTHER
                    DISPLAY
                       'GU FROM IOPCB FAILED WITH STATUS CODE: '
                       TPSTAT
               END-EVALUATE
           END-PERFORM
           STOP RUN
           .

      * PROCEDURE TO ADD PHONEBOOK ENTRY
       ADD-CONTACT-ENTRY.
           MOVE IN-COMMAND TO OUT-COMMAND
           EXEC SQL INSERT INTO CONTACTS (LASTNAME,
                FIRSTNAME,
                PHONE,
                ZIPCODE,
                EMAIL)
                VALUES (:IN-LAST-NAME,
                :IN-FIRST-NAME,
                :IN-EXTENSION,
                :IN-ZIP-CODE,
                :IN-EMAIL)
                END-EXEC

           EVALUATE SQLCODE
           WHEN 0
                MOVE ADDED TO OUT-MESSAGE
                MOVE IN-COMMAND TO OUT-COMMAND
                MOVE IN-RECORD TO OUT-RECORD
           WHEN +100
                MOVE ADD-FAILED TO OUT-MESSAGE
           WHEN OTHER
                MOVE ADD-FAILED TO OUT-MESSAGE
                DISPLAY 'ADD-CONTACT - BAD SQLCODE: ' SQLCODE
                PERFORM DISPLAY-SQL-CODE
           END-EVALUATE
           PERFORM INSERT-IO
           .

      * PROCEDURE TO DISPLAY PHONEBOOK ENTRY
       DISPLAY-CONTACT-ENTRY.
           DISPLAY 'Contact recu : ' IN-LAST-NAME
           MOVE IN-LAST-NAME TO W-LASTNAME
           MOVE IN-COMMAND TO OUT-COMMAND
           EXEC SQL SELECT LASTNAME,
                FIRSTNAME,
                PHONE,
                ZIPCODE,
                EMAIL
                INTO :W-LASTNAME,
                :W-FIRSTNAME,
                :W-PHONE,
                :W-ZIPCODE,
                :W-EMAIL
                FROM CONTACTS WHERE LASTNAME = :W-LASTNAME
                END-EXEC

           EVALUATE SQLCODE
           WHEN 0
                MOVE DISPLAYED TO OUT-MESSAGE
                MOVE W-HOSTVAR-IMSVIP TO OUT-RECORD
           WHEN +100
                MOVE DISPLAY-FAILED TO OUT-MESSAGE
           WHEN OTHER
                MOVE DISPLAY-FAILED TO OUT-MESSAGE
                DISPLAY 'DISPLAY-CONTACT - BAD SQLCODE: ' SQLCODE
                PERFORM DISPLAY-SQL-CODE
           END-EVALUATE
           PERFORM INSERT-IO
           .

      * PROCEDURE TO UPDATE PHONEBOOK ENTRY
       UPDATE-CONTACT-ENTRY.
           DISPLAY 'Contact a update : ' IN-LAST-NAME
           MOVE IN-LAST-NAME TO W-LASTNAME
           MOVE IN-COMMAND TO OUT-COMMAND
           EXEC SQL UPDATE CONTACTS SET FIRSTNAME = :IN-FIRST-NAME,
                PHONE = :IN-EXTENSION,
                ZIPCODE = :IN-ZIP-CODE,
                EMAIL = :IN-EMAIL
                WHERE LASTNAME = :IN-LAST-NAME
                END-EXEC

           EVALUATE SQLCODE
           WHEN 0
                MOVE UPDATED TO OUT-MESSAGE
                MOVE IN-RECORD TO OUT-RECORD
           WHEN +100
                MOVE UPDATE-FAILED TO OUT-MESSAGE
                DISPLAY 'UPDATE-CONTACT - BAD SQLCODE: ' SQLCODE
                PERFORM DISPLAY-SQL-CODE
           WHEN OTHER
                MOVE UPDATE-FAILED TO OUT-MESSAGE
                DISPLAY 'UPDATE-CONTACT - BAD SQLCODE: ' SQLCODE
                PERFORM DISPLAY-SQL-CODE
           END-EVALUATE
           PERFORM INSERT-IO
           .

      * PROCEDURE TO DELETE PHONEBOOK ENTRY
       DELETE-CONTACT-ENTRY.
           MOVE IN-COMMAND TO OUT-COMMAND
           EXEC SQL DELETE FROM CONTACTS WHERE LASTNAME = :IN-LAST-NAME
                END-EXEC

           EVALUATE SQLCODE
           WHEN 0
                MOVE DELETED TO OUT-MESSAGE
                MOVE IN-RECORD TO OUT-RECORD
           WHEN +100
                MOVE DELETE-FAILED TO OUT-MESSAGE
           WHEN OTHER
                MOVE DELETE-FAILED TO OUT-MESSAGE
                DISPLAY 'DELETE-CONTACT - BAD SQLCODE: ' SQLCODE
                PERFORM DISPLAY-SQL-CODE
           END-EVALUATE
           PERFORM INSERT-IO
           .

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
           MOVE 0 TO TERM-LOOP
           MOVE 0 TO OUT-NUM-RECORDS
           MOVE 0 TO NUMTOSTRING9

           MOVE IN-LAST-NAME TO W-LASTNAME
           MOVE IN-COMMAND TO OUT-COMMAND-50

           SET OUT-REC-IDX TO 1
           DISPLAY 'SHOW50-CURS'
           EXEC SQL DECLARE SHOW50-CURS CURSOR FOR
                SELECT LASTNAME,
                FIRSTNAME,
                PHONE,
                ZIPCODE,
                EMAIL
                FROM CONTACTS WHERE LASTNAME > :W-LASTNAME ORDER
                BY LASTNAME
                END-EXEC

           EXEC SQL
                OPEN SHOW50-CURS
                END-EXEC

           PERFORM UNTIL(SQLCODE NOT = 0)
              OR (OUT-NUM-RECORDS >= 50)
                   EXEC SQL
                        FETCH SHOW50-CURS
                        INTO :W-LASTNAME,
                        :W-FIRSTNAME,
                        :W-PHONE,
                        :W-ZIPCODE,
                        :W-EMAIL
                        END-EXEC
                   IF SQLCODE = 0
                      MOVE W-HOSTVAR-IMSVIP
                         TO OUT-RECORD-50(OUT-REC-IDX)
                      SET OUT-REC-IDX UP BY 1
                   END-IF
           END-PERFORM

      * En fin de liste ou si déjà plus de 50 entrées
           EVALUATE SQLCODE
           WHEN 0
                SET OUT-REC-IDX DOWN BY 1
                SET OUT-NUM-RECORDS TO OUT-REC-IDX
                IF OUT-NUM-RECORDS >= 50
                   MOVE DISPLAYED-MULT TO OUT-MESSAGE-50
                ELSE
                   MOVE 'Fin liste' TO OUT-MESSAGE-50
                END-IF
      * Dans la cas ou on s'arrète avant les 50
           WHEN +100
                SET OUT-REC-IDX DOWN BY 1
                IF OUT-REC-IDX > 1
                   SET OUT-NUM-RECORDS TO OUT-REC-IDX
                   SET NUMTOSTRING9 TO OUT-REC-IDX
                END-IF
      *           STRING OUT-NUM-RECORDS-X DELIMITED BY SPACE
                STRING NUMTOSTRINGX DELIMITED BY SPACE
                       ' contacts trouvé(s)' DELIMITED BY SIZE
                   INTO OUT-MESSAGE-50

           WHEN OTHER
                MOVE DISPLAY-FAILED TO OUT-MESSAGE-50
                DISPLAY 'SHOW50-CONTACTS - BAD SQLCODE: '
                        SQLCODE
                PERFORM DISPLAY-SQL-CODE
           END-EVALUATE

           EXEC SQL
                CLOSE SHOW50-CURS
                END-EXEC

           PERFORM INSERT-IO-50
           .

      * PROCEDURE TO VALIDATE TRANSACTION INPUT
       VALIDATE-INPUT.
           MOVE 0 TO VALID-INPUT

           IF IN-LL < 32
              MOVE 1 TO VALID-INPUT
              MOVE MOREINPUT TO OUT-MESSAGE
              PERFORM INSERT-IO
           END-IF

           IF VALID-INPUT = 0
              IF IN-COMMAND = 'DIS     ' OR
                 IN-COMMAND = 'DISPLAY ' OR
                 IN-COMMAND = 'DEL     ' OR
                 IN-COMMAND = 'DELETE  ' OR
                 IN-COMMAND = 'SHOW50  ' OR
                 IN-COMMAND = 'SHOW-50 '

                 IF IN-LL < 25
                    MOVE 1 TO VALID-INPUT
                    IF IN-COMMAND NOT = 'SHOW50  ' OR
                       IN-COMMAND NOT = 'SHOW-50 '
                       MOVE MOREINPUT TO OUT-MESSAGE
                       PERFORM INSERT-IO
                    ELSE
                       MOVE MOREINPUT TO OUT-MESSAGE-50
                       PERFORM INSERT-IO-50
                    END-IF
                 END-IF
              END-IF
           ELSE
              IF IN-COMMAND = 'UPD     ' OR
                 IN-COMMAND = 'UPDATE  ' OR
                 IN-COMMAND = 'ADD     ' OR
                 IN-COMMAND = 'CREATE  '
                 IF IN-LL < 53
                    MOVE 1 TO VALID-INPUT
                    MOVE MOREINPUT TO OUT-MESSAGE
                    PERFORM INSERT-IO
                 END-IF
              ELSE
                 MOVE 1 TO VALID-INPUT
                 MOVE INVCMD TO OUT-MESSAGE
                 PERFORM INSERT-IO
              END-IF
           END-IF

           IF VALID-INPUT = 0
              IF ( IN-LAST-NAME = ZEROS OR
                 IN-LAST-NAME = SPACES ) AND
                 ( IN-COMMAND NOT = 'SHOW50  ' OR
                 IN-COMMAND NOT = 'SHOW-50 ' )
                 MOVE 1 TO VALID-INPUT
                 MOVE NOLAST TO OUT-MESSAGE
                 PERFORM INSERT-IO
              END-IF
           END-IF
           .

       DISPLAY-SQL-CODE.
           MOVE SQLCODE TO DISP-SQLCODE
           DISPLAY 'SQLCODE  : ' DISP-SQLCODE
           DISPLAY 'SQLSTATE : ' SQLSTATE
           DISPLAY 'SQLERRML : ' SQLERRML
           DISPLAY 'SQLERRMC : ' SQLERRMC
           .

       REQUEST-NOT-RECOGNISED.
           MOVE INVCMD TO OUT-MESSAGE
           MOVE IN-COMMAND TO OUT-COMMAND
           PERFORM INSERT-IO
           .

      * PROCEDURE INSERT-IO : INSERT FOR IOPCB REQUEST HANDLER

       INSERT-IO.
           COMPUTE OUT-LL = LENGTH OF CONTACTS-OUTPUT-MSG
           MOVE 0 TO OUT-ZZ
           CALL 'CBLTDLI' USING ISRT
                                LTERMPCB
                                CONTACTS-OUTPUT-MSG

           IF TPSTAT NOT = SPACES
              DISPLAY 'INSERT TO IOPCB FAILED WITH STATUS CODE: '
                      TPSTAT
           END-IF
           .

       INSERT-IO-50.
           COMPUTE OUT-LL-50 = LENGTH OF CONTACTS-OUTPUT-MSG-50
           MOVE 0 TO OUT-ZZ-50
           CALL 'CBLTDLI' USING ISRT
                                LTERMPCB
                                CONTACTS-OUTPUT-MSG-50

           IF TPSTAT NOT = SPACES
              DISPLAY 'INSERT TO IOPCB FAILED WITH STATUS CODE: '
                      TPSTAT
           END-IF
           .

       END PROGRAM AKCODB2.