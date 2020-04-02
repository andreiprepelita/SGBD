set serveroutput on;
--declare clasa masina cu atribute si metodele get_greutate,afiseaza_pret,varsta_in_zile (metoda de comparare de tip MAP) si constructorul explicit masina(nume varchar2,producataor varchar2)
CREATE OR REPLACE TYPE masina AS OBJECT
( nume varchar2(20),
  producator varchar2(20),
  an_fabricatie NUMBER(5),
  greutate      NUMBER(5),
  transmisie  varchar2(20),
  data_nastere date,
  member function get_greutate RETURN NUMBER,
  not final member procedure afiseaza_pret,
  map member function varsta_in_zile RETURN NUMBER,
  CONSTRUCTOR FUNCTION masina(nume varchar2, producator varchar2)
  RETURN SELF AS RESULT
  ) NOT FINAL;
  
  
  
--implementare metode  
CREATE OR REPLACE TYPE BODY masina AS
member function get_greutate RETURN NUMBER AS
v_greutate NUMBER;
BEGIN
v_greutate:=greutate;
return v_greutate;
end get_greutate;
member procedure afiseaza_pret AS
v_pret NUMBER;
BEGIN
v_pret:=1000/(2020-an_fabricatie+1);
DBMS_OUTPUT.PUT_LINE('Pretul masinii '|| nume || ' este de ' || v_pret || ' euro');
END;
CONSTRUCTOR FUNCTION masina(nume varchar2, producator varchar2)
    RETURN SELF AS RESULT
  AS
  BEGIN
    SELF.nume := nume;
    SELF.producator := producator;
    SELF.an_fabricatie:=2020;
    SELF.greutate:=10000;
    SELF.transmisie := 'automata';
    SELF.data_nastere:=sysdate;
    RETURN;
  END;
  map member function varsta_in_zile RETURN NUMBER AS
   v_zile NUMBER;
   BEGIN
   v_zile:=sysdate-data_nastere;
   return v_zile;
   END;
END;

--creare subclasa masina_bmw cu suprascrierea metodei afiseaza_pret

CREATE OR REPLACE TYPE masina_bmw UNDER masina
( cai_putere NUMBER,
OVERRIDING member procedure afiseaza_pret 
)

CREATE OR REPLACE TYPE BODY masina_bmw AS
OVERRIDING member procedure afiseaza_pret IS
BEGIN
  dbms_output.put_line('Pret nelimitat pentru tipul BMW');
  END afiseaza_pret;
END;

--DROP TYPE masina_bmw;
--DROP TABLE masini_oop;

--creare tabela masini_oop
CREATE TABLE masini_oop(id_masina VARCHAR2(4),obiect MASINA);



--bloc anonim
set serveroutput on;
DECLARE
v_masina1 MASINA;
v_masina2 MASINA;
v_masina3 MASINA;
v_masina4 MASINA_BMW;
v_greutate NUMBER;
BEGIN
v_masina1:=masina('Dacia LOGAN','Dacia',1994,3500,'manuala',TO_DATE('11/04/1994', 'dd/mm/yyyy'));
v_masina2:=masina('MAZDA 3','MAZDA',1995,2500,'manuala',TO_DATE('22/03/1995', 'dd/mm/yyyy')); --se apeleaza constructorul implicit
v_masina3:=masina('AUDI Q7','AUDI'); -- se apeleaza constructorul explicit
v_masina4:=masina_bmw('BMW E92','BMW',1992,2300,'manuala',TO_DATE('22/03/1992', 'dd/mm/yyyy'),500);
v_greutate:=v_masina3.get_greutate();
DBMS_OUTPUT.PUT_LINE('A treia masina are greutatea ' || v_greutate);
v_masina3.afiseaza_pret();
v_masina4.afiseaza_pret();
if(v_masina1<v_masina2) THEN
DBMS_OUTPUT.PUT_LINE('Masina 1 este mai noua decat Masina 2');
else
DBMS_OUTPUT.PUT_LINE('Masina 2 este mai noua decat Masina 1');
END IF;
insert into masini_oop values ('1',v_masina1);
insert into masini_oop values ('2',v_masina2);
insert into masini_oop values ('3',v_masina3);
insert into masini_oop values( '4',v_masina4);
END;

select * from masini_oop order by obiect;