alter table facultate
add cod_locatie number(5);

ALTER TABLE facultate
ADD FOREIGN KEY (cod_locatie) REFERENCES locatie(cod_locatie);

select * from facultate;

select * from locatie;

update facultate
set cod_locatie = 2
where cod_facultate = 10;


update facultate
set cod_locatie = 5
where cod_facultate = 20;

update facultate
set cod_locatie = 1
where cod_facultate = 30;

update facultate
set cod_locatie = 3
where cod_facultate = 40;

update facultate
set cod_locatie = 4
where cod_facultate = 50;

commit;

2
5
1
3
4
