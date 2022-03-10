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
Definiti un declansator care sa introduca date intr-un tabel creat 
dupa ce utilizatorul curent a folosit o comanda LDD
(declansator sistem - la nivel de schema)

*/



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
