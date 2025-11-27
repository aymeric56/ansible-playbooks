      ****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID RECASS00.
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
           10 T-CLE-ID-PERS        PIC 9(10).
           10 T-NOM                PIC X(64).
           10 T-PRENOM             PIC X(32).
           10 T-DATE_NAISS         PIC X(10).
           10 T-ADRESSE            PIC X(64).
           10 T-COD-POS-NAISS      PIC X(05).
           10 FILLER               PIC X(25).
       FD  FSYS020
           LABEL RECORD STANDARD
           RECORDING MODE IS F
           BLOCK 0 RECORDS.
       01  ENR-SYS020.
           10 O-CLE-ID-PERS        PIC 9(10).
           10 O-NOM                PIC X(64).
           10 O-PRENOM             PIC X(32).
           10 O-DATE_NAISS         PIC X(10).
           10 O-ADRESSE            PIC X(64).
           10 O-COD-POS-NAISS      PIC X(05).
           10 O-ID-ASSUR           PIC 9(10).
           10 O-LIBELLE            PIC X(32).
       WORKING-STORAGE SECTION.
      ******************************************************************
      * CONSTANTES DU PROGRAMME                                        *
      ******************************************************************

       COPY YESASSUR.
       77  C-TASSUR                               PIC X(09)
                                                  VALUE 'TASSUR00'.
       01  I-I                                    PIC 9(01).
       01  FIN-FICHIER                            PIC X(3) VALUE 'DEB'.

       PROCEDURE DIVISION.

           DISPLAY 'OPEN FSYS010'
           OPEN INPUT  FSYS010
           DISPLAY 'OPEN FSYS020'
           OPEN OUTPUT FSYS020

           SET ACCESS-LIST                        TO TRUE
           SET PREMIERE-LECTURE                   TO TRUE

           PERFORM UNTIL FIN-FICHIER = 'FIN'
              READ FSYS010
                AT END
                 MOVE 'FIN' TO FIN-FICHIER
                NOT AT END
                 DISPLAY 'Reading'
              END-READ

              MOVE T-CLE-ID-PERS TO CLE-ACCESS-LECTURE-SIM
              DISPLAY 'La cle:' T-CLE-ID-PERS
              CALL C-TASSUR USING ENTREE SORTIE
              END-CALL
              DISPLAY 'NB poste Liste:' NB-POSTE-LISTE

              PERFORM VARYING I-I FROM 1 BY 1 UNTIL I-I > NB-POSTE-LISTE
                 MOVE T-CLE-ID-PERS TO O-CLE-ID-PERS
                 MOVE T-NOM TO O-NOM
                 MOVE T-PRENOM TO O-PRENOM
                 MOVE T-DATE_NAISS TO O-DATE_NAISS
                 MOVE T-ADRESSE TO O-ADRESSE
                 MOVE T-COD-POS-NAISS TO O-COD-POS-NAISS

                 MOVE T-ID_ASSUR(I-I) TO O-ID-ASSUR
                 MOVE T-LIBELLE(I-I) TO O-LIBELLE
                 WRITE ENR-SYS020
              END-PERFORM

           END-PERFORM

           DISPLAY 'CLOSE FSYS020'
           CLOSE FSYS020
           DISPLAY 'CLOSE FSYS010'
           CLOSE FSYS010

           GOBACK
           .
