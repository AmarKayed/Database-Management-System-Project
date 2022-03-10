create or replace package exercitiul_14
is
    
--    c_camin     camin.cod_camin%type := &cod_camin;
--    c_camin     camin.cod_camin%type := 1;
    
    cursor studenti_la_camin(cod camin.cod_camin%type) is
        select * from student where cod_camin = cod;
        
    type detalii_profesor is record(
        cod         angajat.cod_angajat%type,
        salariu     angajat.salariu%type
    );
    
    type tablou_detalii_profesor is table of detalii_profesor index by pls_integer;
    
    ind tablou_detalii_profesor;
    
    
    function exista_camin(cod   in  camin.cod_camin%type) return boolean;
    
    procedure afisare_studenti(c_camin camin.cod_camin%type);
    
    function functie_main(c_camin in camin.cod_camin%type) return boolean;
    
    
end exercitiul_14;
/

create or replace package body exercitiul_14
is

    function exista_camin(cod   in  camin.cod_camin%type) 
    return boolean
    is
        cod_aux camin.cod_camin%type;
    begin
        select cod_camin
        into cod_aux
        from camin
        where cod_camin = cod;
        return true;
    exception
        when no_data_found then
            dbms_output.put_line('exista_camin(): NU EXISTA CAMINUL CU CODUL ' || cod);
            return false;
    end exista_camin;
    
    
    procedure afisare_studenti(c_camin camin.cod_camin%type)
    is
    begin
        dbms_output.put_line('Studentii cazati la caminul ' || c_camin || ' sunt:');
        for i in studenti_la_camin(c_camin) loop
            dbms_output.put_line('   ' || i.nume || ' ' || i.prenume);
        end loop;
    end afisare_studenti;
    
    function functie_main(c_camin in camin.cod_camin%type) 
    return boolean
    is
        nu_exista_camin exception;
    begin
        if exista_camin(c_camin) then
            afisare_studenti(c_camin);
        else raise nu_exista_camin;
        end if;
        
        return true;
        
    exception
        when nu_exista_camin then
            dbms_output.put_line('functie_main(): Programul nu a fost rulat cu succes pana la capat');
            return false;
    end functie_main;
    
end exercitiul_14;
/

declare
    c_camin     camin.cod_camin%type := &cod_camin;
    rezultat boolean;
begin
    rezultat := exercitiul_14.functie_main(c_camin);
end;
/

select * from student;
delete from student
where cod_student = 66;
commit;
/*
Pentru un cod de camin dat de la tastatura
se vor selecta toti studentii cazati la acel camin
din multimea de studenti se va selecta doar studentul al carui
salariu combinat al tuturor profesorilor la care acesta invata
este maxim
pentru acel student se va printa specializarea pe care acesta o urmeaza la facutlate

Pasi:

    selectam toti studentii din camin
    selectam multimea profesorilor+salariilor pentru fiecare student in parte
    calculam salariul total pentru fiecare multime de profesori
    selectam studentul care are salariul total maxim
    selectam specializarea studentului
*/