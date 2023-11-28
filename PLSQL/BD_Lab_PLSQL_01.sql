-- -------------------------------------------------------------------------

-- PL/SQL: Sesión 1 de laboratorio.

-- Procedimientos almacenados

-- Nombres de los estudiantes participantes: 
-- <<Escribir aquí vuestros nombres para saber quién ha estado trabajando en este fichero.>>

-- -------------------------------------------------------------------------

-- Este script contiene parte de la definición de la base de datos de 
-- una aerolínea. Contiene tablas con la siguiente información:
-- * Los aviones que forman la flota de la aerolínea.
-- * Los empleados de la aerolínea.
-- * Los certificados de los empleados que pilotan los modelos de avión.
-- * Los vuelos que opera la aerolínea.
-- Revisar la estructura de la base de datos para entender cómo está
-- almacenada la información.

-- Ejecutar el script que crea la base de datos y codificar los procedimientos
-- almacenados y los disparadores al final de este fichero.

-- Para comprobar que se están capturando bien las excepciones realizar distintos
-- casos de prueba con parámetros válidos y con parámetros que generen error.

-- -------------------------------------------------------------------------
SET SERVEROUTPUT ON;
ALTER SESSION SET nls_date_format='DD/MM/YYYY';

drop table FWCertificate;
drop table FWEmpl;
drop table FWPlane;
drop table FWFlight;

create table FWFlight(
	flno number(4,0) primary key,
	deptAirport varchar2(20),
	destAirport varchar2(20),
	distance number(6,0), -- distancia en millas
	deptDate date,
	arrivDate date,
	price number(7,2));

create table FWPlane(
	pid number(9,0) primary key,
	name varchar2(30),
	maxFlLength number(6,0) -- longitud máxima en millas
	);

create table FWEmpl(
	eid number(9,0) primary key,
	name varchar2(30),
	salary number(10,2));

create table FWCertificate(
	eid number(9,0),
	pid number(9,0),
	primary key(eid,pid),
	foreign key(eid) references FWEmpl,
	foreign key(pid) references FWPlane); 



