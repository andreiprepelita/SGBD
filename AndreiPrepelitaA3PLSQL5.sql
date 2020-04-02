ALTER TABLE note ADD CONSTRAINT note_uq UNIQUE (id_student,id_curs);
--metoda 1 prin care verific initial daca studentul reprezentat prin ip ul dat prin input are nota la materia logica. Daca are nu fac nimic, in schimb daca nu are adaug nota 8 la materia logica.
CREATE OR REPLACE PROCEDURE metoda1(p_id IN studenti.id%TYPE ) AS
v_count INTEGER;
v_id_curs cursuri.id%TYPE;
v_maxid note.id%TYPE;
BEGIN
--verific prin intermediul lui count(*) daca studentul are nota
select count(*),c.id into v_count,v_id_curs from studenti s join note n on s.id=n.id_student join cursuri c on c.id=n.id_curs where s.id=p_id and c.titlu_curs='Logic?' group by s.id,c.id;
--daca nu are atunci iau cel mai mare id din prima coloana a tabelei note si o  atribui variabilei v_maxid,pe care ulterior o incrementez cu 1
--am nevoie de aceasta variabila pentru a identifica un mod unic o linie din tabela note
if(v_count<1) then 
select max(id) into v_maxid from note;
v_maxid:=v_maxid+1;
INSERT INTO note VALUES (v_maxid,p_id,v_id_curs,8,sysdate,sysdate,sysdate);
END IF;
END;

CREATE OR REPLACE PROCEDURE metoda2(p_id IN studenti.id%TYPE ) AS
v_maxid note.id%TYPE;
v_id_curs cursuri.id%TYPE;
BEGIN
select max(id) into v_maxid from note;
v_maxid:=v_maxid+1;
select id into v_id_curs from cursuri where titlu_curs='Logic?';
INSERT INTO note VALUES (v_maxid,p_id,v_id_curs,8,sysdate,sysdate,sysdate);
END;

CREATE OR REPLACE FUNCTION medie1_student(p_nume studenti.nume%TYPE,p_prenume studenti.prenume%TYPE)
RETURN NUMBER
AS
v_medie NUMBER;
counter INTEGER;
student_inexistent EXCEPTION;
  PRAGMA EXCEPTION_INIT(student_inexistent, -20001);
BEGIN
SELECT count(*) into counter from studenti where studenti.nume=p_nume AND studenti.prenume=p_prenume;
if(counter=0) THEN -- daca nu exista studentul arunc exceptia predefinita de mine.
raise student_inexistent;
END IF;
--daca exista studentul calculez media.
select avg(n.valoare) into v_medie from studenti s join note n on s.id=n.id_student where s.nume=p_nume AND s.prenume=p_prenume;
return v_medie;
END medie1_student;



--bloc anonim metoda1  timp de executie:  14,125 secunde

DECLARE
v_id studenti.id%TYPE:=25;
begin
for v_indice in 1..1000000 LOOP
metoda1(v_id); --apelez procedura 1 cu un id dat de mine.
END LOOP;
end;



--bloc anonim metoda2  timp de executie: 147,757 secunde
SET serveroutput on;
DECLARE
v_id studenti.id%TYPE:=25;
begin
for v_indice in 1..1000000 LOOP
begin
metoda2(v_id); --apelez procedura 2 cu un id dat de mine.
EXCEPTION WHEN DUP_VAL_ON_INDEX THEN --prind exceptia
null;
end;
END LOOP;
end;

--REZULTAT: METODA2 are un timp de executie mult mai mare decat METODA1

--bloc anonim pentru apelarea functiei

--primii 3 studenti sunt existenti in baza de date,iar ceilalti 3 nu. De aceea se afiseaza mediile a primilor 3 studenti iar la urmatorii 3 un mesaj.
SET serveroutput on;
DECLARE
v_medie NUMBER;
student_inexistent EXCEPTION;
PRAGMA EXCEPTION_INIT(student_inexistent, -20001);
type lista_tip is varray(300) of varchar2(300);
    type lista is record
    (
        lista_nume lista_tip := lista_tip('Teodorescu', 'Soficu', 'Ghergu', 'Mihalache', 'Ichim', 'Iacob'),
        lista_prenume lista_tip := lista_tip('Paul', 'Alexandra', 'Xena', 'Mircea', 'Stefan', 'Andrei')
    );
    
    v_nume lista;
BEGIN
  for i in v_nume.lista_nume.first.. v_nume.lista_nume.last loop
  begin
  v_medie:=medie1_student(v_nume.lista_nume(i),v_nume.lista_prenume(i));
  DBMS_OUTPUT.PUT_LINE(v_nume.lista_nume(i) || ' ' || v_nume.lista_prenume(i) || ' are media ' || v_medie);
  
  EXCEPTION 
WHEN student_inexistent THEN 
 DBMS_OUTPUT.PUT_LINE('Studentul ' || v_nume.lista_nume(i) || ' ' || v_nume.lista_prenume(i) || ' nu exista in baza de date');
 end;
 end loop;
END;
