create or replace PROCEDURE ACTUALIZAR_CLIENTE(  numeroDocumentoIN IN  INTEGER       
   , tipoDocumentoIN   IN varchar2   
   , primerNombreIN     IN    varchar2 
   , segundoNombreIN IN   varchar2  
   , primerApellidoIN  IN   varchar2 
   , segundoApellidoIN IN  varchar2
   , direccionIN  IN   varchar2
   , fechaNacimientoIN   IN  date
   , sexoIN IN varchar2 
   , ocupacionIN IN varchar2
   , rangoSalarial_MenorIN IN INTEGER
   , rangoSalarial_MayorIN IN INTEGER
   , telefonoClienteIN FLOAT
   , correoIN IN varchar2
   , nombreCiudadIN IN varchar2)
IS
    codigoCiudadG INTEGER;
BEGIN
  codigoCiudadG := DEVOLVER_CIUDAD(nombreCiudadIN); 
  IF codigoCiudadG <> 0 THEN 
	  IF VALIDAR_CLIENTE(numeroDocumentoIN)=TRUE THEN
      UPDATE Cliente SET primerNombre = primerNombreIN, segundoNombre = segundoNombreIN, primerApellido=primerApellidoIN
							, segundoApellido=segundoApellidoIN, direccion=direccionIN,fechaDnacimiento=fechaNacimientoIN
							, sexo=sexoIN,ocupacion=ocupacionIN, rangoSalarial_Menor=rangoSalarial_MenorIN, rangoSalarial_Mayor=rangoSalarial_MayorIN
							, telefonoDcliente=telefonoClienteIN, correo=correoIN, codigoCiudad=codigoCiudadG 
		WHERE numeroDdocumento = numeroDocumentoIN ;
		COMMIT;
		DBMS_OUTPUT.PUT_LINE(' Se  actualizo el cliente ');
     ELSE
        DBMS_OUTPUT.PUT_LINE(' El cliente no existe');
    END IF;
    ELSE
    DBMS_OUTPUT.PUT_LINE('No se encuentra la ciudad');
  END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(' Se presento un error actualizando ');
        rollback;
END;

create or replace PROCEDURE ELIMINAR_CLIENTE (numeroDocumentoIN IN INTEGER)
IS
BEGIN
  IF VALIDAR_CLIENTE(numeroDocumentoIN) = TRUE THEN
      DELETE FROM Cliente WHERE numeroDdocumento=numeroDocumentoIN;
      DBMS_OUTPUT.PUT_LINE('El cliente fue borrado : '|| numeroDocumentoIN );
  ELSE
      DBMS_OUTPUT.PUT_LINE('El cliente con numero de documento '|| numeroDocumentoIN ||' no existe en la base de datos:' );
  END IF;
  COMMIT;

      EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Se presento un error borrando el cliente'||SQLERRM);
      rollback;

END;

create or replace PROCEDURE REGISTRAR_CLIENTE
  (  numeroDocumentoIN IN  INTEGER       
   , tipoDocumentoIN   IN varchar2   
   , primerNombreIN     IN    varchar2 
   , segundoNombreIN IN   varchar2  
   , primerApellidoIN  IN   varchar2 
   , segundoApellidoIN IN  varchar2
   , direccionIN  IN   varchar2
   , fechaNacimientoIN   IN  date
   , sexoIN IN varchar2 
   , ocupacionIN IN varchar2
   , rangoSalarial_MenorIN IN INTEGER
   , rangoSalarial_MayorIN IN INTEGER
   , telefonoClienteIN FLOAT
   , correoIN IN varchar2
   , nombreCiudadIN IN varchar2  
   )
IS
    codigoCiudadG INTEGER;
BEGIN
  codigoCiudadG := DEVOLVER_CIUDAD(nombreCiudadIN); 
  IF codigoCiudadG <> 0 THEN 
	  IF VALIDAR_CLIENTE(numeroDocumentoIN)=FALSE THEN

		BEGIN
			  INSERT INTO Cliente (numeroDdocumento, tipoDdocumento, primerNombre, segundoNombre, primerApellido,
			segundoApellido,direccion,fechaDnacimiento,sexo,ocupacion,rangoSalarial_Menor,rangoSalarial_Mayor,telefonoDcliente,correo,codigoCiudad
				  )
			  VALUES(numeroDocumentoIN,tipoDocumentoIN,primerNombreIN
				  ,segundoNombreIN,primerApellidoIN,segundoApellidoIN
				  , direccionIN,fechaNacimientoIN,sexoIN, ocupacionIN
				  , rangoSalarial_MenorIN, rangoSalarial_MayorIN, telefonoClienteIN
				  , correoIN, codigoCiudadG
				  );
			  COMMIT;
			  DBMS_OUTPUT.PUT_LINE('Cliente creado : '|| primerNombreIN || ' ' || primerApellidoIN );

			  EXCEPTION
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE(' Se presento un error creando al cliente ');
			END;	
	  ELSE
	  BEGIN
		UPDATE Cliente SET primerNombre = primerNombreIN, segundoNombre = segundoNombreIN, primerApellido=primerApellidoIN
							, segundoApellido=segundoApellidoIN, direccion=direccionIN,fechaDnacimiento=fechaNacimientoIN
							, sexo=sexoIN,ocupacion=ocupacionIN, rangoSalarial_Menor=rangoSalarial_MenorIN, rangoSalarial_Mayor=rangoSalarial_MayorIN
							, telefonoDcliente=telefonoClienteIN, correo=correoIN, codigoCiudad=codigoCiudadG 
		WHERE numeroDdocumento = numeroDocumentoIN ;
		COMMIT;
		DBMS_OUTPUT.PUT_LINE(' Se  actualizo el cliente ');
		  EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(' Se presento un error actualizando el cliente ');
	  END;
	  END IF;
  ELSE
  BEGIN
    DBMS_OUTPUT.PUT_LINE('No se encuentra la ciudad');
  END;
  END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(' Se presento un error actualizando la ciudad ');
        rollback;
END;

create or replace PROCEDURE CONSULTAR_CLIENTE(numeroDocumentoIN INTEGER) IS

  CURSOR c1 IS SELECT * FROM Cliente WHERE numeroDdocumento = numeroDocumentoIN;

BEGIN   
  IF VALIDAR_CLIENTE(numeroDocumentoIN) = TRUE THEN
    FOR registro in c1 LOOP
      DBMS_OUTPUT.PUT_LINE('Numero de Documento  :'|| registro.numeroDdocumento || ', Tipo de documento :'|| registro.tipoDdocumento ||
                           ', Primer Nombre  :'|| registro.primerNombre || ', Segundo Nombre :'|| registro.segundoNombre ||
                           'Primer Apellido  :'|| registro.primerApellido || ', segundoApellido :'|| registro.segundoApellido ||
                           'Direccion  :'|| registro.direccion || ', Fecha de Nacimiento :'|| registro.fechaDnacimiento ||
                           'Sexo  :'|| registro.sexo || ', Ocupacion :'|| registro.ocupacion ||
                           'Rango Salarial Menor  :'|| registro.rangoSalarial_Menor || ', Rango Salarial Mayor :'|| registro.rangoSalarial_Mayor ||
                           'Telefono  :'|| registro.TelefonoDCliente || ', Correo :'|| registro.correo || 'Codigo de la ciudad  :'|| registro.codigoCiudad );
    End LOOP;

  ELSE
    DBMS_OUTPUT.PUT_LINE('El cliente con numero de documento: ' || numeroDocumentoIN || ' no existe en el base de datos');

  END IF;  
        EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Se presento un error consultando el cliente '||SQLERRM);
        rollback;

END;

