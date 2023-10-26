--EJERCICIO 3 CONSULTAS
--PRESTAMOS MENORES A 10 DIAS
SELECT *
FROM prestamo
WHERE dias_p<10;

--Obtener la fecha de vencimiento de todos los préstamos. Columnas a mostrar en la consulta:
select ID_M, ISBN, FECHA_P+10
FROM prestamo;

--Obtener todos los préstamos que vencen antes del 27 de noviembre de 2023. Columnas a mostrar en la consulta: miembroID, ISBD, fecha_vencimiento.
alter session set nls_date_format = 'DD-MM-YYYY';
select ID_M, ISBN, FECHA_P
FROM prestamo
WHERE FECHA_P+DIAS_P<(TO_DATE('27-11-2023'));

--Obtener todos los préstamos devueltos que sean posteriores a la fecha de vencimiento. Columnas
--a mostrar en la consulta: miembroID, ISBN, fecha_prestamo, dias, fecha_devolucion, fecha_vencimiento.
SELECT ID_M, ISBN, FECHA_P, DIAS_P, FECHA_D, FECHA_P+DIAS_P AS FECHA_VENCIMIENTO
FROM PRESTAMO
WHERE FECHA_P+DIAS_P<FECHA_D;

--Obtener los préstamos que ya han expirado y que todavía no se han devuelto. Hacer uso de la
--función SYSDATE de Oracle para obtener la fecha actual del sistema. Columnas a mostrar en la
--consulta: miembroID, ISBN, fecha_prestamo, fecha_vencimiento
SELECT ID_M, ISBN, FECHA_P, DIAS_P, FECHA_P+DIAS_P AS FECHA_VENCIMIENTO
FROM PRESTAMO
WHERE FECHA_D;

SELECT *
FROM prestamo
;