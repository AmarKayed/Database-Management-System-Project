-- Exercitiul 4

CREATE TABLE tara(
    cod_tara number(5) constraint pk_tara primary key,
    nume varchar2(25),
    continent varchar2(25)
);

CREATE TABLE locatie(
    cod_locatie number(5) constraint pk_locatie primary key,
    strada varchar2(25),
    oras varchar2(25),
    cod_tara number(5),
    constraint fk_locatie_tara foreign key(cod_tara) references tara(cod_tara)
);

CREATE TABLE facultate(
    cod_facultate NUMBER(5) CONSTRAINT pk_facultate PRIMARY KEY,
    denumire VARCHAR2(50) CONSTRAINT denumire_facultate NOT NULL,
    ranking NUMBER(4),
    cod_locatie number(5) constraint fk_facultate_locatie references locatie(cod_locatie)
);

CREATE TABLE specializare(
    cod_specializare number(5) constraint pk_specializare primary key,
    denumire varchar2(30) constraint denumire_specializare not null,
    ani number(1) constraint ani_specializare not null,
    cod_facultate number(5) constraint fk_specializare_facultate references facultate(cod_facultate)
);


CREATE TABLE camin(
    cod_camin number(5) constraint pk_camin primary key,
    denumire varchar2(30),
    nr_camere number(4)
);


CREATE TABLE student(
    cod_student number(5) constraint pk_student primary key,
    nume varchar2(25) constraint nume_student not null,
    prenume varchar2(25) constraint prenume_student not null,
    data_nastere date,
    cod_specializare number(5) constraint fk_student_specializare references specializare(cod_specializare),
    cod_camin number(5) constraint fk_student_camin references camin(cod_camin)
);


CREATE TABLE studiaza(
    cod_student number(5) constraint fk_studiaza_student references student(cod_student),
    cod_facultate number(5) constraint fk_studiaza_facultate references facultate(cod_facultate),
    CONSTRAINT pk_studiaza PRIMARY KEY(cod_student, cod_facultate)
);


CREATE TABLE disciplina(
    cod_disciplina NUMBER(5) CONSTRAINT pk_disciplina PRIMARY KEY,
    denumire VARCHAR2(50) CONSTRAINT denumire_disciplina NOT NULL,
    nr_ore NUMBER(3) CONSTRAINT nr_ore_disciplina NOT NULL
);

CREATE TABLE examinare(
    cod_examinare NUMBER(5),
    cod_disciplina NUMBER(5) CONSTRAINT fk_examinare_disciplina REFERENCES disciplina(cod_disciplina),
    forma VARCHAR2(25),
    nota NUMBER(4,2),
    CONSTRAINT pk_examinare PRIMARY KEY(cod_examinare, cod_disciplina)

);

CREATE TABLE programa(
    cod_disciplina number(5) constraint fk_programa_disciplina references disciplina(cod_disciplina),
    cod_specializare number(5) constraint fk_programa_specializare references specializare(cod_specializare),
    CONSTRAINT pk_programa PRIMARY KEY(cod_disciplina, cod_specializare)
);


CREATE TABLE angajat(
    cod_angajat NUMBER(5) CONSTRAINT pk_angajat PRIMARY KEY,
    nume VARCHAR2(25) CONSTRAINT nume_angajat NOT NULL,
    prenume VARCHAR2(25) CONSTRAINT prenume_angajat NOT NULL,
    data_nastere DATE default add_months(sysdate, -12*18),
    salariu NUMBER(10,2),
    cod_facultate NUMBER(5) CONSTRAINT cod_facultate_ang NOT NULL
    
    /*
    Aici practic am incercat sa setez data de nastere default ca fiind ziua de azi - 18 ani(varsta minima pentru angajati este de 18 ani)
    Insa am aflat din documentatie ca nu se pot folosi functii sau sysdate in clauza check. 
    Cum se poate adauga o constrangere pentru a limita intervalul de valori pentru o data in SQL?
    CONSTRAINT data_nastere_ang_valida CHECK(data_nastere <= add_months(sysdate, -12*18))
    */    
    
);

ALTER TABLE angajat
ADD CONSTRAINT fk_angajat_facultate FOREIGN KEY(cod_facultate) REFERENCES facultate(cod_facultate);

