CREATE OR REPLACE PACKAGE lab3 AS

FUNCTION CMMDC(p_nr1 NUMBER,p_nr2 NUMBER) RETURN NUMBER;
FUNCTION CMMMC(p_nr1 NUMBER,p_nr2 NUMBER) RETURN NUMBER;

END lab3;

CREATE OR REPLACE PACKAGE BODY lab3 AS

PROCEDURE calculareCMM(p_nr1 NUMBER,p_nr2 NUMBER,p_cmmdc OUT NUMBER,p_cmmmc OUT NUMBER) IS
v_nr1 NUMBER:=p_nr1;
v_nr2 NUMBER:=p_nr2;
BEGIN
while(v_nr1!=v_nr2) LOOP
  if(v_nr1>v_nr2) THEN
   v_nr1:=v_nr1-v_nr2;
   ELSE
   v_nr2:=v_nr2-v_nr1;
   END IF;
   END LOOP;
   p_cmmdc:=v_nr1;
   p_cmmmc:=p_nr1*p_nr2/p_cmmdc;
END calculareCMM;

FUNCTION CMMDC(p_nr1 NUMBER,p_nr2 NUMBER) RETURN NUMBER
AS
v_cmmdc NUMBER;
v_cmmmc NUMBER;
BEGIN
calculareCMM(p_nr1,p_nr2,v_cmmdc,v_cmmmc);
return v_cmmdc;
END;
FUNCTION CMMMC(p_nr1 NUMBER,p_nr2 NUMBER) RETURN NUMBER
AS
v_cmmdc NUMBER;
v_cmmmc NUMBER;
BEGIN
calculareCMM(p_nr1,p_nr2,v_cmmdc,v_cmmmc);
return v_cmmmc;
END;

END lab3;

SELECT lab3.CMMDC(24,32) FROM DUAL;
SELECT lab3.CMMMC(24,32) FROM DUAL;