-- -------------------------------------------------------------
-- ASIGNATURA: BASES DE DATOS
-- -------------------------------------------------------------
-- GRADO EN INGENIER�?A DEL SOFTWARE
-- -------------------------------------------------------------
-- PR�?CTICA 2: DISEÑO F�?SICO CON SQL (Oracle)
-- -------------------------------------------------------------
-- ID GRUPO: G16
-- Estudiante 1: ALEX GUILLERMO BONILLA TACO
-- Estudiante 2: PABLO RODRIGUEZ ARENAS
-- -------------------------------------------------------------

-- -------------------------------------------------------------
-- PARTE 1: CREACIÓN DE LA ESTRUCTURA DE UNA BASE DE DATOS
-- -------------------------------------------------------------

-- Recrear la estructura que podría tener la base de datos resultante del
-- modelo de datos propuesto en la PR�?CTICA 1 (estudio de los cuerpos celestes). 
-- Utilizar como referencia de modelo relacional la solución que está disponible
-- en el Campus Virtual:

-- EMPLEADO (num_empleado, nombre, edad, titulacion)
--     Clave primaria: num_empleado
-- INVESTIGADOR (ID, nombre_proyecto)
--     Clave primaria: ID
--     INVESTIGADOR.ID -> EMPLEADO.num_empleado
-- TECNICO (ID)
--     Clave primaria: ID
--     TECNICO.ID -> EMPLEADO.num_empleado
-- TELESCOPIO (num_serie, potencia, resolucion, fecha_ult_revisión*)
--     Clave primaria: num_serie
-- INSPECCIONA (ID_tecnico, ID_telescopio, fecha_insp)
--     Clave primaria: ID_tecnico, ID_telescopio, fecha_insp
--     INSPECCIONA.ID_tecnico -> TECNICO.ID
--     INSPECCIONA.ID_telescopio -> TELESCOPIO.num_serie
-- CUERPO_CELESTE (num_registro, nombre, tipo)
--     Clave primaria: num_registro
-- OBSERVACION (ID_investigador, fecha_obs, hora_obs, texto_informe, ID_telescopio)
--     Clave primaria: ID_investigador, fecha_obs, hora_obs
--     OBSERVACION.ID_investigador -> INVESTIGADOR.ID
--     OBSERVACION.ID_telescopio -> TELESCOPIO.num_serie
-- EXAMINA (ID_investigador, fecha_obs, hora_obs, ID_cuerpo_celeste)
--     Clave primaria: ID_investigador, fecha_obs, hora_obs, ID_cuerpo_celeste
--     EXAMINA.(ID_investigador, fecha_obs, hora_obs) -> 
--                     OBSERVACION.(ID_investigador, fecha_obs, hora_obs)
--     EXAMINA.ID_cuerpo_celeste -> CUERPO_CELESTE.num_registro

-- Como dato adicional, considerar que la tabla EMPLEADO, aparte del número de empleado,
-- nombre, edad y titulación, incluye el campo NIF, que no podrá ser nulo, y se ha de 
-- forzar que la base de datos nunca deje almacenar dos empleados con el mismo NIF.

-- Escribir a continuación el código SQL que genera la estructura completa de la base de datos. 
alter session set nls_date_format = 'DD-MM-YYYY';

drop table observacion;
drop table examina;
drop table inspecciona;
drop table tecnico;
drop table investigador;
drop table empleado;
CREATE TABLE EMPLEADO ( 
    nombre varchar2(10),
    edad integer,
    titulacion varchar2(30),
    numEmpleado INTEGER PRIMARY KEY,
    nif varchar2(9) UNIQUE NOT NULL
);

CREATE TABLE INVESTIGADOR( 
    id INTEGER PRIMARY KEY,
    nombreProyecto varchar2(20),
    FOREIGN KEY (id) REFERENCES EMPLEADO(numEmpleado)
);

CREATE TABLE TECNICO( 
    id INTEGER PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES EMPLEADO(numEmpleado)
);

CREATE TABLE TELESCOPIO( 
    potencia varchar2(20),
    resolucion varchar2(20),
    fechaUltRevision DATE, 
    numSerie INTEGER PRIMARY KEY
);

CREATE TABLE INSPECCIONA( 
    idTecnico INTEGER,
    idTelescopio INTEGER,
    fechaInsp DATE,
    PRIMARY KEY(idTecnico, idTelescopio, fechaInsp),
    FOREIGN KEY (idTecnico) REFERENCES TECNICO(id),
    FOREIGN KEY (idTelescopio) REFERENCES TELESCOPIO(numSerie)
);

CREATE TABLE CUERPO_CELESTE(
    numRegistro INTEGER PRIMARY KEY,
    nombre varchar2(20),
    tipo varchar2(20)
);

