create or replace package exercitiul_14
is
    cursor studenti is select * from student;                               -- Cursor pentru parcurgerea tabelului student
    
    -- Cursor parametrizat pentru parcurgerea listei tuturor profesorilor unui student cu codul dat ca parametru
    -- Acest cursor va fi folosit in afiseaza_profesori()
    cursor detalii_profesor(c_student student.cod_student%type)is
        select a.nume, a.prenume, a.salariu
        from angajat a join profesor prof on (a.cod_angajat = prof.cod_angajat)
            join participa p on (a.cod_angajat = p.cod_angajat)
        where p.cod_student = c_student
        order by a.nume, a.prenume, a.salariu desc;
    
    
    -- Tip inregistrare(record) folosit pentru extragerea informatiilor(fetch) din cursorul detalii_profesor
    -- Acesta va fi folosit in afiseaza_profesori()
    type rec_detalii_profesor is record(        
        nume    angajat.nume%type,
        prenume angajat.prenume%type,
        salariu angajat.salariu%type
    );
    
    -- Tablou indexat de inregistrari de tip rec_detalii_profesor
    -- Acesta va fi folosit inafiseaza_profesori()
    type ind_profesori is table of rec_detalii_profesor index by pls_integer;   
    
    ind ind_profesori;      -- Declaram un tablou indexat de tipul anterior mentionat, folosit in afiseaza_profesori()
    
    -- Tablou indexat de salarii cumulative, folosit in afiseaza_profesori()
    type salarii_cumulative is table of angajat.salariu%type index by pls_integer;  
    
    ind_salarii salarii_cumulative; -- Declaram un tablou indexat de tipul anterior mentionat, folosit in afiseaza_profesori()
    
    type salariu_maxim is record(                   -- Tip de data complex ce memoreaza detaliile angajatului ce are salariul maxim
            cod         student.cod_student%type,
            nume        student.nume%type,
            prenume     student.prenume%type,
            salariu     angajat.salariu%type
        );
    maxim   salariu_maxim;      -- Declaram un obiect de tipul record anterior mentionat
    
    
    procedure afiseaza_detalii_studenti;        -- Procedura ce afiseaza detaliile despre studenti si apeleaza afiseaza_profesori()
    
    function afiseaza_profesori(c_student in student.cod_student%type) return boolean;  -- Functie afiseaza detaliile despre toti profesorii la care invata studentul cu codul dat ca parametru, returneaza true daca studentul are cel putin un profesor, false in caz contrar
    
    function salariu_cumulativ_maxim return student.cod_student%type;       -- Functie ce afiseaza detaliile despre salariul cumulativ maximal determinat in prin intermediul apelarii succesive a functiei afiseaza_profesori() in cadrul procedurii afiseaza_detalii_studenti()
    
    function tara_facultate(c_student in student.cod_student%type) return facultate.cod_facultate%type;        -- Functie ce afiseaza tara primei facultati la care este inscris studentul al carui cod este dat ca parametru si returneaza codul respectivei facultati
    
    procedure nota_maxima(c_facultate   facultate.cod_facultate%type);      -- Procedura ce afiseaza nota maxima obtinuta in cadrul facultatii al carei cod este data ca parametru, impreuna cu restul detaliilor legate de student si profesorul coordonator
    
    function main return boolean;       -- Functia principala din care se vor apela toate subprogramele in cascada
    
end exercitiul_14;
/


