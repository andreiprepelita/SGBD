CREATE OR REPLACE TYPE genuri_muzicale AS TABLE OF VARCHAR2(15);


CREATE TABLE pasiuni(
id INT NOT NULL PRIMARY KEY,
id_student INT NOT NULL,
marca_masina VARCHAR2(52),
data_cumparare DATE,
an_fabricatie NUMBER,
cutie_automata NUMBER(1),
genuri_preferate genuri_muzicale,
CONSTRAINT fk_masini_id_student FOREIGN KEY (id_student) REFERENCES studenti(id))
NESTED TABLE genuri_preferate STORE AS lista_genuri_tab;

set serveroutput on;
declare
TYPE varr IS VARRAY(1000) OF varchar2(255);
lista_masini varr :=varr('Audi','Dacia','Bmw','Bugatti','Chevrolet','Ford','Corvette','Ferrari','Jaguar',
'Mazda','Nissan','Mitsubishi','Porsche','Skoda','Peugeot','Seat','Toyota','Renault','Tesla','Volvo',
'Maserati','Land Rover','Bentley','Citroen','Kia','Honda','Lamborghini','Lexus','Mercedes','Opel','Subaru',
'Suzuki','Volkswagen');
lista_genuri_muzicale varr :=varr('Hip hop','Rock','Pop','Heavy metal','Rapsodie','Manele','Vals','Jazz','Dance','Folk','House','Rap','Reggae','Flamenco');
v_id NUMBER;
v_nume_masina VARCHAR2(52);
v_an_fabricatie NUMBER;
v_data_cumparare DATE;
v_lista_genuri genuri_muzicale:=genuri_muzicale();
v_numar_genuri NUMBER;
v_existenta_student NUMBER;
v_id_student studenti.id%TYPE;
v_contor NUMBER:=1;
begin
--dbms_output.put_line(lista_genuri_muzicale.count);
v_id:=1;
for v_i in 1..1025 loop
 v_nume_masina := lista_masini(TRUNC(DBMS_RANDOM.VALUE(0,lista_masini.count))+1);
 v_an_fabricatie:=TRUNC(DBMS_RANDOM.VALUE(2008,2018))+1;
 v_data_cumparare := TO_DATE('01-01-' || v_an_fabricatie,'MM-DD-YYYY')+TRUNC(DBMS_RANDOM.VALUE(0,730));
 --dbms_output.put_line(v_nume_masina || ' ' || v_an_fabricatie || ' ' || v_data_cumparare);
 v_numar_genuri:=TRUNC(DBMS_RANDOM.VALUE(0,5))+1;
 for v_j in 1..v_numar_genuri loop
 v_lista_genuri.EXTEND();
 v_lista_genuri(v_lista_genuri.count):=lista_genuri_muzicale(TRUNC(DBMS_RANDOM.VALUE(0,lista_genuri_muzicale.count))+1);
end loop;
loop
select count(*) into v_existenta_student from studenti where id=v_contor;
exit when v_existenta_student=1;
v_contor:=v_contor+1;
end loop;
INSERT INTO pasiuni VALUES(v_id,v_contor,v_nume_masina,v_data_cumparare,v_an_fabricatie,TRUNC(DBMS_RANDOM.VALUE(0,2)),v_lista_genuri);
v_lista_genuri.delete;
v_id:=v_id+1;
v_contor:=v_contor+1;
end loop;
end;


select * from pasiuni;

--delete from pasiuni;
