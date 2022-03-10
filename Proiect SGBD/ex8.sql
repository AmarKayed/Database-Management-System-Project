create or replace function exercitiul_8(
    nume_student            in    student.nume%type,            -- Numele studentului dat ca parametru de intrare de tip IN
    prenume_student         in    student.prenume%type          -- Prenumele studentului dat ca parametru de intrare de tip IN
)
return tara.nume%type           -- Tipul de data returnat este numele tarii in care se afla facultatea de ranking maxim a studentului dat ca parametru 
is
    cod                     student.cod_student%type;           -- Codul studentului dat ca parametru
    nume_tara               tara.nume%type;                     -- Numele tarii in care afla facultatea studentului
    nume_specializare       specializare.denumire%type;         -- Numele specializarii la care este inscris studentul
    nume_camin              camin.denumire%type;                -- Numele caminului studentului
begin
    -- putem avea erorile no_data_found sau too_many_rows
    -- no_data_found atunci cand nu exista un student cu numele si prenumele dat
    -- too_many_rows atunci cand avem cel putin doi studenti cu nume si prenume identice
    select cod_student      -- selectam codul studentului cu numele si prenumele date
    into cod
    from student
    where initcap(nume) = initcap(nume_student) and initcap(prenume) = initcap(prenume_student);
    -- Selectarea se face fara case sensitivity, numele studentului putand fii scris cu numere mici sau mari.
    
    -- Daca nu s-a aruncat nicio exceptie, atunci putem cauta numele caminului, numele specializarii si numele tarii
    -- Din moment ce selectam informatii din minim 3 tabele diferite, 
    -- avem de facut join-uri care sa conecteze informatiile astfel incat 
    -- sa se pastreze corectitudinea datelor.
    
    select c.denumire "Camin", sp.denumire "Specializare",  t.nume "Tara"
    into nume_camin, nume_specializare, nume_tara
    from student s
        join camin c on (s.cod_camin = c.cod_camin)
        join specializare sp on (s.cod_specializare = sp.cod_specializare)
        join studiaza st on (s.cod_student = st.cod_student) 
        join facultate f on (f.cod_facultate = st.cod_facultate)
        join locatie l on (l.cod_locatie = f.cod_locatie)
        join tara t on (l.cod_tara = t.cod_tara)
    where f.ranking = (
        select min(ranking) -- cu cat rankingul este mai mic cu atat facultatea este mai de top
        from student s2 
            join studiaza st2 on (s2.cod_student = st2.cod_student)
            join facultate f2 on (f2.cod_facultate = st2.cod_facultate)
        where s2.cod_student = cod      -- Selectam ranking-ul maxim dintre toate facultatiile urmate de studentul dat ca parametru
    ) and s.cod_student = cod; -- Selectam detaliile despre facultatea al carei ranking este egal cu ranking-ul maxim dintre toate facultatile urmate de studentul dat ca parametru
    
    -- Afisam detaliile obtinute
    dbms_output.put('Studentul ' || nume_student || ' ' || prenume_student);
    dbms_output.put(' urmeaza specializarea ' || nume_specializare);
    dbms_output.put(' dintr-o facultate din ' || nume_tara || ',');
    if nume_camin = null then   -- Daca studentul nu este cazat la vreun camin, afisam un mesaj sugestiv
        dbms_output.put(' studentul nefiind cazat la vreun camin.');
        else
            dbms_output.put(' fiind cazat in caminul ' || nume_camin || '.');
    end if;
    
    dbms_output.new_line;   -- Pentru dbms_output.put();
    
    return(nume_tara);      -- Functia returneaza numele tarii in care se afla facultatea de ranking maxim urmata de student

exception
    when no_data_found then         -- Atunci cand nu exista studentul dat ca parametru in baza de date
        dbms_output.put_line('Nu exista niciun student cu numele de "' || nume_student || ' ' || prenume_student || '"');
        return('');                 -- Returnam sirul vid, intrucat nu putem afla tara in care se afla facultatea
    when too_many_rows then         -- Exista mai multi studenti cu acelasi nume si prenume
        dbms_output.put_line('Exista mai multi studenti cu numele de "' || nume_student || ' ' || prenume_student || '"');
        return('');
    when others then                -- Orice alt tip de eroare
        dbms_output.put_line('Alt tip de eroare!');
        return('');
end exercitiul_8;
/

declare
    a tara.nume%type;
begin
    a := exercitiul_8('Mircea', 'Bravo');
    a := exercitiul_8('Ionescu', 'Stefan');
    a := exercitiul_8('GeorGeScu', 'NICOLAE');
    a := exercitiul_8('Emil', 'Luca');
    a := exercitiul_8('Florentin', 'Daniel');

end;
/
select * from student;

/*
Pentru prenumele si numele unui student date ca parametru se va returna
numele tarii in care se afla facultatea la care este inscris studentul.
In cazul in care studentul este inscris la mai multe facultati, se va
alege facultatea cu ranking-ul mai mare.

De asemenea, se vor afisa in dbms_output numele specializarii, numele caminului in care
este cazat studentul precum si numele tarii in care se afla facultatea.

Propozitia afisata va avea forma:

Studentul <<nume>> <<prenume>> urmeaza specializarea <<x>> dintr-o facultate din <<y>>,
fiind cazat in caminul <<z>>.

*/

select * from tara;

-- selectam toate facultatile la care sunt inscrisi studentii
select s.cod_student, s.nume, s.prenume, f.cod_facultate, f.denumire, f.ranking
from student s 
    join studiaza st on (s.cod_student = st.cod_student)
    join facultate f on (f.cod_facultate = st.cod_facultate)
order by s.cod_student;
    
    
select c.denumire "Camin", sp.denumire "Specializare",  t.nume "Tara"
from student s
    join camin c on (s.cod_camin = c.cod_camin)
    join specializare sp on (s.cod_specializare = sp.cod_specializare)
    join studiaza st on (s.cod_student = st.cod_student) 
    join facultate f on (f.cod_facultate = st.cod_facultate)
    join locatie l on (l.cod_locatie = f.cod_locatie)
    join tara t on (l.cod_tara = t.cod_tara)
where f.ranking = (
    select min(ranking) -- cu cat rankingul este mai mic cu atat facultatea este mai de top
    from student s 
        join studiaza st on (s.cod_student = st.cod_student)
        join facultate f on (f.cod_facultate = st.cod_facultate)
    where s.cod_student = 11
);

select * 
from facultate f join locatie l on(f.cod_locatie = l.cod_locatie)
join tara t on(t.cod_tara = l.cod_tara)
order by f.ranking;
