REM Archivo para hacer DROP de los tipos en el schema

DROP TABLE solicitud PURGE;
DROP TABLE idioma PURGE; 
DROP TABLE curso PURGE; 
DROP TABLE guia PURGE;
DROP TABLE persona PURGE;
DROP TABLE profesor PURGE;
DROP TABLE horarios PURGE;
DROP TABLE servicio PURGE;
DROP TABLE prestamo PURGE;
DROP TABLE recarga PURGE;
DROP TABLE pago_arancel PURGE;
DROP TABLE reproduccion PURGE;
DROP TABLE almacen_guias PURGE;
DROP TABLE venta_articulos PURGE;
DROP TABLE libros PURGE;


drop type es_dictado_t;
drop type reproduccion_documentos_t;
drop type guia_t;
drop type venta_articulos_papeleria_t;
drop type almacenar_guias_t;
drop type pago_arancel_t;
drop type recarga_saldo_t;
drop type inscripcion_cursos_extension_t FORCE;
drop type libros_t;
drop type servicios_t FORCE;
drop type libro_t FORCE;
drop type prestamo_libros_t FORCE;
drop type arrayPeriodo_t FORCE;
drop type periodo_t FORCE;
drop type horario_t FORCE;
drop type profesor_extension_t;
drop type idioma_t;
drop type curso_t;

drop type solicitud_servicio_t FORCE;
drop type persona_t;
drop type direccion_t;
drop type servicio_t FORCE;

drop type hora_t;
drop type dia_t;
drop type telefono_t;
drop type cuenta_t;









