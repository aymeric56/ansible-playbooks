       CBL CICS('COBOL3') APOST
      *****************************************************************
      *                                                               *
      *  MODULE NAME = PBOOKDB2                                       *
      *                                                               *
      *  DESCRIPTIVE NAME = CICS TS  (Samples) Example Application -  *
      *                     Phone Book Program                        *
      *                                                               *
      *                                                               *
      *  STATUS = 1.0.0                                               *
      *                                                               *
      *  TRANSACTION NAME = n/a                                       *
      *                                                               *
      *  FUNCTION =                                                   *
      *  This module is the controller for the PhoneBook application, *
      *  all requests pass through this module                        *
      *                                                               *
      *-------------------------------------------------------------  *
      *                                                               *
      *  ENTRY POINT = PBOOKCMN                                       *
      *                                                               *
      *-------------------------------------------------------------  *
      *                                                               *
      *  CHANGE ACTIVITY :                                            *
      *                                                               *
      *  2023/02/20 Creation (Aymeric Affouard)                       *
      *                                                               *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PBOOKDB2.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *----------------------------------------------------------------*
      * Common defintions                                              *
      *----------------------------------------------------------------*

      * Working variables
       01 WORKING-VARIABLES.
           03 WS-RESP                  PIC S9(8) COMP.
           03 WS-RETURN-CODE           PIC S9(8) COMP.
           03 DISP-SQLCODE             PIC +ZZZZZZZZ9.
           03 KeyLastname              PIC X(10).
           03 UserID                   PIC X(8).

      * Variables used with Db2 for table contacts
       01  CONTACT-DETAILS.
           03 C-Lastname                   PIC X(10).
           03 C-Firstname                  PIC X(10).
           03 C-Phone                      PIC X(10).
           03 C-zipCode                    PIC X(7).

       01 NUMTOSTRING.
          05 NUMTOSTRINGX           PIC X(2).
          05 NUMTOSTRING9 REDEFINES NUMTOSTRINGX
                                    PIC 9(2).
      * Data structures to hold the input and output data
      * Due to copy books containing 'SYNC' members must be held
      * individually with an 01 level structure to ensure they are
      * aligned on a double word boundry
       01 CONTAINER-PBOOK-INPUT.
           COPY PBOOKCIN.
       01 CONTAINER-PBOOK-OUTPUT1.
           COPY PBOOKCO1.
       01 CONTAINER-PBOOK-OUTPUT2.
           COPY PBOOKCO2.

      *----------------------------------------------------------------*
      *    DB2 CONTROL
      *----------------------------------------------------------------*
      * SQLCA DB2 communications area
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.
      *----------------------------------------------------------------*

      * Pour API Requester
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

      ******************************************************************
      *    L I N K A G E   S E C T I O N
      ******************************************************************
       LINKAGE SECTION.

      * Pour API Requester
      * The response data received from the API endpoint
       COPY API00P01.

      ******************************************************************
      *    P R O C E D U R E S
      ******************************************************************
       PROCEDURE DIVISION.

      *----------------------------------------------------------------*
       MAINLINE SECTION.

      *---------------------------------------------------------------*
      * Get the input data from the supplied container                *
      *---------------------------------------------------------------*
           DISPLAY EIBTRNID ' Je suis au début de PBOOKDB2'
           INITIALIZE CONTAINER-PBOOK-INPUT

           EXEC CICS GET CONTAINER('PBOOK-INPUT')
                    CHANNEL('JSONCHANNEL')
                    INTO(messageInput)
                    RESP(WS-RESP)
           END-EXEC

           IF WS-RESP NOT EQUAL DFHRESP(NORMAL)
               DISPLAY 'Je suis dans GET Container problème'
      *        Set up the Error message for the response
               MOVE 'App Internal Error: Get Container'
                   TO responseMessage OF messageOutput1
      *        Put the response in a container on the channel
      *         EXEC CICS PUT CONTAINER('PBOOK-OUTPUT1')
      *                  FROM(messageOutput1)
      *         END-EXEC
      *        Return to the web service layer to send the response
               EXEC CICS RETURN END-EXEC
           END-IF

      *---------------------------------------------------------------*
      * On regarde quelle action est demand©e                         *
      *---------------------------------------------------------------*
           INITIALIZE CONTAINER-PBOOK-OUTPUT1
           INITIALIZE CONTAINER-PBOOK-OUTPUT2
           INITIALIZE WORKING-VARIABLES
           INITIALIZE CONTACT-DETAILS

           MOVE FUNCTION UPPER-CASE(command OF messageInput)
                 TO command OF messageInput

           EVALUATE command OF messageInput
               WHEN 'DISPLAY '
      *        Call routine to perform
                   PERFORM DISPLAY-CONTACT

               WHEN 'UPDATE'
      *        Call routine to perform
                   PERFORM UPDATE-CONTACT

               WHEN 'DELETE'
      *        Call routine to perform
                   PERFORM DELETE-CONTACT

               WHEN 'CREATE'
      *        Call routine to perform
                   PERFORM CREATE-CONTACT

               WHEN 'SHOW-50'
      *        Call routine to perform
                   PERFORM SHOW-50-CONTACTS

               WHEN OTHER
      *        Request is not recognised or supported
                   PERFORM REQUEST-NOT-RECOGNISED

           END-EVALUATE

      * Return to caller
           EXEC CICS RETURN END-EXEC.

      *----------------------------------------------------------------*
      * On recherche 1 contact                                         *
      *----------------------------------------------------------------*
       DISPLAY-CONTACT SECTION.
           INITIALIZE CONTACT-DETAILS
           MOVE lastName OF messageInput TO KeyLastname

           EXEC SQL
               SELECT LASTNAME,
                      FIRSTNAME,
                      PHONE,
                      ZIPCODE
               INTO  :C-Lastname,
                     :C-Firstname,
                     :C-Phone,
                     :C-zipCode
               FROM CONTACTS
                 WHERE LASTNAME = :KeyLastname
           END-EXEC.

           Evaluate SQLCODE
             When 0
               MOVE 'ah ah ... Trouvé !' TO responseMessage
                 OF messageOutput1
               MOVE C-Lastname  TO lastName of messageOutput1
               MOVE C-Firstname TO firstName of messageOutput1
               MOVE C-Phone     TO telExtension of messageOutput1
               MOVE C-zipCode   TO zipCode of messageOutput1
               MOVE command of messageInput TO command of messageOutput1
             When 100
      * 100 = successful mais pas de ligne retourn©e
               MOVE 'Inconnu au bataillon !' TO responseMessage
                 OF messageOutput1
               MOVE command of messageInput TO command of messageOutput1
               PERFORM DISPLAY-SQL-CODE
             When Other
               MOVE 'Snif: problÛme !' TO responseMessage
                 OF messageOutput1
               PERFORM DISPLAY-SQL-CODE
           END-Evaluate.

      *     MOVE 'Phonebook-display' TO responseMessage OF messageOutput1
           EXEC CICS PUT CONTAINER('PBOOK-OUTPUT1')
                     FROM(messageOutput1)
           END-EXEC

           EXIT.

      *----------------------------------------------------------------*
      * On update 1 contact                                            *
      *----------------------------------------------------------------*
       UPDATE-CONTACT SECTION.
           MOVE lastName OF messageInput TO KeyLastname
           MOVE firstName OF messageInput TO C-Firstname
           MOVE telExtension OF messageInput TO C-Phone
           MOVE zipCode OF messageInput TO C-zipCode
           EXEC SQL UPDATE CONTACTS SET
              FIRSTNAME = :C-Firstname,
              PHONE = :C-Phone,
              ZIPCODE = :C-zipCode
              WHERE LASTNAME = :KeyLastname
           END-EXEC

           Evaluate SQLCODE
             When 0
               MOVE 'C''est fait !' TO responseMessage
                 OF messageOutput1
               MOVE KeyLastname TO lastName of messageOutput1
               MOVE C-Firstname TO firstName of messageOutput1
               MOVE C-Phone     TO telExtension of messageOutput1
               MOVE C-zipCode   TO zipCode of messageOutput1
               MOVE command of messageInput TO command of messageOutput1
             When 100
      * 100 = successful mais pas de ligne retourn©e
               MOVE 'Inconnu au bataillon !' TO responseMessage
                 OF messageOutput1
               MOVE command of messageInput TO command of messageOutput1
               PERFORM DISPLAY-SQL-CODE
             When Other
               MOVE 'Snif: problème !' TO responseMessage
                 OF messageOutput1
               PERFORM DISPLAY-SQL-CODE
           END-Evaluate.

           EXEC CICS PUT CONTAINER('PBOOK-OUTPUT1')
                     FROM(messageOutput1)
           END-EXEC
           EXIT.

      *----------------------------------------------------------------*
      * On delete 1 contact                                            *
      *----------------------------------------------------------------*
       DELETE-CONTACT SECTION.
           MOVE lastName OF messageInput TO C-Lastname
      * On r©cupÛre d'abord tous les attributs pour archivage
           EXEC SQL
               SELECT LASTNAME,
                      FIRSTNAME,
                      PHONE,
                      ZIPCODE
               INTO  :C-Lastname,
                     :C-Firstname,
                     :C-Phone,
                     :C-zipCode
               FROM CONTACTS
                 WHERE LASTNAME = :C-Lastname
           END-EXEC.
      * On delete
           EXEC SQL DELETE FROM CONTACTS WHERE LASTNAME = :C-Lastname
           END-EXEC

           Evaluate SQLCODE
             When 0
               MOVE 'C''est fait !' TO responseMessage
                 OF messageOutput1
               MOVE C-Lastname  TO lastName of messageOutput1
               MOVE C-Firstname TO firstName of messageOutput1
               MOVE C-Phone     TO telExtension of messageOutput1
               MOVE C-zipCode   TO zipCode of messageOutput1
               MOVE command of messageInput TO command of messageOutput1
               PERFORM CALL-API
             When 100
      * 100 = successful mais pas de ligne retourn©e
               MOVE 'Inconnu au bataillon !' TO responseMessage
                 OF messageOutput1
               MOVE command of messageInput TO command of messageOutput1
               PERFORM DISPLAY-SQL-CODE
             When Other
               MOVE 'Snif: problème !' TO responseMessage
                 OF messageOutput1
               PERFORM DISPLAY-SQL-CODE
           END-Evaluate.

           EXEC CICS PUT CONTAINER('PBOOK-OUTPUT1')
                     FROM(messageOutput1)
           END-EXEC
           EXIT.

      *----------------------------------------------------------------*
      * Call API Requester
      *----------------------------------------------------------------*
       CALL-API SECTION.
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
           EXIT.

       B-INIT SECTION.
       B-010.
      * Initialise the Host API
      * Set user credentials
           MOVE BAQZ-SERVER-USERNAME
             TO BAQ-ZCON-PARM-NAME OF BAQ-ZCON-PARMS(1)
           SET BAQ-ZCON-PARM-ADDRESS OF BAQ-ZCON-PARMS(1)
             TO ADDRESS OF MY-USER
           MOVE LENGTH OF MY-USER
             TO BAQ-ZCON-PARM-LENGTH OF BAQ-ZCON-PARMS(1)
           MOVE BAQZ-SERVER-PASSWORD
             TO BAQ-ZCON-PARM-NAME OF BAQ-ZCON-PARMS(2)
           SET BAQ-ZCON-PARM-ADDRESS OF BAQ-ZCON-PARMS(2)
             TO ADDRESS OF MY-PSWD
           MOVE LENGTH OF MY-PSWD
             TO BAQ-ZCON-PARM-LENGTH OF BAQ-ZCON-PARMS(2).
      * Make the BAQINIT call

           CALL BAQ-INIT-NAME USING BY REFERENCE BAQ-ZCONNECT-AREA.

      * Check for bad initialization
           IF NOT BAQ-SUCCESS THEN
              MOVE BAQ-ZCON-COMPLETION-CODE TO WS-CC9
              MOVE BAQ-ZCON-REASON-CODE TO WS-RC9
              DISPLAY EIBTRNID ' INIT Completion Code : ' WS-CC9
              DISPLAY EIBTRNID ' INIT Reason Code     : ' WS-RC9
              DISPLAY BAQ-ZCON-RETURN-MESSAGE
              MOVE 'ErrorAPI' TO command of messageOutput1
              MOVE BAQ-ZCON-RETURN-MESSAGE TO responseMessage
                 OF messageOutput1
      *        STOP RUN
           END-IF.

       B-999.
           EXIT.

       C-PROCESS SECTION.
       C-010.
      * Prepare the request for sending
           MOVE 1 TO lastName-existence of requestBody.
           MOVE C-Lastname TO lastName2 of requestBody.
           MOVE LENGTH OF lastName2 of requestBody
                       TO lastName2-length of requestBody.

           MOVE 1 TO firstName-existence of requestBody.
           MOVE C-Firstname TO firstName2 of requestBody.
           MOVE LENGTH OF firstName2 of requestBody
                       TO firstName2-length of requestBody.

           MOVE 1 TO telExtension-existence of requestBody.
           MOVE C-Phone  TO telExtension2 of requestBody.
           MOVE LENGTH OF telExtension2 of requestBody
                       TO telExtension2-length of requestBody.

           MOVE 1 TO zipCode-existence of requestBody.
           MOVE C-zipCode TO zipCode2 of requestBody.
           MOVE LENGTH OF zipCode2 of requestBody
                       TO zipCode2-length of requestBody.

      *     SET WS-API-INFO TO ADDRESS OF BAQ-API-INFO-RBK02I01.
           SET BAQ-REQ-BASE-ADDRESS TO ADDRESS OF BAQBASE-API00Q01.
           MOVE LENGTH OF BAQBASE-API00Q01 TO BAQ-REQ-BASE-LENGTH.

      *     DISPLAY 'longeur input data : ' BAQ-REQ-BASE-LENGTH.
      *     DISPLAY 'lastname : ' lastName2 of requestBody.
      *     DISPLAY 'firstname : ' firstName2 of requestBody.

       C-020.
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
              DISPLAY EIBTRNID ' EXEC Completion Code : ' WS-CC9
              DISPLAY EIBTRNID ' EXEC Reason Code     : ' WS-RC9
              DISPLAY BAQ-ZCON-RETURN-MESSAGE
              MOVE 'ErrorAPI' TO command of messageOutput1
              MOVE BAQ-ZCON-RETURN-MESSAGE TO responseMessage
                 OF messageOutput1
      *        STOP RUN
           END-IF.

       C-030.
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
                       MOVE 'ARCHIVED' TO command OF messageOutput1
                       MOVE Xid2 TO responseMessage OF messageOutput1
                 END-IF

              END-IF
      *    ELSE
      * On est dans le cas ou nous n'avons pas pu faire l'archivage
      * du contact
      *    EXEC CICS ABEND ABCODE('BCDE')      
           END-IF.

       C-999.
           EXIT.

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
       X-TERM SECTION.
       X-010.
      * Terminate the connection
           CALL BAQ-TERM-NAME USING BY REFERENCE BAQ-ZCONNECT-AREA.

           IF NOT BAQ-SUCCESS THEN
              MOVE BAQ-ZCON-COMPLETION-CODE TO WS-CC9
              MOVE BAQ-ZCON-REASON-CODE TO WS-RC9
              DISPLAY ' TERM Completion Code ' WS-CC9
              DISPLAY ' TERM Reason Code ' WS-RC9
              DISPLAY BAQ-ZCON-RETURN-MESSAGE
           END-IF.
           DISPLAY 'Je suis à la fin du TERM : X-TERM'.
      * BAQH2006S: The call to BAQTERM to terminate the Host API failed
      * unexpectedly. Service ID=34210048 Service Code=1048577
       X-999.
           EXIT.
      *----------------------------------------------------------------*
      * End of API Requester call                                      *
      *----------------------------------------------------------------*

      *----------------------------------------------------------------*
      * On crée 1 contact                                              *
      *----------------------------------------------------------------*
       CREATE-CONTACT SECTION.
           MOVE lastName OF messageInput TO C-Lastname
           MOVE firstName OF messageInput TO C-Firstname
           MOVE telExtension OF messageInput TO C-Phone
           MOVE zipCode OF messageInput TO C-zipCode
           EXEC SQL INSERT INTO CONTACTS (
                LASTNAME,
                FIRSTNAME,
                PHONE,
                ZIPCODE)
                VALUES (:C-Lastname,
                :C-Firstname,
                :C-Phone,
                :C-zipCode)
                END-EXEC

           Evaluate SQLCODE
             When 0
               MOVE 'C''est fait !' TO responseMessage
                 OF messageOutput1
               MOVE C-Lastname  TO lastName of messageOutput1
               MOVE C-Firstname TO firstName of messageOutput1
               MOVE C-Phone     TO telExtension of messageOutput1
               MOVE C-zipCode   TO zipCode of messageOutput1
               MOVE command of messageInput TO command of messageOutput1
             When 100
      * 100 = successful mais pas de ligne retourn©e
               MOVE 'Inconnu au bataillon !' TO responseMessage
                 OF messageOutput1
               MOVE command of messageInput TO command of messageOutput1
               PERFORM DISPLAY-SQL-CODE
             When Other
               MOVE 'Snif: problÛme !' TO responseMessage
                 OF messageOutput1
               PERFORM DISPLAY-SQL-CODE
           END-Evaluate.

           EXEC CICS PUT CONTAINER('PBOOK-OUTPUT1')
                     FROM(messageOutput1)
           END-EXEC
           EXIT.

      *----------------------------------------------------------------*
      * On recherche 50 contacts                                       *
      *----------------------------------------------------------------*
       SHOW-50-CONTACTS SECTION.
           INITIALIZE CONTACT-DETAILS
           SET  OUT-REC-IDX        TO 1
           MOVE lastName OF messageInput TO KeyLastname

           EXEC SQL DECLARE SHOW50-CURS CURSOR FOR
              SELECT LASTNAME,
                     FIRSTNAME,
                     PHONE,
                     ZIPCODE
               FROM CONTACTS WHERE LASTNAME > :KeyLastname LIMIT 50
           END-EXEC

           EXEC SQL
              OPEN SHOW50-CURS
           END-EXEC

           PERFORM UNTIL (SQLCODE NOT = 0)
                         OR (numberOfContacts >= 50)
              EXEC SQL
                 FETCH SHOW50-CURS
                  INTO :C-Lastname,
                       :C-Firstname,
                       :C-Phone,
                       :C-zipCode
              END-EXEC
              IF SQLCODE = 0
                 MOVE CONTACT-DETAILS TO contacts-50(OUT-REC-IDX)
                 SET  OUT-REC-IDX   UP BY 1
              END-IF
           END-PERFORM

           EVALUATE SQLCODE
              WHEN 0
                SET  OUT-REC-IDX  DOWN BY 1
                SET  numberOfContacts TO OUT-REC-IDX
                IF numberOfContacts >= 50
                    MOVE 'Il en reste encore'  TO responseMessage
                  OF messageOutput2
                ELSE
                    MOVE 'Fin de Liste - 2' TO responseMessage
                  OF messageOutput2
                END-IF
              WHEN +100
                 IF OUT-REC-IDX > 1
                    SET OUT-REC-IDX  DOWN BY 1
                    SET numberOfContacts TO OUT-REC-IDX
                    SET NUMTOSTRING9 TO OUT-REC-IDX
                 END-IF
                 STRING NUMTOSTRINGX DELIMITED BY SPACE
                       ' contact(s) trouvé(es)' DELIMITED BY SIZE
                  INTO responseMessage OF messageOutput2
              WHEN OTHER
                 DISPLAY 'SHOW50-CONTACTS - BAD SQLCODE : '
                 PERFORM DISPLAY-SQL-CODE
           END-EVALUATE

           EXEC SQL
              CLOSE SHOW50-CURS
           END-EXEC

      *     MOVE command of messageInput TO command of messageOutput2

           EXEC CICS ASSIGN
               USERID(UserID)
           END-EXEC 
           DISPLAY "UserID : " UserID 
           MOVE UserID TO command of messageOutput2

           EXEC CICS PUT CONTAINER('PBOOK-OUTPUT2')
                     FROM(messageOutput2)
           END-EXEC

           EXIT.

      *----------------------------------------------------------------*
      * On signale que la commande in-command est inconnue             *
      *----------------------------------------------------------------*
       REQUEST-NOT-RECOGNISED SECTION.
      * Start to work
           MOVE command of messageInput TO command of messageOutput1
           MOVE 'Action non reconnue'
                TO responseMessage OF messageOutput1
      * Put the response in a container on the channel
           EXEC CICS PUT CONTAINER('PBOOK-OUTPUT1')
                    FROM(messageOutput1)
           END-EXEC
      * Exit to send the response
           EXIT.

      *----------------------------------------------------------------*
      * On affiche le code erreur SQL                                  *
      *----------------------------------------------------------------*
       DISPLAY-SQL-CODE SECTION.
           MOVE SQLCODE TO DISP-SQLCODE
           DISPLAY 'SQLCODE  : ' DISP-SQLCODE
           DISPLAY 'SQLSTATE : ' SQLSTATE
           DISPLAY 'SQLERRML : ' SQLERRML
           DISPLAY 'SQLERRMC : ' SQLERRMC

           EXIT.