CREATE TABLE OBSERVACION( 
    idInvestigador INTEGER,
    fechaObs DATE,
    textoInforme varchar2(250) NOT NULL,
    idTelescopio INTEGER NOT NULL,
    PRIMARY KEY(idInvestigador, fechaObs),
    FOREIGN KEY (idInvestigador) REFERENCES INVESTIGADOR(id),
    FOREIGN KEY (idTelescopio) REFERENCES TELESCOPIO(numSerie)
);

CREATE TABLE EXAMINA(
    idInvestigador INTEGER,
    fechaObs DATE,
    idCuerpoCeleste INTEGER,
    PRIMARY KEY(idInvestigador, fechaObs,idCuerpoCeleste),
    FOREIGN KEY (idInvestigador, fechaObs) REFERENCES OBSERVACION(idInvestigador, fechaObs),
    FOREIGN KEY (idCuerpoCeleste) REFERENCES CUERPO_CELESTE(numRegistro)
);

-- -------------------------------------------------------------
-- PARTE 2: INSERCIÓN DE DATOS EN TABLAS
-- -------------------------------------------------------------

-- Siguiendo la estructura de las tablas generadas en la sección anterior,
-- inserta datos en la tabla CUERPO_CELESTE y en otras dos tablas a elegir,
-- que muestren la aplicación de integridad referencial.

-- Escribir a continuación el código SQL que inserta los datos en las tablas.
-- inserccion de datos nuevos en las tablas cuerpo_celeste,empleado,telescopio que no tendran ningun fallo por integridad referencial, ya que es una tabla independiente.
INSERT INTO CUERPO_CELESTE (numRegistro, nombre, tipo) VALUES (1, 'LUZ', 'COMETAS');
INSERT INTO CUERPO_CELESTE (numRegistro, nombre, tipo) VALUES (2, 'FUEGO', 'PLANETAS');
INSERT INTO CUERPO_CELESTE (numRegistro, nombre, tipo) VALUES (3, 'HIELO', 'ESTRELLAS');
INSERT INTO CUERPO_CELESTE (numRegistro, nombre, tipo) VALUES (4, 'ESTELAR', 'METEOROS');

INSERT INTO EMPLEADO(nombre, edad, titulacion, numEmpleado, nif) VALUES ('Pablo', 20, 'Grado', 1, '12345678B');
INSERT INTO EMPLEADO(nombre, edad, titulacion, numEmpleado, nif) VALUES ('Pepe', 30, 'Grado', 2, '21214545X');
INSERT INTO EMPLEADO(nombre, edad, titulacion, numEmpleado, nif) VALUES ('Luis', 25, 'Master', 3, '09091234P');
INSERT INTO EMPLEADO(nombre, edad, titulacion, numEmpleado, nif) VALUES ('Elena', 23, 'Doctorado', 4, '54619312K'); 

INSERT INTO TELESCOPIO(potencia, resolucion, fechaUltRevision, numSerie) VALUES ('100', '50', TO_DATE('15-10-1995'), 1);
INSERT INTO TELESCOPIO(potencia, resolucion, fechaUltRevision, numSerie) VALUES ('200', '60', TO_DATE('26-09-1995'), 2);
INSERT INTO TELESCOPIO(potencia, resolucion, fechaUltRevision, numSerie) VALUES ('300', '70', TO_DATE('07-07-1995'), 3);
INSERT INTO TELESCOPIO(potencia, resolucion, fechaUltRevision, numSerie) VALUES ('400', '80', TO_DATE('18-02-1995'), 4);

-- insercion de datos en las tablas investigador, tecnico observacion respetando la integridad referencial, es decir, con los numEmpleado de la tabla Empleado insertados
INSERT INTO INVESTIGADOR VALUES (1,'CASCADAS');
INSERT INTO INVESTIGADOR VALUES (2,'PROYECTX');
INSERT INTO TECNICO VALUES (3);
INSERT INTO TECNICO VALUES (4);
INSERT INTO OBSERVACION VALUES (1,TO_DATE('18-02-2022 05:00','DD/MM/YYYY HH:MI'),'CUERPO CELESTE LEIDO', 2);


--insercion de datos en las tablas investigador, tecnico, observacion no respetando la integridad referencial, por lo tanto, nos debe dar un fallo al insertar
INSERT INTO INVESTIGADOR VALUES (5,'zzzffff');--NO EXISTE EL EMPLEADO 5
INSERT INTO TECNICO VALUES (8);--NO EXISTE EL TECNICO 8
INSERT INTO OBSERVACION VALUES (10,TO_DATE('18-02-2022 05:00','DD/MM/YYYY HH:MI'),'CUERPO CELESTE LEIDO', 5);--NO EXISTE EL TELESCOPIO 5 NI EL INVESTIGADOR 10

