create or replace package exercitiul_14
is
    cursor studenti(id_student student.cod_student%type) is 
        select * from student where cod_student = id_student;
    
    cursor studenti_la_camin(c_camin camin.cod_camin%type) is
        select s.cod_student, e.nota "Nota maxima"
        from student s join participa p on(s.cod_student = p.cod_student)
            join disciplina d on (p.cod_disciplina = d.cod_disciplina)
            join examinare e on (d.cod_disciplina = e.cod_disciplina)
        where e.nota = (
            select max(nota)
            from examinare e2
            where e2.cod_disciplina = e.cod_disciplina
        )
        and
            s.cod_camin = c_camin;
    
    
    type informatii_student is record(
        stud    student%rowtype,
        nota    examinare.nota%type
    );
    
    type tablou_studenti is table of informatii_student;
    
--    type tablou_studenti is table of student%rowtype;
    
    type note_student is table of examinare.nota%type index by pls_integer;
    
    imb tablou_studenti := tablou_studenti();
    
    imb_note note_student;
    
    cod_premiant    student.cod_student%type;
    
    ok  boolean := true;        -- flag care indica daca fluxul programului este ok sau nu
    
    function exista_camin(id_camin  in  camin.cod_camin%type) return boolean;
    
    function detalii_camin(id_camin in camin.cod_camin%type) return camin%rowtype;
    
--    type boolean_cod_premiant is record(
--        ok boolean,                     -- Daca s-a gasit codul premiantului atunci ok = true si cod reprezinta codul premiantului
--        cod student.cod_student%type    -- Daca nu, ok = false iar cod nu are valoare
--    );
    
    function cauta_cod_premiant return boolean;
    
    procedure detalii_student(id_student student.cod_student%type);
    
    procedure cauta_studenti(c_camin camin.cod_camin%type);
    
    procedure principal;
end exercitiul_14;
/

create or replace package body exercitiul_14
is

    
    
    function exista_camin(id_camin in camin.cod_camin%type)
    return boolean
    is
        cod camin.cod_camin%type;
    begin
        select cod_camin
        into cod
        from camin
        where cod_camin = id_camin;
        
        -- Daca nu s-a aruncat exceptia no_data_found atunci caminul exista
        return true;
    exception
        when no_data_found then 
            dbms_output.put_line('Nu exista niciun camin cu codul ' || id_camin);
            return false;
        -- este imposibil sa avem exceptia too_many_rows datorita unicitatii cheii primare cod_camin
    end exista_camin;
    
    function detalii_camin(id_camin in camin.cod_camin%type)
    return camin%rowtype
    is
        nu_exista_camin exception;
    begin
        if exista_camin(id_camin) = false then
            raise nu_exista_camin;
        end if;
        
    exception
        when nu_exista_camin then 
            -- Avem deja un mesaj printat din functia exista_camin
            -- deci nu mai avem nimic de executat in functia detalii_camin
            null;
    end detalii_camin;
    

    procedure detalii_student(id_student student.cod_student%type)
    is

    begin
        null;
--    exception
--        no_data_found;
    end detalii_student;
    
    
    procedure cauta_studenti(c_camin    camin.cod_camin%type)
    is
        contor number := 1;
    begin        
        
        for i in studenti_la_camin(c_camin) loop
            dbms_output.put_line(i.cod_student);
            imb.extend;
            imb(contor).stud := i;
            contor := contor + 1;
        end loop;
    end cauta_studenti;
    
    
    
    function cauta_cod_premiant return boolean
    is
--        rezultat boolean_cod_premiant;
        nu_exista_studenti_la_camin exception;
    begin
        if imb.count > 0 then
            for i in imb.first..imb.last loop
                
                select s.cod_student
                bulk collect into imb_note(i)
                from student s join participa p on(s.cod_student = p.cod_student)
                    join disciplina d on (p.cod_disciplina = d.cod_disciplina)
                    join examinare e on (d.cod_disciplina = e.cod_disciplina)
                where e.nota = (
                    select max(nota)
                    from examinare e2
                    where e2.cod_disciplina = e.cod_disciplina
                )
                and s.cod_student in imb;
    --            rezultat.ok := true;
    --            rezultat.cod := cod_premiant;
    --            return rezultat;
                return true;
            end loop;
            
        else raise nu_exista_studenti_la_camin;
        end if;
        
    exception
        when nu_exista_studenti_la_camin then
            dbms_output.put_line('Nu exista studenti la camin');
--            rezultat.ok := false;
--            rezultat.cod := 0;
--            return rezultat;
            return false;
        
    end cauta_cod_premiant;
    
    procedure principal
    is
--        c_camin     camin.cod_camin%type := &cod_camin;
        c_camin     camin.cod_camin%type;
    begin
        if exista_camin(c_camin) then
            cauta_studenti(c_camin);    -- am obtinut toti studentii care sunt la caminul c_camin
            if cauta_cod_premiant() then    -- cauta_cod_premiant ne gaseste codul premiantului
                null;
            end if;
        end if;
        
    end principal;
    
end exercitiul_14;
/


/*
select * from camin;
select * from student where cod_camin = 1;
execute exercitiul_14.cauta_studenti(1);
(/

/*
Pentru studentul cu cea mai mare nota din cadrul facultatii in care se afla si care se afla 
intr un camin anume sa se afiseze toti profesorii lui impreuna cu materiile predate

Se va tasta codul unui camin
pentru toti studentii din cadrul acelui camin se va selecta
doar studentul al carui nota este cea mai mare dintre toti
pentru acel student se vor afisa toti profesorii
dupa care pentru fiecare profesor in parte din cei afisati
se va afisa toate materiile predate de fiecare profesor

*/






/*
Daca id-ul este par
sa se afiseze lista profesorilor studentului
daca e impar
sa se obtina studentul cu cei mai multi profesori

*/

