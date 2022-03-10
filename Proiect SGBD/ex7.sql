create or replace procedure exercitiul_7(
    a   angajat.salariu%type,       -- Limita inferioara a intervalului salarial
    b   angajat.salariu%type        -- Limita superioara a intervalului salarial
)
is
    -- cursor explicit parametrizat
    -- selecteaza codul, numele, prenumele, salariul profesorilor ca se incadreaza in intervalul salarial
    -- precum si denumirea facultatii la care acesti profesori predau
    cursor c(x angajat.salariu%type, y angajat.salariu%type) is 
        select cod_angajat, nume, prenume, salariu, denumire
        from angajat join facultate using(cod_facultate) 
        where salariu between x and y;
    
    a_cod               angajat.cod_angajat%type;   -- variabila pentru codul profesorului
    a_nume              angajat.nume%type;          -- variabila pentru numele profesorului
    a_prenume           angajat.prenume%type;       -- variabila pentru prenumele profesorului
    a_salariu           angajat.salariu%type;       -- variabila pentru salariul profesorului
    f_denumire          facultate.denumire%type;    -- variabila pentru denumirea facultatii la care preda profesorul
    
    nr_linii            number := 0;    -- numarul de iteratii ale cursorului c
    salariu_inexistent  exception;      -- exceptie pentru cazul in care nu exista salariu din intervalul [a, b]
    
begin

    open c(a, b);               -- Deschidem cursorul c pentru parametri a si b
        loop
            fetch c into a_cod, a_nume, a_prenume, a_salariu, f_denumire;           -- Asignam valorile linie curente variabilelor corespunzatoare
            exit when c%notfound;           -- Folosim atributul notfound pentru a verifica daca am parcurs toate liniile tabelului. In caz afirmativ iesim din bucla
            nr_linii := nr_linii + 1;       -- La fiecare iteratie a cursorului, incrementam variabila nr_linii
        end loop;
    close c;            -- Dupa ce am iterat prin toate liniile tabelului inchidem cursorul
    
    if nr_linii = 0 then                -- Daca cursorul c nu a gasit nicio linie din tabel, inseamna ca nu exista un salariu din intervalul [a, b]
        raise salariu_inexistent;       -- Prin urmare, se arunca exceptia "salariu_inexistent"
    end if;
    
    -- Daca nu s-a aruncat exceptia "salariu_inexistent"
    open c(a, b);               -- Putem incepe afisarea tuturor angajatilor cu salariul din intervalul [a, b]
    
        loop 
            
            fetch c into a_cod, a_nume, a_prenume, a_salariu, f_denumire;       -- Extragem informatiile angajatului curent
            exit when c%notfound;       -- atribut notfound
            
            
            dbms_output.put_line('Nume Angajat: ' || a_nume || ' ' || a_prenume);   -- Afisam informatiile angajatului
            dbms_output.put_line('Salariu: ' || a_salariu);
            dbms_output.put_line('Facultate: ' || f_denumire);
            dbms_output.put('Colegi: ');
            
            -- Obtinem lista colegilor angajatului curent folosindu-ne de un ciclu cursor in bucla for
            for i in (
                select nume, prenume
                from angajat join facultate using(cod_facultate)            -- ciclu cursor
                where denumire = f_denumire and cod_angajat <> a_cod
            ) loop
                dbms_output.put(i.nume || ' ' || i.prenume || ', ');        -- Afisam lista tuturor colegilor angajatului curent
                
            end loop;
            dbms_output.new_line;   -- Afisam new_line pentru a se afisa lista anterior mentionata
            dbms_output.new_line;   -- Afisam inca 2 new_line-uri pentru spatiere
            dbms_output.new_line;
        end loop;
        
    close c;    -- Inchidem cursorul c
    
exception
    -- nu intalnim cazul in care sa avem eroarea no_data_found
    -- intrucat in cazul cursoarelor, chiar daca nu se gaseste nicio linie in urma
    -- select-urilor, cursoarele raman valide, dar goale
    -- in cazul care cursoarelor goale, avem exceptia "salariu_inexistent"
    
    -- when no_data_found then dbms_output.put_line('Nu au fost gasite date in baza de date');
    
    -- nu intalnim cazul in care sa avem eroarea too_many_rows
    -- intrucat toate select-urile facute sunt pentru cursoare
    
    -- when too_many_rows then dbms_output.put_line('Too Many Rows');
    
    when salariu_inexistent then dbms_output.put_line('Nu exista niciun salariu din intervalul [' || a || ', ' || b || ']');
    when others then dbms_output.put_line('Alt tip de eroare!');
    
    
end exercitiul_7;
/
/*
OBSERVATIE: Inainte de a rula urmatoarele teste
este recomandat sa se verifice integritatea datelor din tabelul
angajat. Mai exact, este important ca salariile sa fie aceleasi
ca cele inserate initial, intrucat acestea ar putea ramane
modificate de trigger-ul de la exercitiul 10.

*/



execute exercitiul_7(3800, 5000);
-- rezultat bun
execute exercitiul_7(100000, 1000001);
-- salariu_inexistent

select * from angajat order by salariu;

select * from facultate;

/*
Sa se afiseze toti angajatii al caror salariu se incadreaza intre cei doi parametri a si b, 
precum si colegii lor de munca la facultate.
*/