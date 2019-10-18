create or replace PROCEDURE CREAR_CONTRATO(
fechaContratoIN IN DATE,
fechaCorteIN IN DATE,
idSucursalIN IN INTEGER,
nDocumentoIN IN INTEGER,
idCatxPlanIN IN INTEGER)
IS
    idContratoF INTEGER;
BEGIN
  IF VALIDAR_SUCURSAL(idSucursalIN)=TRUE 
  AND VALIDAR_CLIENTE(nDocumentoIN)=TRUE 
  AND VALIDAR_CATxPLAN(idCatxPlanIN)=TRUE
  THEN
  BEGIN
      idContratoF := secuencia_contrato.nextval;
      INSERT INTO Contrato (idContrato, fechaContrato, fechaDcorte, numeroUnicoA, idSucursal, numeroDdocumento, idCatxPlan)
      VALUES(idContratoF, fechaContratoIN, fechaCorteIN,NULL, idSucursalIN, nDocumentoIN, idCatxPlanIN);
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Contrato creado');
      CREAR_RESUMEN(idContratoF,fechaCorteIN);
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error creando el contrato');
    END;
  ELSE
    DBMS_OUTPUT.PUT_LINE('La informacion suministrada no existe en el sistema');
  END IF;

END;