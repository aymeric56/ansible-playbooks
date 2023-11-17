      *****************************************************************
      *                                                               *
      * CONTROL BLOCK NAME = DFH0XCP1                                 *
      *                                                               *
      * DESCRIPTIVE NAME = CICS TS  (Samples) Example Application -   *
      *                     Main copybook for example application     *
      *                                                               *
      *                                                               *
      *                                                               *
      *      Licensed Materials - Property of IBM                     *
      *                                                               *
      *      "Restricted Materials of IBM"                            *
      *                                                               *
      *      5655-Y04                                                 *
      *                                                               *
      *      (C) Copyright IBM Corp. 2004"                            *
      *                                                               *
      *                                                               *
      *                                                               *
      *                                                               *
      * STATUS = 7.1.0                                                *
      *                                                               *
      * FUNCTION =                                                    *
      *      This copy book is part of the example application and    *
      *      defines the commarea interface to the catalog manager    *
      *      module and the datastore modules                         *
      *                                                               *
      *      The fields are as follows                                *
      *                                                               *
      *        CA-REQUEST-ID            Identifies function           *
      *        CA-RETURN-CODE           Return Code                   *
      *        CA-RESPONSE-MESSAGE      Response message              *
      *        CA-REQUEST-SPECIFIC      Redefined for inquire/order   *
      *                                                               *
      *        CA-INQUIRE-REQUEST       Group for inquire of 15 items *
      *          CA-LIST-START-REF      Reference to start list from  *
      *          CA-LAST-ITEM-REF       Last item returned            *
      *          CA-ITEM-COUNT          Number of items returned      *
      *          CA-CAT-ITEM            Catalog item                  *
      *              CA-ITEM-REF        Item reference number         *
      *              CA-DESCRIPTION     Short description             *
      *              CA-DEPARTMENT      Department item belongs to    *
      *              CA-COST            Cost of item                  *
      *              IN-STOCK           Number of items in stock      *
      *              ON-ORDER           Number of items on order      *
      *                                                               *
      *        CA-INQUIRE-SINGLE        Structure for inquire single  *
      *          CA-ITEM-REF-REQ        Reference number of item      *
      *          CA-SINGLE-ITEM.                                      *
      *            CA-SNGL-ITEM-REF     Item reference number returned*
      *            CA-SNGL-DESCRIPTION  Short description             *
      *            CA-SNGL-DEPARTMENT   Department item belongs to    *
      *            CA-SNGL-COST         Cost of item                  *
      *            IN-SNGL-STOCK        Number of items in stock      *
      *            ON-SNGL-ORDER        Number of items on order      *
      *                                                               *
      *        CA-ORDER-REQUEST         Structure for placing an order*
      *          CA-USERID              User name placing the order   *
      *          CA-CHARGE-DEPT         Department user belongs to    *
      *          CA-ITEM-REF-NUMBER     Item reference to be ordered  *
      *          CA-QUANTITY-REQ        Quantity of item required     *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      * CHANGE ACTIVITY :                                             *
      *      $SEG(DFH0XCP1),COMP(SAMPLES),PROD(CICS TS ):             *
      *                                                               *
      *   PN= REASON REL YYMMDD HDXXIII : REMARKS                     *
      *   $D0= I07544 640 040910 HDIPCB  : EXAMPLE - BASE APPLICATION *
      *                                                               *
      *****************************************************************
      *    Catalogue COMMAREA structure
           03 CA-REQUEST-ID            PIC X(6).
           03 CA-RETURN-CODE           PIC 9(2).
           03 CA-RESPONSE-MESSAGE      PIC X(79).
      *    Fields used in Inquire Catalog
           03 CA-INQUIRE-REQUEST.
               05 CA-LIST-START-REF        PIC 9(4).
               05 CA-LAST-ITEM-REF         PIC 9(4).
               05 CA-ITEM-COUNT            PIC 9(3).
               05 CA-CAT-ITEM OCCURS 0 TO 15 TIMES 
                              DEPENDING ON CA-ITEM-COUNT.
                   07 CA-ITEM-REF          PIC 9(4).
                   07 CA-DESCRIPTION       PIC X(40).
                   07 CA-DEPARTMENT        PIC 9(3).
                   07 CA-COST              PIC X(6).
                   07 IN-STOCK             PIC 9(4).
                   07 ON-ORDER             PIC 9(3).
