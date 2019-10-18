create or replace PROCEDURE ACTUALIZAR_SUCURSAL(idSucursalIN IN  INTEGER, nombreSucursalIN IN  varchar2, nombreCiudadIN IN varchar2)
IS
 codigoCiudadG INTEGER;
BEGIN
  codigoCiudadG:=DEVOLVER_CIUDAD(nombreCiudadIN);
  IF codigoCiudadG <> 0 THEN
      IF VALIDAR_SUCURSAL(idSucursalIN)=TRUE THEN
          UPDATE Sucursales SET nombreSucursal = nombreSucursalIN, codigoCiudad=codigoCiudadG
                WHERE idSucursal = idSucursalIN ;
                COMMIT;
                DBMS_OUTPUT.PUT_LINE(' Se  actualizo la sucursal ');
       ELSE
        DBMS_OUTPUT.PUT_LINE('La sucursal con Id'|| idsucursalin|| 'no existe');
       END IF;
  ELSE
    DBMS_OUTPUT.PUT_LINE('La ciudad no existe');
  END IF;
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(' Se presento un error creando la sucursal ');
END;

create or replace PROCEDURE CONSULTAR_SUCURSALES(idSucursalIN INTEGER) IS

  CURSOR c1 IS SELECT * FROM Sucursales WHERE idSucursal = idSucursalIN ;

BEGIN   
  IF VALIDAR_SUCURSAL(idSucursalIN) = TRUE THEN
    FOR registro in c1 LOOP
      DBMS_OUTPUT.PUT_LINE('ID Sucursal  :'|| registro.idSucursal || ', Nombre de la sucursal:' || registro.nombreSucursal ||
       ', Codigo de la ciudad:' || registro.codigoCiudad);
    End LOOP;

  ELSE
    DBMS_OUTPUT.PUT_LINE('La sucursal con id: ' || idSucursalIN || ' no existe en el base de datos');

  END IF;  
        EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Se presento un error consultando las sucursales '||SQLERRM);
        rollback;

END;

create or replace PROCEDURE ELIMINAR_SUCURSAL (idSucursalIN IN INTEGER)
IS
BEGIN
  IF VALIDAR_SUCURSAL(idSucursalIN) = TRUE 
  THEN
      DELETE FROM Sucursales WHERE Sucursales.idSucursal = idSucursalIN ;
      DBMS_OUTPUT.PUT_LINE('La sucursal fue borrada : '|| idSucursalIN );
  ELSE
      DBMS_OUTPUT.PUT_LINE('La sucursal con id'|| idSucursalIN ||' no existe en la base de datos:' );
  END IF;
  COMMIT;
      EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Se presento un error borrando la sucursal'||SQLERRM);
      rollback;

END;


create or replace PROCEDURE REGISTRAR_SUCURSAL
  (  idSucursalIN IN  INTEGER       
   , nombreSucursalIN IN   varchar2
   , nombreCiudadIN IN varchar2
   )
IS
 codigoCiudadG INTEGER;
BEGIN
  codigoCiudadG:=DEVOLVER_CIUDAD(nombreCiudadIN);
  IF codigoCiudadG <> 0 THEN
      IF VALIDAR_SUCURSAL(idSucursalIN)=FALSE THEN
          INSERT INTO Sucursales (idSucursal,nombreSucursal,codigoCiudad)
          VALUES(idSucursalIN,nombreSucursalIN,codigoCiudadG);
          COMMIT;
          DBMS_OUTPUT.PUT_LINE('Sucursal agregada : '|| idSucursalIN || ' ' || nombreSucursalIN );
      ELSE
        UPDATE Sucursales SET nombreSucursal = nombreSucursalIN, codigoCiudad=codigoCiudadG
        WHERE idSucursal = idSucursalIN ;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(' Se  actualizo la sucursal ');
      END IF;
  ELSE
    DBMS_OUTPUT.PUT_LINE('La ciudad no existe');
  END IF;
  COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error creando la sucursal ');
END;
