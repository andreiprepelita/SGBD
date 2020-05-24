--Nume: Andrei Prepelita
--Grupa: A3
set SERVEROUTPUT ON
drop view catalog;
/
create view catalog as select nume,prenume,titlu_curs,valoare from studenti  join note  on studenti.id=note.id_student join cursuri on cursuri.id=note.id_curs;
/
--triggerul pentru stergerea unui student si a notelor sale.Totodata am sters si prietenia cu prietenii studentului sters
create or replace trigger delete_student
instead of delete on catalog
begin
delete from note where id_student in (select id from studenti where nume=:OLD.nume and prenume=:OLD.prenume);
delete from prieteni where id_student1 in ( select id from studenti where nume=:OLD.nume and prenume=:OLD.prenume);
delete from prieteni where id_student2 in (select id from studenti where nume=:OLD.nume and prenume=:OLD.prenume);
delete from studenti where id= (select s2.id from studenti s2 where s2.nume=:OLD.nume and s2.prenume=:OLD.prenume);
end;
/
--mi am facut un trigger care trateaza cele 3 cazuri posibile de INSERt
create or replace trigger insert_curs_or_student_or_both
instead of insert on catalog
declare 
v_count_nr_cursuri NUMBER;
v_count_nr_student NUMBER;
v_id cursuri.id%TYPE;
v_id_note note.id%TYPE;
v_id_student studenti.id%TYPE;
v_nr_matricol studenti.nr_matricol%TYPE;
v_contor NUMBER;
v_grupa studenti.grupa%TYPE;
v_an studenti.an%TYPE;
v_data_nastere studenti.data_nastere%TYPE;
v_email studenti.email%TYPE;
begin
select count(*) into v_count_nr_cursuri from cursuri where titlu_curs=:NEW.titlu_curs;
select count(*) into v_count_nr_student from studenti where nume=:NEW.nume AND prenume=:NEW.prenume;
--daca atat cursul cat si studentul nu exista in baza de date in urma insertului le voi insera cu proprietatile aferente
if(v_count_nr_cursuri=0 AND v_count_nr_student=0) then
--id-ul nu l fac random. preiau maximul valorii id si o incrementez cu unul
select max(id) into v_id from cursuri;
v_id:=v_id+1;
--generez random : o valoare pentru an intre  1 si 3,o valoare pentru semestru intre 1 si 2 si o valoare intre 1 si 6 pentru credite
--adaug cursul inexistent cu proprietatile aferente
insert into cursuri values(v_id,:NEW.titlu_curs,TRUNC(DBMS_RANDOM.VALUE(1,4)),TRUNC(DBMS_RANDOM.VALUE(1,3)),TRUNC(DBMS_RANDOM.VALUE(1,7)),sysdate,sysdate);
--preiau maximul valorii id-ului si o incrementez cu unu pentru a adauga un id valid
select max(id) into v_id_student from studenti;
v_id_student:=v_id_student+1;
--am folosit de la dumneavoastra,din scriptul de creare metoda de generare random pentru numarul matricol si pentru grupa
 LOOP
         v_nr_matricol := FLOOR(DBMS_RANDOM.VALUE(100,999)) || CHR(FLOOR(DBMS_RANDOM.VALUE(65,91))) || CHR(FLOOR(DBMS_RANDOM.VALUE(65,91))) || FLOOR(DBMS_RANDOM.VALUE(0,9));
         select count(*) into v_contor from studenti where nr_matricol = v_nr_matricol;
         exit when v_contor=0;
      END LOOP;
 LOOP
  v_grupa := chr(TRUNC(DBMS_RANDOM.VALUE(0,2))+65) || chr(TRUNC(DBMS_RANDOM.VALUE(0,6))+49);
  v_an := TRUNC(DBMS_RANDOM.VALUE(1,4));
  select count(*) into v_contor from studenti where an=v_an and grupa=v_grupa;
        exit when v_contor < 35;
      END LOOP;
