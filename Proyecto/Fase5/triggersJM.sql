REM Triggers sobre RECARGA_SALDO

REM Trigger: validarRecarga
CREATE OR REPLACE TRIGGER validarRecarga
BEFORE INSERT ON recarga
FOR EACH ROW
DECLARE
	num_personas NUMBER(5);
	es_estudiante BOOLEAN;
	cuentas cuentaArray_t;
	i NUMBER(3);
BEGIN

	IF :NEW.monto_recarga <= 0 THEN
		raise_application_error(-20101, 'Monto itroducido no es valido');
	END IF;
	
	SELECT COUNT(*) INTO num_personas
	FROM persona 
	WHERE nombre = deref(:NEW.solicitante).nombre
	  AND 	apellido = deref(:NEW.solicitante).apellido
	  AND   correo_electronico = deref(:NEW.solicitante).correo_electronico;
					  

	IF num_personas = 0 THEN
		raise_application_error(-20101, 'La persona solicitante no se encuentra en la base de datos');
	END IF;
	
	SELECT cuenta INTO cuentas
	FROM persona
	WHERE nombre = deref(:NEW.solicitante).correo_electronico;
	
	i := 1;
	es_estudiante := FALSE;
	
	WHILE es_estudiante = FALSE AND i <= cuentas.COUNT LOOP
		
		IF cuentas(i).es_tai = 1 THEN 
			es_estudiante := TRUE;
		ELSE 
			i := i + 1;
		END IF;
	END LOOP;
	
	IF es_estudiante = FALSE THEN
		raise_application_error(-20101, 'La persona solicitante no tiene una cuenta TAI. No es estudiante');
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('Validacion sintactica realizada.');
	
END;
/


REM Trigger: validarMonto
REM 		 Una vez validada la sintaxis de la recarga, es hora de validar el monto.
CREATE OR REPLACE TRIGGER validarMonto
BEFORE INSERT ON recarga
FOR EACH ROW WHEN (NEW.monto_recarga > 0)
DECLARE
	cuentas cuentaArray_t;
BEGIN
	SELECT cuenta INTO cuentas
	FROM persona
	WHERE correo_electronico = deref(:NEW.solicitante).correo_electronico;
	FOR i IN 1 .. cuentas.COUNT LOOP
		IF cuentas(i).es_tai = 1 AND cuentas(i).monto < :NEW.monto_recarga THEN
			raise_application_error(-20101, 'El monto de recarga excede el balance de la cuenta');
		END IF;
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('Monto validado.');
END;
/

			
REM Trigger: agregarSolicitud
CREATE OR REPLACE TRIGGER agregarSolicitud
AFTER INSERT ON recarga
FOR EACH ROW
DECLARE
	serv ref servicio_t;
BEGIN

	SELECT ref(s) INTO serv FROM servicio s WHERE s.nombre = 'Recarga de Saldo';
	
	INSERT INTO solicitud VALUES(SYSDATE, :NEW.monto_recarga, "Transferencia", SYSDATE, serv, :NEW.solicitante);

	DBMS_OUTPUT.PUT_LINE('Solicitud agregada.');
END;	
/