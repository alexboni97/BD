--- -------------------------------------------------------------
-- ASIGNATURA: BASES DE DATOS
-- -------------------------------------------------------------
-- GRADO EN INGENIER�?A DEL SOFTWARE
-- -------------------------------------------------------------
-- PR�?CTICA 3: Oracle - PL/SQL: procedimientos y disparadores
-- -------------------------------------------------------------
-- ID GRUPO: 16
-- Estudiante 1: ALEX GUILLERMO BONILLA TACO
-- Estudiante 2: PABLO RODDRIGUEZ ARENAS
-- -------------------------------------------------------------

-- Ejecutar el siguiente script para crear la base de datos a  
-- utilizar en esta práctica.

-- Esta base de datos contiene información de prescripción de
-- medicamentos a pacientes y sus alergias a tipos de medicamentos.
-- A continuación de cada bloque de comentarios, contestar a las 
-- preguntas que se detallan al final de este fichero.

SET SERVEROUTPUT ON;
alter session set nls_date_format = 'DD/MM/YYYY';
SET LINESIZE 500;
SET PAGESIZE 500;

drop table ESTADISTICA;
drop table PRESCRIPCION;
drop table ALERGIA;
drop table PACIENTE;
drop table MEDICAMENTO;
drop table TIPO_MEDICAMENTO;

CREATE TABLE TIPO_MEDICAMENTO(
    IdTipo varchar2(20) PRIMARY KEY,
    descripcion varchar2(100) NOT NULL
);

CREATE TABLE MEDICAMENTO(
    IdMed INTEGER PRIMARY KEY,
    denominacion varchar2(100) NOT NULL,
    tipoMed varchar2(20) NOT NULL ,
    precioDosis NUMBER(9,2) NOT NULL, -- precio por cada dosis del medicamento.
    FOREIGN KEY (tipomed) REFERENCES TIPO_MEDICAMENTO(IdTipo)
);

CREATE TABLE PACIENTE(
    IdPaciente INTEGER PRIMARY KEY,
    nombre varchar2(100) NOT NULL,
    fecNacim DATE,
    descuento NUMBER(5,2)
);

-- Prescripción de medicamentos a pacientes.
CREATE TABLE PRESCRIPCION(
    IdPres INTEGER PRIMARY KEY,
    IdPaciente INTEGER NOT NULL,
    IdMed INTEGER NOT NULL ,
    NumDosis INTEGER NOT NULL,  -- número dosis del medicamento prescritas al paciente.
    alertaAlergia INTEGER,
    FOREIGN KEY (IdPaciente) REFERENCES PACIENTE(IdPaciente),
    FOREIGN KEY (IdMed) REFERENCES MEDICAMENTO(IdMed)
);

-- Alergias diagnosticadas a los pacientes en base al
-- tipo de medicamento.
CREATE TABLE ALERGIA(
    IdPaciente INTEGER NOT NULL,
    tipoMed varchar2(20) NOT NULL,
    PRIMARY KEY (IdPaciente, tipoMed),
    FOREIGN KEY (IdPaciente) REFERENCES PACIENTE(IdPaciente),
    FOREIGN KEY (tipomed) REFERENCES TIPO_MEDICAMENTO(IdTipo)
);

-- Información estadística sobre medicamentos: número
-- de pacientes alérgicos.
CREATE TABLE ESTADISTICA(
    IdMed INTEGER NOT NULL,
    numPacientes INTEGER,
    FOREIGN KEY (IdMed) REFERENCES MEDICAMENTO(IdMed)-- número pacientes alérgicos.
);

INSERT INTO TIPO_MEDICAMENTO VALUES ('penicilinas', 'Antibioticos derivados de la penicilina');
INSERT INTO TIPO_MEDICAMENTO VALUES ('anticonvulsivos', 'Medicamentos anticonvulsivos y derivados');
INSERT INTO TIPO_MEDICAMENTO VALUES ('insulinas', 'Insulinas animales');
INSERT INTO TIPO_MEDICAMENTO VALUES ('yodos', 'Medicamentos para contraste basados en yodo');
INSERT INTO TIPO_MEDICAMENTO VALUES ('sulfas', 'Medicamentos basados en sulfamidas antibacterianas');
INSERT INTO TIPO_MEDICAMENTO VALUES ('otros', 'Resto de medicamentos');

