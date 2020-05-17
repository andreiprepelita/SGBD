--nume:Andrei Prepelita
--grupa: A3
--Tema: PLSQL5


create or replace PACKAGE exceptieBursa AS
function getBursa(p_id studenti.id%TYPE) RETURN studenti.bursa%TYPE;

END exceptieBursa;

create or replace PACKAGE BODY exceptieBursa AS
FUNCTION getBursa(p_id studenti.id%TYPE) RETURN studenti.bursa%TYPE
AS
v_bursa studenti.bursa%TYPE;
v_contor NUMBER;
student_inexistent EXCEPTION;
PRAGMA EXCEPTION_INIT(student_inexistent,-20001);

BEGIN

select count(*) into v_contor from studenti where id=p_id;
if(v_contor<1) then
raise student_inexistent;
END IF;
select nvl(bursa,0) into v_bursa from studenti where id=p_id;
return v_bursa;

end getBursa;
end exceptieBursa;
