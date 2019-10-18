create or replace PROCEDURE ACTUALIZAR_CIUDAD(  codigoCiudadIN IN  INTEGER, nombreCiudadIN IN   varchar2)    IS
BEGIN
    IF VALIDAR_CIUDAD(codigoCiudadIN)=TRUE THEN
        UPDATE Ciudad SET nombreCiudad = nombreCiudadIN
        WHERE codigoCiudad = codigoCiudadIN ;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(' Se  actualizo la ciudad ');
    ELSE
        DBMS_OUTPUT.PUT_LINE('La ciudad con Id: '|| codigoCiudadIN);
    END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(' Se presento un error actualizando la ciudad ');
        rollback;
END;

create or replace PROCEDURE CONSULTAR_CIUDAD(codigoCiudadIN INTEGER) IS

  CURSOR c1 IS SELECT * FROM Ciudad WHERE codigoCiudad = codigoCiudadIN;

BEGIN   
  IF VALIDAR_CIUDAD(codigoCiudadIN) = TRUE THEN
    FOR registro in c1 LOOP
      DBMS_OUTPUT.PUT_LINE('Codigo ciudad  :'|| registro.codigoCiudad || ', Nombre de la ciudad :'|| registro.nombreCiudad);
    End LOOP;

  ELSE
    DBMS_OUTPUT.PUT_LINE('La ciudad con codigo: ' || codigoCiudadIN || ' no existe en el base de datos');

  END IF;  
        EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Se presento un error consultando la ciudad '||SQLERRM);
        rollback;

END;

create or replace PROCEDURE ELIMINAR_CIUDAD (codigoCiudadIN IN INTEGER)
IS
BEGIN
  IF VALIDAR_CIUDAD(codigoCiudadIN) = TRUE THEN
      DELETE FROM Ciudad WHERE codigoCiudad=codigoCiudadIN;
      DBMS_OUTPUT.PUT_LINE('La ciudad fue borrada : '|| codigoCiudadIN );
  ELSE
      DBMS_OUTPUT.PUT_LINE('La ciudad con id '|| codigoCiudadIN ||' no existe en la base de datos:' );
  END IF;
  COMMIT;

      EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Se presento un error borrando la ciudad'||SQLERRM);
      rollback;

END;

create or replace PROCEDURE REGISTRAR_CIUDAD
  (  codigoCiudadIN IN  INTEGER       
   , nombreCiudadIN IN   varchar2
   )
IS
BEGIN
  IF VALIDAR_CIUDAD(codigoCiudadIN)=FALSE THEN
  BEGIN
      INSERT INTO Ciudad (codigoCiudad,nombreCiudad
        )
      VALUES (codigoCiudadIN,nombreCiudadIN);
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Ciudad agregada : '|| codigoCiudadIN || ' ' || nombreCiudadIN );

      EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error creando la ciudad ');
    END;
  ELSE
      BEGIN
        UPDATE Ciudad SET nombreCiudad = nombreCiudadIN
        WHERE codigoCiudad = codigoCiudadIN ;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(' Se  actualizo la ciudad ');
          EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(' Se presento un error actualizando la ciudad ');
        rollback;
      END;
  END IF;
END;