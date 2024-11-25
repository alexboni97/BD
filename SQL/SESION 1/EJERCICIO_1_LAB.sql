--LABORATORIO: SQL(Sesion 1)
--EJERCICIO 1. CREACION DE UNA BASE DE DATOS
--CREACION DE LA TABLA LIBRO
DROP TABLE PRESTAMO;
DROP TABLE LIBRO;
DROP TABLE MIEMBRO;
CREATE TABLE LIBRO(
ISBN VARCHAR2(17),
TITULO VARCHAR2(100) NOT NULL,
AUTOR VARCHAR2(300),
NUM_COPIAS INT default 1,
PRIMARY KEY(ISBN)
);

-------------------------------------------------------------------------
-- Configuración inicial del formato para las fechas.
-------------------------------------------------------------------------
alter session set nls_date_format = 'DD-MM-YYYY';

--CREACION DE LA TABLA MIEMBRO
CREATE TABLE MIEMBRO(
ID_MIEMBRO INT,
NIF VARCHAR2(9)NOT NULL UNIQUE,
NOMBRE VARCHAR2(100) NOT NULL,
EMAIL VARCHAR2(50) NOT NULL,
PRIMARY KEY(ID_MIEMBRO)
);

-- CREACION DE LA TABLA PRESTAMO
CREATE TABLE PRESTAMO(
ISBN VARCHAR2(17) REFERENCES LIBRO(ISBN),
ID_M INT REFERENCES MIEMBRO(ID_MIEMBRO),
DIAS_P INTEGER NOT NULL,
FECHA_P DATE NOT NULL,
FECHA_D DATE,
PRIMARY KEY(ISBN, ID_M,FECHA_P)
);
-------------------------------------------------------------------------------------
--EJERCICIO 2
--INSERTAR DOS LIBROS
INSERT INTO libro(isbn, titulo, autor, num_copias) VALUES('0-07-115110-9',' Database Management Systems','A. Silberschatz, H.F. Korth, S. Sudarshan','2');
INSERT INTO libro(isbn, titulo, autor, num_copias) VALUES('978-84-782-9085-7','Fundamentals of Database Systems','R. Elmasri, S.B. Navathe','3');

--INSERTAR DOS MIEMBROS
INSERT INTO miembro VALUES ('1','54490847Y','ALEX','ALEXBONI@UCM.ES');
INSERT INTO miembro VALUES ('2','54490847A','JUAN','otro@UCM.ES');

--INSERTAR 4 PRESTAMOS
INSERT INTO prestamo VALUES('0-07-115110-9','1','10',TO_DATE('25-08-2023'),TO_DATE('30-08-2023'));
INSERT INTO prestamo VALUES('0-07-115110-9','2','10',TO_DATE('27-08-2023'),TO_DATE('30-08-2023'));

INSERT INTO prestamo VALUES('0-07-115110-9','1','5',TO_DATE('12-09-2023'),'');
INSERT INTO prestamo VALUES('978-84-782-9085-7','1','30',TO_DATE('24-09-2023'),'');

--EJERCICIO 3 CONSULTAS
--PRESTAMOS MENORES A 10 DIAS
SELECT *
FROM prestamo
WHERE dias_p<10;