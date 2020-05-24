--nume: Andrei Prepelita
--grupa: A3

DELETE FROM NOTE;
/
set serveroutput on;
DECLARE
  v_fisier UTL_FILE.FILE_TYPE;
  v_linie VARCHAR2(300);
  v_id  VARCHAR2(300);
  v_id_student VARCHAR2(300);
  v_id_curs VARCHAR2(300);
  v_valoare VARCHAR2(300);
  v_data_notare VARCHAR2(300);
  v_created_at VARCHAR2(300);
  v_updated_at VARCHAR2(300);
  v_contor NUMBER:=0;
BEGIN
  v_fisier:=UTL_FILE.FOPEN('MYDIR','exportareNote.csv','R');
  if UTL_FILE.IS_OPEN(v_fisier) then
  LOOP
  BEGIN
  UTL_FILE.GET_LINE(v_fisier,v_linie);
  EXCEPTION 
  WHEN NO_DATA_FOUND THEN 
  EXIT;
    END;
  v_id:=REGEXP_SUBSTR(v_linie,'[^,]+',1,1);
  v_id_student:=REGEXP_SUBSTR(v_linie,'[^,]+',1,2);
  v_id_curs:=REGEXP_SUBSTR(v_linie,'[^,]+',1,3);
  v_valoare:=REGEXP_SUBSTR(v_linie,'[^,]+',1,4);
  v_data_notare:=REGEXP_SUBSTR(v_linie,'[^,]+',1,5);
  v_created_at:=REGEXP_SUBSTR(v_linie,'[^,]+',1,6);
  v_updated_at:=REGEXP_SUBSTR(v_linie,'[^,]+',1,7);

   INSERT INTO note VALUES(v_id,v_id_student,v_id_curs,v_valoare,v_data_notare,v_created_at,v_updated_at);
   v_contor:=v_contor+1;
  END LOOP;
  END IF;
  UTL_FILE.FCLOSE(v_fisier);
  DBMS_OUTPUT.PUT_LINE('Note adaugate ' || v_contor);
END;
/