CREATE TABLE secretara(
    cod_angajat NUMBER(5) CONSTRAINT pk_secretara PRIMARY KEY,
    tehnologie_favorita VARCHAR2(25),
    specializare VARCHAR2(25),
    CONSTRAINT pk_secretara_valid FOREIGN KEY(cod_angajat) REFERENCES angajat(cod_angajat)
);

CREATE TABLE profesor(
    cod_angajat NUMBER(5) CONSTRAINT pk_profesor PRIMARY KEY,
    nota_titularizare NUMBER(4,2),
    tip_profesor VARCHAR2(15),
    CONSTRAINT pk_profesor_valid FOREIGN KEY(cod_angajat) REFERENCES angajat(cod_angajat)
);


CREATE TABLE participa(
    cod_angajat number(5) constraint fk_participa_angajat references angajat(cod_angajat),
    cod_disciplina number(5) constraint fk_participa_disciplina references disciplina(cod_disciplina),
    cod_student number(5) constraint fk_participa_student references student(cod_student),
    CONSTRAINT pk_participa PRIMARY KEY(cod_angajat, cod_disciplina, cod_student)
);












-- Exercitiul 5
-- Inserari:



INSERT INTO tara
VALUES(1, 'Romania', 'Europa');

INSERT INTO tara
VALUES(2, 'Argentina', 'America de Sud');

INSERT INTO tara
VALUES(3, 'SUA', 'America de Nord');

INSERT INTO tara
VALUES(4, 'China', 'Asia');

INSERT INTO tara
VALUES(5, 'Egipt', 'Africa');

commit;



INSERT INTO locatie
VALUES(1, 'Mihai Eminescu', 'Bucuresti', 1);

INSERT INTO locatie
VALUES(2, 'Mihail Kogalniceanu', 'Craiova', 2);

INSERT INTO locatie
VALUES(3, 'George Enescu', 'Timisoara', 3);

INSERT INTO locatie
VALUES(4, 'Mihail Sadoveanu', 'Cluj', 4);

INSERT INTO locatie
VALUES(5, 'Ion Creanga', 'Brasov', 5);

commit;



INSERT INTO facultate
VALUES(10, 'Facultatea de Matematica si Informatica', 1, 2);

INSERT INTO facultate
VALUES(20, 'Facultatea de Automatica si Calculatoare', 2, 5);

INSERT INTO facultate
VALUES(30, 'Facultatea de Agronomie', 3, 1);

INSERT INTO facultate
VALUES(40, 'Facultatea de Medicina', 4, 3);

INSERT INTO facultate
VALUES(50, 'Facultatea de Constructii', 5, 4);

commit;



INSERT INTO specializare
VALUES(1, 'Informatica', 3, 10);

INSERT INTO specializare
VALUES(2, 'Matematica', 4, 20);

INSERT INTO specializare
VALUES(3, 'Finante', 5, 30);

INSERT INTO specializare
VALUES(4, 'Contabilitate', 6, 40);

INSERT INTO specializare
VALUES(5, 'Calculatoare', 3, 50);

commit;



INSERT INTO camin
VALUES(1, 'Grozavesti', 50);

INSERT INTO camin
VALUES(2, 'Politehnica', 600);

INSERT INTO camin
VALUES(3, 'Magic Dorm', 120);

INSERT INTO camin
VALUES(4, 'Tineretului', 30);

INSERT INTO camin
VALUES(5, 'Artei', 900);

commit;



INSERT INTO student
VALUES(11, 'Ionescu', 'Stefan', '05-JAN-02', 1, 1);

INSERT INTO student
VALUES(22, 'Iliescu', 'Mihail', '12-DEC-89', 2, 2);

INSERT INTO student
VALUES(33, 'Georgescu', 'Nicolae', '23-MAY-95', 3, 3);

INSERT INTO student
VALUES(44, 'Emil', 'Luca', '28-APR-00', 4, 4);

INSERT INTO student
VALUES(55, 'Florentin', 'Daniel', '19-SEP-92', 5, 5);

commit;



INSERT INTO studiaza
VALUES(11, 10);

INSERT INTO studiaza
VALUES(11, 20);

INSERT INTO studiaza
VALUES(22, 20);

INSERT INTO studiaza
VALUES(22, 30);

INSERT INTO studiaza
VALUES(33, 20);

INSERT INTO studiaza
VALUES(33, 30);

INSERT INTO studiaza
VALUES(33, 40);

INSERT INTO studiaza
VALUES(44, 40);

INSERT INTO studiaza
VALUES(55, 40);

