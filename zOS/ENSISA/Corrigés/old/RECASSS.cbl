      ****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID RECASSS .
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-370.
       OBJECT-COMPUTER. IBM-370.
       SPECIAL-NAMES.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT FSYS010 ASSIGN TO UT-S-SYS010.
           SELECT FSYS020 ASSIGN TO UT-S-SYS020.
       DATA DIVISION.
       FILE SECTION.
       FD  FSYS010
           LABEL RECORD STANDARD
           RECORDING MODE IS F
           BLOCK 0 RECORDS.
       01  ENR-SYS010.
           05  CLIENT-ID                          PIC 9(10).
           05  CLIENT-NAME-DEC                    PIC X(96).
           05  CLIENT-INFO-DEC                    PIC X(79).
       FD  FSYS020
           LABEL RECORD STANDARD
           RECORDING MODE IS F
           BLOCK 0 RECORDS.
       01  ENR-SYS020.
           05  PART-CLIENT1                       PIC X(10).
           05  PART-CLIENT2                       PIC X(96).
           05  PART-ASSURANCE1                    PIC X(10).
           05  PART-ASSURANCE2                    PIC X(32).
           05  FILLER                             PIC X(62).
       WORKING-STORAGE SECTION.
      ******************************************************************
      * CONSTANTES DU PROGRAMMES                                       *
      ******************************************************************

       COPY YESASSUR.
       77  C-TPERSPGM                             PIC X(09)
                                                  VALUE 'TASSURS'.
       01  I-I                                    PIC 9(01).

       01  ETAT-FICHIER                           PIC X(01).
           88  DEBUT-LECTURE                      VALUE 'D'.
           88  FIN-LECTURE-FICHIER                VALUE 'F'.


       PROCEDURE DIVISION.

      * FSYS010 : Fichier d'entr‚e de la liste des personnes
           OPEN INPUT FSYS010
      * Fichier de sortie avec les clients avec assurances
           OPEN OUTPUT FSYS020


           SET DEBUT-LECTURE                     TO TRUE

           READ FSYS010
              AT END
                 SET FIN-LECTURE-FICHIER              TO TRUE
           END-READ

           PERFORM UNTIL FIN-LECTURE-FICHIER

              SET ACCESS-LIST                        TO TRUE
              SET PREMIERE-LECTURE                   TO TRUE

              MOVE CLIENT-ID to CLE-ACCESS-LECTURE-LIS
              CALL C-TPERSPGM USING ENTREE SORTIE
              END-CALL

              IF NB-POSTE-LISTE > 0
                 PERFORM VARYING I-I FROM 1 BY 1 UNTIL
                                                 I-I > NB-POSTE-LISTE

                 DISPLAY 'CLIENT-ID : ' CLIENT-ID
                 DISPLAY 'I-I : ' I-I
                 DISPLAY 'ID_ASSUR : ' T-ID_ASSUR(I-I)
                 DISPLAY 'ID_PERS : ' T-ID_PERS(I-I)
                 DISPLAY 'LIBELLE : ' T-LIBELLE(I-I)

                 MOVE CLIENT-ID TO PART-CLIENT1
                 MOVE CLIENT-NAME-DEC TO PART-CLIENT2
                 MOVE T-ID_ASSUR(I-I) TO PART-ASSURANCE1
                 MOVE T-LIBELLE(I-I) TO PART-ASSURANCE2
                 WRITE ENR-SYS020

                 END-PERFORM

              END-IF


              READ FSYS010
                 AT END
                    SET FIN-LECTURE-FICHIER        TO TRUE
              END-READ

           END-PERFORM

           CLOSE FSYS020
           CLOSE FSYS010

           GOBACK
           .
