select * 
from student s join camin c on (s.cod_camin = c.cod_camin);

select * 
from student s join studiaza st on (s.cod_student = st.cod_student)
    join facultate f on (f.cod_facultate = st.cod_facultate);


/*
pentru un id dat de la tastatura, cat si pentru urmatoarele 9 id-uri,
sa se afiseze facultatea la care studiaza, precum si caminele colegilor care
sunt colegi cu acesta la facultate
daca o facultate a fost deja verificata, nu se va mai aplica procedeul pentru 
un alt student de la respectiva facultate


*/


select * from angajat a join secretara s on(a.cod_angajat = s.cod_angajat) 
            join facultate f on (a.cod_facultate = f.cod_facultate);

select * from secretara;

/*
Pentru toate secretarele facultatii de matematica si informatica, 
mariti salariul cu media salariilor profesorilor de la facultatea de automatica 
si calculatoarelor.

Pentru salariile care depasesc valoarea de 5000, se va adauga un bonus egal cu 
salariul minim al oricarui angajat de la facultatea de agronomie

*/

declare
    
    type secr is record(
        ang     angajat%rowtype,
        sec     secretara%rowtype
    );
    
    type prfsr is record(
        ang     angajat%rowtype,
        prof    profesor%rowtype
    );
    
    type secretare is table of secr index by pls_integer;
    
    type profesori is table of prfsr;
    
    s   secretare;
    p   profesori := profesori();
    
    cursor cs is select * from angajat join secretara using(cod_angajat);
    
    cursor cp is select * from angajat join profesor using(cod_angajat);
    
    
    pr  profesor%rowtype;
    sc  secretara%rowtype;
    
    i integer := 1;
    
    
begin
    open cs;
    
    loop
        fetch cs into sc;
--        dbms_output.put_line(sc.
        i := i + 1;
        exit when cs%notfound or i = 5;
    end loop;
    open cp;
    
    
    while cp%found loop
        null;
    end loop;
    
end;
/


select * from user_tables;






-- cod pentru cerinta de mai jos

declare
    
    id      number;
    
    cursor c is select nume from student;
    
    nume    student.nume%type;
begin
    open c;
    
    loop
        fetch c.nume into nume;
        dbms_output.put_line(nume);
        exit when c%notfound;
    end loop;
    
    close c;
end;
/

select nume from student;

/*

pentru un id dat ca parametru si incepand cu urmatoarele linii de dupa acest id
(incepand cu acest id)
pentru fiecare student al carui id este egal cu un numar fibonacci
sa se afiseze numele profesorilor la care acesta invata
precum si salariul acestora si materiile predate

Sa se insereze aceasta informatie drept o coloana in tabelul STUDENT
Sa se faca modifice la loc tabelul in afara procedurii

Daca nu exista studenti cu id-uri egale cu numere fibonacci, se va arunca o exceptie "NO_FIBONACCI_FOUND"
daca mai mult de jumatate + 1 dintre studenti au id-uri egale cu numere fibonacci, atunci se va arunca exceptia
"TOO_MANY_FIBONACCI"


Rezolvare:
folosim un tablou indexat pentru numerele fibonacci, trebuie sa gasim id-ul maxim pentru ultimul nr fibonacci
folosim un varray cu toate facultatile la care preda profesorul
folosim un record cu numele profului, salariul si varray-ul de facultati
folosim un tablou imbricat de record-uri(cate un record pentru fiecare student)

folosim cursoare pentru tabelele student si angajat



*/