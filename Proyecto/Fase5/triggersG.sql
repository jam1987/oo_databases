REM Triggers sobre Almacenar Guia

REM validarAsignatura : Tabla Almacenar_Guia
REM			al recibir el string del codigo de la asignatura a la cual
REM 		la Guia estara asociada, se debe verificar que este codigo pertenece
REM 		a una asignatura existente.

CREATE OR REPLACE TRIGGER validarAsignatura 
BEFORE UPDATE ON almacen_guias REFERENCING OLD AS a NEW AS n
FOR EACH ROW WHEN (a.codigo_materia_guia != n.codigo_materia_guia)
DECLARE 
	codigo_asignatura varchar(8);
BEGIN

	SELECT codigo INTO codigo_asignatura FROM asignatura WHERE codigo = :n.codigo_materia_guia;
	
	EXCEPTION
	WHEN NO_DATA_FOUND THEN
	raise_application_error(-20101, 'Codigo materia es invalido');
	
END;
/

REM Auxiliares para evitar las <mutating tables>

DROP TABLE auxiliarAlmacen;
/
DROP TYPE auxiliarAlmacen_t;
/

CREATE OR REPLACE TYPE auxiliarAlmacen_t as object(
	nombre_guia varchar(50),
	tema_guia varchar(50),
	categoria_guia varchar(30),
	codigo_materia_guia varchar(8),
	num_paginas number (4,1),
	archivo BFILE,
	fecha_solicitud date,
	precio number(10,2),
	modo_pago varchar(20),
	dato_entrega date,
	servicio_solicitado ref servicio_t,
	almacen_guias ref almacenar_guias_t
);
/

CREATE TABLE auxiliarAlmacen of auxiliarAlmacen_t;
/

CREATE OR REPLACE TRIGGER crearAuxiliarAlmacen
AFTER UPDATE ON almacen_guias REFERENCING NEW AS n
FOR EACH ROW WHEN (n.dato_entrega IS NULL AND n.codigo_materia_guia IS NOT NULL AND n.archivo IS NOT NULL)
BEGIN
	INSERT INTO auxiliarAlmacen(nombre_guia, tema_guia, categoria_guia, codigo_materia_guia,
								num_paginas, archivo, fecha_solicitud, precio, servicio_solicitado)
								VALUES (:n.nombre_guia, :n.tema_guia, :n.categoria_guia, :n.codigo_materia_guia,
								:n.num_paginas, :n.archivo, :n.fecha_solicitud, :n.precio, :n.servicio_solicitado);
END;
/


DROP TABLE costo;
/

CREATE TABLE costo (
	nombre_guia varchar(50) primary key,
	costo_guia number(10,2),
	auxiliarAlmacen auxiliarAlmacen_t
);
/

REM calcularCosto
CREATE OR REPLACE TRIGGER calcularCosto
AFTER INSERT ON auxiliarAlmacen REFERENCING NEW AS n
FOR EACH ROW WHEN (n.precio IS NULL AND n.dato_entrega IS NULL AND n.servicio_solicitado IS NOT NULL
					AND n.num_paginas IS NOT NULL AND n.archivo IS NOT NULL)
DECLARE
	costoPorPagina number(10,2);
	costo number(10,2);
BEGIN

	SELECT precio INTO costoPorPagina FROM servicio WHERE nombre = deref(:n.servicio_solicitado).nombre;
	costo :=  costoPorPagina * :n.num_paginas;
	INSERT INTO costo(nombre_guia, costo_guia) VALUES (:n.nombre_guia, costo);
	UPDATE costo set auxiliarAlmacen = auxiliarAlmacen_t(:n.nombre_guia, :n.tema_guia, :n.categoria_guia, 
								:n.codigo_materia_guia,:n.num_paginas, :n.archivo, :n.fecha_solicitud, :n.precio,
								 NULL, NULL,
								:n.servicio_solicitado, :n.almacen_guias) WHERE nombre_guia= :n.nombre_guia;
	EXCEPTION
	WHEN NO_DATA_FOUND THEN
	raise_application_error(-20101, 'COSTO NO ENCONTRADO');

END;
/

REM crearGuia: Tabla Guia
REM			  al calcularse el precio de la solicitud de almacenar guias
REM			  y este es mayor que 0, entonces se procede a crear el objeto guia

CREATE OR REPLACE TRIGGER crearGuia
AFTER UPDATE ON costo REFERENCING NEW AS n
FOR EACH ROW WHEN (n.costo_guia > 0)
DECLARE
	num_guias int;
	asig_aux ref asignatura_t;
BEGIN
	
	SELECT COUNT(*) INTO num_guias FROM guia WHERE nombre= :n.nombre_guia AND fecha = :n.auxiliarAlmacen.dato_entrega;
	
	IF (num_guias > 0) THEN
		raise_application_error(-20101, 'Ya la guia existe');
	ELSIF (num_guias = 0) THEN
		INSERT INTO guia(nombre, fecha, tema, categoria, costo_reproduccion, archivo)
					VALUES(:n.nombre_guia, SYSDATE, :n.auxiliarAlmacen.tema_guia, :n.auxiliarAlmacen.categoria_guia, :n.costo_guia, :n.auxiliarAlmacen.archivo);
					
		DBMS_OUTPUT.PUT_LINE('Guia agregada');
		
		SELECT ref(a) INTO asig_aux FROM asignatura a WHERE codigo = :n.auxiliarAlmacen.codigo_materia_guia;
		UPDATE guia set asignatura = asig_aux;
		
	ELSE
	raise_application_error(-20101, 'Error en la consulta');

	END IF;
	
END;
/


REM Reproduccion : Tabla Solicitud
REM Se actualiza el monto a pagar por la guia a insertar
REM en la tabla Reproduccion.

CREATE OR REPLACE TRIGGER actualizarPagoGuia
AFTER INSERT ON solicitud REFERENCING NEW AS n
DECLARE
	subtotal number(10,2);
	cantidad int;
BEGIN
	SELECT c.costo_guia into subtotal
	FROM costo c
	WHERE c.nombre_guia = deref(:n.guia_imprimir).nombre;
	
	subtotal := subtotal * :n.numero_copias;
	
	UPDATE solicitud set precio = subtotal WHERE guia_imprimir = :n.guia_imprimir;
	EXCEPTION:
		raise_application_error(-20102,'La Guia no fue encontrada');
END;
/



