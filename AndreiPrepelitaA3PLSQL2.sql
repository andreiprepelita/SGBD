set serveroutput on;
 
DECLARE
   v_an studenti.an%TYPE:=&i_an;
   CURSOR lista_cursuri (p_an studenti.an%type) IS select titlu_curs from cursuri where an=p_an;
   v_std_linie lista_cursuri%ROWTYPE;  
BEGIN
OPEN lista_cursuri(v_an);
UPDATE studenti set bursa=5000 where studenti.id in ( select studenti.id from note n where studenti.id=n.id_student AND studenti.an=v_an group by studenti.id having avg(n.valoare)=(select max(avg(n1.valoare)) from studenti s1 join
note n1 on s1.id=n1.id_student where studenti.an=s1.an AND studenti.grupa=s1.grupa group by s1.id,s1.an,s1.grupa));
IF(SQL%FOUND) 
      THEN
         DBMS_OUTPUT.PUT_LINE('Am marit bursa la ' || SQL%ROWCOUNT || ' studenti.');
      ELSE
         DBMS_OUTPUT.PUT_LINE('Nimanui nu i s-a marit bursa.');
    END IF;
LOOP
FETCH lista_cursuri INTO v_std_linie;
EXIT WHEN lista_cursuri%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(v_std_linie.titlu_curs);
END LOOP;
CLOSE lista_cursuri;
END;

SELECT id from note 
SELECT s.nume,s.prenume,avg(n.valoare) from studenti s join note n on s.id=n.id_student group by s.id,s.nume,s.prenume,s.an,s.grupa having avg(n.valoare)=(select max(avg(n1.valoare)) from studenti s1 
join note n1 on s1.id=n1.id_student where s1.an=s.an AND s.grupa=s1.grupa group by s1.id,s1.an,s1.grupa);


select max(avg(n1.valoare)) from studenti s1 
join note n1 on s1.id=n1.id_student where s1.an=1 AND s1.grupa='A3' group by s1.id


