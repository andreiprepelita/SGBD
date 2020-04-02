SET serveroutput ON;
DECLARE
  v_nume_stud studenti.nume%TYPE:=&i_nume;
  v_nota_max note.valoare%TYPE;
  v_materie cursuri.titlu_curs%TYPE;
  v_an studenti.an%TYPE;
  v_grupa studenti.grupa%TYPE;
  v_nr_colegi_grupa NUMBER;
  v_verif           NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_verif FROM studenti WHERE v_nume_stud=nume;
  IF(v_verif>0) THEN
    SELECT *
    INTO v_nota_max,
      v_materie,
      v_an,
      v_grupa
    FROM
      (SELECT n.valoare,
        c.titlu_curs,
        s.an,
        s.grupa
      FROM studenti s
      JOIN note n
      ON s.id=n.id_student
      JOIN cursuri c
      ON n.id_curs=c.id
      WHERE nume  =v_nume_stud
      ORDER BY n.valoare DESC
      )
    WHERE rownum=1;
    SELECT COUNT(*)
    INTO v_nr_colegi_grupa
    FROM studenti s
    JOIN note n
    ON s.id=n.id_student
    JOIN cursuri c
    ON n.id_curs      =c.id
    WHERE c.titlu_curs=v_materie
    AND s.grupa       =v_grupa
    AND s.an          =v_an
    AND s.nume!       =v_nume_stud
    AND n.valoare     =v_nota_max;
    DBMS_OUTPUT.PUT_LINE('Valoarea maxima a notei: ' || v_nota_max);
    DBMS_OUTPUT.PUT_LINE('Materia la care a luat nota maxima: ' || v_materie);
    DBMS_OUTPUT.PUT_LINE('Nr colegilor din grupa cu ' || v_nume_stud || ' care a luat aceeasi nota la materia ' || v_materie || ' este ' || v_nr_colegi_grupa);
  ELSE
    DBMS_OUTPUT.PUT_LINE('Numele dat nu este in baza de date');
  END IF;
END;


UPDATE note SET valoare=valoare+1 where valoare IN ( select valoare from studenti,cursuri where note.id_student=studenti.id AND grupa='A3'  AND cursuri.id=note.id_curs AND titlu_curs='Baze de date' AND valoare!=10);
select nume,prenume,valoare from studenti,note,cursuri where note.id_student=studenti.id AND studenti.an=2 AND grupa='A3' AND  AND cursuri.id=note.id_curs AND titlu_curs='Baze de date' AND valoare!=10;
select nume,prenume,an,grupa from studenti where nume='Rosca' AND grupa='A3';