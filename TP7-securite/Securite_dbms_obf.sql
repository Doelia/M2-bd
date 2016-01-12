-- extrait de http://fdegrelle.over-blog.com/article-1001066.html


CREATE OR REPLACE PACKAGE Cryptit AS
   FUNCTION encrypt( Str VARCHAR2 ) RETURN RAW;
   FUNCTION decrypt( xCrypt VARCHAR2 ) RETURN VARCHAR2;
END Cryptit;
/

CREATE OR REPLACE PACKAGE BODY Cryptit AS
   crypt_raw RAW(2000);
   crypt_str VARCHAR(2000);

   -- Encrypt the string --
   FUNCTION encrypt( Str VARCHAR2 ) RETURN RAW AS

   l INTEGER := LENGTH(str);
   i INTEGER;
   padblock RAW(2000);
   Cle RAW(8) := UTL_RAW.CAST_TO_RAW('frankzap');

   BEGIN
      i := 8-MOD(l,8);
      padblock := utl_raw.cast_to_raw(str||RPAD(CHR(i),i,CHR(i)));

      dbms_obfuscation_toolkit.DESEncrypt(
               input     => padblock,
               KEY       => Cle,
               encrypted_data => crypt_raw );
      RETURN crypt_raw ;
   END;

   -- Decrypt the string --
   FUNCTION decrypt( xCrypt VARCHAR2 ) RETURN VARCHAR2 AS
   l NUMBER;
   Cle RAW(8) := UTL_RAW.CAST_TO_RAW('frankzap');
   crypt_raw RAW(2000) := utl_raw.cast_to_raw(utl_raw.cast_to_varchar2(xCrypt)) ;
   BEGIN
      dbms_obfuscation_toolkit.DESDecrypt(
               input     => xCrypt,
               KEY       => Cle,
               decrypted_data => crypt_raw );
      crypt_str := utl_raw.cast_to_varchar2(crypt_raw);
      l := LENGTH(crypt_str);
      crypt_str := RPAD(crypt_str,l-ASCII(SUBSTR(crypt_str,l)));
      RETURN crypt_str;
   END;
END Cryptit;
/
-- Exemple utilisation

set serveroutput on

DECLARE
     LC$Code VARCHAR2(100) := 'Music is the best!' ;
    BEGIN 
      -- Get the encrypted string --
      LC$Code := Cryptit.Encrypt( LC$Code ) ;
      dbms_output.put_line( LC$Code ) ;
      -- Get the decrypted string --
     LC$Code := Cryptit.Decrypt( LC$Code ) ;
     dbms_output.put_line( LC$Code ) ;
   END ;   
   /

