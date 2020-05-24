--nume:Andrei Prepelita
--grupa: A3

DECLARE
  v_fisier UTL_FILE.FILE_TYPE;
  CURSOR c_parcurgere_note IS SELECT * from note;
BEGIN
  v_fisier:=UTL_FILE.FOPEN('MYDIR','exportareNote.csv','W');
  for v_indice_cursor in c_parcurgere_note LOOP
  UTL_FILE.PUT_LINE(v_fisier,v_indice_cursor.id || ',' || v_indice_cursor.id_student || ',' || v_indice_cursor.id_curs || ',' || v_indice_cursor.valoare || ',' || v_indice_cursor.data_notare || ',' 
  || v_indice_cursor.created_at || ',' || v_indice_cursor.updated_at );
  END LOOP;
  UTL_FILE.FCLOSE(v_fisier);
END;
/

