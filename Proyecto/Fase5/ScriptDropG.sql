REM Archivo para hacer DROP de los tipos en el schema

DROP TABLE solicitud PURGE;
DROP TABLE idioma PURGE; 
DROP TABLE curso PURGE;
DROP TABLE asignatura PURGE; 
DROP TABLE guia PURGE;
DROP TABLE persona PURGE;
DROP TABLE servicio PURGE;
DROP TABLE pago_arancel PURGE;
DROP TABLE reproduccion PURGE;
DROP TABLE almacen_guias PURGE;
DROP TABLE venta_articulos PURGE;
DROP TABLE libros PURGE;
DROP TABLE recarga PURGE;


drop type es_dictado_t FORCE;
drop type reproduccion_documentos_t FORCE;
drop type guia_t FORCE;
drop type asignatura_t FORCE;
drop type venta_articulos_papeleria_t FORCE;
drop type almacenar_guias_t FORCE;
drop type pago_arancel_t FORCE;
drop type recarga_saldo_t FORCE;
drop type libro_t FORCE;
drop type prestamo_libros_t FORCE;
drop type horario_t FORCE;
drop type profesor_extension_t FORCE;
drop type idioma_t FORCE;
drop type curso_t FORCE;
drop type inscripcion_cursos_extension_t FORCE;
drop type solicitud_servicio_t FORCE;
drop type persona_t FORCE;
drop type servicios_t FORCE;
drop type direccion_t FORCE;
drop type servicio_t FORCE;
drop type arrayPeriodo_t FORCE;
drop type periodo_t FORCE;

drop type hora_t FORCE;
drop type dia_t FORCE;
drop type telefono_t FORCE;
drop type cuentaArray_t FORCE;
drop type cuenta_t FORCE;









