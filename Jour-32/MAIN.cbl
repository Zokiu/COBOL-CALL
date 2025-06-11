       IDENTIFICATION DIVISION.
       PROGRAM-ID.    MAIN.
       AUTHOR.        Terry.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       
       01  WS-NOM       PIC X(20) VALUE "SIMPLON".
       01  WS-REPONSE   PIC X(30).
       


       PROCEDURE DIVISION.

           CALL "greeting" USING WS-NOM WS-REPONSE.
           DISPLAY WS-REPONSE.

           STOP RUN.
       
