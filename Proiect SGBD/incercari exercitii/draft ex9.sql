create or replace procedure exercitiul_9(
    cod_angajat     angajat.cod_angajat%type
) 
is

begin

    null;
    
exception
    when others then dbms_output.put_line('Alt tip de eroare!');

end;

/*
Pentru un cod de angajat dat, afisati tara in care se afla facultatea la care studiaza
studentul cu nota cea mai mare din toate examinarile efectuate
*/

select