--generez date de nastere random pentru studenti cu restrictia de a fi nascuti in anul 1990
v_data_nastere:=TO_DATE('01-01-1990','MM-DD-YYYY')+TRUNC(DBMS_RANDOM.VALUE(0,365));
--construiesc mailul
v_email:=lower(:NEW.nume || '.' || :NEW.prenume) || '@gmail.com';
--inserez studentul cu proprietatile aferente
INSERT INTO studenti VALUES(v_id_student,v_nr_matricol,:NEW.nume,:NEW.prenume,v_an,v_grupa,TRUNC(DBMS_RANDOM.VALUE(100,400)),v_data_nastere,v_email,sysdate,sysdate,null);
select id into v_id from cursuri where titlu_curs=:NEW.titlu_curs;
--salvez id-ul maxim din tabela note si o incrementez cu 1
select max(id) into v_id_note from note;
v_id_note:=v_id_note+1;
--adaug si nota in tabelul note
INSERT INTO note VALUES(v_id_note,v_id_student,v_id,:NEW.valoare,sysdate,sysdate,sysdate);
dbms_output.put_line('Inseram studentul inexistent ' || :NEW.nume || ' ' || :NEW.prenume || '  si cursul inexistent ' || :NEW.titlu_curs);
--daca studentul este existent dar  cursul inexistent atunci adaug cursul cu anul,semestrul si numarul de credite random in tabela cursuri dar si nota in tabela note
elsif(v_count_nr_cursuri=0) then
select max(id) into v_id from cursuri;
select max(id) into v_id_note from note;
select id into v_id_student from studenti where nume=:NEW.nume AND prenume=:NEW.prenume;
v_id:=v_id+1;
v_id_note:=v_id_note+1;
insert into cursuri values(v_id,:NEW.titlu_curs,TRUNC(DBMS_RANDOM.VALUE(1,4)),TRUNC(DBMS_RANDOM.VALUE(1,3)),TRUNC(DBMS_RANDOM.VALUE(1,7)),sysdate,sysdate);
insert into note values(v_id_note,v_id_student,v_id,:NEW.valoare,sysdate,sysdate,sysdate);
dbms_output.put_line('Inseram cursul inexistent:' || :NEW.titlu_curs);
--daca cunosc cursul dar nu cunosc studentul adaug studentul in tabela studenti cu nr_matricol,anul,grupa,bursa,data de nastere si emailul random.
elsif (v_count_nr_student=0) then
select max(id) into v_id_student from studenti;
v_id_student:=v_id_student+1;
 LOOP
         v_nr_matricol := FLOOR(DBMS_RANDOM.VALUE(100,999)) || CHR(FLOOR(DBMS_RANDOM.VALUE(65,91))) || CHR(FLOOR(DBMS_RANDOM.VALUE(65,91))) || FLOOR(DBMS_RANDOM.VALUE(0,9));
         select count(*) into v_contor from studenti where nr_matricol = v_nr_matricol;
         exit when v_contor=0;
      END LOOP;
 LOOP
  v_grupa := chr(TRUNC(DBMS_RANDOM.VALUE(0,2))+65) || chr(TRUNC(DBMS_RANDOM.VALUE(0,6))+49);
  v_an := TRUNC(DBMS_RANDOM.VALUE(1,4));
  select count(*) into v_contor from studenti where an=v_an and grupa=v_grupa;
        exit when v_contor < 35;
      END LOOP;
v_data_nastere:=TO_DATE('01-01-1990','MM-DD-YYYY')+TRUNC(DBMS_RANDOM.VALUE(0,365));
v_email:=lower(:NEW.nume || '.' || :NEW.prenume) || '@gmail.com';
INSERT INTO studenti VALUES(v_id_student,v_nr_matricol,:NEW.nume,:NEW.prenume,v_an,v_grupa,TRUNC(DBMS_RANDOM.VALUE(100,400)),v_data_nastere,v_email,sysdate,sysdate,null);
select id into v_id from cursuri where titlu_curs=:NEW.titlu_curs;
select max(id) into v_id_note from note;
v_id_note:=v_id_note+1;
INSERT INTO note VALUES(v_id_note,v_id_student,v_id,:NEW.valoare,sysdate,sysdate,sysdate);
dbms_output.put_line('Inseram studentul inexistent:' || :NEW.nume || ' ' || :NEW.prenume);
end if;
end;
/
--triggerul pentru updatarea unei note cu restrictia de a nu adauga o nota mai mica decat cea existenta
create or replace trigger update_nota_student
instead of update on catalog
declare
v_id_student studenti.id%TYPE;
v_id_curs cursuri.id%TYPE;
v_nota note.valoare%TYPE;
begin

select id into v_id_student from studenti where nume=:NEW.nume and prenume=:NEW.prenume;
select id into v_id_curs from cursuri where titlu_curs=:NEW.titlu_curs;
select valoare into v_nota from note where id_student=v_id_student and id_curs=v_id_curs;

if(v_nota<:NEW.valoare) then
dbms_output.put_line('Nota primita de ' || :NEW.nume || ' ' || :NEW.prenume || ' a fost modificata primind o nota mai mare la examenul de marire');
 UPDATE note set valoare=:NEW.valoare,created_at=sysdate where id_student=v_id_student and id_curs=v_id_curs;
 else
 dbms_output.put_line('Nu se poate modifica nota cu o valoare mai mica la examenul de maririre');
 end if;
end;
/

begin
insert into catalog values ('Georgescu','Catalina','Yoga',7);
insert into catalog values ('Monitor', 'George','Antreprenoriat',10);
delete from catalog where nume='Monitor' and prenume='George';
insert into catalog values ('Georgescu', 'Catalina', 'Olimpiada',8);
update catalog set valoare=10 where nume='Georgescu' and prenume='Catalina' and titlu_curs='Yoga';
end;
/

