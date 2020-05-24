--nume:Andrei Prepelita
--grupa: A3

set serveroutput on;
declare
  v_fisier UTL_FILE.FILE_TYPE;
  v_linie varchar2(32767);
   CURSOR catalog IS select studenti.nume,studenti.prenume,studenti.an,studenti.grupa,note.valoare,cursuri.titlu_curs from studenti join note on studenti.id=note.id_student join cursuri on note.id_curs=cursuri.id;
begin
  v_fisier:=UTL_FILE.FOPEN('MYDIR','catalog.xml','W');
  v_linie:='<?xml version="1.0" encoding="UTF-8"?>' || chr(13) || chr(10);
  UTL_FILE.PUT_LINE(v_fisier, v_linie);
   v_linie := '<catalog>' || CHR(13)||CHR(10);
  UTL_FILE.PUT_LINE(v_fisier, v_linie);
  for v_std_linie in catalog loop
  v_linie:='<student> ' || CHR(13) || CHR(9) || '<nume>' || v_std_linie.nume || '</nume>' || CHR(13) || CHR(9) || '<prenume>' || v_std_linie.prenume || '</prenume>' || CHR(13) || CHR(9) || 
  '<an>' || v_std_linie.an || '</an>' || CHR(13) || CHR(9) || '<grupa>' || v_std_linie.grupa || '</grupa>' || CHR(13) || CHR(9) || '<nota>' ||
  v_std_linie.valoare || '</nota>' || CHR(13) || CHR(9) || '<curs>' || v_std_linie.titlu_curs || '</curs>' || CHR(13) || '</student>' ;
 UTL_FILE.PUT_LINE(v_fisier,v_linie);
 end loop;
  v_linie := '</catalog>' || CHR(13)||CHR(10);
  UTL_FILE.PUT_LINE(v_fisier,v_linie);
 UTL_FILE.FCLOSE(v_fisier);
end;
  
 
  