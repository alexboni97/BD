CREATE OR REPLACE PROCEDURE PR_ACTUALIZA_CONTRATO
       (v_referencai in varchar2) 
      aS
      v_num_trayectos Contrato.num_trayectos%type;
      e_sin_trayectos Exception;
      BEGIN
          select count (*) into v_num_trayectos from trayectos
          where referencia=v_referencia;
          
          if v_num_trayectos=0 then raise e_sin_trayectos;
          else update contrato set num_trayectos=v_numtrayectos
          where referencia=v_referencia;
          DMBS_OUTPUT.PUT_LINE('SE HA ACTUALIZZADO CORRECTAMENTE');
          end if;
        
        EXCEPTION 
            WHEN e_sin_trayectos then 
            DMBS_OUTPUT.PUT_LINE('WXC: NO HAY TRAYECTOS PARA LA REFERENCIA DEL CONTRATO');
            WHEN OTHERS THEN 
            DMBS_OUTPUT.PUT_LINE('EXC: ERROR INESPERADO');
      END;
      