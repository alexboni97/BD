-- -------------------------------------------------------------------------

-- PL/SQL: Sesión 2 de laboratorio.

-- Procedimientos almacenados y disparadores
-- 
-- -------------------------------------------------------------------------

-- Este script contiene parte de la definición de una base de datos 
-- en una cadena de tiendas. 
-- Las tablas contienen la siguiente información:
--
--  * Las tiendas que forman parte de la cadena de tiendas (DSStore).
--  * Los departamentos de cada tienda (DSDept).
--  * Las ofertas disponibles en cada departamento de cada tienda (DSSaleOffer).
--  * Las compras realizadas por los clientes (DSSale).
--
-- Revisar la estructura de la base de datos para entender bien cómo se
-- está almacenando la información. 

-- Ejecutar el script en una sesión de base de datos para crear la base
-- de datos.

-- Intentar resolver los dos ejercicios planteados y realizar 
-- caso de prueba para validar vuestra propuesta.

-- -------------------------------------------------------------------------
SET SERVEROUTPUT ON;
alter session set nls_date_format='DD-MM-YYYY';

DROP TABLE DSSale;
DROP TABLE DSSaleOffer;
DROP TABLE DSDept;
DROP TABLE DSStore;

CREATE TABLE DSStore (
  IdStore VARCHAR2(5) PRIMARY KEY,
  Address VARCHAR2(40)
);

CREATE TABLE DSDept (
  IdStore VARCHAR2(5) REFERENCES DSStore,
  IdDept NUMBER(3),
  Descr VARCHAR2(40),
  DateSalesOffers DATE,
  NumSalesOffers NUMBER(6,0),
  PRIMARY KEY (IdStore, IdDept)
);

CREATE TABLE DSSaleOffer (
  IdOffer VARCHAR2(5) PRIMARY KEY,
  IdStore VARCHAR2(5),
  IdDept NUMBER(3),
  startDate DATE,
  endDate DATE,
  Product VARCHAR2(40),
  OfferedItems NUMBER(4) NOT NULL,
  SoldItems NUMBER(4) DEFAULT 0 NOT NULL,
  FOREIGN KEY (IdStore, IdDept) REFERENCES DSDept,
  CHECK (OfferedItems > 0),
  CHECK (OfferedItems >= SoldItems)
);

CREATE TABLE DSSale (
  IdSale VARCHAR2(5) PRIMARY KEY,
  IdOffer VARCHAR2(5) REFERENCES DSSaleOffer,
  SaleDate DATE,
  Customer VARCHAR2(40),
  NumItems NUMBER(4),
  CHECK (NumItems > 0)
);

INSERT INTO DSStore VALUES ('37','Conde de Peñalver, 44');
INSERT INTO DSStore VALUES ('44','Princesa, 25');

INSERT INTO DSDept VALUES ('37',1, 'Papelería',null,0);
INSERT INTO DSDept VALUES ('37',2, 'Informática',null,0);
INSERT INTO DSDept VALUES ('37',3, 'TV Sonido',null,0);
INSERT INTO DSDept VALUES ('44',1, 'Informática',null,0);
INSERT INTO DSDept VALUES ('44',2, 'Librería',null,0);

INSERT INTO DSSaleOffer VALUES ('o01', '37', 1, TO_CHAR('01-02-2023'), TO_CHAR('01-02-2023'), 'SuperDestroyer 60', 50, 0);
INSERT INTO DSSaleOffer VALUES ('o02', '37', 2, TO_CHAR('15-03-2023'), TO_CHAR('15-04-2023'), 'Computer i7 16Gb 1Tb HD', 15, 0);
INSERT INTO DSSaleOffer VALUES ('o03', '37', 2, TO_CHAR('15-03-2023'), TO_CHAR('15-04-2023'), 'Monitor 27in 4K', 15, 0);
INSERT INTO DSSaleOffer VALUES ('o04', '37', 3, TO_CHAR('01-02-2023'), TO_CHAR('15-05-2023'), 'Soundbar Speaker Megatron', 20, 0);
INSERT INTO DSSaleOffer VALUES ('o05', '44', 1, TO_CHAR('01-02-2023'), TO_CHAR('15-04-2023'), 'Compaq Computer i5 8Gb 1Tb HD', 84, 0);
INSERT INTO DSSaleOffer VALUES ('o06', '44', 1, TO_CHAR('01-02-2023'), TO_CHAR('15-02-2023'), 'Saikushi Printer 3000', 20, 0);
INSERT INTO DSSaleOffer VALUES ('o07', '44', 2, TO_CHAR('01-02-2023'), TO_CHAR('15-02-2023'), 'Tetralogy The Ring', 25, 0);

COMMIT;

