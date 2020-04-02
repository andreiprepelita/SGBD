-- Nume: Andrei Prepelita
--Grupa: A3
CREATE OR REPLACE TYPE listaMedii
AS
  TABLE OF NUMBER;
  
  
  
  --mi am adaugat coloana lista_medii in tabelul studenti de tip nested table
  ALTER TABLE studenti ADD(lista_medii listaMedii) NESTED TABLE lista_medii STORE
AS
  listaMedii_tab;
  
  
  
  
  --mi-am creat o precedura in care calculez pentru fiecare student mediile semestriale ordonate dupa an si semestru
  --stochez  mediile intr-o lista de tip tabel
  --updatez coloana lista_medii asociata studentului
CREATE OR REPLACE PROCEDURE adaugareMediiSemestriale
IS
  v_listacumedii listaMedii:=listaMedii();
BEGIN
--parcurg fiecare student
  FOR stud IN
  (SELECT * FROM studenti
  )
  LOOP
  --calaculez mediile semestriale pentru fiecare student grupand notele studentului dupa anul si semestrul in care au fost tinute cursurile la care are note 
    FOR i IN
    (SELECT AVG(n.valoare) AS medie
    FROM studenti s
    JOIN note n
    ON s.id=n.id_student
    JOIN cursuri c
    ON c.id   =n.id_curs
    WHERE s.id=stud.id
    GROUP BY s.id,
      s.nume,
      s.prenume,
      c.an,
      c.semestru
    ORDER BY s.id, --am ordonat mediile pentru a avea pe pozitia 1 notele din anul 1 semestrul 1, pe pozitia 2 notele din anul 1 semestrul 2 etc
      c.an,
      c.semestru
    )
    LOOP
      v_listacumedii.EXTEND(); --adaug cate o pozitie pentru v_listacumedii de tip tabel
      v_listacumedii(v_listacumedii.count):=i.medie; -- stochez media
    END LOOP;
    UPDATE studenti SET lista_medii=v_listacumedii WHERE studenti.id=stud.id; --dupa ce am terminat de calculat mediile semestriale,updatez coloana lista_medii pentru studentul curent
    v_listacumedii.delete; --sterg elementele din v_listacumedii
  END LOOP;
END adaugareMediiSemestriale;


--functia primeste ca parametru id-ul unui student
CREATE OR REPLACE FUNCTION nrMedii(
    p_id studenti.id%type)
  RETURN NUMBER
AS
  v_lista listaMedii;
  v_validare NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_validare FROM studenti WHERE id=p_id; --validez inputul primit ca parametru: verific daca exista studentul cu id-ul respectiv in baza de date
  IF(v_validare=0) THEN --daca nu exista returnez -1
    RETURN -1;
  END IF;
  --in caz contrar calculez numarul de medii semestriale
SELECT lista_medii INTO v_lista FROM studenti WHERE studenti.id=p_id;
RETURN v_lista.count;
END;




set SERVEROUTPUT ON;
DECLARE
  v_id studenti.id%TYPE:=&i; --se citeste id -ul unui student
  v_nr NUMBER;
BEGIN
  adaugareMediiSemestriale();
  v_nr  :=nrMedii(v_id); 
  IF(v_nr=-1) THEN
    DBMS_OUTPUT.PUT_LINE('Studentul nu exista in baza de date');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Studentul are trecute ' || v_nr || ' medii in coloana lista_medii');
  END IF;
END;

