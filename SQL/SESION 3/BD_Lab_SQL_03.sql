-- -------------------------------------------------------------------------

-- Sesión 3 de laboratorio.
--ALUMNOS: ALEX GUILLERMO BONILLA TACO
--         Pablo Rodr�guez Arenas
--         grupo 16
-- Ejecutar el script y resolver las consultas propuestas

-- -------------------------------------------------------------------------

SET LINESIZE 500;
SET PAGESIZE 500;
alter session set nls_date_format = 'DD/MM/YYYY';

drop table ARTICULO cascade constraints;
drop table PERIODISTA cascade constraints;
drop table PERIODICO cascade constraints;

create table PERIODICO(
    idPeriodico integer primary key,
    nombre varchar2(50),
    url varchar2(200),
    idioma varchar2(3)
    -- El idioma puede ser 'en' (para Inglés), 'es' (para Español), etc.
);

create table PERIODISTA(
    idPeriodista integer primary key,
    nombre varchar2(30)
);

create table ARTICULO(
    idArticulo integer primary key,
    titular varchar2(100),
    url varchar2(200),
    idPeriodico references PERIODICO,
    idPeriodista references PERIODISTA,
    fechaPublicacion date,
    numVisitas integer
);


INSERT INTO PERIODICO VALUES (1, 'El Noticiero', 'http://www.newstoday.com','es');
INSERT INTO PERIODICO VALUES (2, 'El Diario de Zaragoza', 'http://www.diariozaragoza.es','es');
INSERT INTO PERIODICO VALUES (3, 'The Gazette', 'http://www.gacetaguadalajara.es','en');
INSERT INTO PERIODICO VALUES (4, 'Toledo Tribune', 'http://www.toledotribune.es','en');
INSERT INTO PERIODICO VALUES (5, 'Alvarado Times', 'http://www.alvaradotimes.es','en');
INSERT INTO PERIODICO VALUES (6, 'El Retiro Noticias', 'http://www.elretironoticias.es','es');

insert into PERIODISTA values (201,'Margarita Sanchez');
insert into PERIODISTA values (203,'Pedro Santillana');
insert into PERIODISTA values (204,'Rosa Prieto');
insert into PERIODISTA values (206,'Lola Arribas');
insert into PERIODISTA values (207,'Antonio Lopez');

INSERT INTO ARTICULO VALUES (101, 'El Banco de Inglaterra advierte de los peligros del Brexit',
			   'http://www.elnoticiero.es/ibex9000',
			   1,204, TO_DATE('01/06/2018'), 370);
INSERT INTO ARTICULO VALUES (102, 'La UE acabará con el 100% de las emisiones de CO2 para 2050',
			   'http://www.elnoticiero.es/ibex9000',
			   1,204, TO_DATE('01/06/2018'), 1940);
INSERT INTO ARTICULO VALUES (103, 'Madrid Central starts tomorrow',
			   'http://www.gacetaguadalajara.es/nacional24',
			   3,201, TO_DATE('01/06/2018'), 490);
INSERT INTO ARTICULO VALUES (104, 'El Ayuntamiento prepara diez nuevos carriles bici',
			   'http://www.diariozaragoza.es/movilidad33',
			   2,203, TO_DATE('01/06/2018'), 2300);
INSERT INTO ARTICULO VALUES (105, 'Un aragonés cruzará Siberia, de punta a punta en bici',
			   'http://www.diariozaragoza.es/ibex9000',
			   2,203, TO_DATE('01/11/2018'), 2300);
INSERT INTO ARTICULO VALUES (106, 'Hecatombe financiera ante un Brexit duro',
			   'http://www.diariozaragoza.es/ibex9000',
			   2,204, TO_DATE('01/11/2018'), 2220);

INSERT INTO ARTICULO VALUES (107, 'Fomento anuncia una estrategia nacional para fomentar la intermodalidad y el uso de la bicicleta',
			   'http://www.elnoticiero.es/ibex9001',
			   1,206, TO_DATE('22/06/2018'), 390);
INSERT INTO ARTICULO VALUES (108, 'Así será el carril bici que pasará por la puerta del Clínico',
			   'http://www.diariozaragoza.es/nacional22062018',
			   2,206, TO_DATE('13/11/2018'), 230);
INSERT INTO ARTICULO VALUES (109, 'How will traffic constraints affect you? The Gazette answers your questions',
			   'http://www.gacetaguadalajara.es/deportes33',
			   3,204, TO_DATE('22/11/2018'), 123);
INSERT INTO ARTICULO VALUES (110, 'How will traffic constraints affect you? Toledo Tribune answers your questions',
			   'http://www.toledotribune.es/deportes33',
			   4,204, TO_DATE('22/11/2018'), 880);
INSERT INTO ARTICULO VALUES (111, 'Financial havoc if there is a hard Brexit',
			   'http://www.toledotribune.es/deportes44',
			   4,201, TO_DATE('22/11/2018'), 110);
INSERT INTO ARTICULO VALUES (112, 'Financial havoc if there is a hard Brexit',
			   'http://www.alvaradotimes.es/deportes44',
			   5,204, TO_DATE('22/10/2018'), 130);
INSERT INTO ARTICULO VALUES (113, 'How President Trump took ''fake news'' into the mainstream',
			   'http://www.alvaradotimes.es/politics',
			   5,201, TO_DATE('22/10/2019'), 820);
INSERT INTO ARTICULO VALUES (114, 'How President Trump took ''fake news'' into the mainstream',
			   'http://www.alvaradotimes.es/politics',
			   4,204, TO_DATE('25/08/2019'), 1425);

COMMIT;

