create or replace package exercitiul_13
is

    procedure exercitiul_6(id      student.cod_student%type);
    
    procedure exercitiul_7(a   angajat.salariu%type, b   angajat.salariu%type);
    
    function exercitiul_8(
        nume_student            in    student.nume%type,
        prenume_student         in    student.prenume%type
    )
    return tara.nume%type;
    
    procedure exercitiul_9(ranking_facultate   facultate.ranking%type);
    
    

end exercitiul_13;
/

create or replace package body exercitiul_13
is

    procedure exercitiul_6(
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
    




    procedure exercitiul_7(
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
    
    
    
    


    function exercitiul_8(
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
    
    
    

    procedure exercitiul_9(
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

    


end exercitiul_13;
/



declare
    a tara.nume%type;
begin
    exercitiul_13.exercitiul_6(11);
    exercitiul_13.exercitiul_7(3800, 5000);
    
    a := exercitiul_13.exercitiul_8('Mircea', 'Bravo');
    dbms_output.put_line(a);
    exercitiul_13.exercitiul_9(1);
    
end;
/