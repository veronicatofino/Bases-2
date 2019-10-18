create or replace PROCEDURE LLAMAR(
	numeroAbonadoIN IN integer
	,numeroDestinoIN IN integer
	,duracionLlamadaIN IN integer
    ,ciudadDestinoIN IN varchar2
    ,ciudadAbonadoIN IN varchar2
    ,operadorDestinoIN IN varchar2
	)

	IS
	idPlanPost INTEGER;
    idPlanPrep INTEGER;
    idContrato INTEGER;
	BEGIN
    IF VALIDAR_NUMEROABONADO(numeroAbonadoIN)=TRUE THEN
        SELECT catalogoxtipoplan.idplanprepago, catalogoxtipoplan.idplanpostpago, contrato.idcontrato INTO idPlanPrep, idPlanPost,idContrato FROM Contrato 
        INNER JOIN CatalogoxTipoPlan ON catalogoxtipoplan.idcatxplan=contrato.idcatxplan AND contrato.numerounicoa=numeroAbonadoIN;
        DBMS_OUTPUT.PUT_LINE(idPlanPrep ||'gh' ||idPlanPost);
        IF idPlanPost<>0 AND idPlanPrep=0 THEN
            LLAMADA_POSTPAGO(numeroAbonadoIN,numeroDestinoIN,duracionLlamadaIN,idContrato,ciudadDestinoIN,ciudadAbonadoIN,operadorDestinoIN);
            COMMIT;
        ELSIF idPlanPost=0 AND idPlanPrep<>0 THEN
            LLAMADA_PREPAGO(numeroAbonadoIN,numeroDestinoIN,duracionLlamadaIN,idContrato,ciudadDestinoIN,ciudadAbonadoIN,operadorDestinoIN);
            COMMIT;
        ELSE
            DBMS_OUTPUT.PUT_LINE('No se ha encontrado su plan en el sistema');
        END IF;
     ELSE
        DBMS_OUTPUT.PUT_LINE('El numero no existe en el sistema');
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE(' Se presento un error realizando la llamada ');
    rollback;
END;

create or replace PROCEDURE LLAMADA_POSTPAGO(
	numeroAbonadoIN IN integer
	,numeroDestinoIN IN integer
	,duracionLlamadaIN IN integer
    ,idContratoIN IN integer
    ,ciudadDestinoIN IN VARCHAR2
    ,ciudadAbonadoIN IN VARCHAR2
    ,operadorDestinoIN IN VARCHAR2
	)
    IS
     minDisponibles INTEGER;
     BEGIN
         DBMS_OUTPUT.PUT_LINE('Es postpago');
        IF CUENTA_TIENE_CONTROL(numeroAbonadoIN)=True THEN

            DBMS_OUTPUT.PUT_LINE('Tiene control');
            SELECT ResumenPostpago.minutosDisponibles INTO minDisponibles FROM ResumenPostpago INNER JOIN Contrato 
            ON ResumenPostpago.idContrato=Contrato.idContrato AND Contrato.idContrato=idContratoIN;

            DBMS_OUTPUT.PUT_LINE(minDisponibles);
            IF minDisponibles >= duracionLlamadaIN THEN
                ACTUALIZAR_POSTPAGO(idContratoIN,duracionLlamadaIN,numeroAbonadoIN,numeroDestinoIN,ciudadDestinoIN,ciudadAbonadoIN,operadorDestinoIN);
                COMMIT;
            ELSE
                DBMS_OUTPUT.PUT_LINE('No cuenta con suficientes minutos para realizar la llamada');
            END IF;   
        ELSE 
            ACTUALIZAR_POSTPAGO(idContratoIN,duracionLlamadaIN,numeroAbonadoIN,numeroDestinoIN,ciudadDestinoIN,ciudadAbonadoIN,operadorDestinoIN);
            COMMIT;
        END IF;
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(' Se presento un error consultando el saldo ');
        rollback;
END;

create or replace PROCEDURE LLAMADA_PREPAGO(
	numeroAbonadoIN IN integer
	,numeroDestinoIN IN integer
	,duracionLlamadaIN IN integer
    ,idContratoIN IN integer
    ,ciudadDestinoIN IN VARCHAR2
    ,ciudadAbonadoIN IN VARCHAR2
    ,operadorDestinoIN IN VARCHAR2
	)
    IS
     saldoDisponible INTEGER;
     precMinuto FLOAT; 
     saldoUsado FLOAT;
     BEGIN
         DBMS_OUTPUT.PUT_LINE('Es prep');
        SELECT ResumenPrepago.valorSaldo, Prepago.precioMinuto INTO saldoDisponible,precMinuto FROM ResumenPrepago 
        INNER JOIN Contrato ON ResumenPrepago.idContrato=Contrato.idContrato AND Contrato.idContrato=idContratoIN 
        INNER JOIN CatalogoxTipoPlan ON contrato.idcatxplan=catalogoxtipoplan.idcatxplan 
        INNER JOIN Prepago ON catalogoxtipoplan.idplanprepago=prepago.idplan;
        saldoUsado := duracionLlamadaIN*precMinuto;
        IF saldoDisponible >= saldoUsado THEN
                ACTUALIZAR_PREPAGO(idContratoIN,saldoUsado,numeroAbonadoIN,numeroDestinoIN,duracionLlamadaIN,ciudadDestinoIN,ciudadAbonadoIN,operadorDestinoIN);
                COMMIT;
        ELSE
           DBMS_OUTPUT.PUT_LINE('No cuenta con suficiente saldo para realizar la llamada');
        END IF;
              EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(' Se presento un error consultando el saldo ');
        rollback;
