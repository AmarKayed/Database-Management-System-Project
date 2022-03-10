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



CREATE TABLE facultate(
    cod_facultate NUMBER(5) CONSTRAINT pk_facultate PRIMARY KEY,
    denumire VARCHAR2(50) CONSTRAINT denumire_facultate NOT NULL,
    ranking NUMBER(4)
    
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

CREATE TABLE camin(
    cod_camin number(5) constraint pk_camin primary key,
    denumire varchar2(30),
    nr_camere number(4)
);


CREATE TABLE specializare(
    cod_specializare number(5) constraint pk_specializare primary key,
    denumire varchar2(30) constraint denumire_specializare not null,
    ani number(1) constraint ani_specializare not null,
    cod_facultate number(5) constraint fk_specializare_facultate references facultate(cod_facultate)
);


CREATE TABLE student(
    cod_student number(5) constraint pk_student primary key,
    nume varchar2(25) constraint nume_student not null,
    prenume varchar2(25) constraint prenume_student not null,
    data_nastere date,
    cod_specializare number(5) constraint fk_student_specializare references specializare(cod_specializare),
    cod_camin number(5) constraint fk_student_camin references camin(cod_camin)
);


CREATE TABLE locatie(
    cod_locatie number(5) constraint pk_locatie primary key,
    strada varchar2(25),
    oras varchar2(25),
    cod_tara number(5)
);

CREATE TABLE tara(
    cod_tara number(5) constraint pk_tara primary key,
    nume varchar2(25),
    continent varchar2(25)
);

ALTER TABLE locatie
ADD CONSTRAINT fk_locatie_tara FOREIGN KEY(cod_tara) REFERENCES tara(cod_tara);


CREATE TABLE participa(
    cod_angajat number(5) constraint fk_participa_angajat references angajat(cod_angajat),
    cod_disciplina number(5) constraint fk_participa_disciplina references disciplina(cod_disciplina),
    cod_student number(5) constraint fk_participa_student references student(cod_student),
    CONSTRAINT pk_participa PRIMARY KEY(cod_angajat, cod_disciplina, cod_student)
);

CREATE TABLE studiaza(
    cod_student number(5) constraint fk_studiaza_student references student(cod_student),
    cod_facultate number(5) constraint fk_studiaza_facultate references facultate(cod_facultate),
    CONSTRAINT pk_studiaza PRIMARY KEY(cod_student, cod_facultate)
);

CREATE TABLE programa(
    cod_disciplina number(5) constraint fk_programa_disciplina references disciplina(cod_disciplina),
    cod_specializare number(5) constraint fk_programa_specializare references specializare(cod_specializare),
    CONSTRAINT pk_programa PRIMARY KEY(cod_disciplina, cod_specializare)
);






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


INSERT INTO facultate
VALUES(10, 'Facultatea de Matematica si Informatica', 1);

INSERT INTO facultate
VALUES(20, 'Facultatea de Automatica si Calculatoare', 2);

INSERT INTO facultate
VALUES(30, 'Facultatea de Agronomie', 3);

INSERT INTO facultate
VALUES(40, 'Facultatea de Medicina', 4);

INSERT INTO facultate
VALUES(50, 'Facultatea de Constructii', 5);

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

select * from camin;

INSERT INTO student
VALUES(11, 'Ionescu', 'Stefan', '05-JAN-02', 1, 1);

INSERT INTO student
VALUES(22, 'Iliescu', 'Mihail', '05-JAN-02', 2, 2);

INSERT INTO student
VALUES(33, 'Georgescu', 'Nicolae', '05-JAN-02', 3, 3);

INSERT INTO student
VALUES(44, 'Emil', 'Luca', '05-JAN-02', 4, 4);

INSERT INTO student
VALUES(55, 'Florentin', 'Daniel', '05-JAN-02', 5, 5);

commit;


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

