declare
    cursor studenti_la_camin(c_camin camin.cod_camin%type) is
            select s.cod_student, e.nota
            from student s join participa p on(s.cod_student = p.cod_student)
                join disciplina d on (p.cod_disciplina = d.cod_disciplina)
                join examinare e on (d.cod_disciplina = e.cod_disciplina)
            where e.nota = (
                select max(nota)
                from examinare e2
                where e2.cod_disciplina = e.cod_disciplina
            )
            and
                s.cod_camin = c_camin;
begin
    for i in studenti_la_camin(1) loop
        dbms_output.put_line(i.cod_student || ' ' );
        --||  nvl(i.nota, 'NULL'));
    end loop;
end;