       CBL LIST,MAP,XREF,FLAG(I)
       IDENTIFICATION DIVISION.
       PROGRAM-ID. IVTNDB2.

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

       COPY IVTNDB2C.

      ******************************************************************
      *Host variables
      ******************************************************************
       01 W-HOSTVAR-IMSVIP.
          05 W-LASTNAME             PIC X(10).
          05 W-FIRSTNAME            PIC X(10).
          05 W-PHONE                PIC X(10).
          05 W-ZIPCODE              PIC X(7).


           EXEC SQL INCLUDE SQLCA END-EXEC.
      *    EXEC SQL INCLUDE SYSLIB END-EXEC.
      *    EXEC SQL INCLUDE CONTACTS END-EXEC.

      ******************************************************************
      * Pour API Requester
      ******************************************************************
      * API requester Host API required copybooks
       COPY BAQHAREC.
       COPY BAQHCONC.

      * The API to call
       COPY API00I01.

      * The request data to send to the API endpoint
       COPY API00Q01.

      * Pointer to API-INFO structure
       01 WS-API-INFO        USAGE POINTER VALUE NULL.

      * Data Area name to get
       01 WS-DATA-AREA-NAME  PIC X(16).

      * The address of a returned Data Area Element
       01 WS-ELEMENT         USAGE POINTER VALUE NULL.

      * Length of element for BAQGETN call.
       01 WS-ELEMENT-LENGTH  PIC 9(9) COMP-5.

      * Prepare to print messages to the log
       01 WS-FAIL-TYPE       PIC X(18) VALUE SPACES.
       01 WS-CC9             PIC 9(5).
       01 WS-RC9             PIC 9(5).
       01 WS-ST9             PIC 9(5).

      * Display this message to CICS log
       01 WS-DISPLAY-MSG     PIC X(78) VALUE ALL SPACES.

      * User credentials for basic authentication
       01 MY-USER PIC X(10) VALUE 'ZCOBOSS'.
       01 MY-PSWD PIC X(10) VALUE 'zcee4you'.

       LINKAGE SECTION.

      * Pour API Requester
      * The response data received from the API endpoint
       COPY API00P01.

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

      *----------------------------------------------------------------*
      * PROCEDURE DIVISION
      *----------------------------------------------------------------*
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
               INITIALIZE IVTNO-INPUT-MSG
               INITIALIZE IVTNO-OUTPUT-MSG
               INITIALIZE IVTNO-OUTPUT-MSG-50

               CALL 'CBLTDLI' USING GU
                                    LTERMPCB
                                    IVTNO-INPUT-MSG
               EVALUATE TRUE
               WHEN TPSTAT-OK
               WHEN TPSTAT-EXIST
                    DISPLAY 'Avant Validate LN : ' IN-LAST-NAME
                    PERFORM VALIDATE-INPUT
      * INPUT WASVALID, CONTINUE
                    IF VALID-INPUT = 0
                       EVALUATE IN-COMMAND
                       WHEN 'ADD     '
                       WHEN 'CREATE  '
                            MOVE SPACES TO IVTNO-OUTPUT-MSG
                            PERFORM ADD-CONTACT-ENTRY
                       WHEN 'DIS     '
                       WHEN 'DISPLAY '
                            MOVE SPACES TO IVTNO-OUTPUT-MSG
                            PERFORM DISPLAY-CONTACT-ENTRY
                       WHEN 'UPDATE  '
                       WHEN 'UPD     '
                            MOVE SPACES TO IVTNO-OUTPUT-MSG
                            PERFORM UPDATE-CONTACT-ENTRY
                       WHEN 'DELETE  '
                       WHEN 'DEL     '
                            MOVE SPACES TO IVTNO-OUTPUT-MSG
                            PERFORM DELETE-CONTACT-ENTRY
                       WHEN 'SHOW50  '
                       WHEN 'SHOW-50 '
                            MOVE SPACES TO IVTNO-OUTPUT-MSG-50
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

      *----------------------------------------------------------------*
      * PROCEDURE TO ADD PHONEBOOK ENTRY
      *----------------------------------------------------------------*
       ADD-CONTACT-ENTRY.
           MOVE IN-COMMAND TO OUT-COMMAND
           EXEC SQL INSERT INTO CONTACTS (
                      LASTNAME,
                      FIRSTNAME,
                      PHONE,
                      ZIPCODE
                      )
                VALUES (
                      :IN-LAST-NAME,
                      :IN-FIRST-NAME,
                      :IN-EXTENSION,
                      :IN-ZIP-CODE
                      )
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

      *----------------------------------------------------------------*
      * PROCEDURE TO DISPLAY PHONEBOOK ENTRY
      *----------------------------------------------------------------*
       DISPLAY-CONTACT-ENTRY.
           DISPLAY 'Contact recu : ' IN-LAST-NAME
           MOVE IN-LAST-NAME TO W-LASTNAME
           MOVE IN-COMMAND TO OUT-COMMAND
           EXEC SQL SELECT LASTNAME,
                           FIRSTNAME,
                           PHONE,
                           ZIPCODE
                INTO :W-LASTNAME,
                     :W-FIRSTNAME,
                     :W-PHONE,
                     :W-ZIPCODE
                FROM CONTACTS 
                WHERE LASTNAME = :W-LASTNAME
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

      *----------------------------------------------------------------*
      * PROCEDURE TO UPDATE PHONEBOOK ENTRY
      *----------------------------------------------------------------*
       UPDATE-CONTACT-ENTRY.
           MOVE IN-LAST-NAME TO W-LASTNAME
           MOVE IN-COMMAND TO OUT-COMMAND
           EXEC SQL UPDATE CONTACTS SET FIRSTNAME = :IN-FIRST-NAME,
                PHONE = :IN-EXTENSION,
                ZIPCODE = :IN-ZIP-CODE
                WHERE LASTNAME = :IN-LAST-NAME
                END-EXEC

           EVALUATE SQLCODE
           WHEN 0
                MOVE UPDATED TO OUT-MESSAGE

                MOVE IN-RECORD TO OUT-RECORD
           WHEN +100
                MOVE UPDATE-FAILED TO OUT-MESSAGE
           WHEN OTHER
                MOVE UPDATE-FAILED TO OUT-MESSAGE
                DISPLAY 'UPDATE-CONTACT - BAD SQLCODE: ' SQLCODE
                PERFORM DISPLAY-SQL-CODE
           END-EVALUATE
           PERFORM INSERT-IO
           .

      *----------------------------------------------------------------*
      * PROCEDURE TO DELETE PHONEBOOK ENTRY
      *----------------------------------------------------------------*
       DELETE-CONTACT-ENTRY.
           MOVE IN-LAST-NAME TO W-LASTNAME
           MOVE IN-COMMAND TO OUT-COMMAND
      * On récupère d'abord tous les attributs pour archivage
           EXEC SQL
               SELECT LASTNAME,
                      FIRSTNAME,
                      PHONE,
                      ZIPCODE
               INTO :W-LASTNAME,
                    :W-FIRSTNAME,
                    :W-PHONE,
                    :W-ZIPCODE
               FROM CONTACTS
                 WHERE LASTNAME = :W-LASTNAME
           END-EXEC.
           DISPLAY 'On a récupéré le contact : ' W-LASTNAME
           DISPLAY 'Voici le prénom : ' W-FIRSTNAME
      * On delete
           PERFORM CALL-API
           EXEC SQL DELETE FROM CONTACTS WHERE LASTNAME = :W-LASTNAME
           END-EXEC

           Evaluate SQLCODE
             When 0
               MOVE 'C''est fait !' TO OUT-MESSAGE
               MOVE W-HOSTVAR-IMSVIP TO OUT-RECORD         
             When 100
      * 100 = successful mais pas de ligne retourn©e
               MOVE 'Inconnu au bataillon !' TO OUT-MESSAGE
               PERFORM DISPLAY-SQL-CODE
             When Other
               MOVE 'Snif: problème !' TO OUT-MESSAGE
               PERFORM DISPLAY-SQL-CODE
           END-Evaluate.
           PERFORM INSERT-IO
           .

      *----------------------------------------------------------------*
      * Call API Requester
      *----------------------------------------------------------------*
       CALL-API.
      * Initialise the BAQ Host API and acquire a connection to
      * a z/OS Connect server instance
           PERFORM B-INIT
      * If a connection was gained execute the Tx and make a BAQEXEC
      * call to a remote endpoint API operation
           IF BAQ-SUCCESS THEN
                PERFORM C-PROCESS
      * Optional: Free any resources used by BAQEXEC
      *          PERFORM W-FREE
      * Terminate the BAQHAPI connection to the z/OS Connect server
      * In CICS the allocated connection is returned to a pool
      * and will be reused for the next request to the same z/OS Connect
      * server instance.
                PERFORM X-TERM
           END-IF
           .

       B-INIT.

      * Initialise the Host API
      * Set user credentials
           MOVE BAQZ-SERVER-USERNAME
             TO BAQ-ZCON-PARM-NAME OF BAQ-ZCON-PARMS(1)
           SET BAQ-ZCON-PARM-ADDRESS OF BAQ-ZCON-PARMS(1)
             TO ADDRESS OF MY-USER
      *     MOVE LENGTH OF MY-USER
           MOVE 7
             TO BAQ-ZCON-PARM-LENGTH OF BAQ-ZCON-PARMS(1)
           MOVE BAQZ-SERVER-PASSWORD
             TO BAQ-ZCON-PARM-NAME OF BAQ-ZCON-PARMS(2)
           SET BAQ-ZCON-PARM-ADDRESS OF BAQ-ZCON-PARMS(2)
             TO ADDRESS OF MY-PSWD
      *     MOVE LENGTH OF MY-PSWD
           MOVE 8
             TO BAQ-ZCON-PARM-LENGTH OF BAQ-ZCON-PARMS(2).
      
      * Enable les traces
           MOVE BAQZ-TRACE-VERBOSE 
             TO BAQ-ZCON-PARM-NAME OF BAQ-ZCON-PARMS(3) 
           SET BAQ-ZCON-PARM-ADDRESS OF BAQ-ZCON-PARMS(3) 
             TO ADDRESS OF BAQZ-TRACE-LEVEL-ALL 
           MOVE LENGTH OF BAQZ-TRACE-LEVEL-ALL 
             TO BAQ-ZCON-PARM-LENGTH OF BAQ-ZCON-PARMS(3) 

           DISPLAY 'MY-USER : ' MY-USER
           DISPLAY 'Longueur LENGTH : ' LENGTH OF MY-USER
           DISPLAY 'Longueur de MY-USER : '
                          BAQ-ZCON-PARM-LENGTH OF BAQ-ZCON-PARMS(1)

      * Make the BAQINIT call
           CALL BAQ-INIT-NAME USING BY REFERENCE BAQ-ZCONNECT-AREA.

      * Check for bad initialization
           IF NOT BAQ-SUCCESS THEN
              MOVE BAQ-ZCON-COMPLETION-CODE TO WS-CC9
              MOVE BAQ-ZCON-REASON-CODE TO WS-RC9
              DISPLAY ' INIT Completion Code : ' WS-CC9
              DISPLAY ' INIT Reason Code     : ' WS-RC9
              DISPLAY BAQ-ZCON-RETURN-MESSAGE
              MOVE 'ErrorAPI' TO OUT-COMMAND
              MOVE BAQ-ZCON-RETURN-MESSAGE TO OUT-MESSAGE
           ELSE
              DISPLAY 'Fin ok de INIT'
           END-IF
           .

       C-PROCESS.
      * Prepare the request for sending
           MOVE 1 TO lastName-existence of requestBody.
           MOVE W-LASTNAME TO lastName2 of requestBody.
           MOVE LENGTH OF lastName2 of requestBody
                       TO lastName2-length of requestBody.

           MOVE 1 TO firstName-existence of requestBody.
           MOVE W-FIRSTNAME TO firstName2 of requestBody.
           MOVE LENGTH OF firstName2 of requestBody
                       TO firstName2-length of requestBody.

           MOVE 1 TO telExtension-existence of requestBody.
           MOVE W-PHONE  TO telExtension2 of requestBody.
           MOVE LENGTH OF telExtension2 of requestBody
                       TO telExtension2-length of requestBody.

           MOVE 1 TO zipCode-existence of requestBody.
           MOVE W-ZIPCODE TO zipCode2 of requestBody.
           MOVE LENGTH OF zipCode2 of requestBody
                       TO zipCode2-length of requestBody.

      *     SET WS-API-INFO TO ADDRESS OF BAQ-API-INFO-RBK02I01.
           SET BAQ-REQ-BASE-ADDRESS TO ADDRESS OF BAQBASE-API00Q01.
           MOVE LENGTH OF BAQBASE-API00Q01 TO BAQ-REQ-BASE-LENGTH.

      *     DISPLAY 'longeur input data : ' BAQ-REQ-BASE-LENGTH.
      *     DISPLAY 'lastname : ' lastName2 of requestBody.
      *     DISPLAY 'firstname : ' firstName2 of requestBody.
           DISPLAY 'Le mot de passe avant le call : ' MY-PSWD

      * Call the API
           CALL BAQ-EXEC-NAME USING
                           BY REFERENCE BAQ-ZCONNECT-AREA
                           BY REFERENCE BAQ-API-INFO-API00I01
                           BY REFERENCE BAQ-REQUEST-AREA
                           BY REFERENCE BAQ-RESPONSE-AREA.

           IF NOT BAQ-SUCCESS THEN
              MOVE BAQ-ZCON-COMPLETION-CODE TO WS-CC9
              MOVE BAQ-ZCON-REASON-CODE TO WS-RC9

              EVALUATE TRUE
                 WHEN BAQ-WARNING
                    MOVE "API RETURN WARNING" TO WS-FAIL-TYPE
                 WHEN BAQ-ERROR
                    MOVE "API RETURN ERROR  " TO WS-FAIL-TYPE
                 WHEN BAQ-SEVERE
                    MOVE "API RETURN SEVERE " TO WS-FAIL-TYPE
              END-EVALUATE

              MOVE BAQ-ZCON-COMPLETION-CODE TO WS-CC9
              MOVE BAQ-ZCON-REASON-CODE TO WS-RC9
              DISPLAY ' EXEC Completion Code : ' WS-CC9
              DISPLAY ' EXEC Reason Code     : ' WS-RC9
              DISPLAY BAQ-ZCON-RETURN-MESSAGE
              MOVE 'ErrorAPI' TO OUT-COMMAND
              MOVE BAQ-ZCON-RETURN-MESSAGE TO OUT-MESSAGE
              EXIT
           END-IF

      * Successful call, address the base structure
           SET ADDRESS OF BAQBASE-API00P01 to BAQ-RESP-BASE-ADDRESS.

      * The RESTful API has returned but the HTTP Status Code could
      * be 200 (OK) to indicate a successful return

           IF BAQ-RESP-STATUS-CODE EQUAL 200 THEN
      *        DISPLAY 'C est bon code retour : ' BAQ-RESP-STATUS-CODE
              IF responseCode200-existence > 0 THEN

                 MOVE LENGTH OF API00P01-responseCode200 TO
                    WS-ELEMENT-LENGTH

      * Récupère les données du code retour 200
                 CALL BAQ-GETN-NAME USING
                         BY REFERENCE BAQ-ZCONNECT-AREA
                         responseCode200-dataarea
                         BY REFERENCE WS-ELEMENT
                         BY REFERENCE WS-ELEMENT-LENGTH

                 IF NOT BAQ-SUCCESS THEN
                    MOVE BAQ-ZCON-COMPLETION-CODE TO WS-CC9
                    MOVE BAQ-ZCON-REASON-CODE TO WS-RC9
                    DISPLAY ' GETN Completion Code ' WS-CC9
                    DISPLAY ' GETN Reason Code ' WS-RC9
                    DISPLAY BAQ-ZCON-RETURN-MESSAGE
                 ELSE
                       SET ADDRESS OF API00P01-responseCode200 to
                                                 WS-ELEMENT
      *                 DISPLAY 'Xid2 : ' Xid2
                       MOVE 'ARCHIVED' TO OUT-COMMAND
                       MOVE Xid2 TO OUT-MESSAGE
                 END-IF

              END-IF
      *    ELSE
      * On est dans le cas ou nous n'avons pas pu faire l'archivage
      * du contact
      *    EXEC CICS ABEND ABCODE('BCDE')      
           END-IF
           .

      * W-FREE SECTION.
      * Free Storage acquired by BAQEXEC
      *     CALL BAQ-FREE-NAME USING BY REFERENCE BAQ-ZCONNECT-AREA.
      *     IF NOT BAQ-SUCCESS THEN
      *        MOVE BAQ-ZCON-COMPLETION-CODE TO WS-CC9
      *        MOVE BAQ-ZCON-REASON-CODE TO WS-RC9
      *        DISPLAY ' FREE Completion Code ' WS-CC9
      *        DISPLAY ' FREE Reason Code ' WS-RC9
      *        DISPLAY BAQ-ZCON-RETURN-MESSAGE
      *     END-IF.
      *     DISPLAY 'Je suis à la fin du FREE : X-FREE'.
      *     EXIT.
      *----------------------------------------------------------------*
      * X-TERM
      *
      * Terminates the connection to z/OS Connect using BAQTERM.
      *----------------------------------------------------------------*
       X-TERM.
      * Terminate the connection
           CALL BAQ-TERM-NAME USING BY REFERENCE BAQ-ZCONNECT-AREA.

           IF NOT BAQ-SUCCESS THEN
              MOVE BAQ-ZCON-COMPLETION-CODE TO WS-CC9
              MOVE BAQ-ZCON-REASON-CODE TO WS-RC9
              DISPLAY ' TERM Completion Code ' WS-CC9
              DISPLAY ' TERM Reason Code ' WS-RC9
              DISPLAY BAQ-ZCON-RETURN-MESSAGE
           ELSE
              DISPLAY 'Je suis à la fin OK du TERM : X-TERM'
           END-IF
           .
      *----------------------------------------------------------------*
      * End of API Requester call                                      *
      *----------------------------------------------------------------*

      *----------------------------------------------------------------*
      * PROCEDURE TO SHOW 50  PHONEBOOK RECORDS                        *
      *----------------------------------------------------------------*
      * - RETURN FIRST 50  RECORDS OF THE DATABASE IF
      *   NO IN-LAST-NAME PROVIDED
      * - RETURN NEXT 50  RECORDS OF THE DATABASE
      *   AFTER FINDING THE PROVIDED IN-LAST-NAME
       SHOW50-CONTACTS.
           DISPLAY 'Debut de Show50'
           MOVE 0 TO TERM-LOOP
           MOVE 0 TO OUT-NUM-RECORDS
           MOVE 0 TO NUMTOSTRING9

           MOVE IN-LAST-NAME TO W-LASTNAME
           MOVE IN-COMMAND TO OUT-COMMAND-50

           SET OUT-REC-IDX TO 1
           EXEC SQL DECLARE SHOW50-CURS CURSOR FOR
                SELECT LASTNAME,
                FIRSTNAME,
                PHONE,
                ZIPCODE
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
                        :W-ZIPCODE
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
                       ' contacts trouvé(es)' DELIMITED BY SIZE
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
           COMPUTE OUT-LL = LENGTH OF IVTNO-OUTPUT-MSG
           MOVE 0 TO OUT-ZZ
           CALL 'CBLTDLI' USING ISRT
                                LTERMPCB
                                IVTNO-OUTPUT-MSG

           IF TPSTAT NOT = SPACES
              DISPLAY 'INSERT TO IOPCB FAILED WITH STATUS CODE: '
                      TPSTAT
           END-IF
           .

       INSERT-IO-50.
           COMPUTE OUT-LL-50 = LENGTH OF IVTNO-OUTPUT-MSG-50
           MOVE 0 TO OUT-ZZ-50
           CALL 'CBLTDLI' USING ISRT
                                LTERMPCB
                                IVTNO-OUTPUT-MSG-50

           IF TPSTAT NOT = SPACES
              DISPLAY 'INSERT TO IOPCB FAILED WITH STATUS CODE: '
                      TPSTAT
           END-IF
           .

       END PROGRAM IVTNDB2.