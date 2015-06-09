CREATE OR REPLACE TYPE aux_reproduccion_docs_guias_t under solicitud_servicio_t (
		numero_copias number(2),
	archivo_imprimir BFILE, 
	blanco_negro number(1),
	numero_paginas number(2),
	guia_imprimir ref guia_t
);
/


	
CREATE TABLE aux_reproduccion of aux_reproduccion_docs_guias_t;


CREATE OR REPLACE TRIGGER crear_aux_rep_guia
AFTER INSERT ON reproduccion REFERENCING NEW AS n
FOR EACH ROW WHEN (n.archivo_imprimir IS NULL AND n.precio IS NULL AND n.guia_imprimir IS NOT NULL AND n.modo_pago IS NULL AND n.dato_entrega IS NULL)
BEGIN
 INSERT INTO aux_reproduccion(fecha_solicitud,servicio_solicitado,numero_copias,guia_imprimir)
								VALUES (:n.fecha_solicitud, :n.servicio_solicitado, :n.numero_copias, :n.guia_imprimir);
END;
/

REM Reproduccion : Tabla Solicitud
REM Se actualiza el monto a pagar por la guia a insertar
REM en la tabla Reproduccion.

CREATE OR REPLACE TRIGGER actualizarPagoGuia
AFTER INSERT ON aux_reproduccion
FOR EACH ROW
DECLARE
	subtotal number(10,2);
	cantidad int;
BEGIN
	SELECT costo_reproduccion into subtotal
	FROM guia
	WHERE nombre = deref(:NEW.guia_imprimir).nombre;
	
	subtotal := (subtotal * :NEW.numero_copias);
	
	UPDATE reproduccion set precio = subtotal WHERE guia_imprimir = :NEW.guia_imprimir;
	
END;
/

CREATE OR REPLACE TRIGGER crear_aux_rep_documentos
AFTER INSERT ON reproduccion REFERENCING NEW AS n
FOR EACH ROW WHEN (n.archivo_imprimir IS NOT NULL AND n.precio IS NULL AND n.guia_imprimir IS NULL AND n.modo_pago IS NULL AND n.dato_entrega IS NULL)
BEGIN
 INSERT INTO aux_reproduccion(fecha_solicitud,servicio_solicitado,numero_copias,archivo_imprimir, numero_paginas, blanco_negro)
								VALUES (:n.fecha_solicitud, :n.servicio_solicitado, :n.numero_copias, :n.archivo_imprimir, :n.numero_paginas, :n.blanco_negro);
END;
/

REM Reproduccion : Tabla Solicitud
REM Se actualiza el monto a pagar por el documento  a insertar
REM en la tabla Reproduccion.

CREATE OR REPLACE TRIGGER actualizarPagoDocumento
AFTER INSERT ON aux_reproduccion REFERENCING NEW AS n
FOR EACH ROW
DECLARE
	subtotal number(10,2);
	cantidad int;
BEGIN
	IF (:n.blanco_negro=1) THEN
		subtotal := 1.00;
	ELSE 
		subtotal := 5.00;
	END IF;
	subtotal := subtotal * :n.numero_copias * :n.numero_paginas;
	UPDATE reproduccion set precio = subtotal WHERE fecha_solicitud= :n.fecha_solicitud AND dbms_lob.compare(archivo_imprimir,:n.archivo_imprimir,1024,0,0)=0;
END;
/


CREATE OR REPLACE TRIGGER actualizar_aux_rep_documentos
AFTER update ON reproduccion REFERENCING NEW AS n
FOR EACH ROW WHEN (n.archivo_imprimir IS NOT NULL AND n.precio IS NOT NULL AND n.guia_imprimir IS NULL AND n.modo_pago IS  NOT NULL AND n.dato_entrega IS NULL)
BEGIN
 update aux_reproduccion set precio = :n.precio
						 where fecha_solicitud = :n.fecha_solicitud and dbms_lob.compare(archivo_imprimir,:n.archivo_imprimir,1024,0,0)=0;		
						  update aux_reproduccion set modo_pago = :n.modo_pago
						 where fecha_solicitud = :n.fecha_solicitud and dbms_lob.compare(archivo_imprimir,:n.archivo_imprimir,1024,0,0)=0;
END;
/

CREATE OR REPLACE TRIGGER actualizar_aux_rep_guias
AFTER update ON reproduccion REFERENCING NEW AS n
FOR EACH ROW WHEN (n.archivo_imprimir IS NULL AND n.precio IS NOT NULL AND n.guia_imprimir IS NOT NULL AND n.modo_pago IS  NOT NULL AND n.dato_entrega IS NULL)
BEGIN
 update aux_reproduccion set precio = :n.precio
						 where fecha_solicitud = :n.fecha_solicitud and guia_imprimir = :n.guia_imprimir;		
						  update aux_reproduccion set modo_pago = :n.modo_pago
						 where fecha_solicitud = :n.fecha_solicitud and guia_imprimir = :n.guia_imprimir;
END;
/


REM Reproduccion : Tabla Solicitud
REM Se actualiza la fecha  de entrega de la impresion de documentos a la fecha actual.
REM en la tabla Reproduccion.

CREATE OR REPLACE TRIGGER cerrarRepGuia
AFTER UPDATE ON aux_reproduccion REFERENCING NEW AS n
FOR EACH ROW WHEN (n.modo_pago is NOT NULL AND n.precio IS NOT NULL AND n.guia_imprimir IS NOT NULL AND n.archivo_imprimir IS NULL) 
DECLARE
fecha_actual DATE;
BEGIN
	SELECT SYSDATE into fecha_actual
	FROM DUAL;
	UPDATE reproduccion set dato_entrega = fecha_actual;
	
END;
/

CREATE OR REPLACE TRIGGER cerrarRepDocumentos
AFTER UPDATE ON aux_reproduccion REFERENCING NEW AS n
FOR EACH ROW WHEN (n.modo_pago is NOT NULL AND n.precio IS NOT NULL AND n.guia_imprimir IS NULL AND n.archivo_imprimir IS NOT NULL) 
DECLARE
fecha_actual DATE;
BEGIN
	SELECT SYSDATE into fecha_actual
	FROM DUAL;
	UPDATE reproduccion set dato_entrega = fecha_actual;
	
END;
/

	
	
	