       IDENTIFICATION DIVISION.
       PROGRAM-ID. cou_char.
       AUTHOR.     Terry.

       DATA DIVISION.
       LINKAGE SECTION.

       01  LK-NOM        PIC X(20).
       01  LK-COUNT      PIC 9(02).
       
       PROCEDURE DIVISION USING LK-NOM LK-COUNT.

           MOVE LENGTH OF FUNCTION TRIM(LK-NOM) TO LK-COUNT.

           DISPLAY LK-COUNT.
       
           END PROGRAM cou_char.
           