-- -------------------------------------------------------------
-- PARTE 3: CREACIÓN DE CONSULTAS
-- -------------------------------------------------------------

-- Ejecutar el siguiente script para crear la base de datos a utilizar 
-- en esta segunda parte de la práctica.

-- Esta base de datos contiene información de prescripción de
-- medicamentos a pacientes, alergias a tipos de medicamentos.

-- Realizar las consultas que se solicitan a continuación.
--
-- No se puede modificar la estructura de las tablas y no
-- se pueden utilizar vistas.


alter session set nls_date_format = 'DD/MM/YYYY';
SET LINESIZE 500;
SET PAGESIZE 500;

drop table PRESCRIPCION cascade constraints;
drop table ALERGIA cascade constraints;
drop table PACIENTE cascade constraints;
drop table MEDICAMENTO cascade constraints;
drop table TIPO_MEDICAMENTO cascade constraints;

CREATE TABLE TIPO_MEDICAMENTO(
    IdTipo varchar2(20) PRIMARY KEY,
    descripcion varchar2(100) NOT NULL
);

CREATE TABLE MEDICAMENTO(
    IdMed INTEGER PRIMARY KEY,
    denominacion varchar2(100) NOT NULL,
    tipoMed varchar2(20) NOT NULL REFERENCES TIPO_MEDICAMENTO (IdTipo),
    precioDosis NUMBER(9,2) NOT NULL, -- precio por cada dosis del medicamento
    totalDosisPrescritas INTEGER
);

CREATE TABLE PACIENTE(
    IdPaciente INTEGER PRIMARY KEY,
    nombre varchar2(100) NOT NULL
);

CREATE TABLE PRESCRIPCION(
    IdPres INTEGER PRIMARY KEY,
    IdPaciente INTEGER NOT NULL REFERENCES PACIENTE,
    IdMed INTEGER NOT NULL REFERENCES MEDICAMENTO,
    NumDosis INTEGER NOT NULL
    -- número de dosis prescritas del medicamento al paciente
);

CREATE TABLE ALERGIA(
    IdPaciente INTEGER NOT NULL REFERENCES PACIENTE,
    tipoMed varchar2(20) NOT NULL REFERENCES TIPO_MEDICAMENTO,
    PRIMARY KEY (IdPaciente, tipoMed)
);


INSERT INTO TIPO_MEDICAMENTO VALUES ('penicilinas', 'Antibioticos derivados de la penicilina');
INSERT INTO TIPO_MEDICAMENTO VALUES ('anticonvulsivos', 'Medicamentos anticonvulsivos y derivados');
INSERT INTO TIPO_MEDICAMENTO VALUES ('insulinas', 'Insulinas animales');
INSERT INTO TIPO_MEDICAMENTO VALUES ('yodos', 'Medicamentos para contraste basados en yodo');
INSERT INTO TIPO_MEDICAMENTO VALUES ('sulfas', 'Medicamentos basados en sulfamidas antibacterianas');
INSERT INTO TIPO_MEDICAMENTO VALUES ('otros', 'Resto de medicamentos');

INSERT INTO MEDICAMENTO VALUES (1, 'sulfametoxazol', 'sulfas', 3.45, 50);
INSERT INTO MEDICAMENTO VALUES (2, 'sulfadiazina', 'sulfas', 2.10, 25);
INSERT INTO MEDICAMENTO VALUES (3, 'meticilina', 'penicilinas', 0.87, 90);
INSERT INTO MEDICAMENTO VALUES (4, 'amoxicilina', 'penicilinas', 0.22, 150);
INSERT INTO MEDICAMENTO VALUES (5, 'insulina de accion ultrarrapida', 'insulinas', 0.82, 80);
INSERT INTO MEDICAMENTO VALUES (6, 'insulina de accion rapida', 'insulinas', 0.55, 200);
INSERT INTO MEDICAMENTO VALUES (7, 'yoduro potasico', 'yodos', 0.30, 75);
INSERT INTO MEDICAMENTO VALUES (8, 'acido acetilsalicilico', 'otros', 0.05, 200);

insert into PACIENTE values (101,'Margarita Sanchez');
insert into PACIENTE values (102,'Angel Garcia');
insert into PACIENTE values (103,'Pedro Santillana');
insert into PACIENTE values (104,'Rosa Prieto');
insert into PACIENTE values (105,'Ambrosio Perez');
insert into PACIENTE values (106,'Lola Arribas');