INSERT INTO studiaza
VALUES(55, 50);

commit;



INSERT INTO disciplina
VALUES(11, 'Matematica', 5);

INSERT INTO disciplina
VALUES(12, 'Chimie', 6);

INSERT INTO disciplina
VALUES(13, 'Geografie', 2);

INSERT INTO disciplina
VALUES(14, 'Fizica', 3);

INSERT INTO disciplina
VALUES(15, 'Literatura', '8');

commit;



INSERT INTO examinare
VALUES(1, 11, 'Examen', 10);

INSERT INTO examinare
VALUES(2, 12, 'Proiect', 9.5);

INSERT INTO examinare
VALUES(3, 13, 'Ascultare Orala', 5.77);

INSERT INTO examinare
VALUES(4, 14, 'Proiect', 8.66);

INSERT INTO examinare
VALUES(5, 15, 'Ascultare Orala', 7.7);

commit;



INSERT INTO programa
VALUES(11, 1);

INSERT INTO programa
VALUES(12, 1);

INSERT INTO programa
VALUES(12, 2);

INSERT INTO programa
VALUES(12, 3);

INSERT INTO programa
VALUES(13, 1);

INSERT INTO programa
VALUES(13, 3);

INSERT INTO programa
VALUES(14, 2);

INSERT INTO programa
VALUES(14, 3);

INSERT INTO programa
VALUES(15, 4);

INSERT INTO programa
VALUES(15, 5);

commit;



INSERT INTO angajat
VALUES(1, 'Popescu', 'Ion', '17-JAN-87', 1500, 10);

INSERT INTO angajat
VALUES(2, 'Stefanescu', 'Teodora', '25-DEC-86', 2500, 10);

INSERT INTO angajat
VALUES(3, 'Mihaileascu', 'Andrei', '06-MAY-92', 3800, 10);

INSERT INTO angajat
VALUES(4, 'Popovoci', 'Alexandra', '21-AUG-82', 1800, 20);

INSERT INTO angajat
VALUES(5, 'Ionescu', 'Mihai', '12-SEP-96', 2300, 20);

INSERT INTO angajat
VALUES(6, 'Stanescu', 'Constantin', '19-OCT-89', 3700, 20);

INSERT INTO angajat
VALUES(7, 'Popa', 'Andra', '08-APR-90', 3200, 30);

INSERT INTO angajat
VALUES(8, 'Mihai', 'George', '27-JUL-82', 1900, 30);

INSERT INTO angajat
VALUES(9, 'Marinescu', 'Elena', '19-SEP-77', 4100, 30);

INSERT INTO angajat
VALUES(10, 'Bogdan', 'Octavian', '04-NOV-78', 5000, 40);

INSERT INTO angajat
VALUES(11, 'Alexandrescu', 'Marius', '15-FEB-81', 2500, 40);

commit;



INSERT INTO secretara
VALUES(1, 'Powerpoint', 'Prezentari');

INSERT INTO secretara
VALUES(3, 'Word', 'Birocratie');

INSERT INTO secretara
VALUES(5, 'Excel', 'Organizare');

INSERT INTO secretara
VALUES(7, 'Access', 'Human Recources');

INSERT INTO secretara
VALUES(9, 'Paint', 'Grafica');

commit;



INSERT INTO profesor
VALUES(2, 9.25, 'Cursant');

INSERT INTO profesor
VALUES(4, 5.23, 'Seminarist');

INSERT INTO profesor
VALUES(6, 7.5, 'Laborant');

INSERT INTO profesor
VALUES(8, 6.9, 'Cursant');

INSERT INTO profesor
VALUES(10, 8.3, 'Seminarist');

commit;



INSERT INTO participa
VALUES(2, 11, 11);

INSERT INTO participa
VALUES(2, 11, 22);

INSERT INTO participa
VALUES(2, 11, 33);

INSERT INTO participa
VALUES(4, 12, 11);

INSERT INTO participa
VALUES(4, 12, 44);

INSERT INTO participa
VALUES(6, 13, 55);

INSERT INTO participa
VALUES(6, 13, 33);

INSERT INTO participa
VALUES(8, 14, 44);

INSERT INTO participa
VALUES(10, 15, 44);

INSERT INTO participa
VALUES(10, 15, 55);

commit;























-- Exercitiul 6

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

/*
-- Teste:
insert into student
values(66, 'c', 'c', sysdate, 1, 1);

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


*/





















