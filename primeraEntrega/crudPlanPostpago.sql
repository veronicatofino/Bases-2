create or replace PROCEDURE ACTUALIZAR_PLAN_POSTPAGO
  (  idPlanIN IN  INTEGER       
   , numMinutosIN   IN INTEGER   
   , gigasIN     IN    INTEGER 
   , nombrePlanIN IN   varchar2  
   , precioPlanIN  IN   FLOAT 
   , tieneControlIN IN  INTEGER
   , valorminAdiIN  IN   INTEGER
   , descrPlanIN   IN  varchar2
   , mensajesIncluidosIN IN INTEGER 
   )
IS
BEGIN
  IF VALIDAR_PLAN_PREPAGO(idPlanIN)=TRUE THEN
  BEGIN
    UPDATE Postpago SET numMinutos = numMinutosIN, gigas = gigasIN, nombrePlan=nombrePlanIN
                        , precioPlan=precioPlanIN, tieneControl=tieneControlIN,valorminAdi=valorminAdiIN
                        , descrPlan=descrPlanIN,mensajesIncluidos=mensajesIncluidosIN 
    WHERE idPlan = idPlanIN ;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(' Se  actualizo el plan postpago ');
      EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error actualizando el plan postpago ');
  END;
  END IF;

END ACTUALIZAR_PLAN_POSTPAGO;

create or replace PROCEDURE CONSULTAR_PLAN_POSTPAGO(idPlanIN INTEGER) IS

  CURSOR c1 IS SELECT * FROM Postpago WHERE idPlan = idPlanIN;

BEGIN   
  IF VALIDAR_PLAN_POSTPAGO(idPlanIN) = TRUE THEN
    FOR registro in c1 LOOP
      DBMS_OUTPUT.PUT_LINE('ID plan  :'|| registro.idPlan || ', Numero de Minutos:' || registro.numMinutos ||
       ', Número de Gigas:' || registro.gigas || ', Nombre del plan postpago  :'|| registro.nombrePlan ||
        ', Precio:' || registro.precioPlan || ', Tiene Control:' || registro.tieneControl ||
        ', Valor del minuto adicional:' || registro.valorminAdi|| ', Descripción del Plan:' || registro.descrPlan || 
        ', Número de mensajes Incluidos:' || registro.mensajesIncluidos);
    End LOOP;

  ELSE
    DBMS_OUTPUT.PUT_LINE('El plan postpago con codigo: ' || idPlanIN || ' no existe en el base de datos');

  END IF;  
        EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Se presento un error consultando el plan postpago '||SQLERRM);
        rollback;

END CONSULTAR_PLAN_POSTPAGO;

create or replace PROCEDURE DELETE_PLAN_POSTPAGO (idPlanIN IN INTEGER)
IS
BEGIN
  IF VALIDAR_PLAN_POSTPAGO(idPlanIn) = TRUE THEN
      DELETE FROM Postpago WHERE idPlan=idPlanIN;
      DBMS_OUTPUT.PUT_LINE('El plan Postpago fue borrado : '|| idPlanIN );
  ELSE
      DBMS_OUTPUT.PUT_LINE('El plan Postpago número '|| idPlanIN ||' no existe en la base de datos:' );
  END IF;
  COMMIT;

      EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Se presento un error borrando el plan postpago'||SQLERRM);
      rollback;

END DELETE_PLAN_POSTPAGO;

create or replace PROCEDURE REGISTRAR_PLAN_POSTPAGO
  (  idPlanIN IN  INTEGER       
   , numMinutosIN   IN INTEGER   
   , gigasIN     IN    INTEGER 
   , nombrePlanIN IN   varchar2  
   , precioPlanIN  IN   FLOAT 
   , tieneControlIN IN  INTEGER
   , valorminAdiIN  IN   INTEGER
   , descrPlanIN   IN  varchar2
   , mensajesIncluidosIN IN INTEGER 
   )
IS
BEGIN
  IF VALIDAR_PLAN_POSTPAGO(idPlanIN)=FALSE THEN
  BEGIN
      INSERT INTO Postpago (idPlan,numMinutos,gigas
          ,nombrePlan,precioPlan,tieneControl
          ,valorminAdi,descrPlan,mensajesIncluidos
          )
      VALUES(idPlanIN,numMinutosIN,gigasIN
          ,nombrePlanIN,precioPlanIN,tieneControlIN
          , valorminAdiIN,descrPlanIN,mensajesIncluidosIN
          );
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Plan postpago insertado : '|| idPlanIN || ' ' || nombrePlanIN );

      EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error insertando el plan postpago ');
    END;
  ELSE
  BEGIN
    UPDATE Postpago SET numMinutos = numMinutosIN, gigas = gigasIN, nombrePlan=nombrePlanIN
                        , precioPlan=precioPlanIN, tieneControl=tieneControlIN,valorminAdi=valorminAdiIN
                        , descrPlan=descrPlanIN,mensajesIncluidos=mensajesIncluidosIN 
    WHERE idPlan = idPlanIN ;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(' Se  actualizo el plan postpago ');
      EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error actualizando el plan postpago ');
  END;
  END IF;
END REGISTRAR_PLAN_POSTPAGO;