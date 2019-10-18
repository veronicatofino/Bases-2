create or replace PROCEDURE ACTUALIZAR_PLAN_PREPAGO
  (  idPlanIN IN  INTEGER       
   , nombrePlanIN IN   varchar2      
   , precioMinutoIN  IN   FLOAT 
   )
IS
BEGIN
  IF VALIDAR_PLAN_PREPAGO(idPlanIN)=TRUE THEN
  BEGIN
    UPDATE Prepago SET  nombrePlan=nombrePlanIN,precioMinuto=precioMinutoIN 
    WHERE idPlan = idPlanIN ;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(' Se  actualizo el plan prepago ');
      EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error actualizando el plan prepago ');
  END;
  END IF;
END ACTUALIZAR_PLAN_PREPAGO;

create or replace PROCEDURE CONSULTAR_PLAN_PREPAGO(idPlanIN INTEGER) IS

  CURSOR c1 IS SELECT * FROM Prepago WHERE idPlan = idPlanIN;

BEGIN   
  IF VALIDAR_PLAN_PREPAGO(idPlanIN) = TRUE THEN
    FOR registro in c1 LOOP
      DBMS_OUTPUT.PUT_LINE('ID plan  :'|| registro.idPlan || ', Nombre del plan prepago  :'|| registro.nombrePlan ||
       ', Precio:' || registro.precioMinuto);

    End LOOP;

  ELSE
    DBMS_OUTPUT.PUT_LINE('El plan prepago con codigo: ' || idPlanIN || ' no existe en el base de datos');

  END IF;  
        EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Se presento un error consultando el plan prepago '||SQLERRM);
        rollback;

END CONSULTAR_PLAN_PREPAGO;

create or replace PROCEDURE DELETE_PLAN_PREPAGO (idPlanIN IN INTEGER)
IS
BEGIN
  IF VALIDAR_PLAN_PREPAGO(idPlanIn) = TRUE THEN
      DELETE FROM Prepago WHERE idPlan=idPlanIN;
      DBMS_OUTPUT.PUT_LINE('El plan Prepago fue borrado : '|| idPlanIN );
  ELSE
      DBMS_OUTPUT.PUT_LINE('El plan Prepago número '|| idPlanIN ||' no existe en la base de datos:' );
  END IF;
  COMMIT;

      EXCEPTION 
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Se presento un error borrando el plan Prepago'||SQLERRM);
      rollback;

END DELETE_PLAN_PREPAGO;

create or replace PROCEDURE REGISTRAR_PLAN_PREPAGO
  (  idPlanIN IN  INTEGER       
   , nombrePlanIN IN   varchar2      
   , precioMinutoIN  IN   FLOAT 
   )
IS
BEGIN
  IF VALIDAR_PLAN_PREPAGO(idPlanIN)=FALSE THEN
  BEGIN
      INSERT INTO Prepago (idPlan,nombrePlan,precioMinuto)
      VALUES(idPlanIN,nombrePlanIN,precioMinutoIN);
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Plan prepago insertado : '|| idPlanIN || ' ' || nombrePlanIN );

      EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error insertando el plan prepago ');
    END;
  ELSE
  BEGIN
    UPDATE Prepago SET  nombrePlan=nombrePlanIN,precioMinuto=precioMinutoIN 
    WHERE idPlan = idPlanIN ;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(' Se  actualizo el plan prepago ');
      EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error actualizando el plan prepago ');
  END;
  END IF;
END REGISTRAR_PLAN_PREPAGO;