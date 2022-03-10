create or replace procedure exercitiul_6(
    id      student.cod_student%type          -- codul studentului dat ca parametru
)
is
        
    cursor c is select rownum, cod_student, nume, prenume from student;      -- cursor pentru a parcurge liniile din tabelul student
    
    nr_linie_id         number;                                                 -- numarul liniei parcurse de cursor
    id_student          student.cod_student%type;                               -- id-ul studentului parcurs de cursor
    nume                student.nume%type;                                      -- numele studentului parcurs de cursor
    prenume             student.prenume%type;                                   -- prenumele studentului parcurs de cursor
    
    id_maxim            student.cod_student%type;       -- id-ul de valoare maxima a studentilor aflati pe liniile urmatoare id-ului de student dat ca parametru
    
    type tab_ind_fibonacci is table of number index by pls_integer;         -- tablou indexat ce memoreaza numerele fibonacci mai mici +-1 decat id_maxim
    
    ind             tab_ind_fibonacci;                  -- tabloul indexat in care o sa memoram numerele fibonacci calculate        

    contor          number;                             -- contor folosit pentru a parcurge tabloul indexat anterior declarat
    nr_studenti     number;                             -- numarul total de studenti
    sem             boolean;                            -- semafor folosit pentru eficientizarea timpului de executie
    
    no_fibonacci_found exception;               -- exceptie specifica exercitiului
    too_many_fibonacci exception;               -- exceptie specifica exercitiului
    
    type detalii_profesor is record(            -- tip inregistrare(record) pentru memorarea detaliilor despre un profesor
        nume        angajat.nume%type,
        prenume     angajat.prenume%type,
        salariu     angajat.salariu%type
    );
    
    type v_detalii_profesor is varray(25) of detalii_profesor;      -- varray de 25 de detalii_profesor
    
    type tab_imb_nume_profesori is table of v_detalii_profesor;     -- tablou imbricat al carui elemente sunt varray-uri de detalii_profesor(matrice)
    
    imb tab_imb_nume_profesori := tab_imb_nume_profesori();         -- imb este practic o matrice de detalii_profesor
    
    
