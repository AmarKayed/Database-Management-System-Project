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


/*
Daca se doreste inserarea unui nou angajat, acesta va putea fi inserat
doar daca salariul lui adaugat cu salariul
tuturor angajatilor nu depaseste valoarea de 37000

Daca conditia nu este indeplinita atunci
se vor genera erori diferite in felul urmator:
    - Daca salariul este inserat(insert) si este mai mare decat salariul minim, se va afisa un mesaj, daca este mai mic, se va afisa alt mesaj
    - Daca salariul este modificat(update) si este mai mare decat salariul mediu, se va afisa un mesaj, daca este mai mic, se va afisa alt mesaj
    
cele doua salarii alternative vor fi calculate din salariile tuturor angajatilor deja existenti in baza de date,
cu exceptia salariului angajatului care declanseaza triggerul

In orice caz, daca triggerul va fi declansat acesta va apela o eroare.

Din moment ce se va lucra pe tabel mutating
se va crea un pachet cu toate informatiile necesare din tabelul respectiv.
Pachetul va fi populat prin intermediul unui trigger la nivel de comanda
folosind precedenta triggerilor before la nivel de comanda vs la nivel de linie

*/

