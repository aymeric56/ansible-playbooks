      ******************************************************************
      *INPUT/OUTPUT MESSAGE AREA FOR NEW TABLES
      ******************************************************************

      ******************************************************************
      * DATA AREA FOR TRANSACTION INPUT
      ******************************************************************
       01 INPUT-MSG-UNITAIRE.
          05 IN-LL                  PIC S9(4) COMP-5.
          05 IN-ZZ                  PIC S9(4) COMP-5.
          05 IN-TRANCDE             PIC X(10).
          05 IN-COMMAND             PIC X(8).
          05 IN-RECORD              PIC X(1110).
      * PERSPECTIVE
          05 IN-RECORD-PERSP REDEFINES IN-RECORD.
               07 IN-PERSP-ID         PIC 9(10).
               07 IN-PERSP-NAME       PIC X(150).
               07 IN-PERSP-DES        PIC X(150).
               07 FILLER              PIC X(800).
      * OBJECTIF
          05 IN-RECORD-OBJ REDEFINES IN-RECORD.
               07 IN-OBJ-ID           PIC 9(10).
               07 IN-OBJ-NAME         PIC X(150).
               07 INO-PERSP-ID         PIC 9(10).
               07 FILLER              PIC X(940).
      * LEVIER
          05 IN-RECORD-LEV REDEFINES IN-RECORD.
               07 IN-LEV-ID           PIC 9(10).
               07 IN-LEV-NAME         PIC X(150).
               07 IN-OBJ-ID           PIC 9(10).
               07 FILLER              PIC X(940).
      * INDICATEUR
          05 IN-RECORD-IND REDEFINES IN-RECORD.
               07 IN-LEV-ID           PIC 9(10).
               07 IN-IND-EXEMPLE      PIC X(150).
               07 IN-IND-ID           PIC 9(10).
               07 IN-IND-DEFINITION   PIC X(150).
               07 IN-IND-NATURE       PIC X(20).
               07 IN-IND-MESURABLE    PIC 9(4).
               07 IN-IND-SCOPE        PIC X(20).
               07 IN-IND-TYPE         PIC X(20).
               07 IN-IND-SOURCE       PIC X(255).
               07 FILLER              PIC X(1).

      ******************************************************************
      * DATA AREA FOR TRANSACTION OUTPUT
      ******************************************************************
       01 OUTPUT-MSG-UNITAIRE.
          05 OUT-LL                 PIC S9(4) COMP-5.
          05 OUT-ZZ                 PIC S9(4) COMP-5.
          05 OUT-MESSAGE            PIC X(40).
          05 OUT-RECORD             PIC X(1110).
      * PERSPECTIVE
          05 OUT-RECORD-PERSP REDEFINES OUT-RECORD.
               07 OUT-PERSP-ID        PIC 9(10).
               07 OUT-PERSP-NAME      PIC X(150).
               07 OUT-PERSP-DES       PIC X(150).
               07 FILLER              PIC X(800).
      * OBJECTIF
          05 OUT-RECORD-OBJ REDEFINES OUT-RECORD.
               07 OUT-OBJ-ID          PIC 9(10).
               07 OUT-OBJ-NAME        PIC X(150).
               07 OUT-PERSP-ID        PIC 9(10).
               07 FILLER              PIC X(940).
      * LEVIER
          05 OUT-RECORD-LEV REDEFINES OUT-RECORD.
               07 OUT-LEV-ID          PIC 9(10).
               07 OUT-LEV-NAME        PIC X(150).
               07 OUT-OBJ-ID          PIC 9(10).
               07 FILLER              PIC X(940).
      * INDICATEUR
          05 OUT-RECORD-IND REDEFINES OUT-RECORD.
      *        07 OUT-PERSP-NAME      PIC X(150).
      *         07 OUT-PERSP-ID        PIC 9(10).
      *         07 OUT-OBJ-NAME        PIC X(150).
      *         07 OUT-OBJ-ID          PIC 9(10).
      *         07 OUT-LEV-NAME        PIC X(150).
               07 OUT-LEV-ID          PIC 9(10).
               07 OUT-IND-EXEMPLE     PIC X(150).
               07 OUT-IND-ID          PIC 9(10).
               07 OUT-IND-DEFINITION  PIC X(150).
               07 OUT-IND-NATURE      PIC X(20).
               07 OUT-IND-MESURABLE   PIC 9(4).
               07 OUT-IND-SCOPE       PIC X(20).
               07 OUT-IND-TYPE        PIC X(20).
               07 OUT-IND-SOURCE      PIC X(255).
               07 FILLER              PIC X(471).


      ******************************************************************
      * DATA AREA FOR TRANSACTION OUTPUT - MULTIPLE RECORDS (50 MAX)
      ******************************************************************
       01 OUTPUT-MSG-50.
          05 OUT-LL-50                PIC S9(4) COMP-5.
          05 OUT-ZZ-50                PIC S9(4) COMP-5.
          05 OUT-MESSAGE-50           PIC X(40).
          05 OUT-NUM-RECORDS          PIC S9(3).
          05 OUT-RECORDS-50           PIC X(32000).

      * PERSPECTIVE
          05 OUT-RECORD-PERSP-OUT-50 REDEFINES OUT-RECORDS-50.
             07 OUT-RECORD-PERSP-50    OCCURS 50 TIMES
                                       INDEXED BY OUT-IDX-50.
                   09 OUT-PERSP-ID-REC        PIC 9(10).
                   09 OUT-PERSP-NAME-REC      PIC X(150).
                   09 OUT-PERSP-DES-REC       PIC X(150).
             07 FILLER                 PIC X(16500).

      * OBJECTIF
          05 OUT-RECORD-OBJ-OUT-50 REDEFINES OUT-RECORDS-50.
             07 OUT-RECORD-OBJ-50    OCCURS 50 TIMES
                                       INDEXED BY OUT-IDX-50.
                09 OUT-OBJ-ID-REC          PIC 9(10).
                09 OUT-OBJ-NAME-REC        PIC X(150).
                09 OUT-PERSP-ID-REC        PIC 9(10).
             07 FILLER                     PIC X(23500).

      * LEVIER
          05 OUT-RECORD-LEV-OUT-50 REDEFINES OUT-RECORDS-50.
            07 OUT-RECORD-LEV-50    OCCURS 50 TIMES
                                       INDEXED BY OUT-IDX-50.
                09 OUT-LEV-ID-REC          PIC 9(10).
                09 OUT-LEV-NAME-REC        PIC X(150).
                09 OUT-OBJ-ID-REC          PIC 9(10).
            07 FILLER                         PIC X(23500).

      * INDICATEUR
          05 OUT-RECORD-IND-OUT-50 REDEFINES OUT-RECORDS-50.
            07 OUT-RECORD-IND-50    OCCURS 50 TIMES
                                       INDEXED BY OUT-IDX-50.
                09 OUT-LEV-ID-REC          PIC 9(10).
                09 OUT-IND-EXEMPLE-REC     PIC X(150).
                09 OUT-IND-ID-REC          PIC 9(10).
                09 OUT-IND-DEFINITION-REC  PIC X(150).
                09 OUT-IND-NATURE-REC      PIC X(20).
                09 OUT-IND-MESURABLE-REC   PIC 9(4).
                09 OUT-IND-SCOPE-REC       PIC X(20).
                09 OUT-IND-TYPE-REC        PIC X(20).
                09 OUT-IND-SOURCE-REC      PIC X(255).
            07 FILLER                     PIC X(150).


      ******************************************************************
      * CATALOGUE ENTIER
      ****************************************************************

      * COPYBOOK POUR LA STRUCTURE ARBORESCENTE

       01 CAT-OUTPUT-MSG.
          05 OUT-CAT-LL                     PIC S9(4) COMP-5.
          05 OUT-CAT-ZZ                     PIC S9(4) COMP-5.
          05 OUT-CAT-MESSAGE                PIC X(40).
          05 NB-PERSP                      PIC 9(4).
          05 NB-OBJ-MAX                    PIC 9(4).
          05 NB-LEV-MAX                    PIC 9(4).
          05 NB-IND-MAX                    PIC 9(4).
          05 PERSP-TAB OCCURS 0 TO 20 TIMES DEPENDING ON NB-PERSP.
              07 PERSP-ID                 PIC 9(10).
              07 PERSP-NAME               PIC X(150).
              07 PERSP-DESC               PIC X(150).
              07 NB-OBJ                   PIC 9(4).
              07 OBJ OCCURS 0 TO 20 TIMES DEPENDING ON NB-OBJ-MAX.
                 09 OBJ-ID                PIC 9(10).
                 09 OBJ-NAME              PIC X(150).
                 09 NB-LEV                PIC 9(4).
                 09 LEV OCCURS 0 TO 20 TIMES DEPENDING ON NB-LEV-MAX.
                    11 LEV-ID             PIC 9(10).
                    11 LEV-NAME           PIC X(150).
                    11 NB-IND             PIC 9(4).
                    11 IND OCCURS 0 TO 20 TIMES DEPENDING ON NB-IND-MAX.
                       13 IND-ID          PIC 9(10).
                       13 IND-NAME        PIC X(150).
                       13 IND-DEFINITION  PIC X(150).
                       13 IND-NATURE      PIC X(20).
                       13 IND-MESURABLE   PIC 9(4).
                       13 IND-PERIMETRE   PIC X(20).
                       13 IND-TYPE        PIC X(20).
                       13 IND-SOURCE      PIC X(255).