begin
    -- verificam daca id-ul dat ca parametru exista de fapt in baza de date
    select cod_student into id_student from student where cod_student = id;   
    -- generam NO_DATA_FOUND daca nu gasim id-ul dat ca parametru
    -- Daca nu s-a generat eroarea NO_DATA_FOUND inseamna ca id-ul exista si il avem memorat in variabila auxiliara id_student
    
    open c;     -- deschidem cursorul pentru a incepe parcurgerea tabelului student
    
        loop    -- cat timp nu am parcurs tot tabelul
            fetch c into nr_linie_id, id_student, nume, prenume;    -- plasam valorile liniei curente in variabilele asociate
            exit when c%notfound;                                   -- oprim bucla atunci cand am trecut de ultima linie a tabelului
            if id_student = id then                                 -- daca id-ul curent este egal cu id-ul dat ca parametru
                exit;                                               -- inseamna ca putem sa iesim din bucla parcurgerii cursorului
            end if;
            
        end loop;
        
        -- am gasit linia unde se afla student-ul cu id-ul dat
        -- trebuie sa calculam id-ul maxim dintre cei ramasi
        
        id_maxim := id_student; -- initial, id-ul maxim va fi fix id-ul dat ca parametru
        
        loop                                        -- incepand cu linia imediat urmatoare liniei in care se afla id-ul dat ca parametru
            exit when c%notfound;                   -- verificam intai daca id-ul dat ca parametru se afla deja pe ultima linie a tabelului student
            fetch c into nr_linie_id, id_student, nume, prenume;    -- Daca nu era pe ultima linie, atunci incepem cautarea id-ului maxim
            if id_student > id_maxim then           -- Daca id-ul curent este mai mare decat id-ul maxim calculat pana in acest moment
                id_maxim := id_student;             -- Atunci noul id_maxim devine id-ul curent
            end if;
        end loop;
        
        dbms_output.put_line('ID-ul dat: ' || id);          -- Printam id-ul dat ca parametru
        dbms_output.put_line('ID-ul maxim: ' || id_maxim);  -- Printam id-ul maxim incepand cu linia urmatoare id-ului curent
    close c;
    
   
    dbms_output.new_line;           -- Printam o noua linie
    
    -- Acum ca avem id-ul maxim calculat, putem incepe calcularea numerelor fibonacci mai mici +-1 decat id_maxim
    
    if 1 <= id_maxim + 1 then       -- Daca primul termen fibonacci(1) este mai mic sau egal decat id_maxim + 1 atunci putem incepe calcularea
        ind(1) := 1;                -- Primul termen fibonacci este 1
        ind(2) := 1;                -- Al doilea termen fibonacci este 2
        contor := 3;                -- Calculul incepe cu al treilea termen fibonacci, deci contor este 3
        else            -- Daca in schimb id_maxim + 1 este mai mic decat primul termen fibonacci, atunci nu avem ce termeni fibonacci sa calculam(numerele fibonacci sunt strict pozitive)
            raise no_fibonacci_found;       -- Prin urmare, aruncam exceptia no_fibonacci_found, intrucat nu avem numere fibonacci
    end if;
    
    -- Daca nu s-a aruncat exceptia, atunci putem continua calcularea numerelor fibonacci
    while ind(contor-1) + 1 <= id_maxim loop                    -- Cat timp termenul anterior + 1 este mai mic sau egal decat id_maxim calculam urmatorul termen fibonacci
        if ind(contor - 1) + ind(contor - 2) > id_maxim then    -- Daca urmatorul termen fibonacci va fi mai mare strict decat id_maxim, nu il mai calculam
            exit;                                               -- Ci in schimb iesim din bucla
        end if;
        ind(contor) := ind(contor-1) + ind(contor-2);   -- fib(i) = fib(i-1) + fib(i-2);
        contor := contor + 1;                           -- i++;
    end loop;
    
    
    dbms_output.put_line('Numerele fibonacci mai mici ca ' || id_maxim || ':');     -- Incepem afisarea termenilor fibonacci calculati
    for i in ind.first..ind.last loop               -- Parcurgem tabloul indexat folosind o bucla for
        dbms_output.put(ind(i) || ' ');             -- Printam toti termenii fibonacci intr-o singura linie separand prin spatiu
    end loop;
    dbms_output.new_line;                           -- Afisam 3 linii noi pentru a separa continutul afisat
    dbms_output.new_line;
    dbms_output.new_line;
    
    
    -- Determinam numarul de studenti care se afla dupa id-ul dat, precum si numarul de studenti al caror id este fibonacci
    nr_studenti := 0;               -- Initial consideram ca numarul de studenti aflati sub id-ul dat este 0
    contor := 0;                    -- In contor vom memora numarul de id-uri fibonacci, contor este initializat cu 0
    open c;                         -- Deschidem cursorul din nou, acesta se afla inainte de prima linie din tabel
        loop                        -- Cautam sa ajungem la linia unde se afla id-ul dat ca parametru
            fetch c into nr_linie_id, id_student, nume, prenume;
            exit when id_student = id;      -- Odata ce am ajuns la linia cu id-ul dat ca parametru oprim bucla
        end loop;
        loop                                -- Incepem sa numaram studentii aflati sub id-ul dat
            nr_studenti := nr_studenti + 1; -- Luam in considerare si id-ul dat ca fiind unul elegibil
            -- Testam daca id-ul curent este fibonacci
            sem := true;                    -- Consideram sem = true atunci cand id-ul nu este fibonacci
            for i in ind.first..ind.last loop       -- Parcurgem tabloul de numere fibonacci
                if id_student >= ind(i) - 1 and id_student <= ind(i) + 1 then       -- Daca id-ul curent este egal +-1 fata de termenul fibonacci curent

                    contor := contor + 1;       -- Incrementam contor-ul pentru a creste numarul de id-uri fibonacci
                    sem := false;               -- sem devine false, intrucat stim ca id-ul este fibonacci
                end if;
                
                if sem = false then             -- Daca am determinat ca id-ul este fibonacci, nu mai este nevoie sa comparam cu restul numerelor fibonacci din tablou
                    exit;                       -- Prin urmare, putem iesi din bucla for
                end if;
                
            end loop;
            
            
            
            fetch c into nr_linie_id, id_student, nume, prenume;        -- Trecem la urmatorul id
            exit when c%notfound;                                       -- Repetam procesul pentru fiecare id in parte
        end loop;
    close c;    -- Inchidem cursorul odata ce am terminat
            
    
    /*
    Pana acum avem urmatoarele:
    contor = numarul de studenti cu id fibonacci
    nr_studenti = numarul tuturor studentilor
    */
