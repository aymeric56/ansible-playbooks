       01  ENTREE PIC X(500).
       01  FILLER REDEFINES ENTREE.
           05  PARTIE-FIXE-ALLER.
               10  TYPE-ACCESS PIC X(01).
                   88  ACCESS-SELECT VALUE 'S'.
                   88  ACCESS-LIST   VALUE 'L'.
                   88  ACCESS-INSERT VALUE 'I'.
                   88  ACCESS-ASSUR-LIST VALUE 'A'.
           05  PARTIE-VARIABLE-ALLER PIC X(499).
           05  ENTREE-FONCTION-LECTURE-SIMPLE REDEFINES
                PARTIE-VARIABLE-ALLER.
               10  CLE-ACCESS-LECTURE-SIM PIC 9(10).
           05 ENTREE-FONCTION-LECTURE-LISTE REDEFINES
              PARTIE-VARIABLE-ALLER.
              10  CLE-ACCESS-LECTURE-LIS PIC 9(10).
              10  CODE-FONCTION PIC X(05).
                  88  PREMIERE-LECTURE VALUE 'PLECT'.
                  88  LECTURE-SUIVANTE VALUE 'LSUIV'.
                  88  FIN-LECTURE      VALUE 'FLECT'.
           05  ENTREE-FONCTION-INSERT REDEFINES
                PARTIE-VARIABLE-ALLER.
               10  I-ID_ASSUR          PIC S9(9) COMP.
               10  I-ID_PERS           PIC S9(9) COMP.
               10  I-LIBELLE           PIC X(32).


      *
       01  SORTIE PIC X(1100).
       01  FILLER REDEFINES SORTIE.
           05  PARTIE-FIXE-RETOUR.
               10  CODE-RETOUR     PIC X(2).
                   88  RETOUR-OK   VALUE 'OK'.
                   88  RETOUR-KO   VALUE 'KO'.
               10  LIBELLE-ANOMALIE PIC X(98).
           05  PARTIE-VARIABLE-RETOUR    PIC X(1000).
           05  DONNEES-LECTURE-SIMPLE REDEFINES PARTIE-VARIABLE-RETOUR.
               10  S-ID_ASSUR         PIC S9(9) COMP.
               10  S-ID_PERS          PIC S9(9) COMP.
               10  S-LIBELLE          PIC X(32).
           05  DONNEES-LECTURE-LISTE REDEFINES PARTIE-VARIABLE-RETOUR.
               10  STATUT-SUITE    PIC X(10).
               88  FIN-LISTE-ATTEINTE  VALUE 'FIN LISTE '.
               88  LISTE-EN-COURS      VALUE 'LISTE ENCO'.
               10  NB-POSTE-LISTE  PIC 9(1).
               10  TABLEAU-DONNEES OCCURS 5.
                   15  T-ID_ASSUR          PIC S9(9) COMP.
                   15  T-ID_PERS           PIC S9(9) COMP.
                   15  T-LIBELLE           PIC X(32).
