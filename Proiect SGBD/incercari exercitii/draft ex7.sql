create or replace procedure exercitiul_7(
    id      student.cod_student%type
)

is
    
begin
    null;
end;
/

/*

pentru un id dat ca parametru si pentru toti studentii care au id-ul ca fiind un multiplu al id-ului dat
sa se afiseze toate facultatiile care ofera aceeasi specializare ca cea in care acestia sunt inscrisi
(practic sa afiseze ce alte optiuni ar fi avut la facultate)

*/

select s.cod_student, nume, prenume, sp.cod_specializare, sp.denumire, f.cod_facultate, f.denumire
from student s join specializare sp on(s.cod_specializare = sp.cod_specializare)
    join studiaza st on (s.cod_student = st.cod_student)
    join facultate f on (st.cod_facultate = f.cod_facultate)
order by s.cod_student;


select f.cod_facultate, f.denumire, sp.cod_specializare, sp.denumire
from facultate f join specializare sp on(f.cod_facultate = sp.cod_facultate)
order by sp.denumire;


select * from studiaza;

select s.cod_student
from student s join studiaza st on (s.cod_student = st.cod_student);


select * from tara;

select * from locatie join tara using (cod_tara);


select * from examinare;

select * 
from student s join participa p on(s.cod_student = p.cod_student)
    join disciplina d on (p.cod_disciplina = d.cod_disciplina)
    join examinare e on (d.cod_disciplina = e.cod_disciplina)
order by s.cod_student;