--    dbms_output.put_line(contor);
--    dbms_output.put_line(nr_studenti);
    if contor = 0 then                         -- daca contor = 0 inseaman ca nu avem id-uri fibonacci si aruncam exceptia no_fibonacci_found
        raise no_fibonacci_found;
    elsif contor > 0.5 * nr_studenti then      -- daca avem mai mult de jumatate + 1 dintre toti studentii eligibil cu id-uri fibonacci, intram pe exceptia TOO_MANY_FIBONACCI
        raise too_many_fibonacci;
    end if;  
    
    -- daca nu am intrat pe exceptia TOO_MANY_FIBONACCI, inseamna putem sa
    -- afisam toti studentii care se incadreaza in conditia id-ului:
    -- Practic nu mai avem nevoie de numarul de id-uri fibonacci, deci putem sa reutilizam variabila contor
    open c;     -- Deschidem cursorul pentru parcurgerea tabelului student
        
        loop
            fetch c into nr_linie_id, id_student, nume, prenume;
            exit when id_student = id;          -- Parcurgem toate liniile pana la linia cu id-ul dat ca parametru
        end loop;
        
        -- Incepem sa construim matricea de detalii_profesor din imb
        contor := 1;    -- Contor ia primul indice al tabloului imb
        
        loop
            -- Pentru fiecare id de dupa id-ul parametru, verificam daca este fibonacci si afisam datele
            for i in ind.first..ind.last loop
                if id_student >= ind(i) - 1 and id_student <= ind(i) + 1 then   -- Daca id-ul este id fibonacci afisam informatiile
                    dbms_output.put_line('Nr linie: ' || nr_linie_id);
                    dbms_output.put_line('ID: ' || id_student);
                    dbms_output.put_line('Nume Student: ' || nume || ' ' || prenume);
                    dbms_output.put('Profesori: ');
                    
                    imb.extend;     -- necesar tablourilor imbricate si varray-urilor
                    
                    select a.nume, a.prenume, a.salariu             -- Selectam toti profesorii studentului cu id-ul curent
                    bulk collect into imb(contor)                   -- Stocam toate campurile selectate in imb(contor), care este de tipul varray(25) de detalii_profesor
                    from participa p join student s on (s.cod_student = p.cod_student)
                        join profesor pf on (p.cod_angajat = pf.cod_angajat)
                        join angajat a on (p.cod_angajat = a.cod_angajat)
                    where s.cod_student = id_student
                    order by s.nume;
                    
                    
                    
                    for i in imb(contor).first..imb(contor).last loop       -- Parcurgem lista tuturor profesorilor unui student
                        dbms_output.put(imb(contor)(i).nume || ' ' || imb(contor)(i).prenume || ' ' || imb(contor)(i).salariu); -- Afisam numele, prenumele si salariul profesorului curent
                        if i < imb(contor).last then        -- Daca nu am ajuns la ultimul profesor
                            dbms_output.put(', ');          -- Afisam virgula ca separator
                            else
                                dbms_output.put('.');       -- Daca am ajuns la ultimul profesor, punem simbolul punct.
                        end if;
                    end loop;
                    
                    contor := contor + 1;       -- Incrementam contor-ul pentru a trece la urmatorul element al lui imb
                    
                    
                    dbms_output.new_line;       -- Punem new_line pentru a se afisa toate dbms_output.put()-urile executate in for
                    dbms_output.new_line;       -- Punem inca un new_line pentru a pastra afisarea mai spatiata
                    
                    
                end if;
            end loop;
            
            fetch c into nr_linie_id, id_student, nume, prenume;        -- Trecem la urmatorul student
            exit when c%notfound;                                       -- Incheiem bucla atunci cand am terminat studentii
            
        end loop;
        
    close c;     
    
    ind.delete;     -- stergem tabloul indexat
    for i in imb.first..imb.last loop
        imb(i).delete;      -- Stergem fiecare varray existent in imb
    end loop;
    imb.delete;         -- Stergem tabloul imbricat
    
    
