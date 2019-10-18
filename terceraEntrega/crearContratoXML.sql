CREATE DIRECTORY OUR_DIR AS '/alumno/alumno2';
        DROP TABLE contrato_xml;
        CREATE TABLE contrato_xml OF XMLType;
create or replace PROCEDURE CREAR_CONTRATO_DESDE_XML
    IS
        fechaContrato DATE;
        fechaCorte DATE;
        idSucursal INTEGER;
        nDocumento INTEGER;
        idCatxPlan INTEGER;
        tipoDocumento VARCHAR2(15 BYTE);
        primerNombre VARCHAR(15 BYTE);
        segundoNombre VARCHAR(15 BYTE);
        primerApellido VARCHAR(15 BYTE);
        segundoApellido VARCHAR(15 BYTE);
        direccion VARCHAR(20 BYTE);
        fechaNacimiento DATE;
        sexo VARCHAR(15 BYTE);
        ocupacion VARCHAR(30 BYTE);
        rangoSalarial_Menor FLOAT;
        rangoSalarial_Mayor FLOAT;
        telefonoCliente FLOAT;
        correo VARCHAR(30 BYTE);
        nombreCiudad VARCHAR(15 BYTE);
    BEGIN

        INSERT INTO contrato_xml VALUES (XMLType(bfilename('OUR_DIR','contratos.xml'),nls_charset_id('AL32UTF8')));

        SELECT TO_NUMBER(extractValue(OBJECT_VALUE,'/Contrato/Cliente/numero_Documento')) , TO_DATE(extractValue(OBJECT_VALUE,'/Contrato/fecha_Contrato'),'DD/MM/YY'),
               TO_DATE(extractValue(OBJECT_VALUE,'/Contrato/fecha_Corte'),'DD/MM/YY'), TO_NUMBER(extractValue(OBJECT_VALUE,'/Contrato/id_Sucursal')), 
               TO_NUMBER(extractValue(OBJECT_VALUE,'/Contrato/id_CatxPlan'))
        INTO nDocumento , fechaContrato, fechaCorte, idSucursal, idCatxPlan
        FROM contrato_xml;

        IF VALIDAR_CLIENTE(nDocumento) THEN
            CREAR_CONTRATO(fechaContrato,fechaCorte,idSucursal,nDocumento,idCatxPlan);
        ELSE
            SELECT extractValue(OBJECT_VALUE,'/Contrato/Cliente/tipo_Documento'),extractValue(OBJECT_VALUE,'/Contrato/Cliente/primer_Nombre'),extractValue(OBJECT_VALUE,'/Contrato/Cliente/segundo_Nombre'),
                extractValue(OBJECT_VALUE,'/Contrato/Cliente/primer_Apellido'), extractValue(OBJECT_VALUE,'/Contrato/Cliente/segundo_Apellido'), extractValue(OBJECT_VALUE,'/Contrato/Cliente/direccion'), TO_DATE(extractValue(OBJECT_VALUE,'/Contrato/Cliente/fecha_Nacimiento'),'DD/MM/YY'),
                extractValue(OBJECT_VALUE,'/Contrato/Cliente/sexo'), extractValue(OBJECT_VALUE,'/Contrato/Cliente/ocupacion'), TO_NUMBER(extractValue(OBJECT_VALUE,'/Contrato/Cliente/rango_Salarial_Menor')),
                TO_NUMBER(extractValue(OBJECT_VALUE,'/Contrato/Cliente/rango_Salarial_Mayor')), TO_NUMBER(extractValue(OBJECT_VALUE,'/Contrato/Cliente/telefono')),extractValue(OBJECT_VALUE,'/Contrato/Cliente/correo'),
                extractValue(OBJECT_VALUE,'/Contrato/Cliente/nombre_Ciudad')
                INTO
                    tipoDocumento, primerNombre, segundoNombre, primerApellido, segundoApellido, direccion, fechaNacimiento, sexo, ocupacion, rangoSalarial_Menor, rangoSalarial_Mayor, telefonoCliente,
                    correo, nombreCiudad
                FROM contrato_xml;
            REGISTRAR_CLIENTE(nDocumento,tipoDocumento,primerNombre,segundoNombre,primerApellido,segundoApellido,direccion,fechaNacimiento, sexo, ocupacion, rangoSalarial_Menor, rangoSalarial_Mayor,telefonoCliente, correo, nombreCiudad);
            CREAR_CONTRATO(fechaContrato,fechaCorte,idSucursal,nDocumento,idCatxPlan);
                    
        end if;
end;