-- Exercitiul 7


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
-- Teste:
execute exercitiul_7(3800, 5000);
-- rezultat bun
execute exercitiul_7(100000, 1000001);
-- salariu_inexistent

*/




















-- Exercitiul 8


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


/*
-- Teste:

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

*/




















-- Exercitiul 9


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



/*
-- Teste:

execute exercitiul_9(1);
execute exercitiul_9(2);
-- Rezultate Corecte

execute exercitiul_9(10);
-- no_data_found


*/




















-- Exercitiul 10


create or replace trigger exercitiul_10     -- Cream(sau inlocuim in cazul existentei) triggerul
    for insert on angajat                   -- Acesta va actiona asupra inserarilor asupra tabelei angajat
    compound trigger                        -- Trigger de tip Compound
    
    before statement is                     -- La declansarea trigger-ului, inainte de inserare se va afisa un mesaj sugestiv
    begin
        dbms_output.put_line('A fost apelat trigger-ul compound');
    end before statement;
    
    after statement is                      -- Dupa ce s-a inserat angajatul, se va micsora salariul fiecarui angajat
    begin
        update angajat
        set salariu = salariu - 0.2*salariu;    -- Nu exista clausa where, intrucat dorim sa modificam salariul tuturor angajatilor
    end after statement;
    
end exercitiul_10;
/

/*
-- Teste:

-- In cazul in care inca era activat trigger-ul de la exercitiul 11, il dezactivam
alter trigger nivel_linie disable;

select avg(salariu) from angajat;
-- salariul mediu este aproximativ 2936

select avg(salariu - salariu*0.2) from angajat;
-- salariul mediu calculat din toate salariile existente
-- inainte de inserare reduse cu 20% este aproximativ 2349

insert into angajat
values (13, 'c', 'c', sysdate, 3000, 10);
-- Inseram o valoare oarecare in tabelul angajat pentru a declansa trigger-ul

select avg(salariu) 
from angajat 
where cod_angajat <> 13;
-- dupa inserarea angajatului 13, toate salariile existente
-- inainte de inserare s-au micsorat cu 20%, prin urmare salariul
-- mediu s-a micsorat cu 20%

select * from angajat;
-- Putem observa ca toate salariile s-au micsorat cu 20%

-- Odata ce am rulat codul, putem realiza un rollback pentru
-- A modifica la loc salariile si a sterge angajatul inserat
rollback;

-- Putem face disable la trigger
alter trigger exercitiul_10 disable;

*/





















-- Exercitiul 11


create or replace package informatii_angajat        -- Cream pachetul ce va contine toate informatiile pe care le vrem din tabela mutating
is
    
    salariu_minim       angajat.salariu%type;       -- Salariul minim din tabelul angajat
    salariu_mediu       angajat.salariu%type;       -- Salariul mediu din tabelul angajat
    suma_salarii        angajat.salariu%type;       -- Suma salariilor din tabelul angajat
    
end;
/

-- Triggerul la nivel de comanda before are o precedenta mai mare fata de triggerul la nivel de linie before
-- Prin urmare, inainte de a declansa trigger-ul la nivel de linie
-- ne putem folosi de cel de la nivel de comanda pentru a extrage informatiile de care avem nevoie
-- din tabela mutating angajat
create or replace trigger nivel_comanda              -- Cream triggerul la nivel de comanda
before insert or update on angajat                   -- Acesta va actiona inainte de insert-urile sau update-urile pe tabela angajat
begin
    select min(salariu), avg(salariu), sum(salariu) -- Selectam salariul minim, mediu si suma salariilor
    into informatii_angajat.salariu_minim,          -- In cele 3 atribute ale pachetului informatii_angajat
        informatii_angajat.salariu_mediu, 
        informatii_angajat.suma_salarii
    from angajat;
--    where cod_angajat <> :old.cod_angajat;
end;
/