exception
    when no_data_found then dbms_output.put_line('ID-ul dat nu exista in baza de date');        -- Atunci cand avem no_data_found inseamna ca nu exista student cu id-ul dat ca parametru
    when no_fibonacci_found then dbms_output.put_line('Niciun student nu are id fibonacci');    -- Atunci cand nu exista niciun id fibonacci sau daca id_maxim este mai mic decat primul termen fibonacci
    when too_many_fibonacci then dbms_output.put_line('Mai mult de jumatate + 1 dintre studentii eligibili au id-uri fibonacci');   -- Atunci cand mai mult de jumatate + 1 dintre id-uri sunt fibonacci primim aceasta eroare
    -- nu intalnim erori de tipul too_many_rows, intrucat toate select-urile pe care le 
    -- efectuam se fac impreuna cu clauza where cod_student = id;
    -- din moment ce prin definitie cod_student este cheie primara in tabela student 
    -- o sa avem cel mult un rezultat in urma select-ului.
    
    -- when too_many_rows then dbms_output.put_line('Too Many Rows');
    
    when others then dbms_output.put_line('Alt tip de eroare!');        -- Tratam orice alt tip de eroare
    
    
end exercitiul_6;
/

insert into student
values(66, 'c', 'c', sysdate, 1, 1);

select * from student;

select p.cod_angajat, nume, prenume, salariu 
from angajat a join profesor p on (a.cod_angajat = p.cod_angajat);

select * from participa;

execute exercitiul_6(11);
-- rezultat bun
execute exercitiul_6(33);
-- rezultat bun
execute exercitiul_6(44);
-- rezultat bun

execute exercitiul_6(1001);
-- no_data_found
execute exercitiul_6(22);
-- too_many_fibonacci
execute exercitiul_6(66);
-- no_fibonacci_found

rollback;

select * from student;



select * from student join specializare using(cod_specializare);


/*

pentru un id dat ca parametru si incepand cu urmatoarele linii de dupa acest id pana la sfarsitul tabelului
(incepand cu acest id)
pentru fiecare student al carui id este egal cu un numar fibonacci +- o marja de eroare de maxim 1 numar

sa se afiseze numele profesorilor la care acesta invata precum si salariul acestora

afisarea se va face sub forma: nume prenume salariu
pentru fiecare profesor in parte

De asemenea, sa se afiseze lista tuturor numerelor fibonacci mai mici sau egale +- 1 decat id-ul maxim al categoriei
de studenti aflate pe liniile urmatoare din tabel fata de id-ul dat ca parametru

Daca nu exista studenti cu id-uri egale cu numere fibonacci, se va arunca o exceptie "NO_FIBONACCI_FOUND"
daca mai mult de jumatate + 1 dintre toti studentii eligibili(care se afla sub id-ul dat ca parametru)
au id-uri egale cu numere fibonacci +- marja de eroare, atunci se va arunca exceptia
"TOO_MANY_FIBONACCI"

Spunem ca un numar este egal +-1 cu un numar fibonacci x daca acesta este cuprins in intervalul [x-1, x+1].

Indiferent daca se va arunca o exceptie no_fibonacci_found sau too_many_fibonacci 
id-ul dat, id-ul maxim, precum si numerele fibonacci mai mici ca id-ul maxim vor fi afisate.

In cazul exceptiei no_data_found, se va trata direct exceptia, intrucat nu se poate face
nimic fara un id valid.

Rezolvare:
    Verificam daca id-ul dat ca parametru este valid, daca nu este valid ne oprim la acest pas
    Calculam id-ul maxim luand in considerare doar id-urile care vin imediat dupa id-ul dat ca parametru
    Folosim un tablou indexat pentru numerele fibonacci, trebuie sa gasim id-ul maxim pentru ultimul nr fibonacci
    Folosim un record cu numele si salariul unui profesor
    Folosim un varray de tipul record anterior mentionat pentru a retine detaliile tuturor profesorilor la care invata un student
    Folosim un tablou imbricat de varray-uri pentru a contrui o matrice in care fiecare linie i reprezinta lista profesorilor studentului i

Pentru majoritatea operatiilor vom folosi un cursor pentru a parcurge tabelul student



*/

select s.nume from participa p join student s using(cod_student);

select * from participa;


select s.nume "Student" , a.nume "Profesor"
from participa p join student s on (s.cod_student = p.cod_student)
    join profesor pf on (p.cod_angajat = pf.cod_angajat)
    join angajat a on (p.cod_angajat = a.cod_angajat)
order by s.nume;

select a.cod_angajat, nume, prenume, salariu, data_nastere
from angajat a join profesor p on (a.cod_angajat = p.cod_angajat);

