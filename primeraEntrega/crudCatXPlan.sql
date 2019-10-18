create or replace PROCEDURE ACTUALIZAR_CATxPLAN(
id_CatxPlanIN Int,
id_CatalogoIN INT,
id_PlanPreIN INT,
id_PlanPosIN INT)
IS
BEGIN
  IF VALIDAR_CATxPLAN(id_CatxPlanIN)=TRUE AND VALIDAR_CATALOGO(id_CatalogoIN)=TRUE THEN
    UPDATE CatalogoxTipoPlan
    SET idPlanPostpago = id_PlanPosIN, idPlanPrepago = id_PlanPreIN, idCatalago = id_CatalogoIN
    WHERE idCatxPlan = id_CatxPlanIN;
    DBMS_OUTPUT.PUT_LINE
    ('Catalogo actualizado');
  ELSE
    DBMS_OUTPUT.PUT_LINE
    ('El catalogo por plan con id: '||id_CatxPlanIN||' no existe.');
  END IF;
  COMMIT;
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE
    ('Error al actualizar');
END;

create or replace PROCEDURE CONSULTAR_CATXPLAN
(id_catxplanIN IN INTEGER)
AS
  CURSOR c1 IS SELECT * FROM CatalogoxTipoPlan WHERE idCatxPlan = id_catxplanIN; 
BEGIN
  IF VALIDAR_CATxPLAN(id_catxplanIN)=TRUE THEN
    FOR registro in c1 LOOP
      DBMS_OUTPUT.PUT_LINE
      ('Id del plan prepago '||registro.idPlanPrepago); 
      DBMS_OUTPUT.PUT_LINE
      ('Id del plan postpago '||registro.idPlanPostpago);
      DBMS_OUTPUT.PUT_LINE
      ('Id del catalogo '||registro.idCatalago);
    END LOOP;
  ELSE
    DBMS_OUTPUT.PUT_LINE
      ('El catalogo por plan con ID: '||id_catxplanIN||' no existe.');
  END IF;
  EXCEPTION
  WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error');
END;

create or replace PROCEDURE ELIMINAR_CATXPLAN(
id_CatxPlanIN INTEGER)
AS

BEGIN
  IF VALIDAR_CATxPLAN(id_CatxPlanIN)=TRUE THEN
   DELETE FROM CatalogoxTipoPlan WHERE idCatxPlan = id_CatxPlanIN;
   DBMS_OUTPUT.PUT_LINE
    ('El catalogo con id: '||id_CatxPlanIN||' fue eliminado.');
  ELSE
    DBMS_OUTPUT.PUT_LINE
    ('El catalogo con id: '||id_CatxPlanIN||' no existe.');
  END IF;

  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE
    ('Error al eliminar');
END;

create or replace PROCEDURE CREAR_CATxPLAN
(idPlanPrepagoIN IN INTEGER, 
idPlanPostpagoIN IN INTEGER, 
idCatalogoIN IN INTEGER) 
IS
BEGIN
  IF VALIDAR_CATALOGO(idCatalogoIN)=TRUE THEN   
    IF idPlanPrepagoIN=0 AND idPlanPostpagoIN <> 0 THEN
      IF validar_plan_postpago(idPlanPostpagoIN)=TRUE THEN
          INSERT INTO CatalogoXTipoPlan (idPlanPrepago, idPlanPostpago, idCatalago, idCatxPlan)
          VALUES(0, idPlanPostpagoIN, idCatalogoIN, null);
          DBMS_OUTPUT.PUT_LINE('CatalogoxPlan creado ');
      ELSE
        DBMS_OUTPUT.PUT_LINE('No existe el plan postpago');
      END IF;
    END IF;
    IF idPlanPostpagoIN=0 AND idPlanPrepagoIN<>0 THEN
      IF VALIDAR_PLAN_PREPAGO(idPlanPostpagoIN)=TRUE THEN
          INSERT INTO CatalogoxTipoPlan (idPlanPrepago, idPlanPostpago, idCatalago, idCatxPlan)
          VALUES(idPlanPrepagoIN, 0, idCatalogoIN, NULL);
          DBMS_OUTPUT.PUT_LINE('CatalogoxPlan creado ');
        COMMIT;
      ELSE
        DBMS_OUTPUT.PUT_LINE('No existe el plan postpago');
      END IF;
    END IF;
  ELSE
    DBMS_OUTPUT.PUT_LINE('No existe catalogo');
  END IF;
  COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(' Se presento un error creando el catalogo por plan');
      DBMS_OUTPUT.put_line(SQLERRM);
END;