create or replace package body exercitiul_14
is

    procedure afiseaza_detalii_studenti
    is
        contor number := 1;             -- Contor folosit strict pentru a tine evidenta indicelui studentului afisat(utilizat strict pentru o afisare mai stilistica)
        exista_profesori boolean;       -- Variabila ce primeste ca valoare rezultatul apelarii functiei afiseaza_profesori() pe un cod de student din cursorul studenti declarat in antetul pachetului
    begin
        dbms_output.put_line('Studenti:');
        dbms_output.new_line;
        dbms_output.put_line('Forma afisarii: <<nume>> <<<prenume>> (<<cod>>)');
        dbms_output.put_line('Profesori: <<nume>> <<prenume>> <<salariu>>');
        dbms_output.new_line;
        for i in studenti loop  -- Parcurgem liniile din cursorul studenti
            
            dbms_output.put_line(contor || '. ' || i.nume || ' ' || i.prenume || ' (' || i.cod_student || ')'); -- Afisam indicele, numele, prenumele si codul studentului curent
            dbms_output.put('Profesori: ');     -- Pregatim afisarea tuturor profesorilor studentului curent
            exista_profesori := afiseaza_profesori(i.cod_student);  -- apelam functia afiseaza_profesori() pentru codul studentului curent
            -- Functia afiseaza_profesori() se va ocupa de afisare si va returna true daca studentul are profesori sau false daca nu are profesori
            if exista_profesori = false then    -- Daca studentul nu are niciun profesor atunci afisam un mesaj sugestiv
                dbms_output.put_line('Studentul nu are niciun profesor');
            end if;
            dbms_output.new_line;
            dbms_output.new_line;
            contor := contor + 1;   -- Incrementam contor-ul pentru a trece la urmatorul indice la afisare
        end loop;
    end afiseaza_detalii_studenti;
    
    
    
    function afiseaza_profesori                 -- Functie ce afiseaza toti profesorii unui student al carui cod este dat ca parametru
        (c_student in student.cod_student%type)
    return boolean                              -- Functia returneaza true daca studentul are cel putin un profesor, false in caz contrar
    is
        
        aux rec_detalii_profesor;               -- Variabila de tip record rec_detalii_profesor ce memoreaza detaliile unui profesor
        
        cnt     number := 1;                    -- Variabila contor/count care incepe de la 1
        
        suma    angajat.salariu%type := 0;      -- Variabila ce memoreaza suma salariilor profesorilor studentului, suma este initializata cu 0
        
        s_nume      student.nume%type;          -- Variabila ce memoreaza numele studentului al cauri cod este dat ca parametru
        s_prenume   student.prenume%type;       -- Variabila ce memoreaza prenumele studentului al carui cod este dat ca parametru
    begin
--        imb.extend;
        select nume, prenume            -- Selectam numele si prenumele studentului al carui cod este dat ca parametru
        into s_nume, s_prenume
        from student
        where cod_student = c_student;
        -- Acest select nu va genera exceptia no_data_found, 
        -- intrucat aceasta va fi apelata prin intermediul procedurii afiseaza_detalii_studenti
        -- procedura care facilitateaza apeluri numai pentru coduri de student existente in baza de date
        -- De asemenea, nu se va genera exceptia too_many_rows, intrucat cheia primara nu se poate repeta in baza de date
        
        open detalii_profesor(c_student);       -- Deschidem cursorul parametrizat declarat in antetul pachetului si il apelam pentru codul dat ca parametru in functie
            loop                                -- Acest cursor ne parcurge lista tuturor profesorilor studentului cu codul dat ca parametru
                
                fetch detalii_profesor into aux;        -- Obtinem informatiile fiecarui profesor la care studentul invata si le transmitem variabilei record aux
                exit when detalii_profesor%notfound;    -- Oprim bucla atunci cand am parcurs toata lista profesorilor studentului al carui cod este dat ca parametru

                ind(cnt) := aux;        -- Tabloul indexat ind va retine pe pozitia cnt detaliile profesorului curent
