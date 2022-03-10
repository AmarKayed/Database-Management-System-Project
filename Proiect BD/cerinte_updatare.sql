/*
1.
Cerinta: Pentru fiecare student, sa se afiseze numele concatenat cu prenumele, numarul de ani necesari pentru a completa specializarea la care sunt inscrisi, precum si denumirea facultatii care contine aceasta specializare si numarul de camere al caminului la care studentul este cazat.
*/

select nume || ' ' || prenume "Nume Student",  s.ani "Numarul de ani", f.denumire "Denumirea Facultatii", c.nr_camere "Numarul de Camere" 
from student e join specializare s ON(e.cod_specializare = s.cod_specializare)
    join facultate f ON(s.cod_facultate = f.cod_facultate) 
    join camin c ON(e.cod_camin = c.cod_camin);
    
   
   
/* 
2. Cerinta: Sa se afiseze toti angajatii al caror salariu depaseste strict 2500 lei. Se vor ordona angajatii in ordine descrescatoare dupa salariu.
*/

select * from angajat;

select * 
from angajat 
where salariu > 2500
order by salariu desc;


