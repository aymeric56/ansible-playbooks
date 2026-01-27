//RUNPGM JOB MSGLEVEL=1,REGION=0M,NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H
//*
//JOBLIB   DD DSN=ENSISA.EXEC.LOAD,DISP=SHR
//*
//*
//* Etape 1 : Suppression au pr‚alable du fichier
//*
//DELETE  EXEC PGM=IEFBR14
//DD1     DD DSN=ENSISA.TPBATCH.xxx,
//        DISP=(MOD,DELETE,DELETE),
//        UNIT=SYSALLDA,SPACE=(CYL,10)
//*
//* Etape 2 : Run du programme avec les bons paramŠtres d'entr‚e/sortie
//*
//RUNPGM1 EXEC PGM=pgm
//SYSPRINT DD   SYSOUT=*
//SYSOUT   DD   SYSOUT=*,OUTLIM=1000
//SYS010   DD   DISP=SHR,DSN=ENSISA.SAVE.FICPRJ.PRJ11
//SYS020   DD   DSN=ENSISA.TPBATCH.xxx,
//              DISP=(NEW,CATLG,DELETE),
//              UNIT=SYSDA,SPACE=(CYL,(5,1)),
//              DCB=(RECFM=F,LRECL=200,BLKSIZE=0)