--                imb(c_student)(cnt) := ind(cnt);
                cnt := cnt + 1;         -- Incrementam cnt pentru urmatoarea iteratie
            end loop;
        
        close detalii_profesor;    -- Inchidem cursorul 
        
        if ind.count = 0 then       -- Daca tabloul indexat ind nu are niciun element, inseamna ca studentul nu are niciun profesor
            ind.delete;             -- Dezalocam memoria alocata in tabloul indexat(pas inutil din moment ce oricum ind.count = 0)
            return false;           -- Returnam false, intrucat studentul nu are niciun profesor
            else                    -- Altfel, inseamna ca studentul are cel putin un profesor 
                for i in ind.first..ind.last loop   -- Parcurgem tabloul indexat ind pentru a obtine informatiile pentru fiecare profesor in parte
                    dbms_output.put(ind(i).nume || ' ' || ind(i).prenume || ' ' || ind(i).salariu);     -- Afisam numele, prenumele si salariul profesorului curent la care studentul invata
                    suma := suma + ind(i).salariu;      -- Calculam salariul profesoral cumulativ pentru studentul dat ca parametru
                                                        -- Acest lucru ne va folosi pentru determinarea salariului profesoral cumulativ maximal
                                                        -- Salariu cumulativ = suma tuturor salariilor profesorilor din tabloului ind
                    if i = ind.last then            -- Daca am ajuns la ultimul profesor
                        dbms_output.put_line('.');  -- Printam punct
                    else
                        dbms_output.put(', ');      -- Altfel separam profesorii prin virgula
                    end if; -- Observam ca nu mai este nevoie sa folosim dbms_output.new_line pentru a se printa toate virgulele din dbms_output.put()
                end loop;   -- intrucat oricum la sfarsit se va printa punctul prin dbms_output.put_line()
                
                dbms_output.put_line('Salariu Cumulativ: ' || suma);        -- Afisam salariul cumulativ calculat insumand salariul tuturor profesorilor din ind
                if suma > maxim.salariu or      -- Daca salariul cumulativ este mai mare decat salariul cumulativ maximal
                (suma = maxim.salariu and (s_nume < maxim.nume)) or -- sau daca salariile sunt egale, dar numele studentului dat ca parametru este mai mic alfabetic decat numele studentului cu salariu cumulativ maximal
                (suma = maxim.salariu and s_nume = maxim.nume and s_prenume < maxim.prenume)then    -- sau daca atat salariile cumulative, cat si numele sunt egale iar prenumele studentului cu codul dat este mai mic alfabetic decat prenumele studentului cu salariu cumulativ maximal
                    maxim.salariu := suma;  -- atunci updatam salariul cumulativ maximal
                    maxim.nume := s_nume;   -- precum si numele
                    maxim.prenume := s_prenume; -- prenumele
                    maxim.cod := c_student;     -- si codul studentului posesor al acestui salariu cumulativ maximal
                    
                end if;
