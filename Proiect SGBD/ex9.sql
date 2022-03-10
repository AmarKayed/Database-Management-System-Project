create or replace procedure exercitiul_9(
    ranking_facultate   facultate.ranking%type          -- ranking-ul facultatii dat ca parametru
)
is
    cod                 facultate.cod_facultate%type;       -- Codul facultatii
    nume_facultate      facultate.denumire%type;            -- Numele facultatii
    nota_maxima         examinare.nota%type;                -- Nota maxima obtinuta in cadrul facultatii
    nume_disciplina     disciplina.denumire%type;           -- Numele disciplinei asupra carei s-a obtinut nota maxima
    nume_student        student.nume%type;                  -- Numele studentului care a obtinut nota maxima la disciplina din cadrul facultatii
    nume_profesor       angajat.nume%type;                  -- Numele profesorului coordonator disciplinei cu nota maxima
    
    
begin
    
    -- verificam daca codul exista 
    select cod_facultate
    into cod
    from facultate
    where ranking = ranking_facultate;
    -- Daca codul nu ar fi exista, s-ar fi generat eroare no_data_found si s-ar fi oprit executia procedurii
    
    select *    -- Selectam informatiile necesare din tabele multiple folosind join-uri
    into nume_facultate, nota_maxima, nume_disciplina, nume_student, nume_profesor
    from(
        select f.denumire "Facultate",
                e.nota "Nota",
                d.denumire "Disciplina",
                s.nume || ' ' || s.prenume "Student",   -- Numele studentului si profesorului sunt complete
                a.nume || ' ' || a.prenume "Profesor"
        from student s 
            join participa      p     on (p.cod_student = s.cod_student)
            join examinare      e     on (e.cod_disciplina = p.cod_disciplina)
            join angajat        a     on (a.cod_angajat = p.cod_angajat)
            join profesor       pf    on (a.cod_angajat = pf.cod_angajat)
            join disciplina     d     on (p.cod_disciplina = d.cod_disciplina)
            join programa       pr    on (d.cod_disciplina = pr.cod_disciplina)
            join specializare   sp    on (pr.cod_specializare = sp.cod_specializare)
            join facultate      f     on (f.cod_facultate = sp.cod_facultate)
        where nota = (  -- Selectam toate detaliile pentru disciplina cu nota maxima
            select max(nota)    -- Subcerere in care electam nota maxima din cadrul facultatii date 
            from examinare e 
                join disciplina d on (e.cod_disciplina = d.cod_disciplina)
                join programa   p on (d.cod_disciplina = p.cod_disciplina) 
                join specializare sp on (sp.cod_specializare = p.cod_specializare)
                join facultate f on (sp.cod_facultate = f.cod_facultate)
            where f.cod_facultate = cod
            ) and f.cod_facultate = cod
        order by s.nume, s.prenume      -- Ordonam selectia dupa nume si prenume
    )
    where rownum = 1;   -- In cazul in care exista mai multi studenti, selectam doar primul ordonat dupa nume si prenume
    
    -- Afisam informatiile obtinute
    
    dbms_output.put_line('Facultate: ' || nume_facultate);
    dbms_output.put_line('Nota: ' || nota_maxima);
    dbms_output.put_line('Disciplina: ' || nume_disciplina);
    dbms_output.put_line('Student: ' || nume_student);
    dbms_output.put_line('Profesor: ' || nume_profesor);
    
exception
    when no_data_found then dbms_output.put_line('Nu exista facultate cu ranking-ul dat'); 
    when too_many_rows then dbms_output.put_line('Exista mai multe facultati care au ranking-ul egal cu ' || ranking_facultate);
    when others then dbms_output.put_line('Alt tip de eroare!');
end exercitiul_9;
/

execute exercitiul_9(1);
execute exercitiul_9(2);
-- Rezultate Corecte

execute exercitiul_9(10);
-- no_data_found





-- Rezultate incorecte?
execute exercitiul_9(3);
execute exercitiul_9(4);
execute exercitiul_9(5);

/*

Pentru un ranking al unei facultati dat ca parametru, sa se returneze numele facultatii, 
impreuna cu nota cea mai mare obtinuta in cadrul facultatii, numele disciplinei, 
numele studentului si numele profesorului coordonator

Daca exista mai multi studenti cu nota maxima, se va afisa doar primul in ordine alfabetica dupa nume si prenume.

*/

select * from facultate;

