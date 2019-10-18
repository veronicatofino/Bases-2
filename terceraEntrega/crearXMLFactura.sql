create or replace PROCEDURE REGISTRAR_XML_FACTURA(idFact IN INTEGER) IS
	xmldoc CLOB;
BEGIN
    
	IF VALIDAR_FACTURA(idFact) = TRUE THEN 
		SELECT XMLELEMENT("factura",
			XMLFOREST(
				f.idFactura AS "id",
				f.FechaDfacturacion AS "fechaFactura",
				f.impuestos AS "impuestos",
				f.valorTotal AS "totalMinutos",
				f.idContrato AS "idContrato"),
			XMLELEMENT("detallesFactura",
				XMLCONCAT(
					XMLSEQUENCE(
						CURSOR(
							SELECT ll.numeroAbonado "celularUsuario", ll.fechaLlamada "fechaLlamada", 
							ll.duracionDllamada "minutos consumidos"
							FROM DetalleFactura df JOIN RegistroLLamadas ll ON (df.idRegistroLlam = ll.idRegistro)
							WHERE f.idFactura = df.idFactura
						)
					)
				)
			)
		).getClobVal()

		INTO xmldoc
		FROM Factura f
		WHERE f.idFactura = idFact;

		dbms_xslprocessor.clob2file(xmldoc, 'OUR_DIR', 'factura.xml');
	ELSE
		DBMS_OUTPUT.PUT_LINE('El codigo: '|| idFact || ' de la factura no existe en la base de datos');
  	END IF;
END;