-- -------------------------------------------------------------------------
-- Consultas SQL
-- -------------------------------------------------------------------------
/* 1. Mostrar la lista de periodistas que han publicado artículos y el idioma
en el que los han escrito. Mostrar también en esta misma consulta la siguiente
información: número de periódicos en los cuales cada periodista ha publicado
artículos en un determinado idioma, el total de visitas a los artículos publicados
en cada idioma, y el número máximo de visitas recibidos por un artículo escrito
por cada periodista en cada idioma.
Columnas a mostrar: id del periodista, nombre del periodista, idioma, número
de periódicos, suma de las visitas y máximo de visitas.*/
select p.idperiodista, p.nombre,pe.idioma, count(idioma)as numPeriodicos,sum(a.numvisitas)as totalVisitas, max(a.numvisitas) as maxVisitas
from periodista p join articulo a on p.idperiodista = a.idperiodista join periodico pe on pe.idperiodico=a.idperiodico
group by p.idperiodista,p.nombre,pe.idioma
;



/* 2. Mostrar la lista de periódicos que en 2018 recibieron más visitas 
que 'The Gazette'.
Columnas a mostar: nombre del periódico y número de visitas.  
*/
select distinct pe.nombre, sum(a.numvisitas)as totalvisitas
from periodico pe join articulo a on pe.idperiodico =a.idperiodico
where (extract (year from a.fechapublicacion)=2018)
group by pe.nombre
having  sum( a.numvisitas) > 
    (SELECT sum (a.numvisitas)
    FROM articulo a join periodico pe on a.idperiodico=pe.idperiodico
    where  pe.nombre='The Gazette' and extract (year from a.fechapublicacion)=2018);


/* 3. Mostrar la lista de todos los periodistas, y el nombre de los
periódicos en los que cada periodista ha escrito artículos. Si un
periodista no ha escrito artículos en ningún periódico, se debe
mostrar el texto 'ninguno' en vez de el nombre del periódico.
Columnas a mostrar: id del periodista, nombre del periodista y 
nombre del periódico.
*/
select distinct a.idperiodista, p.nombre,pe.nombre
from periodista p join articulo a on p.idperiodista=a.idperiodista join periodico pe on pe.idperiodico=a.idperiodico
union 
select distinct a.idperiodista, p.nombre, nvl(pe.nombre,'ninguno')
from periodista p left join articulo a  on p.idperiodista=a.idperiodista left join periodico pe on pe.idperiodico=a.idperiodico
where a.idperiodista is null ;


/* 4. Mostrar la lista de todos los periodistas, el número de artículos
escritos por cada periodista, y el número de periódicos en los que
dichos artículos han sido publicados.
Si un periodista no ha escrito artículos en ningún periódico, aparecerá
un 0 en las columnas correspondientes.
Columnas a mostrar: id del periodista, nombre del periodista, número de artículos
y número de periódicos.
*/
select a.idperiodista, p.nombre, sum(a.idperiodista)as sumarticulos, sum(a.idperiodico) as sumPeriodicos
from periodista p join articulo a on p.idperiodista=a.idperiodista join periodico pe on pe.idperiodico=a.idperiodico
group by a.idperiodista, p.nombre
union 
select p.idperiodista, p.nombre,nvl(a.idperiodista,'0') as sumarticulos, nvl(a.idperiodico,'0')as sumPeriodicos
from periodista p left join articulo a on p.idperiodista=a.idperiodista left join periodico pe on pe.idperiodico=a.idperiodico
where a.idperiodista is null
;


/* 5. Mostrar los titulares de los artículos escritos por 
periodistas que en 2019 no escribieron ningún artículo en inglés.
Columnas a mostrar: id del artículo, titular de artículo y nombre del periodista.
*/
select a.idarticulo,a.titular,p.nombre
from periodista p join articulo a on p.idperiodista = a.idperiodista join periodico pe on pe.idperiodico=a.idperiodico
where (extract (year from a.fechapublicacion)=2019) and p.idperiodista not in(
        select p.idperiodista
        from periodista p join articulo a on p.idperiodista = a.idperiodista join periodico pe on pe.idperiodico=a.idperiodico
        where (extract (year from a.fechapublicacion)=2019) and pe.idioma='en');


/* 6. Mostrar los titulares de los artículos escritos por periodistas que solamente
publicaron en 2018 para revistas en inglés.
Columnas a mostrar: id del artículo, titular del artículo y nombre del periodista.
*/
select a.idarticulo,a.titular,p.nombre
from periodista p join articulo a on p.idperiodista = a.idperiodista join periodico pe on pe.idperiodico=a.idperiodico
where (extract (year from a.fechapublicacion)=2018) and pe.idioma='en' and p.idperiodista not in(
        select p.idperiodista
        from periodista p join articulo a on p.idperiodista = a.idperiodista join periodico pe on pe.idperiodico=a.idperiodico
        where (extract (year from a.fechapublicacion)=2018) and pe.idioma<>'en');


/* 7. Mostrar los artículos más visitados de cada periódico.
Columnas a mostrar: id del periódico, titular del artículo y número de visitas.
*/
select a.idperiodico,a.titular,a.numvisitas
from articulo a join (SELECT a.idperiodico, max(a.numvisitas) as numvisitas
FROM articulo a 
group by a.idperiodico) c on a.idperiodico =c.idperiodico and a.numvisitas=c.numvisitas
;

SELECT a.idperiodico, max(a.numvisitas) as numvisitas
FROM articulo a 
group by a.idperiodico
;


/* 8. Mostrar los periodistas que han escrito todos sus artículos en 
periódicos con idioma inglés.
Columnas a mostrar: id del periodista, nombre del periodista.
*/
select p.idperiodista, p.nombre
from periodista p
where (select count (a.idarticulo)
        from articulo a join periodico pe on a.idperiodico=pe.idperiodico
        where pe.idioma='en' and a.idperiodista=p.idperiodista)>0;






