create or replace PROCEDURE actualizar_catalogo(
id_catIN IN INTEGER,
n_fecha_iniIN IN DATE,
n_fecha_finIN IN DATE)
IS
BEGIN
	IF VALIDAR_CATALOGO(id_catIN)=TRUE THEN
    UPDATE Catalogo
		SET fechaInicio = n_fecha_iniIN, fechaFin = n_fecha_finIN
		WHERE idCatalogo = id_catIN;
  ELSE
    DBMS_OUTPUT.PUT_LINE
    ('El catalogo con id: '||id_catIN||' no existe.');
  END IF;
	
	EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE
    ('Error al actualizar');
END actualizar_catalogo;

create or replace PROCEDURE borrar_catalogo(
id_catIN IN INTEGER)
AS

BEGIN
	IF VALIDAR_CATALOGO(id_catIN)=TRUE THEN
   DELETE FROM Catalogo WHERE idCatalogo = id_catIN;
  ELSE
    DBMS_OUTPUT.PUT_LINE
    ('El catalogo con id: '||id_catIN||' no existe.');
  END IF;
	
	EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE
    ('Error al eliminar');
END borrar_catalogo;

create or replace PROCEDURE CREAR_CATALOGO(fecha_iniIN IN DATE, 
	fecha_finIN IN DATE)
IS
BEGIN
  IF VALIDAR_CATALOGO_FECHA(fecha_iniIN, fecha_finIN)=FALSE THEN
  BEGIN
      INSERT INTO Catalogo (idcatalogo,fechaInicio,fechaFin)
      VALUES(NULL, fecha_iniIN, fecha_finIN);
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Catalogo creado : '|| fecha_iniIN || ' ' || fecha_finIN);

    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(' Se presento un error creando el catalogo');
    END;
  ELSE
    DBMS_OUTPUT.PUT_LINE(' ya existe un catalogo en este periodo');
  END IF;
    
END;

create or replace PROCEDURE ELIMINAR_CATALOGO(
id_CatxPlanIN IN INTEGER)
AS

BEGIN
  IF VALIDAR_CATxPLAN(id_CatxPlanIN)=TRUE THEN
   DELETE FROM CatalogoxTipoPlan WHERE idCatxPlan = id_CatxPlanIN;
  ELSE
    DBMS_OUTPUT.PUT_LINE
    ('El catalogo con id: '||id_CatxPlanIN||' no existe.');
  END IF;

  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE
    ('Error al eliminar');
END;