INSERT INTO FWFlight  VALUES (99,'Los Angeles','Washington D.C.',2308,to_date('04/12/2005 09:30', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 09:40', 'dd/mm/yyyy HH24:MI'),235.98);

INSERT INTO FWFlight  VALUES (13,'Los Angeles','Chicago',1749,to_date('04/12/2005 08:45', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 08:45', 'dd/mm/yyyy HH24:MI'),220.98);

INSERT INTO FWFlight  VALUES (346,'Los Angeles','Dallas',1251,to_date('04/12/2005 11:50', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 07:05', 'dd/mm/yyyy HH24:MI'),225-43);

INSERT INTO FWFlight  VALUES (387,'Los Angeles','Boston',2606,to_date('04/12/2005 07:03', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 05:03', 'dd/mm/yyyy HH24:MI'),261.56);

INSERT INTO FWFlight  VALUES (7,'Los Angeles','Sydney',7487,to_date('04/12/2005 05:30', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 11:10', 'dd/mm/yyyy HH24:MI'),278.56);

INSERT INTO FWFlight  VALUES (2,'Los Angeles','Tokyo',5478,to_date('04/12/2005 06:30', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 03:55', 'dd/mm/yyyy HH24:MI'),780.99);

INSERT INTO FWFlight  VALUES (33,'Los Angeles','Honolulu',2551,to_date('04/12/2005 09:15', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 11:15', 'dd/mm/yyyy HH24:MI'),375.23);

INSERT INTO FWFlight  VALUES (34,'Los Angeles','Honolulu',2551,to_date('04/12/2005 12:45', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 03:18', 'dd/mm/yyyy HH24:MI'),425.98);

INSERT INTO FWFlight  VALUES (76,'Chicago','Los Angeles',1749,to_date('04/12/2005 08:32', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 10:03', 'dd/mm/yyyy HH24:MI'),220.98);

INSERT INTO FWFlight  VALUES (68,'Chicago','New York',802,to_date('04/12/2005 09:00', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 12:02', 'dd/mm/yyyy HH24:MI'),202.45);

INSERT INTO FWFlight  VALUES (7789,'Madison','Detroit',319,to_date('04/12/2005 06:15', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 08:19', 'dd/mm/yyyy HH24:MI'),120.33);

INSERT INTO FWFlight  VALUES (701,'Detroit','New York',470,to_date('04/12/2005 08:55', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 10:26', 'dd/mm/yyyy HH24:MI'),180.56);

INSERT INTO FWFlight  VALUES (702,'Madison','New York',789,to_date('04/12/2005 07:05', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 10:12', 'dd/mm/yyyy HH24:MI'),202.34);

INSERT INTO FWFlight  VALUES (4884,'Madison','Chicago',84,to_date('04/12/2005 10:12', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 11:02', 'dd/mm/yyyy HH24:MI'),112.45);

INSERT INTO FWFlight  VALUES (2223,'Madison','Pittsburgh',517,to_date('04/12/2005 08:02', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 10:01', 'dd/mm/yyyy HH24:MI'),189.98);

INSERT INTO FWFlight  VALUES (5694,'Madison','Minneapolis',247,to_date('04/12/2005 08:32', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 09:33', 'dd/mm/yyyy HH24:MI'),120.11);

INSERT INTO FWFlight  VALUES (304,'Minneapolis','New York',991,to_date('04/12/2005 10:00', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 01:39', 'dd/mm/yyyy HH24:MI'),101.56);

INSERT INTO FWFlight  VALUES (149,'Pittsburgh','New York',303,to_date('04/12/2005 09:42', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 12:09', 'dd/mm/yyyy HH24:MI'),1165.00);

Insert into FWPlane  values ('1','Boeing 747-400','8430');
Insert into FWPlane  values ('3','Airbus A340-300','7120');
Insert into FWPlane  values ('4','British Aerospace Jetstream 41','1502');
Insert into FWPlane  values ('5','Embraer ERJ-145','1530');
Insert into FWPlane  values ('7','Piper Archer III','520');


Insert into FWEmpl  values ('567354612','Lisa Walker',256481);
Insert into FWEmpl  values ('254099823','Patricia Jones',223000);
Insert into FWEmpl  values ('355548984','Angela Martinez',212156);
Insert into FWEmpl  values ('310454876','Joseph Thompson',212156);
Insert into FWEmpl  values ('269734834','George Wright',289950);
Insert into FWEmpl  values ('552455348','Dorthy Lewis',251300);
Insert into FWEmpl  values ('486512566','David Anderson',43001);
Insert into FWEmpl  values ('573284895','Eric Cooper',114323);
Insert into FWEmpl  values ('574489457','Milo Brooks',2000);


Insert into FWCertificate values ('269734834','1');
Insert into FWCertificate values ('269734834','3');
Insert into FWCertificate values ('269734834','4');
Insert into FWCertificate values ('269734834','5');
Insert into FWCertificate values ('269734834','7');
Insert into FWCertificate values ('567354612','1');
Insert into FWCertificate values ('567354612','3');
Insert into FWCertificate values ('567354612','4');
Insert into FWCertificate values ('567354612','5');
Insert into FWCertificate values ('567354612','7');
Insert into FWCertificate values ('573284895','3');
Insert into FWCertificate values ('573284895','4');
Insert into FWCertificate values ('573284895','5');
Insert into FWCertificate values ('574489457','7');


-- -------------------------------------------------------------------------
-- Escribir las respuestas a continuación de cada comentario.
-- No se debe eliminar ningún comentario.
-- -------------------------------------------------------------------------

/* 1. Escribir un procedimiento almacenado PL/SQL con el nombre pr_FLIGHT_print_info
que reciba como parámetro un número de vuelo y escriba por consola la información
relacionada a ese vuelo. Si el vuelo no existe, se debe mostrar un mensaje de error
en la consola.

Por ejemplo, si se invoca al procedimiento con el número de vuelo 7789,
el resultado ha de ser algo parecido a lo siguiente 
(la distancia ha de mostrarse en kilómetros, no en millas):

-------------------------------------------------------------
Información del vuelo: 7789-Madison-Detroit (513 km)
-------------------------------------------------------------

Si se invoca al procedimiento con un número de vuelo que no existe, 
por ejemplo, 9999, el resultado por consola será el siguiente mensaje:

¡No se ha encontrado el número de vuelo: 9999!

Comprobar que el procedimiento almacenado funciona a través de 
distintos casos de prueba.

Sugerencia: utilizar SELECT...INTO para recuperar la información del
vuelo de la base de datos. Se debería controlar la excepción en caso
de que el vuelo no exista.*/

CREATE  OR REPLACE PROCEDURE pr_FLIGHT_print(vuelo in number) as

-- variable solo visible dentro del procedimiento
-- vars de trabajo

    p_num_vuelo FWFLIGHT.FLNO%TYPE;
    p_depairport FWFLIGHT.deptairport%TYPE;
    p_destairport FWFLIGHT.destairport%TYPE;
    p_distance FWFLIGHT.distance%TYPE;

-- cursor para leer datos
      CURSOR cursor_vuelos IS
      select flno,deptairport,destairport,distance
      from fwflight;
BEGIN
  OPEN cursor_vuelos;

LOOP
  FETCH  cursor_vuelos
    INTO p_num_vuelo,p_depairport,p_destairport,p_distance;
  EXIT WHEN cursor_vuelos%NOTFOUND;
--            --> atencion  DBMS_output.put_line necesita "set serveroutput on"
  IF p_num_vuelo LIKE vuelo THEN
  p_distance := p_distance*1.60934;
  DBMS_output.put_line('Informacion del vuelo: '||p_num_vuelo||'-'||p_depairport||'-'||p_destairport||' ('||p_distance||' km)');
  END IF;
END LOOP;
IF cursor_vuelos%ISOPEN 
   THEN  CLOSE cursor_vuelos; 
END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
   DBMS_output.put_line('¡No se ha encontrado el nÃºmero de vuelo: '||vuelo||'!');
   IF cursor_vuelos%ISOPEN 
     THEN  CLOSE cursor_vuelos; 
   END IF;
END;



/* 2. Escribir un procedimiento almacenado PL/SQL con el nombre pr_FLIGHT_PLANE_list_info
basado en el ejercicio anterior, donde aparte de mostrar la información del 
vuelo, muestre también por consola todos los aviones de la flota que pueden
operar dicho vuelo (es decir, los aviones que tienen una longitud máxima
de distancia de vuelo que permite operar ese vuelo). Para cada avión, mostrar
la siguiente información: identificador del avión, nombre, número de pilotos
que tienen la certificación para opera pilotar ese avión y el salario medio
de esos pilotos. Si el vuelo no existe deberá mostrar un mensaje de error en
la consola. Por ejemplo, si se invoca el procedimiento con el vuelo 7789, el
resultado debería ser el siguiente (la distancia ha de mostrarse en kilómetros,
no en millas):

*/

select a.pid,a.name,count(e.eid)as numEmp,round(avg(salary),2)as mediasalario
from FWPlane a join  FWCertificate c on a.pid=c.pid join FWEmpl e on e.eid=c.eid
where a.maxFlLength>=(select v.distance from fwflight v where v.flno=7789) 
group by a.pid,a.name
order by a.pid
;
/*
-----------------------------------------------------------------
Aviones para el vuelo: 7789-Madison-Detroit (513 km)
-------------------------------------------------------------
PID Avión                       Núm.emp.        Media salario
-------------------------------------------------------------
  1 Boeing 747-400                     2          273.215,50
  3 Airbus A340-300                    3          220.251,33
  4 British Aerospace Jetstream 41     3          220.251,33
  5 Embraer ERJ-145                    3          220.251,33
  7 Piper Archer III                   3          182.810,33
-----------------------------------------------------------------

Si se invoca al procedimiento con un número de vuelo que no existe, 
por ejemplo, 9999, el resultado por consola será el siguiente mensaje:

¡No se ha encontrado el número de vuelo: 9999!

Sugerencia: aparte de la sentencia SELECT...INTO del ejercicio 1, también
se debería utilizar un cursor que permita recuperar la información de los
aviones. Hacer uso de las funciones de cadenas de caracteres para formatear
adecuadamente la salida, como por ejemplo, RPAD o TO_CHAR, tal y como
se vio en las transparencias de clase. */

CREATE  OR REPLACE PROCEDURE pr_FLIGHT_PLANE_list_info as

-- variable solo visible dentro del procedimiento
-- vars de trabajo

	v_name;
    v_pid;
	v_eid;
	v_mediasalario;

	v_num_vuelo FWFLIGHT.FLNO%TYPE;
    v_depairport FWFLIGHT.deptairport%TYPE;
    v_destairport FWFLIGHT.destairport%TYPE;
    v_distance FWFLIGHT.distance%TYPE;

-- cursor para leer datos
      CURSOR cursor_vuelos IS
      select flno,deptairport,destairport,distance
      from fwflight;

BEGIN
  OPEN cursor_vuelos;

LOOP
  FETCH  cursor_vuelos
    INTO v_num_vuelo,v_depairport,v_destairport,v_distance;
  EXIT WHEN cursor_vuelos%NOTFOUND;
--            --> atencion  DBMS_output.put_line necesita "set serveroutput on"
  IF p_num_vuelo LIKE vuelo THEN
  DBMS_output.put_line('Informacion del vuelo:'||p_num_vuelo||'-'||p_depairport||'-'||p_destairport||' ('||p_distance||' km)');
  
  END IF;
END LOOP;
IF cursor_vuelos%ISOPEN 
   THEN  CLOSE cursor_vuelos; 
END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
   DBMS_output.put_line('¡No se ha encontrado el nÃºmero de vuelo: '||vuelo||'!');
   IF cursor_vuelos%ISOPEN 
     THEN  CLOSE cursor_vuelos; 
   END IF;
END;





/* 3. A partir del procedimiento anterior escribir un nuevo procedimiento
almacenado PL/SQL con el nombre pr_FLIGHT_PILOT_list_info que añada la siguiente
información: para cada avión imprimir el nombre y el salario de cada 
uno de los empleados que están certificados para pilotar ese avión, 
ordenados por el nombre de manera ascendente. Por ejemplo, si se invoca
el procedimiento con el vuelo 2, debería mostrar lo siguiente
(la distancia ha de mostrarse en kilómetros, no en millas):

-------------------------------------------------------------
Aviones para el vuelo 2-Los Angeles-Tokyo (8816 km)
-------------------------------------------------------------
PID Avión                          Núm.emp.    Media salario
-------------------------------------------------------------
  1 Boeing 747-400                        2       273.215,50
    Pilotos:
     George Wright                                289.950,00
     Lisa Walker                                  256.481,00
-------------------------------------------------------------
  3 Airbus A340-300                       3       220.251,33
    Pilotos:
     Eric Cooper                                  114.323,00
     George Wright                                289.950,00
     Lisa Walker                                  256.481,00
-------------------------------------------------------------

Sugerencia: utilizar dos cursores: uno para los aviones (el que 
se utilizó en el ejercicio 2), y otro cursor que muestre los 
pilotos certificados para ese vuelo. Los cursores se deben 
recorrer a través de bucles FOR. Se pueden utilizar variables 
locales para proporcionar la información de un cursor en otro. */