INSERT INTO MEDICAMENTO VALUES (1, 'sulfametoxazol', 'sulfas', 3.45);
INSERT INTO MEDICAMENTO VALUES (2, 'sulfadiazina', 'sulfas', 2.10);
INSERT INTO MEDICAMENTO VALUES (3, 'meticilina', 'penicilinas', 0.87);
INSERT INTO MEDICAMENTO VALUES (4, 'amoxicilina', 'penicilinas', 0.22);
INSERT INTO MEDICAMENTO VALUES (5, 'insulina de accion ultrarrapida', 'insulinas', 0.82);
INSERT INTO MEDICAMENTO VALUES (6, 'insulina de accion rapida', 'insulinas', 0.55);
INSERT INTO MEDICAMENTO VALUES (7, 'yoduro potasico', 'yodos', 0.30);
INSERT INTO MEDICAMENTO VALUES (8, 'acido acetilsalicilico', 'otros', 0.05);
INSERT INTO MEDICAMENTO VALUES (9, 'cloxacilina', 'penicilinas', 0.99);
 
insert into PACIENTE values (101,'Margarita Sánchez', TO_DATE('17/02/2001'), 0.0);
insert into PACIENTE values (102,'Luis García', TO_DATE('24/09/1985'), 35.0);
insert into PACIENTE values (103,'Pedro Santillana', TO_DATE('28/02/1951'), 60.0);
insert into PACIENTE values (104,'Rosa Prieto', TO_DATE('5/12/2005'), 15.0);
insert into PACIENTE values (105,'Ambrosio Pérez', TO_DATE('22/01/1951'), 60.0);
insert into PACIENTE values (106,'Lola Arribas', TO_DATE('14/12/1977'), 20.0);

INSERT INTO PRESCRIPCION VALUES (201,101,1,12, 0);
INSERT INTO PRESCRIPCION VALUES (202,101,3,24, 0);
INSERT INTO PRESCRIPCION VALUES (203,101,4,48, 0);
INSERT INTO PRESCRIPCION VALUES (204,101,7,8, 0);
INSERT INTO PRESCRIPCION VALUES (205,102,4,14, 0);
INSERT INTO PRESCRIPCION VALUES (206,103,3,24, 0);
INSERT INTO PRESCRIPCION VALUES (208,103,7,14, 0);
INSERT INTO PRESCRIPCION VALUES (209,104,7,8, 0);
INSERT INTO PRESCRIPCION VALUES (210,106,7,12, 0);

INSERT INTO ALERGIA VALUES (101, 'penicilinas');
INSERT INTO ALERGIA VALUES (101, 'sulfas');
INSERT INTO ALERGIA VALUES (104, 'yodos');
INSERT INTO ALERGIA VALUES (105, 'penicilinas');
INSERT INTO ALERGIA VALUES (106, 'penicilinas');
INSERT INTO ALERGIA VALUES (103, 'penicilinas');

-- Inicializar a cero todos los alérgicos a un medicamento.
INSERT INTO ESTADISTICA SELECT IdMed, 0 FROM MEDICAMENTO;

COMMIT;


-- -----------------------------------------------------------------
-- 1. Escribir un procedimiento almacenado llamado pr_MEDICAMENTO_listar
-- que reciba como parámetro un tipo de medicamento y muestre por la
-- consola todos los medicamentos de ese tipo (id, descripción y gasto
-- total de ese medicamento, sin aplicar descuentos).
--
-- Si el tipo de medicamento no existe en la base de datos debe
-- mostrar un mensaje de error y terminar.
-- 
-- Por cada medicamento, debe mostrar la lista de pacientes a los que
-- se ha prescrito ese medicamento (id, nombre, edad, gasto total 
-- antes y después de aplicar descuento). Para calcular la edad se puede
-- utilizar alguna de las funciones de fecha que se han visto en clase
-- (por ejemplo, ADD_MONTHS o MONTHS_BETWEEN). Si un medicamento no
-- ha sido prescrito a ningún paciente, debe mostrar el mensaje 'No
-- prescrito'.
--
-- Por cada medicamento mostrado, el procedimiento debe actualizar la
-- estadística de pacientes alérgicos en la base de datos
-- (ESTADISTICA), actualizando la columna numPacientes con el
-- número de pacientes alérgicos a ese medicamento.

