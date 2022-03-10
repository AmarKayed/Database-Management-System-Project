create type tip_returnat_exercitiul_7 is object(
    nume_facultate      facultate.denumire%type,
    nota                examinare.nota%type,
    nume_disciplina     disciplina.denumire%type,
    nume_student        student.nume%type,
    nume_profesor       angajat.nume%type
);

create or replace function exercitiul_7(
    cod_facultate   facultate.cod_facultate%type
)
returning;

select * from facultate;

/*

Pentru un cod de facultate, sa se returneze numele facultatii, 
impreuna cu nota cea mai mare obtinuta in cadrul facultatii, numele disciplinei, 
studentului si profesorului coordonator

*/