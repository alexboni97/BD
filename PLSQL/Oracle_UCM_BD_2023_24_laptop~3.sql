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
  DBMS_output.put_line('Informacion del vuelo:'||p_num_vuelo||'-'||p_depairport||'-'||p_destairport||' ('||p_distance||' km)');
  END IF;
END LOOP;
IF cursor_vuelos%ISOPEN 
   THEN  CLOSE cursor_vuelos; 
END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
   DBMS_output.put_line('°No se ha encontrado el n√∫mero de vuelo: '||vuelo||'!');
   IF cursor_vuelos%ISOPEN 
     THEN  CLOSE cursor_vuelos; 
   END IF;
END;