/*
Datorita deficitului bugetar, la inserarea unui nou angajat in tabel,
sa se micsoreze salariul tuturor angajatilor cu un procent de 20%
pentru a putea acomoda salariul noului angajat

Din moment ce dorim sa ne folosim de acelasi tabel care va declansa trigger-ul
vom intra in cazul de tabel mutating, caz pe care il rezolvam folosind
trigger compound
*/


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

--delete from angajat
--where cod_angajat = 13;
--commit;

/*

Triggeri complecsi:

- triggeri instead of
- triggeri pe tabele mutating
- triggeri compound

*/


/*
Daca se doreste inserarea unui nou angajat, acesta va putea fi inserat
doar daca salariul lui adaugat cu salariul
tuturor angajatilor nu depaseste valoarea de 10000

Daca suma salariilor depaseste valoarea 10000
atunci salariul noului angajat inserat va deveni in schimb salariul mediu
calculat din salariile tuturor angajatilor deja existenti in baza de date


*/