INSERT INTO PRESCRIPCION VALUES (201,101,1,12);
INSERT INTO PRESCRIPCION VALUES (202,101,3,24);
INSERT INTO PRESCRIPCION VALUES (203,101,3,48);
INSERT INTO PRESCRIPCION VALUES (204,101,7,8);
INSERT INTO PRESCRIPCION VALUES (205,102,7,14);
INSERT INTO PRESCRIPCION VALUES (206,103,3,24);
INSERT INTO PRESCRIPCION VALUES (207,103,4,36);
INSERT INTO PRESCRIPCION VALUES (208,103,7,14);
INSERT INTO PRESCRIPCION VALUES (209,104,7,8);
INSERT INTO PRESCRIPCION VALUES (210,105,7,4);
INSERT INTO PRESCRIPCION VALUES (211,106,7,2);

INSERT INTO ALERGIA VALUES (101,'penicilinas');
INSERT INTO ALERGIA VALUES (104,'yodos');
INSERT INTO ALERGIA VALUES (106,'penicilinas');

COMMIT;


-- -----------------------------------------------------------------
-- 1. Lista de pacientes que incluya id, nombre del paciente y el
-- gasto total en medicamentos de tipo 'penicilinas', de aquellos
-- pacientes que toman al menos dos medicamentos distintos de ese
-- mismo tipo.

select  pa.idpaciente,pa.nombre, sum(pre.numdosis*m.preciodosis) as totalGastado
from paciente pa join prescripcion pre on pa.idpaciente=pre.idpaciente join medicamento m on m.idmed=pre.idmed
where pa.idpaciente in (
        select pre.idpaciente
        from prescripcion pre join medicamento m on pre.idmed=m.idmed
        where m.tipomed='penicilinas'
        group by pre.idpaciente,m.tipomed
        having count (m.idmed)>1
        )
group by pa.idpaciente,pa.nombre
;
--SOLUCION PROFESOR
select  pa.idpaciente,pa.nombre, sum(pre.numdosis*m.preciodosis) as totalGastado
from paciente pa join prescripcion pre on pa.idpaciente=pre.idpaciente join medicamento m on m.idmed=pre.idmed
where m.tipomed='penicilinas'
group by pa.idpaciente,pa.nombre
having count (m.idmed)>1;
-- -----------------------------------------------------------------
-- 2. Lista de todos los medicamentos (id, denominación) y el número
-- de pacientes con alergia a cada medicamento.  Si para un
-- medicamento no hay pacientes que sean alérgicos, debe mostrar un 0.
select m.idmed, m.denominacion, count (p.idpaciente) as numpacientes
from medicamento m left join alergia a on m.tipomed=a.tipomed left join paciente p on p.idpaciente=a.idpaciente
group by m.idmed,m.denominacion
;
--solution profesor
select m.idmed, m.denominacion, count (a.tipomed) as numpacientes
from medicamento m left join alergia a on m.tipomed=a.tipomed 
group by m.idmed,m.denominacion
;

-- -----------------------------------------------------------------
-- 3. Lista de los pacientes (id, nombre) que no son alérgicos a
-- ninguno de los medicamentos que se les han prescrito.
SELECT distinct p.idpaciente,p.nombre
FROM paciente p join prescripcion pre on p.idpaciente=pre.idpaciente
where p.idpaciente not in (
        SELECT pre.idpaciente
        from alergia a join medicamento m on a.tipomed=m.tipomed join prescripcion pre on m.idmed=pre.idmed and pre.idpaciente=a.idpaciente);

-- -----------------------------------------------------------------
-- 4. Lista de los tipos de medicamentos (tipo, descripción) que
-- tienen más casos de alergias. El resultado debe incluir el 
-- número de casos de alergias.

CREATE VIEW NUMCASOS_MEDICAMENTOS_ALERGIA(NUMCASOS)AS(
select count (t.idtipo) as numcasos
from alergia a join tipo_medicamento t on a.tipomed=t.idtipo
group by t.idtipo,t.descripcion)
;
select t.idtipo,t.descripcion
from alergia a join tipo_medicamento t on a.tipomed=t.idtipo
group by t.idtipo,t.descripcion
HAVING count (t.idtipo) = (SELECT MAX(NUMCASOS) FROM NUMCASOS_MEDICAMENTOS_ALERGIA)
;

-- -----------------------------------------------------------------
-- 5. Lista de medicamentos (id, denominación) que han sido prescritos
-- a todos los pacientes.
select m.idmed,m.denominacion
from medicamento m 
where m.idmed=( select pre.idmed
                from prescripcion pre
                group by pre.idmed
                having count(distinct pre.idpaciente)=(select count(p.idpaciente)
                                                        from paciente p));


-- -----------------------------------------------------------------
-- 6. Lista de los pacientes (id, nombre) que solamente tienen alergia
-- a las penicilinas.
select p.idpaciente,p.nombre
from paciente p join alergia a on p.idpaciente=a.idpaciente
where a.tipomed='penicilinas' and  p.idpaciente not in(
        select pa.idpaciente
        from paciente pa join alergia a on pa.idpaciente=a.idpaciente
        where a.tipomed<>'penicilinas');
