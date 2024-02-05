//DB2PBDDL   JOB 0,'Aymeric',NOTIFY=&SYSUID.,CLASS=W,MSGCLASS=H
//*
//   EXPORT SYMLIST=*
//   SET SYS=DBC1,DB2PREF=DBC0CFG,DB2=DB2.V12
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
//*//STEP1    EXEC DDL
//*  CREATE DATABASE PBOOKDB
//*    STOGROUP SYSDEFLT
//*    BUFFERPOOL BP0
//*    CCSID EBCDIC;
//*//SYSIN     DD *
//*  CREATE TABLESPACE HACKATS
//*    IN PBOOKDB
//*    USING STOGROUP SYSDEFLT
//*              PRIQTY 20
//*              SECQTY 20
//*              ERASE NO
//*    LOCKSIZE PAGE LOCKMAX SYSTEM
//*    BUFFERPOOL BP0
//*    CLOSE NO
//*    CCSID EBCDIC;
//*
//*  COMMIT ;
//*/*
//*********************************************************************
//*
//*        STEP  2: CREATE SAMPLE TABLES
//*
//*********************************************************************
//*//         IF RC <= 4 THEN
//STEP2    EXEC DDL
//SYSIN     DD  *
    DELETE FROM HACKATHON.CONTACTS;
/*
//*  CREATE TABLE HACKATHON.CONTACTS
//*                (LASTNAME  CHAR(15)       NOT NULL,
//*                 FIRSTNAME CHAR(15)               ,
//*                 PHONE     CHAR(10)               ,
//*                 ZIPCODE   CHAR(07)               ,
//*                 EMAIL     CHAR(40)               ,
//*                 PRIMARY   KEY(LASTNAME))
//*         IN PBOOKDB.HACKATS
//*         CCSID EBCDIC;
//*
//*  CREATE UNIQUE INDEX HACKATHON.CONTACTSI
//*                   ON HACKATHON.CONTACTS
//*                       (LASTNAME ASC)
//*                   USING STOGROUP SYSDEFLT
//*                             PRIQTY 12
//*                             ERASE NO
//*                   BUFFERPOOL BP0
//*                   CLOSE NO;
//*
//*  COMMIT ;
//*/*
//*//         ENDIF
//*********************************************************************
//*
//*        STEP  3: GRANT AUTHORITY
//*
//*********************************************************************
//*//         IF RC <= 4 THEN
//*//STEP3    EXEC DDL
//*//SYSIN     DD  *
//*  GRANT DBADM ON DATABASE PBOOKDB TO PUBLIC;
//*  GRANT USE OF TABLESPACE PBOOKDB.HACKATS TO PUBLIC;
//*  GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE HACKATHON.CONTACTS
//*        TO PUBLIC;
//*//         ENDIF
//*********************************************************************
//*
//*        STEP  4: LOAD DATA INTO SAMPLE PROGRAM TABLES
//*
//*********************************************************************
//*//         IF RC <= 4 THEN
//STEP4    EXEC DSNUPROC,
//             SYSTEM=&SYS,LIB=&DB2..SDSNLOAD
//SORTOUT   DD UNIT=SYSDA,SPACE=(CYL,(5,5))
//SYSUT1    DD UNIT=SYSDA,SPACE=(CYL,(5,5))
//SYSIN     DD  *
  LOAD DATA INDDN(CONTACTS)
       INTO TABLE HACKATHON.CONTACTS
            (LASTNAME  POSITION(  1) CHAR(15),
             FIRSTNAME POSITION( 16) CHAR(15),
             PHONE     POSITION( 31) CHAR(10),
             ZIPCODE   POSITION( 41) CHAR(07),
             EMAIL     POSITION( 48) CHAR(30),)
       SORTDEVT SYSDA SORTNUM 4
/*
//CONTACTS  DD *
Zidane         Zinedine       2-123-151175000  zinedine.zidane@gmail.com      
Henry          Thierry        4-321-1211D01/R01henry.thierry@gmail.com        
Mbappé         Kylian         9-121-5411D01/R01mbappe.kylian@gmail.com        
Platini        Michel         8-131-1111D01/R08platini.michel@gmail.com       
Vieira         Patrick        8-111-1161D01/R01vieira.patrick@gmail.com       
Ribéry         Franck         4-181-1111D01/O07ribery.franck@gmail.com        
Cantona        Eric           8-852-111169000  cantona.eric@gmail.com         
Kanté          N'golo         8-191-1111D01/R01kante.ngolo@gmail.com          
Desailly       Marcel         2-111-1141D01/R01desailly.marcel@gmail.com      
Pirès          Robert         8-171-111185000  pires.robert@gmail.com         
Griezmann      Antoine        8-951-1111D01/R01griezmann.antoine@gmail.com    
Makélélé       Claude         1-141-8511D01/P01makelele.claude@gmail.com      
Deschamps      Didier         8-963-1145D01/R01deschamps.didier@gmail.com     
Petit          Emmanuel       6-131-1211D01/R01petit.emmanuel@gmail.com       
Blanc          Laurent        5-121-1111D01/R01blanc.laurent@gmail.com        
Giroud         Olivier        8-161-181134000  giroud.olivier@gmail.com       
Lizarazu       Bixente        6-168-118964000  lizarazu.bixente@gmail.com     
Pogba          Paul           2-181-1541D01/R01pogba.paul@gmail.com           
Papin          Jean-Pierre    8-198-1148D01/R01papin.jeanpierre@gmail.com     
/*
//*//         ENDIF