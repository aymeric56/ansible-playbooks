//DB2PBDDL   JOB 0,'Aymeric',NOTIFY=&SYSUID.,CLASS=W,MSGCLASS=H
//*
//   EXPORT SYMLIST=*
//   SET SYS=DBC0,DB2PREF=DBC0CFG,DB2=DB2.V12
//*
//DDL      PROC
//DDL      EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT  DD SYSOUT=*
//SYSPRINT  DD SYSOUT=*
//SYSTSIN   DD *,SYMBOLS=EXECSYS
DSN SYSTEM(&SYS.)
RUN  PROGRAM(DSNTIAD) PLAN(DSNTIA12) -
      LIB('&DB2PREF..RUNLIB.LOAD')
/*
//         PEND
//*
//*********************************************************************
//*
//*        STEP  1: CREATE SAMPLE STORAGE GROUPS, TABLESPACES
//*
//*********************************************************************
//STEP1    EXEC DDL
//SYSIN     DD *
  CREATE DATABASE PBOOKDB
    STOGROUP SYSDEFLT
    BUFFERPOOL BP0
    CCSID EBCDIC;

  CREATE TABLESPACE PBOOKTS
    IN PBOOKDB
    USING STOGROUP SYSDEFLT
              PRIQTY 20
              SECQTY 20
              ERASE NO
    LOCKSIZE PAGE LOCKMAX SYSTEM
    BUFFERPOOL BP0
    CLOSE NO
    CCSID EBCDIC;

  COMMIT ;
//*
//*        STEP  2: CREATE SAMPLE TABLES
//*
//         IF RC <= 4 THEN
//STEP2    EXEC DDL
//SYSIN     DD  *

  CREATE TABLE PHONEBOOK.CONTACTS
                (LASTNAME  CHAR(10)       NOT NULL,
                 FIRSTNAME CHAR(10)               ,
                 PHONE     CHAR(10)               ,
                 ZIPCODE   CHAR(07)               ,
                 PRIMARY   KEY(LASTNAME))
         IN PBOOKDB.PBOOKTS
         CCSID EBCDIC;

  CREATE UNIQUE INDEX PHONEBOOK.CONTACTSI
                   ON PHONEBOOK.CONTACTS
                       (LASTNAME ASC)
                   USING STOGROUP SYSDEFLT
                             PRIQTY 12
                             ERASE NO
                   BUFFERPOOL BP0
                   CLOSE NO;

  COMMIT ;
//         ENDIF
//*
//*        STEP  3: GRANT AUTHORITY
//*
//         IF RC <= 4 THEN
//STEP3    EXEC DDL
//SYSIN     DD  *
  GRANT DBADM ON DATABASE PBOOKDB TO PUBLIC;
  GRANT USE OF TABLESPACE PBOOKDB.PBOOKTS TO PUBLIC;
  GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE PHONEBOOK.CONTACTS
        TO PUBLIC;
//         ENDIF
//*
//*
//*        STEP  4: LOAD DATA INTO SAMPLE PROGRAM TABLES
//*
//         IF RC <= 4 THEN
//STEP4    EXEC DSNUPROC,
//             SYSTEM=&SYS,LIB=&DB2..SDSNLOAD
//SORTOUT   DD UNIT=SYSDA,SPACE=(CYL,(5,5))
//SYSUT1    DD UNIT=SYSDA,SPACE=(CYL,(5,5))
//SYSIN     DD  *
  LOAD DATA INDDN(CONTACTS)
       INTO TABLE PHONEBOOK.CONTACTS
            (LASTNAME  POSITION(  1) CHAR(10),
             FIRSTNAME POSITION( 11) CHAR(10),
             PHONE     POSITION( 21) CHAR(10),
             ZIPCODE   POSITION( 31) CHAR(07))
       SORTDEVT SYSDA SORTNUM 4
//CONTACTS  DD *
LAST1     FIRST1    8-111-1111D01/R01
LAST2     FIRST2    8-111-2222D02/R02
LAST3     FIRST3    8-111-3333D03/R03
LAST4     FIRST4    8-111-4444D04/R04
LAST5     FIRST5    8-111-5555D05/R05
LAST6     FIRST6    8-111-6666D06/R06
AFFOUARD  AYMERIC   8-111-7777D07/R07
//         ENDIF