--                ind_salarii(c_student) := suma;
                suma := 0;  -- la sfarsit reinitializam suma cu 0, intrucat aceasta va fi folosita de urmatorul student dat ca parametru
                ind.delete; -- dezalocam tabloul de profesori, intrucat si acesta va fi folosit de urmatorul student dat ca parametru
              
                return true;    -- returnam true, intrucat am gasit cel putin un profesor pentru studentul dat ca parametru
        end if;
        
    end afiseaza_profesori;
    
    
    
    function salariu_cumulativ_maxim return student.cod_student%type    -- Functie ce afiseaza detaliile studentului posesor al salariului cumulativ maximal
    is  -- si returneaza codul acestui student
    begin
        -- Afisam numele, prenumele si codul studentului posesor al salariului profesoral cumulativ maximal
        -- Aceste detalii se afla in variabila record "maxim", declarata in antetul pachetului
        -- Iar detaliile din cadrul acestei variabile au fost calculate in functia afiseaza_profesori() prin intermediul procedurii afiseaza_detalii_studenti()
        dbms_output.put_line('Prin urmare, studentul al carui salariu cumulativ este maxim este:');
        dbms_output.put_line(maxim.nume || ' ' || maxim.prenume || ' (' || maxim.cod || ') ');
        dbms_output.put_line('Cu salariul cumulativ de: ' || maxim.salariu);
        dbms_output.new_line;
        dbms_output.new_line;
        return maxim.cod;       -- Returnam codul studentului posesor al salariului profesoral cumulativ maximal
    end salariu_cumulativ_maxim;
    
    
    
    
    function tara_facultate                     -- Functie ce afiseaza tara primei facultati la care este inscris
    (c_student in student.cod_student%type)     -- studentul cu codul dat ca parametru
    return facultate.cod_facultate%type         -- si returneaza codul acestei facultati
    is
        nume_tara   tara.nume%type;                     -- Variabila in care o sa memoram numele tarii in care se afla facultatea studentului cu codul dat ca parametru
        s_nume      student.nume%type;                  -- Numele studentului cu codul dat ca parametru
        s_prenume   student.prenume%type;               -- Prenumele studentului cu codul dat ca parametru
        f_nume      facultate.denumire%type;            -- Numele facultatii studentului cu codul dat ca parametru
        f_cod       facultate.cod_facultate%type;       -- Codul facultatii principale al studentului cu codul dat ca parametru
    begin
        select t.nume, s.nume, s.prenume, f.denumire, f.cod_facultate   -- Selectam numele tarii, numele si prenumele studentului, numele si codul facultatii
        into nume_tara, s_nume, s_prenume, f_nume, f_cod                -- In variabilele anterior declarate in aceasta functie
        from tara t join locatie l on (t.cod_tara = l.cod_tara)
            join facultate f on (l.cod_locatie = f.cod_locatie)
            join studiaza st on (f.cod_facultate = st.cod_facultate)
            join student s on(st.cod_student = s.cod_student)
        where s.cod_student = c_student                                 -- Acolo unde codul studentului este egal cu cel dat ca parametru
        and rownum = 1;                                                 -- Daca exista mai multe facultati, se va selecta prima la care a fost inscris studentul
        -- Acest select nu va genera exceptia no_data_found, intrucat avem garantia validitatii codului dat ca parametru, datorita apelarii in cascada a subprogramelor din acest pachet
        -- Afisam detaliile obtinute
        dbms_output.put_line('Studentul ' || s_nume || ' ' || s_prenume || ' este inscris la ' || f_nume || ', care se afla in tara: ' || nume_tara);
        
        dbms_output.new_line;   -- Afisam o noua linie pentru spatiere
        return f_cod;           -- Returnam codul facultatii principale
    end tara_facultate;
    
    
    procedure nota_maxima(c_facultate   facultate.cod_facultate%type)   -- Procedura ce afiseaza nota maxima obtinuta in cadrul facultatii cu codul dat ca parametru
    is
        f_denumire  facultate.denumire%type;        -- Variabila pentru numele facultatii cu codul dat ca parametru
        s_nume      student.nume%type;              -- Variabila pentru numele studentului cu nota maxima din cadrul facultatii cu codul dat ca parametru
        s_prenume   student.prenume%type;           -- Prenumele studentului cu nota maxima din facultate
        a_nume      angajat.nume%type;              -- Numele profesorului coordonator al disciplinei in care s-a obtinut nota maxima
        a_prenume   angajat.prenume%type;           -- Prenumele profesorului anterior mentionat
        c_denumire  camin.denumire%type;            -- Denumirea caminului in care este cazat studentul ce a obtinut nota maxima
        d_denumire  disciplina.denumire%type;       -- Denumirea disciplinei la care s-a obtinut nota maxima
        e_nota      examinare.nota%type;            -- Nota maxima obtinuta in cadrul facultatii cu codul dat ca parametru
    begin
    
        /*
        Dupa ce se afiseaza tara, sa se afiseze nota maxima obtinuta in cadrul facultatii
        precum si numele materiei, numele profesorului coordonator, 
        numele studentului care a obtinut nota respectiva si, daca exista,
        caminul la care acesta este cazat
        */
        -- Selectam toate detaliile cerute si le memoram in variabilele declarate in cadrul procedurii
        select f.denumire, s.nume, s.prenume, a.nume, a.prenume, c.denumire, d.denumire, e.nota
        into f_denumire, s_nume, s_prenume, a_nume, a_prenume, c_denumire, d_denumire, e_nota
        from facultate f join studiaza st on (f.cod_facultate = st.cod_facultate)
            join student s on (st.cod_student = s.cod_student)
            join participa p on (s.cod_student = p.cod_student)
            join disciplina d on (p.cod_disciplina = d.cod_disciplina)
            join examinare e on (d.cod_disciplina = e.cod_disciplina)
            join angajat a on (a.cod_angajat = p.cod_angajat)
            join profesor prof on (a.cod_angajat = prof.cod_angajat)
            join camin c on (s.cod_camin = c.cod_camin)
        where f.cod_facultate = c_facultate and rownum = 1      -- Selectam toate detaliile pentru facultatea cu codul dat ca parametru, daca exista mai multe materii la care s-a obtinut nota maxima, o selectam doar pe prima
        order by nota desc;     -- Ordonam descrescator dupa nota
        -- Afisam detaliile cerute
        dbms_output.put_line('Pentru facultatea "' || f_denumire || '" nota maxima este ' || e_nota || ' si este la materia ' || d_denumire || ', ');
        dbms_output.put_line('nota fiind obtinuta de studentul ' || s_nume || ' ' || s_prenume || ' alaturi de profesorul coordonator ');
        dbms_output.put_line(a_nume || ' ' || a_prenume || ', studentul fiind cazat la caminul ' || c_denumire || '.');
        dbms_output.new_line;
        
    end nota_maxima;
    
    
    function main return boolean            -- In functia main vom apela toate subprogramele create in cadrul pachetului
    is
        cod_salariu_maxim       student.cod_student%type;       -- Variabila in care vom memora codul studentului al carui salariu profesoral cumulativ este maxim
        c_facultate             facultate.cod_facultate%type;   
    begin
        maxim.salariu := -1;            -- Initializam primul salariu maxim ca fiind -1, astfel incat orice salariul profesoral sa fie mai mare decat -1
        afiseaza_detalii_studenti();    -- Afisam detaliile studentilor, aceasta procedura va apela si functia afiseaza_profesori()
        -- Dupa ce s-au apelat procedura afiseaza_detalii_student() si functia afiseaza_profesori(), salariul cumulativ maximal a fost calculat
        cod_salariu_maxim := salariu_cumulativ_maxim();     -- Prin urmare, apelam functia salariu_cumulativ_maxim() pentru a afisa detaliile studentului posesor al salariului cumulativ maximal si returnam codul acestui student, cod pe care il memoram in cod_salariu_maxim
        c_facultate := tara_facultate(cod_salariu_maxim);   -- Dupa ce am obtinut codul studentului cu salariul cumulativ maximal, apelam functia tara_facultate() pentru a afisa tara in care se afla prima facultate la care este inscris studentul si returnam codul acestei facultati
        nota_maxima(c_facultate);   -- Cu codul facultatii obtinut, apelam procedura nota_maxima() pentru a afisa nota maxima obtinuta in cadrul acelei facultati, precum si toate detaliile legate de studentul si profesoorul coordonator
        return true;            -- Functia main returneaza true atunci cand toate procedurile si functiile s-au executat cu succes
    end main;
