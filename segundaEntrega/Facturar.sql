create or replace PROCEDURE Facturar
(celIN IN Contrato.numeroUnicoA%TYPE, impuestosIN IN Factura.impuestos%TYPE)  
IS
	minDisponibles ResumenPostpago.minutosDisponibles%TYPE;
	menDisponibles ResumenPostpago.mensajesDisponibles%TYPE;
	gDisponibles ResumenPostpago.gigasDisponibles%TYPE;
	minAdicionales ResumenPostpago.minutosAdicionales%TYPE;
	minutosTotales Postpago.numMinutos%TYPE;
	gigasTotales Postpago.gigas%TYPE;
	mensajesTotales Postpago.mensajesIncluidos%TYPE;
	minutosConsumidos Postpago.numMinutos%TYPE;
	mensajesConsumidos Postpago.mensajesIncluidos%TYPE;
	gigasConsumidos Postpago.gigas%TYPE;
	precio Postpago.precioPlan%TYPE;
	precioTotal Postpago.precioPlan%TYPE;
	precioMinAd Postpago.precioPlan%TYPE;
	idPp INTEGER;
	idCont INTEGER;
  idFact INTEGER;
BEGIN
	idCont := VALIDAR_CELULAR(celIN);
    DBMS_OUTPUT.PUT_LINE(idCont);
	IF idCont <> 0 THEN
		SELECT CatalogoxTipoPlan.idPlanPostpago INTO idPp FROM Contrato INNER JOIN 
		CatalogoxTipoPlan ON CatalogoxTipoPlan.idCatxPlan = Contrato.idCatxPlan AND Contrato.numeroUnicoA = celIN;
    DBMS_OUTPUT.PUT_LINE(idPp);
		IF idPp <> 0 THEN
			SELECT Postpago.numMinutos, Postpago.precioPlan, Postpago.valorMinAdi, 
			Postpago.mensajesIncluidos, Postpago.gigas
      INTO minutosTotales, precio, precioMinAd, mensajesTotales, gigasTotales
			FROM Postpago WHERE idPlan = idPp;    

			SELECT ResumenPostpago.minutosDisponibles, ResumenPostpago.minutosAdicionales, 
			ResumenPostpago.mensajesDisponibles, ResumenPostpago.gigasDisponibles
			INTO minDisponibles, minAdicionales, menDisponibles, gDisponibles
			FROM CONTRATO 
			INNER JOIN ResumenPostpago ON Contrato.idContrato = ResumenPostpago.idContrato
			WHERE numeroUnicoA = celIN;

			minutosConsumidos := minutosTotales - minDisponibles;
			mensajesConsumidos := mensajesTotales - menDisponibles;
			gigasConsumidos := gigasTotales - gDisponibles;
			precioTotal := precio;

			IF minDisponibles = 0 AND minAdicionales <> 0 THEN
				minutosConsumidos := minutosConsumidos + minAdicionales;
				precioTotal := precioTotal + (minAdicionales*precioMinAd);
			END IF; 

			precioTotal := precioTotal + (precioTotal*impuestosIN);

			LOCK TABLE Factura IN EXCLUSIVE MODE;
			BEGIN
        idFact := secuencia_factura.nextval;
				INSERT INTO Factura (IdFactura, fechaDfacturacion, impuestos, valorTotal, idContrato) 
				VALUES (idFact, SYSDATE, impuestosIN, precioTotal, idCont);
					DBMS_OUTPUT.PUT_LINE('---Factura dl numero: '||celIN);
					DBMS_OUTPUT.PUT_LINE('Minutos consumidos: '||minutosConsumidos);
					DBMS_OUTPUT.PUT_LINE('Mensajes consumidos: '||mensajesConsumidos);
					DBMS_OUTPUT.PUT_LINE('Gigas consumidos: '||gigasConsumidos);
          CREAR_DETALLE_FACTURA(idFact,idCont,SYSDATE);
          REGISTRAR_XML_FACTURA(idFact); --De la tercera entrega.
          EXCEPTION
          WHEN OTHERS THEN
              DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error al facturar');                 
            END;
		ELSE
			 DBMS_OUTPUT.PUT_LINE('El plan no es postpago');

		END IF;

	END IF;
END;

create or replace PROCEDURE CREAR_DETALLE_FACTURA
(idFactIN IN INTEGER, idContIN IN INTEGER, fechaFactIN IN DATE)
IS
  CURSOR c1 IS SELECT idRegistro,  Duraciondllamada, Fechallamada FROM RegistroLlamadas 
	INNER JOIN Contrato ON Contrato.idContrato=RegistroLlamadas.idContrato WHERE contrato.idContrato = idContIN AND EXTRACT (MONTH FROM RegistroLlamadas.fechaLlamada) = EXTRACT (MONTH FROM fechaFactIN);
BEGIN
  for r in c1 LOOP
    INSERT INTO DetalleFactura(iddetalle,idFactura,idRegistroLlam) VALUES(NULL,idFactIN,r.idRegistro);
     DBMS_OUTPUT.PUT_LINE('Fecha Llamada '||r.fechaLlamada);
     DBMS_OUTPUT.PUT_LINE('Duracion Llamada en minutos '||r.Duraciondllamada);  
    COMMIT;
  END LOOP;
END;

