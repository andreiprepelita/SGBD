--nume:Andrei Prepelita
--grupa:A3

SET SERVEROUTPUT ON;
DECLARE
CURSOR informatii_tabele  IS
SELECT table_name,num_rows,nested from user_tables;
CURSOR  tip_constrangere_coloana(p_nume_tabel user_tables.table_name%TYPE) IS
select user_constraints.constraint_name,constraint_type,column_name,user_constraints.search_condition from user_constraints join user_cons_columns on user_constraints.table_name=user_cons_columns.table_name where user_constraints.table_name=p_nume_tabel;
CURSOR tip_index(p_nume_tabel user_tables.table_name%TYPE) IS
select user_indexes.index_name,index_type,column_name from user_indexes join USER_IND_COLUMNS on user_indexes.table_name=USER_IND_COLUMNS.table_name where user_indexes.table_name=p_nume_tabel;
CURSOR informatii_view IS
select view_name,text from user_views;
CURSOR informatii_types IS 
select type_name,attributes,methods from user_types;
CURSOR informatii_package IS
select name,type,max(line) AS "NUMAR" from user_source where type='PACKAGE' or type='PACKAGE BODY' group by name,type;
CURSOR informatii_functii IS
select name,type,max(line) AS "NUMAR",deterministic from user_source join user_procedures on user_source.name=user_procedures.object_name or user_source.name=user_procedures.procedure_name where user_source.type='FUNCTION' group by name,type,deterministic;
CURSOR informatii_proceduri IS
select name,type,max(line) AS "NUMAR",deterministic from user_source join user_procedures on user_source.name=user_procedures.object_name or user_source.name=user_procedures.procedure_name where user_source.type='PROCEDURE' group by name,type,deterministic;
v_contor_constrangeri NUMBER;
v_contor_indecsi NUMBER;
BEGIN
DBMS_OUTPUT.PUT_LINE('Informatii TABELE');
DBMS_OUTPUT.PUT_LINE('');
FOR v_std_linie IN informatii_tabele LOOP  
DBMS_OUTPUT.PUT_LINE('Nume tabel:' || v_std_linie.table_name);
DBMS_OUTPUT.PUT_LINE('Numar inregistrari:' || v_std_linie.num_rows);
DBMS_OUTPUT.PUT_LINE('Este NESTED TABLE:' ||  v_std_linie.nested);
SELECT count(*) into v_contor_constrangeri from user_constraints where table_name=v_std_linie.table_name;
if(v_contor_constrangeri>0) then
DBMS_OUTPUT.PUT_LINE('Exista constrangeri: DA');
for v_std_linie_constrangere in tip_constrangere_coloana(v_std_linie.table_name) LOOP
if(v_std_linie_constrangere.search_condition IS NOT NULL) THEN
DBMS_OUTPUT.PUT_LINE('Nume constrangere:' || v_std_linie_constrangere.constraint_name || ' Tip constrangere:' || v_std_linie_constrangere.constraint_type || ' Coloana implicata:' || v_std_linie_constrangere.column_name || ' Conditie cautare:' || v_std_linie_constrangere.search_condition);

else
DBMS_OUTPUT.PUT_LINE('Nume constrangere:' || v_std_linie_constrangere.constraint_name || ' Tip constrangere:' || v_std_linie_constrangere.constraint_type || ' Coloana implicata:' || v_std_linie_constrangere.column_name);
end if;
END LOOP;
else
DBMS_OUTPUT.PUT_LINE('Exista constrangeri: NU');
end if;
SELECT count(*) into v_contor_indecsi from user_indexes where table_name=v_std_linie.table_name;
if(v_contor_indecsi>0) then
DBMS_OUTPUT.PUT_LINE('Exista indecsi: DA');
for v_std_linie_index in tip_index(v_std_linie.table_name) LOOP
DBMS_OUTPUT.PUT_LINE('Nume index:' || v_std_linie_index.index_name || ' Tip index:' || v_std_linie_index.index_type || ' Coloana implicata:' || v_std_linie_index.column_name );
END LOOP;
else
DBMS_OUTPUT.PUT_LINE('Exista indecsi: NU');
end if;
DBMS_OUTPUT.PUT_LINE('');
    END LOOP; 
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Informatii view-uri');
    FOR v_std_linie IN informatii_view LOOP 
    DBMS_OUTPUT.PUT_LINE('Nume view : ' || v_std_linie.view_name);
    DBMS_OUTPUT.PUT_LINE('Text view : ' || v_std_linie.text);
     DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    
      DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Informatii types');
    FOR v_std_linie IN informatii_types LOOP 
    DBMS_OUTPUT.PUT_LINE('Nume tip : ' || v_std_linie.type_name);
    DBMS_OUTPUT.PUT_LINE('Numar atribute : ' || v_std_linie.attributes);
     DBMS_OUTPUT.PUT_LINE('Numar metode : ' || v_std_linie.methods);
     DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Informatii package');
     FOR v_std_linie IN informatii_package LOOP 
      DBMS_OUTPUT.PUT_LINE('Nume package: ' || v_std_linie.name);
      DBMS_OUTPUT.PUT_LINE('Tip package: ' || v_std_linie.type);
      DBMS_OUTPUT.PUT_LINE('Numar linii: ' || v_std_linie.NUMAR);
      DBMS_OUTPUT.PUT_LINE('');
      END LOOP;
      
      DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Informatii functii');
    FOR v_std_linie IN informatii_functii LOOP 
     DBMS_OUTPUT.PUT_LINE('Nume functie: ' || v_std_linie.name);
     DBMS_OUTPUT.PUT_LINE('Numar linii: ' || v_std_linie.NUMAR);
     DBMS_OUTPUT.PUT_LINE('Este determinista:' || v_std_linie.deterministic);
     DBMS_OUTPUT.PUT_LINE('');
     END LOOP;
     
      DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Informatii proceduri');
    FOR v_std_linie IN informatii_proceduri LOOP 
     DBMS_OUTPUT.PUT_LINE('Nume procedura: ' || v_std_linie.name);
     DBMS_OUTPUT.PUT_LINE('Numar linii: ' || v_std_linie.NUMAR);
     DBMS_OUTPUT.PUT_LINE('Este determinista:' || v_std_linie.deterministic);
     DBMS_OUTPUT.PUT_LINE('');
     END LOOP;
END;