END;

create or replace PROCEDURE ACTUALIZAR_POSTPAGO(
    idContratoIN IN integer
    ,duracionLlamadaIN IN integer
    ,numeroAbonadoIN IN integer
	,numeroDestinoIN IN integer
    ,ciudadDestinoIN IN VARCHAR2
    ,ciudadAbonadoIN IN VARCHAR2
    ,operadorDestinoIN IN VARCHAR2
    )
    IS
     minDisponibles INTEGER;  
     nuevosMinutos INTEGER;
    BEGIN
     IF CUENTA_TIENE_CONTROL(numeroAbonadoIN)=True THEN
        SELECT minutosDisponibles INTO minDisponibles FROM resumenpostpago WHERE idContrato=idContratoIN;
        nuevosMinutos := minDisponibles - duracionLlamadaIN;
        UPDATE ResumenPostpago SET minutosDisponibles=nuevosMinutos WHERE idContrato = idContratoIN;
        AGREGAR_REGISTROLLAMADA(numeroAbonadoIN,numeroDestinoIN,duracionLlamadaIN,idContratoIN,0,ciudadDestinoIN,ciudadAbonadoIN,operadorDestinoIN);
        COMMIT;
     ELSE
        SELECT minutosDisponibles INTO minDisponibles FROM resumenpostpago WHERE idContrato=idContratoIN;
        nuevosMinutos := minDisponibles - duracionLlamadaIN;
        IF nuevosMinutos >=0 THEN
            UPDATE ResumenPostpago SET minutosDisponibles=nuevosMinutos WHERE idContrato = idContratoIN;
            AGREGAR_REGISTROLLAMADA(numeroAbonadoIN,numeroDestinoIN,duracionLlamadaIN,idContratoIN,0,ciudadDestinoIN,ciudadAbonadoIN,operadorDestinoIN);
            COMMIT;           
        ELSE
            UPDATE ResumenPostpago SET minutosDisponibles=0, minutosAdicionales=ABS(nuevosMinutos)+minutosAdicionales WHERE idContrato = idContratoIN;
            AGREGAR_REGISTROLLAMADA(numeroAbonadoIN,numeroDestinoIN,duracionLlamadaIN,idContratoIN,1,ciudadDestinoIN,ciudadAbonadoIN,operadorDestinoIN); 
            DBMS_OUTPUT.PUT_LINE('Ya esta consumiendo minutos adicionales');
            COMMIT; 
        END IF;
     END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(' Se presento un error actualizando el saldo ');
        rollback;
END;

create or replace PROCEDURE ACTUALIZAR_PREPAGO(
    idContratoIN IN integer
    ,saldoUsadoIN IN float
    ,numeroAbonadoIN IN integer
    ,numeroDestinoIN IN integer
    ,duracionLlamadaIN IN integer
    ,ciudadDestinoIN IN VARCHAR2
    ,ciudadAbonadoIN IN VARCHAR2
    ,operadorDestinoIN IN VARCHAR2
    )
    IS
     saldoDisponible FLOAT;
     nuevoSaldo FLOAT;
     BEGIN
     SELECT valorSaldo INTO saldoDisponible FROM ResumenPrepago WHERE idContrato=idContratoIN;
     nuevoSaldo := saldoDisponible - saldoUsadoIN;
     UPDATE ResumenPrepago SET valorSaldo= nuevoSaldo WHERE idContrato=idContratoIN;
     AGREGAR_REGISTROLLAMADA(numeroAbonadoIN,numeroDestinoIN,duracionLlamadaIN,idContratoIN,0,ciudadDestinoIN,ciudadAbonadoIN,operadorDestinoIN);
     COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(' Se presento un error actualizando el saldo ');
        rollback;
END;

create or replace PROCEDURE AGREGAR_REGISTROLLAMADA(
    numeroAbonadoIN IN integer
    ,numeroDestinoIN IN integer
    ,duracionLlamadaIN IN integer
    ,idContratoIN IN integer
    ,boolMinAdIN IN integer
    ,ciudadDestinoIN IN VARCHAR2
    ,ciudadAbonadoIN IN VARCHAR2
    ,operadorDestinoIN IN VARCHAR2
    )
    IS
    BEGIN
    INSERT INTO RegistroLlamadas (idRegistro, numeroAbonado, duracionDLlamada, fechaLlamada, ciudadAbonado,
			ciudadDestino,operadorDestino,idContrato,tieneMinAdic)
            VALUES(NULL,numeroAbonadoIN, duracionLlamadaIN, SYSDATE, ciudadAbonadoIN,
			ciudadDestinoIN,operadorDestinoIN,idContratoIN,boolMinAdIN);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Llamada realizada desde : '|| numeroabonadoin || ' a ' || numerodestinoin );
    EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(' Se presento un error agregando la llamada ');
    rollback;
END;