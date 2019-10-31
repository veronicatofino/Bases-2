
        DROP TABLE contrato_xml;
        CREATE TABLE contrato_xml OF XMLType;
        drop table contrato_temp;
create table CONTRATO_TEMP (fecha_Contrato DATE, fecha_Corte DATE, id_Sucursal number, numero_Documento number
            ,tipo_Documento varchar2(15 BYTE), primer_Nombre varchar2(15 BYTE), segundo_Nombre varchar2(15 BYTE), primer_Apellido varchar2(15 BYTE), segundo_Apellido varchar2(15 BYTE)
            ,direccion varchar2(20 BYTE), fecha_Nacimiento date, sexo varchar2(15 BYTE), ocupacion varchar2(30 BYTE), rango_Salarial_Menor number, rango_Salarial_Mayor number
            ,telefono number, correo varchar2(30 BYTE), nombre_Ciudad varchar2(15 BYTE)
        , id_CatxPlan number);
        
        
        CREATE DIRECTORY OUR_DIR2 AS '/alumno/alumno2';
        

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
        INSERT INTO contrato_xml VALUES (XMLType(bfilename('OUR_DIR2','contratos.xml'),nls_charset_id('AL32UTF8')));
        INSERT INTO contrato_temp(fecha_Contrato, fecha_Corte, id_Sucursal, numero_Documento
        ,tipo_Documento,primer_Nombre,segundo_Nombre,primer_Apellido,segundo_Apellido,direccion
        ,fecha_Nacimiento,sexo,ocupacion,rango_Salarial_Menor,rango_Salarial_Mayor,telefono
        ,correo,nombre_Ciudad
        , id_CatxPlan)
        
        SELECT TO_DATE(z.fecha_Contrato, 'DD/MM/YYYY'), TO_DATE(z.fecha_Corte, 'DD/MM/YYYY'), z.id_Sucursal,z.numDoc
        ,z.tipo_Documento,z.primer_Nombre,z.segundo_Nombre,z.primer_Apellido,z.segundo_Apellido,z.direccion
        ,TO_DATE(z.fecha_Nacimiento, 'DD/MM/YYYY'),z.sexo,z.ocupacion,z.rango_Salarial_Menor,z.rango_Salarial_Mayor,z.telefono
        ,z.correo,z.nombre_Ciudad
        , z.id_CatxPlan from contrato_xml, 
        XMLTABLE('/Contratos'
      PASSING OBJECT_VALUE
      COLUMNS 
        contrato xmltype PATH '/Contratos/Contrato') x
      , XMLTABLE('/Contrato'
        PASSING x.contrato
        columns
          fecha_Contrato varchar(100) path '/Contrato/fecha_Contrato'
          , fecha_Corte varchar(100) path '/Contrato/fecha_Corte'
          , id_Sucursal number path '/Contrato/id_Sucursal'
          , numDoc number path '/Contrato/Cliente/numero_Documento'
          
          , tipo_Documento varchar(100) path '/Contrato/Cliente/tipo_Documento'
          , primer_Nombre varchar(100) path '/Contrato/Cliente/primer_Nombre'
          , segundo_Nombre varchar(100) path '/Contrato/Cliente/segundo_Nombre'
          , primer_Apellido varchar(100) path '/Contrato/Cliente/primer_Apellido'
          , segundo_Apellido varchar(100) path '/Contrato/Cliente/segundo_Apellido'
          , direccion varchar(100) path '/Contrato/Cliente/direccion'
          , fecha_Nacimiento varchar(100) path '/Contrato/Cliente/fecha_Nacimiento'
          , sexo varchar(100) path '/Contrato/Cliente/sexo'
          , ocupacion varchar(100) path '/Contrato/Cliente/ocupacion'
          , rango_Salarial_Menor number path '/Contrato/Cliente/rango_Salarial_Menor'
          , rango_Salarial_Mayor number path '/Contrato/Cliente/rango_Salarial_Mayor'
          , telefono number path '/Contrato/Cliente/telefono'
          , correo varchar(100) path '/Contrato/Cliente/correo'
          , nombre_Ciudad varchar(100) path '/Contrato/Cliente/nombre_Ciudad'
          
          , id_CatxPlan number path '/Contrato/id_CatxPlan') z;
          COMPLETAR_REGISTRO_CONTRATO();
    COMMIT;

end;


CREATE OR REPLACE PROCEDURE COMPLETAR_REGISTRO_CONTRATO
IS 
     CURSOR c1 IS SELECT fecha_Contrato , fecha_Corte , id_Sucursal
     , numero_Documento    
            ,tipo_Documento,primer_Nombre,segundo_Nombre,primer_Apellido,segundo_Apellido,direccion
            ,fecha_Nacimiento,sexo,ocupacion,rango_Salarial_Menor,rango_Salarial_Mayor,telefono
            ,correo,nombre_Ciudad
     , id_CatxPlan  FROM CONTRATO_TEMP;
BEGIN
    for r in c1 LOOP
        IF VALIDAR_CLIENTE(r.numero_Documento) THEN
            CREAR_CONTRATO(r.fecha_Contrato,r.fecha_Corte,r.id_Sucursal,r.numero_Documento,r.id_CatxPlan);
        ELSE
            REGISTRAR_CLIENTE(r.numero_Documento,r.tipo_Documento,r.primer_Nombre,r.segundo_Nombre,r.primer_Apellido,r.segundo_Apellido,r.direccion,r.fecha_Nacimiento, r.sexo, r.ocupacion, r.rango_Salarial_Menor, r.rango_Salarial_Mayor,r.telefono, r.correo, r.nombre_Ciudad);
            CREAR_CONTRATO(r.fecha_Contrato,r.fecha_Corte,r.id_Sucursal,r.numero_Documento,r.id_CatxPlan);
        COMMIT;            
        end if; 
        
  END LOOP;
END;