-- (0,4 puntos)
-- FORMATO EJEMPLO DE SALIDA
/*
------------------------------------------------------------------------------------
TIPO DE MEDICAMENTO: penicilinas
------------------------------------------------------------------------------------
Medicamento:    3 -- meticilina          -- Total Gastado:     41.76�
  Pacientes:
 101   Margarita Sánchez   -- 22 a�os -- Total sin Desc:     20.88�  -- Total con Desc:     20.88�. 
 103   Pedro Santillana     -- 72 a�os -- Total sin Desc:     20.88�  -- Total con Desc:      8.35�. 
 
Medicamento:    4 -- amoxicilina         -- Total Gastado:     13.64�
  Pacientes:
 101   Margarita Sánchez   -- 22 a�os -- Total sin Desc:     10.56�  -- Total con Desc:     10.56�. 
 102   Luis García         -- 38 a�os -- Total sin Desc:      3.08�  -- Total con Desc:      2.00�. 
 
Medicamento:    9 -- cloxacilina         -- Total Gastado:      0.00�
  Pacientes:
No prescrito
 
------------------------------------------------------------------------------------
*/
CREATE OR REPLACE PROCEDURE pr_MEDICAMENTO_listar(p_tipoMed in varchar2)
AS

e_notfound_tipomed EXCEPTION;
v_existetipo BOOLEAN:=FALSE;
v_existepaciente BOOLEAN:=FALSE;

cursor cursor_medicamentos is
select m.idmed,m.denominacion, sum(nvl(m.preciodosis * p.numdosis,0) )as totalgastado
from medicamento m left join prescripcion p on m.idmed=p.idmed
where m.tipomed= p_tipoMed 
group by m.idmed,m.denominacion
order by m.idmed;

CURSOR cursor_pacientes is
select m.idmed,p.idpaciente,pa.nombre,trunc(months_between(sysdate,pa.fecnacim)/12)as edad,sum(m.preciodosis * p.numdosis)as totalsindesc,round(sum(m.preciodosis * p.numdosis*(100-pa.descuento)/100),2)as totalcondesc
from medicamento m join prescripcion p on m.idmed=p.idmed join paciente pa on p.idpaciente=pa.idpaciente
where m.tipomed= p_tipoMed
group by m.idmed,p.idpaciente, pa.nombre, pa.fecnacim
order by m.idmed;


BEGIN
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('TIPO DE MEDICAMENTO: '||p_tipoMed||'');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------');
    for v_row_m IN cursor_medicamentos LOOP
        v_existetipo:=true;
        DBMS_OUTPUT.PUT_LINE('Medicamento:    '||v_row_m.idmed||' -- '||rpad(v_row_m.denominacion,20)||'-- Total Gastado: '||TO_CHAR(v_row_m.totalgastado,'9,990.00')||'�');
        DBMS_OUTPUT.PUT_LINE('  Pacientes:');
        v_existepaciente:=false;
        FOR v_row_p IN cursor_pacientes LOOP
            if v_row_m.idmed=v_row_p.idmed THEN
            v_existepaciente:=true;
            ---ACTUALIZACION DE LA TABLA ESTADISTICA
            update ESTADISTICA
            SET NUMPACIENTES=NUMPACIENTES+1
            WHERE IDMED=v_row_m.idmed;
            DBMS_OUTPUT.PUT_LINE(' '||rpad(v_row_p.idpaciente,3)||'   '||rpad(v_row_p.nombre,20)||' -- '||v_row_p.edad||' a�os -- Total sin Desc: '||TO_CHAR(v_row_p.totalsindesc,'9,999.00')||'�  -- Total con Desc: '||TO_CHAR(v_row_p.totalcondesc,'9,999.00')||'�. ');
            end if;
        END LOOP;
        IF NOT v_existepaciente THEN 
            DBMS_OUTPUT.PUT_LINE('   No prescrito');
        END IF;
        DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
    IF NOT v_existetipo then raise e_notfound_tipomed;
    end if;

