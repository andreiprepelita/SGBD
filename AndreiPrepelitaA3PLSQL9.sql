--nume:Andrei Prepelita
--grupa:A3
SET SERVEROUTPUT ON;
--pentru aflarea tipului unei coloane din baza de date am folosit functia din laborator data de dumneavoastra

CREATE OR REPLACE FUNCTION gettype (
    v_rec_tab   dbms_sql.desc_tab,
    v_nr_col    INT
) RETURN VARCHAR2 AS
    v_tip_coloana   VARCHAR2(200);
    v_precizie      VARCHAR2(40);
BEGIN
    CASE ( v_rec_tab(v_nr_col).col_type )
        WHEN 1 THEN
            v_tip_coloana := 'VARCHAR2';
            v_precizie := '('
                          || v_rec_tab(v_nr_col).col_max_len
                          || ')';
        WHEN 2 THEN
            v_tip_coloana := 'NUMBER';
            v_precizie := '('
                          || v_rec_tab(v_nr_col).col_precision
                          || ','
                          || v_rec_tab(v_nr_col).col_scale
                          || ')';

        WHEN 12 THEN
            v_tip_coloana := 'DATE';
            v_precizie := '';
        WHEN 96 THEN
            v_tip_coloana := 'CHAR';
            v_precizie := '('
                          || v_rec_tab(v_nr_col).col_max_len
                          || ')';
        WHEN 112 THEN
            v_tip_coloana := 'CLOB';
            v_precizie := '';
        WHEN 113 THEN
            v_tip_coloana := 'BLOB';
            v_precizie := '';
        WHEN 109 THEN
            v_tip_coloana := 'XMLTYPE';
            v_precizie := '';
        WHEN 101 THEN
            v_tip_coloana := 'BINARY_DOUBLE';
            v_precizie := '';
        WHEN 100 THEN
            v_tip_coloana := 'BINARY_FLOAT';
            v_precizie := '';
        WHEN 8 THEN
            v_tip_coloana := 'LONG';
            v_precizie := '';
        WHEN 180 THEN
            v_tip_coloana := 'TIMESTAMP';
            v_precizie := '('
                          || v_rec_tab(v_nr_col).col_scale
                          || ')';
        WHEN 181 THEN
            v_tip_coloana := 'TIMESTAMP'
                             || '('
                             || v_rec_tab(v_nr_col).col_scale
                             || ') '
                             || 'WITH TIME ZONE';

            v_precizie := '';
        WHEN 231 THEN
            v_tip_coloana := 'TIMESTAMP'
                             || '('
                             || v_rec_tab(v_nr_col).col_scale
                             || ') '
                             || 'WITH LOCAL TIME ZONE';

            v_precizie := '';
        WHEN 114 THEN
            v_tip_coloana := 'BFILE';
            v_precizie := '';
        WHEN 23 THEN
            v_tip_coloana := 'RAW';
            v_precizie := '('
                          || v_rec_tab(v_nr_col).col_max_len
                          || ')';
        WHEN 11 THEN
            v_tip_coloana := 'ROWID';
            v_precizie := '';
        WHEN 109 THEN
            v_tip_coloana := 'URITYPE';
            v_precizie := '';
    END CASE;

    RETURN v_tip_coloana || v_precizie;
END;
/

CREATE OR REPLACE PROCEDURE materie_fac (
    p_id IN NUMBER
) AS

    v_cursor_id                    INTEGER;
    v_ok                           INTEGER;
    v_titlu_curs                   cursuri.titlu_curs%TYPE;
    v_rec_tab                      dbms_sql.desc_tab;
    v_nr_col                       NUMBER;
    v_total_coloane                NUMBER;
    v_tipuri_de_date_concatenate   VARCHAR2(1000);
BEGIN
    v_cursor_id := dbms_sql.open_cursor;
    dbms_sql.parse(v_cursor_id, 'SELECT titlu_curs FROM cursuri where id=' || p_id, dbms_sql.native);
    dbms_sql.define_column(v_cursor_id, 1, v_titlu_curs, 52);
    v_ok := dbms_sql.execute(v_cursor_id);
    LOOP IF dbms_sql.fetch_rows(v_cursor_id) > 0 THEN
        dbms_sql.column_value(v_cursor_id, 1, v_titlu_curs);
        v_titlu_curs := replace(v_titlu_curs, ' ', NULL);
        IF length(v_titlu_curs) > 29 THEN
            v_titlu_curs := substr(v_titlu_curs, 1, 29);
        END IF;

    ELSE
        EXIT;
    END IF;
    END LOOP;

    dbms_sql.close_cursor(v_cursor_id);
    v_cursor_id := dbms_sql.open_cursor;
    dbms_sql.parse(v_cursor_id, 'select n.valoare,n.data_notare,s.nume,s.prenume,s.nr_matricol from studenti s join note n on s.id=n.id_student join cursuri c on n.id_curs=c.id where c.id='
    || p_id, dbms_sql.native);
    v_ok := dbms_sql.execute(v_cursor_id);
    dbms_sql.describe_columns(v_cursor_id, v_total_coloane, v_rec_tab);
    v_nr_col := v_rec_tab.first;
    IF ( v_nr_col IS NOT NULL ) THEN
        LOOP
            v_tipuri_de_date_concatenate := concat(v_tipuri_de_date_concatenate, gettype(v_rec_tab, v_nr_col));
            v_tipuri_de_date_concatenate := concat(v_tipuri_de_date_concatenate, ' ');
            v_nr_col := v_rec_tab.next(v_nr_col);
            EXIT WHEN ( v_nr_col IS NULL );
        END LOOP;
    END IF;

    dbms_sql.close_cursor(v_cursor_id);
    v_cursor_id := dbms_sql.open_cursor;
    dbms_sql.parse(v_cursor_id, 'CREATE TABLE '
                                || upper(v_titlu_curs)
                                || '(nota '
                                || regexp_substr(v_tipuri_de_date_concatenate, '[^ ]+', 1, 1)
                                || ',
           data_notare '
                                || regexp_substr(v_tipuri_de_date_concatenate, '[^ ]+', 1, 2)
                                || ', nume '
                                || regexp_substr(v_tipuri_de_date_concatenate, '[^ ]+', 1, 3)
                                || ',
           prenume '
                                || regexp_substr(v_tipuri_de_date_concatenate, '[^ ]+', 1, 4)
                                || ',numar_matricol '
                                || regexp_substr(v_tipuri_de_date_concatenate, '[^ ]+', 1, 5)
                                || ')', dbms_sql.native);

    v_ok := dbms_sql.execute(v_cursor_id);
    dbms_sql.close_cursor(v_cursor_id);
    v_cursor_id := dbms_sql.open_cursor;
    dbms_sql.parse(v_cursor_id, 'INSERT INTO '
                                || upper(v_titlu_curs)
                                || '(nota,data_notare,nume,prenume,numar_matricol) 
   select n.valoare,n.data_notare,s.nume,s.prenume,s.nr_matricol from studenti s join note n on s.id=n.id_student join cursuri c on n.id_curs=c.id where c.id='
                                || p_id, dbms_sql.native);

    v_ok := dbms_sql.execute(v_cursor_id);
    dbms_sql.close_cursor(v_cursor_id);
    dbms_output.put_line('S-a construit tabela '
                         || upper(v_titlu_curs)
                         || ' si s-au inserat datele corespunzatoare');
END;
/

BEGIN
    materie_fac(10);
END;
/