create or replace trigger nivel_linie           -- Cream triggerul la nivel de linie
before insert or update on angajat              -- Acesta va actiona inainte de insert-urile sau update-urile pe tabela angajat
referencing new as nou                          -- numim variabila externa new ca fiind "nou"
for each row                                    -- Trigger la nivel de linie
begin
    
    if :nou.salariu + informatii_angajat.suma_salarii > 37000 then              -- Daca salariul nou adaugat la suma salariilor este mai mare decat 37000
        if inserting then       -- In cazul in care salariul nou este inserat
            if :nou.salariu >= informatii_angajat.salariu_minim then            -- Daca acesta este mai mare sau egal decat salariul minim afisam un mesaj de eroare
                raise_application_error(-20001,'Salariul inserat este mai mare decat salariul minim');
            elsif :nou.salariu < informatii_angajat.salariu_minim then          -- Altfel, afisam alt mesaj de eroare
                raise_application_error(-20001, 'Salariul inserat este mai mic decat salariul minim');
            end if;
        elsif updating then     -- In cazul in care salariul nou este updatat
            if :nou.salariu >= informatii_angajat.salariu_mediu then            -- Daca acesta este mai mare sau egal cu salariul mediu afisam un mesaj de eroare
                raise_application_error(-20001, 'Salariul updatat este mai mare decat salariul mediu');
            elsif :nou.salariu < informatii_angajat.salariu_mediu then          -- Altfel, afisam alt mesaj de eroare
                raise_application_error(-20001, 'Salariul updatat este mai mic decat salariul mediu');
            end if;
        end if;
    end if;
    
end;
/


/*
-- Teste:

select min(salariu), avg(salariu), sum(salariu)
from angajat;
-- Salariul minim: 1500
-- Salariul mediu: 2936(aproximativ)
-- Suma salariilor: 32300
select * from angajat;

insert into angajat
values (12, 'c', 'c', sysdate, 3000, 10);
-- inserarea se face cu succes, salariul 3000 nu afecteaza conditia impusa

select * from angajat;

rollback;

insert into angajat
values (13, 'c', 'c', sysdate, 3000000, 10);
-- Salariul inserat este mai mare decat salariul minim

-- Nu este nevoie sa folosim rollback, intrucat ultima inserare a declansat trigger-ul
alter trigger nivel_linie disable;
insert into angajat
values (13, 'c', 'c', sysdate, 3000000, 10);
alter trigger nivel_linie enable;
-- acum orice am insera, triggerul va arunca o eroare

insert into angajat
values (14, 'c', 'c', sysdate, 1, 10);
-- Salariul inserat este mai mic decat salariul minim
rollback;

update angajat
set salariu = 300000
where cod_angajat = 1;
-- Salariul updatat este mai mare decat salariul mediu
rollback;

alter trigger nivel_linie disable;
insert into angajat
values (13, 'c', 'c', sysdate, 3000000, 10);
alter trigger nivel_linie enable;
-- acum orice am modifica, triggerul va arunca o eroare

update angajat
set salariu = 1
where cod_angajat = 1;
-- Salariul updatat este mai mic decat salariul mediu

rollback;

alter trigger nivel_linie disable;

*/





















-- Exercitiul 12

create table informatii_tabel(          -- Cream tabelul in care o sa retinem informatiile despre utilizator
    baza_de_date        varchar2(50),   -- Numele bazei de date
    user_logat          varchar2(30),   -- Numele utilizatorului
    eveniment_sistem    varchar2(20),   -- Tipul comenzii(CREATE, ALTER, DROP)
    tip_obiect          varchar2(30),   -- Tipul obiectului asupra caruia a fost aplicata instructiunea(TABLE, INDEX)
    nume_obiect         varchar2(30),   -- Numele obiectului
    data                timestamp(3)    -- Data la care a fost executata instructiunea/comanda
);

create or replace trigger exercitiul_12         -- Cream trigger-ul LDD
    after create or drop or alter on schema     -- Acesta va actiona dupa comenzile create, alter sau drop
begin
    insert into informatii_tabel                -- Inseram in tabelul definit anterior
    values (sys.database_name,                  -- Toate valorile generate de sistem
            sys.login_user,
            sys.sysevent,
            sys.dictionary_obj_type,
            sys.dictionary_obj_name,
            systimestamp(3)
        );
end;
/

/*
-- Teste:

create table exemplu_tabel (
    col_1 number(2)
);

alter table exemplu_tabel 
add (col_2 number(2));

insert into exemplu_tabel 
values (15, 32);

create index ind_exemplu_tabel 
on exemplu_tabel(col_1);

select * from informatii_tabel;

*/




















-- Exercitiul 13


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



/*
-- Teste:

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

*/




















-- Exercitiul 14

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


/*
-- Teste:

-- Bloc anonim in care testam pachetul definit
declare
    rezultat boolean;
begin
    rezultat := exercitiul_14.main();
end;
/

*/