EXCEPTION
    WHEN e_notfound_tipomed THEN
        DBMS_OUTPUT.PUT_LINE('ERROR. NO EXISTE ESTE TIPO DE MEDICAMENTO: '||p_tipoMed||'');

END;

-- -----------------------------------------------------------------
-- 2. Escribir un disparador que cada vez que se inserte un registro
-- en la tabla MEDICAMENTO, compruebe si existe el tipo de medicamento
-- al que pertenece y, si no existe, que lo dé de alta en la tabla
-- TIPO_MEDICAMENTO.

-- (0,2 puntos)

CREATE OR REPLACE TRIGGER t_alta_TIPOMED 
    before insert on MEDICAMENTO
    FOR EACH ROW
DECLARE
    v_cont_tipoMed integer;

BEGIN 
    SELECT count(*)
    INTO v_cont_tipoMed
    FROM TIPO_MEDICAMENTO
    WHERE Idtipo= :NEW.tipomed;

    IF v_cont_tipoMed=0 THEN 
        INSERT INTO TIPO_MEDICAMENTO VALUES(:NEW.tipomed,'tipoNew');    
    END IF;

END;
-- -
-- -----------------------------------------------------------------
-- 3. Añadir una columna importeTotalDescuentos a la tabla MEDICAMENTO
-- con la siguiente sentencia DDL:
-- 
-- ALTER TABLE MEDICAMENTO ADD importeTotalDescuentos NUMBER(9,2) DEFAULT 0;
--
-- Esta columna debe contener el importe total de los descuentos
-- aplicados por cada paciente (precioDosis * numDosis * descuento / 100)
-- 
-- Escribir un disparador que mantenga actualizada la columna
-- importeTotalDescuentos ante cualquier cambio en la prescripción de
-- medicaciones de un paciente. Además, si el paciente es alérgico al
-- medicamento prescrito, debe asignar un 1 en la columna
-- alertaAlergia.
--
-- Se puede suponer que el total de dosis prescritas es consistente con
-- la información de la base de datos antes del cambio que lanza el
-- disparador.

-- (0,4 puntos)

ALTER TABLE MEDICAMENTO ADD importeTotalDescuentos NUMBER(9,2) DEFAULT 0;


CREATE OR REPLACE TRIGGER t_actualizar_descuentos
    after insert or update or delete on prescripcion
    FOR EACH ROW
DECLARE
    v_total_descuento NUMBER(9,2);
    
BEGIN 
    IF INSERTING OR UPDATING THEN
        select nvl(round(sum(m.preciodosis * p.numdosis*pa.descuento/100),2),0)as descuento
        into v_total_descuento
        from medicamento m left join prescripcion p on m.idmed=p.idmed left join paciente pa on p.idpaciente=pa.idpaciente
        where p.idmed= :NEW.idmed;

        update medicamento set medicamento.importetotaldescuentos=v_total_descuento
        where medicamento.idmed=:NEW.idmed;
        END IF;
    ELSIF DELETING THEN
        select nvl(round(sum(m.preciodosis * p.numdosis*pa.descuento/100),2),0)as descuento
        into v_total_descuento
        from medicamento m left join prescripcion p on m.idmed=p.idmed left join paciente pa on p.idpaciente=pa.idpaciente
        where p.idmed= :OLD.idmed;

        update medicamento set medicamento.importetotaldescuentos=v_total_descuento
        where medicamento.idmed=:OLD.idmed;

    END IF;
END;
