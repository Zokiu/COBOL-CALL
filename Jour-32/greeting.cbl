       IDENTIFICATION DIVISION.
       PROGRAM-ID. greeting.
       AUTHOR.     Terry.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       
       01  WS-COUNT     PIC 9(02).

       LINKAGE SECTION.

       01  LK-NOM        PIC X(20).
       01  LK-REPONSE    PIC X(30).

       PROCEDURE DIVISION USING LK-NOM LK-REPONSE.
           
           CALL "cou_char" USING LK-NOM WS-COUNT.
           

           STRING "Hello" 
                  SPACE 
                  LK-NOM(1 : WS-COUNT) 
                  SPACE 
                  "!" 
                                            INTO LK-REPONSE.

           END PROGRAM greeting.