select *
from(
    select f.denumire "Facultate",
            e.nota "Nota", 
            d.denumire "Disciplina",
            s.nume || ' ' || s.prenume "Student", 
            a.nume || ' ' || a.prenume "Profesor"
    from student s 
        join participa      p     on (p.cod_student = s.cod_student)
        join examinare      e     on (e.cod_disciplina = p.cod_disciplina)
        join angajat        a     on (a.cod_angajat = p.cod_angajat)
        join profesor       pf    on (a.cod_angajat = pf.cod_angajat)
        join disciplina     d     on (p.cod_disciplina = d.cod_disciplina)
        join programa       pr    on (d.cod_disciplina = pr.cod_disciplina)
        join specializare   sp    on (pr.cod_specializare = sp.cod_specializare)
        join facultate      f     on (f.cod_facultate = sp.cod_facultate)
    where nota = (select max(nota) from examinare)
    order by s.nume, s.prenume
)
where rownum = 1;



select * from examinare;
/
-- aici incercam sa aflam de care facultate apartine disciplina cu nota maxima
select * 
from disciplina d 
    join programa pr on (d.cod_disciplina = pr.cod_disciplina)
    join specializare sp on(pr.cod_specializare = sp.cod_specializare)
    join facultate f on(f.cod_facultate = sp.cod_facultate)
where d.cod_disciplina = 11;

select *
from(
    select *
    from student s 
        join participa      p     on (p.cod_student = s.cod_student)
        join examinare      e     on (e.cod_disciplina = p.cod_disciplina)
        join angajat        a     on (a.cod_angajat = p.cod_angajat)
        join profesor       pf    on (a.cod_angajat = pf.cod_angajat)
        join disciplina     d     on (p.cod_disciplina = d.cod_disciplina)
        join programa       pr    on (d.cod_disciplina = pr.cod_disciplina)
        join specializare   sp    on (pr.cod_specializare = sp.cod_specializare)
        join facultate      f     on (f.cod_facultate = sp.cod_facultate)
    where nota = (select max(nota) from examinare)
    order by s.nume, s.prenume
)
where rownum = 1;

select * 
from participa p join student s on (s.cod_student = p.cod_student)
order by cod_disciplina;
/

select * 
from student s 
    join studiaza st on (s.cod_student = st.cod_student)
    join facultate f on (st.cod_facultate = f.cod_facultate)
order by s.cod_student;


select * from facultate;
/
select * from studiaza;



-- discipliniele din cadrul unei facultati:

select *
from examinare e
    join disciplina d on (e.cod_disciplina = d.cod_disciplina)
    join programa   p on (d.cod_disciplina = p.cod_disciplina) 
    join specializare sp on (sp.cod_specializare = p.cod_specializare)
    join facultate f on (sp.cod_facultate = f.cod_facultate)
order by nota desc;





















select f.denumire "Facultate",
        e.nota "Nota",
        d.denumire "Disciplina",
        s.nume || ' ' || s.prenume "Student", 
        a.nume || ' ' || a.prenume "Profesor"
from student s 
    join participa      p     on (p.cod_student = s.cod_student)
    join examinare      e     on (e.cod_disciplina = p.cod_disciplina)
    join angajat        a     on (a.cod_angajat = p.cod_angajat)
    join profesor       pf    on (a.cod_angajat = pf.cod_angajat)
    join disciplina     d     on (p.cod_disciplina = d.cod_disciplina)
    join programa       pr    on (d.cod_disciplina = pr.cod_disciplina)
    join specializare   sp    on (pr.cod_specializare = sp.cod_specializare)
    join facultate      f     on (f.cod_facultate = sp.cod_facultate)
where nota = (
    select max(nota)
    from examinare e 
        join disciplina d on (e.cod_disciplina = d.cod_disciplina)
        join programa   p on (d.cod_disciplina = p.cod_disciplina) 
        join specializare sp on (sp.cod_specializare = p.cod_specializare)
        join facultate f on (sp.cod_facultate = f.cod_facultate)
    where f.ranking = 2
    )
order by s.nume, s.prenume;

select *
from examinare e 
    join disciplina d on (e.cod_disciplina = d.cod_disciplina)
    join programa   p on (d.cod_disciplina = p.cod_disciplina) 
    join specializare sp on (sp.cod_specializare = p.cod_specializare)
    join facultate f on (sp.cod_facultate = f.cod_facultate)
where f.ranking = 2