end exercitiul_14;
/
-- Bloc anonim in care testam pachetul definit
declare
    rezultat boolean;
begin
    rezultat := exercitiul_14.main();
end;
/
/*
select * from participa;

select s.nume, t.nume
from tara t join locatie l on (t.cod_tara = l.cod_tara)
    join facultate f on (l.cod_locatie = f.cod_locatie)
    join studiaza st on (f.cod_facultate = st.cod_facultate)
    join student s on(st.cod_student = s.cod_student)
where s.cod_student = 44;
*/
/*
select *
from facultate f join studiaza st on (f.cod_facultate = st.cod_facultate)
    join student s on (st.cod_student = s.cod_student)
    join participa p on (s.cod_student = p.cod_student)
    join disciplina d on (p.cod_disciplina = d.cod_disciplina)
    join examinare e on (d.cod_disciplina = e.cod_disciplina)
    join angajat a on (a.cod_angajat = p.cod_angajat)
    join profesor prof on (a.cod_angajat = prof.cod_angajat)
    join camin c on (s.cod_camin = c.cod_camin)
where f.cod_facultate = 40 and rownum = 1
order by nota desc;
*/
/*
Sa se selecteze tara in care se afla facultatea
studentului al carui salariu profesoral cumulativ este maximal

Definim salariul profesoral cumulativ al unui student ca fiind
suma tututor salariilor profesorilor la care studentul invata

Salariu profesoral cumulativ maximal reprezinta
multimea profesorilor al caror salarii combinate este cea mai mare

Daca exista mai multi studenti ai caror salarii cumulative sunt egale
se va lua in cosiderare primul in ordinea alfabetica dupa nume si prenume

Dupa ce se afiseaza tara, sa se afiseze nota maxima obtinuta in cadrul facultatii
precum si numele materiei, numele profesorului coordonator, 
numele studentului care a obtinut nota respectiva si, daca exista,
caminul la care acesta este cazat

Daca sunt mai multe facultati la care este inscris studentul,
se va lua in considerare doar prima facultate la care s-a inscris.

pasi:
    Pentru fiecare student, printam lista profesorilor si salariilor acestora
    Pentru fiecare student, calculam salariul profesoral cumulativ
    Selectam studentul cu salariul profesoral cumulativ maximal

*/