/* 1.  Escribir un procedimiento almacenado, donde recibiendo un id de tienda
y una fecha, muestre por consola la dirección de la tienda y las ofertas ofrecidas
por cada departamento de esa tienda para esa fecha. 
Debe mostrar cada departamento y, por cada departamento, las ofertas que ofrece:
IdOffer, Product, endDate y OfferItems. Si no hubiera ofertas en un departamento
dado, el procedimiento ha de mostrar por consola el siguiente mensaje:
'No hay ofertas en este departamento.'. Si no existiera una tienda con ese id 
indicado como parámetro, se ha de mostrar un mensaje de error.

El procedimiento también debe actualizar las columnas DateSalesOffers y 
NumSalesOffers (DSDept) con la fecha recibida como parámetro y el total
de ofertas ofrecidas por ese departamento en esa fecha, respectivamente.

Por ejemplo, si se invoca el procedimiento con la tienda 37 y la fecha
1 de abril de 2023, el resultado debería ser el siguiente:

-----------------------------------------------------------------------
OFERTAS EL 01-04-2020 EN TIENDA 37 -- Conde de Peñalver, 44
-----------------------------------------------------------------------
Departamento:    1 -- Papelería
  No hay ofertas en este departamento.
Departamento:    2 -- Informática
  o03    Monitor 27in 4K                      15-04-2023    15 unidades
  o02    Computer i7 16Gb 1Tb HD              15-04-2023    15 unidades
Departamento:    3 -- TV y Sonido
  o04    Soundbar Speaker Megatron            15-05-2023    20 unidades

*/

create or replace PROCEDURE p_ofertas_departamento 
(tienda in VARCHAR2, fecha IN DATE)
AS
  v_id_dep2 dsdept.iddept%TYPE;


  v_direccion dsstore.address%TYPE;
  v_id_dep1 dsdept.iddept%TYPE;
  v_dep_name dsdept.DESCRIPTION%TYPE;
  v_id_offer dssaleoffer.idsale%TYPE;
  v_product dssaleoffer.product%TYPE;
  v_endDate dssaleoffer.enddate%TYPE;
  v_offerItems dssaleoffer.OfferedItems%TYPE;

  CURSOR cursor_ofertas IS
  SELECT s.address, o.iddept, d.descr,o.IdOffer,o.product, o.offereditems
  FROM dsstore s  join  dssaleoffer o on s.idstore=o.idstore  join dsdept d on d.idstore=s.idstore and d.iddept=o.iddept
  WHERE s.idstore=tienda and o.startDate<=fecha and o.endDate>=fecha
  order by o.iddept;

  cursor cursor_dept IS
  select distinct iddept from dsdept where idStore='37' order by iddept;
BEGIN
    open cursor_ofertas;
  LOOP
    open cursor_dept;
    DMBS_OUTPUT.PUT_LINE('----------------------------------------');
    DMBS_OUTPUT.PUT_LINE('OFERTAS EL ||fecha|| EN TIENDA ||tienda||');
    DMBS_OUTPUT.PUT_LINE('----------------------------------------');
    FETCH cursor_ofertas
    INTO v_direccion, v_id_dep1, v_dep_name, v_id_offer, v_product , v_endDate , v_offerItems;
    loop
    fetch cursor_dept into v_id_dep2
    if(v_id_dep1=v_id_dep2) THEN 
    DMBS_OUTPUT.PUT_LINE('DEPARTAMENTO:||||-- ||v_dep_name||');
    DMBS_OUTPUT.PUT_LINE('Departamento:    1 -- Papelería
  No hay ofertas en este departamento.
Departamento:    2 -- Informática
  o03    Monitor 27in 4K                      15-04-2023    15 unidades
  o02    Computer i7 16Gb 1Tb HD              15-04-2023    15 unidades
Departamento:    3 -- TV y Sonido
  o04    Soundbar Speaker Megatron            15-05-2023    20 unidades
');
    END IF;
  END LOOP
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
    DMBS_OUTPUT.PUT_LINE('NO SE HA ENCONTRADO OFERTAS EN LA TIENDA CON ESTA FECHA');
  IF cursor_dept%isopen 
    then close cursor_dept;
  END IF;
END;

/* 2. Escribir un disparador que se active ante cualquier cambio
en la tabla DSSale (INSERT, UPDATE, DELETE). Debe actualizar el
valor de la columna SoldItems. Debe ser capaz de trabajar correctamente
ante la modificación de cualquier columna de la tabla DSSales
incluyendo IdOffer (por ejemplo, si un sentencia UPDATE cambia el
IdOffer de una venta).

Además, si la fecha de venta (SaleDate de la tabla DDSale) es anterior
a la fecha actual, el disparador debe cambiar automáticamente el valor
de esta columna a la fecha actual.

Realizar inserciones y modificaciones en la tabla DSale para probar 
el disparador. 
*/

