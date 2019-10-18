create or replace PROCEDURE CREAR_RESUMEN
(idCIN IN Contrato.idContrato%TYPE
,fechaCIN IN contrato.fechadcorte%TYPE)
    IS
    idPrepago INT;
    idPostpago INT;
    BEGIN
        SELECT  idPlanPrepago, idPlanPostpago INTO idPrepago, idPostpago 
        FROM CATALOGOXTIPOPLAN INNER JOIN Contrato ON catalogoxtipoplan.idcatxplan= contrato.idcatxplan AND Contrato.idContrato=idCIN;
        IF idPrepago <> 0 AND idPostpago = 0 THEN
            CREAR_RESUMEN_PREPAGO(idCIN);
        ELSIF idPrepago = 0 AND idPostpago <> 0 THEN
            CREAR_RESUMEN_POSTPAGO(idPostpago,idCIN,fechaCIN);
        ELSE 
            DBMS_OUTPUT.PUT_LINE('Hubo un problema constulado su plan');
        END IF;
END;