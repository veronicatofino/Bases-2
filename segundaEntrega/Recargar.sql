create or replace PROCEDURE RECARGAR(NumCelular IN INTEGER, Valor_Recarga IN FLOAT) AS
   
    IdContrato INTEGER;

	BEGIN
        IF VALIDAR_NUMERO_CELULAR(NumCelular)=TRUE THEN

                IF VALIDAR_ID_PLAN_PREPAGO(NumCelular)=TRUE THEN

                    IdContrato:=TRAER_ID_CONTRATO(NumCelular);


                    INSERT INTO historialRecargas VALUES(null, Valor_Recarga,IdContrato);
                    	COMMIT;
                    DBMS_OUTPUT.PUT_LINE('Se inserto la recarga'); 
                    ACTUALIZAR_SALDO(IdContrato,Valor_Recarga);

                END IF;
        END IF;	   

        EXCEPTION
    	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Se presento un error insertando la recarga');       
        rollback;        
END;

create or replace PROCEDURE ACTUALIZAR_SALDO(idContratoT INTEGER ,Valor_Recarga FLOAT) 
  IS
  	valorSaldoT FLOAT;

      BEGIN

        SELECT valorSaldo INTO valorSaldoT  FROM Contrato 
        INNER JOIN ResumenPrepago ON Contrato.idContrato= ResumenPrepago.idContrato
        WHERE ResumenPrepago.idContrato=idContratoT;

        valorSaldoT:=valorSaldoT+Valor_Recarga;

        UPDATE ResumenPrepago SET valorSaldo = valorSaldoT
    	WHERE idContrato = idContratoT;
    	COMMIT;
    	DBMS_OUTPUT.PUT_LINE('Se  actualizo el saldo');

      	EXCEPTION
    	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Se presento un error actualizando el saldo');       
        rollback;
END;
