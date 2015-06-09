REM Nombre del Archivo: Script.sql
REM Descripcion del Archivo: Implementacion de las clases del Proyecto de Paradigmas de Bases de Datos.
REM Version: 1.0
REM Autores: Grace Gimon, Jesus Martinez y Julio De Abreu

REM -----------------------------------------------
REM -----------------------------------------------
REM DEFINICION DE LOS TIPOS						 --
REM -----------------------------------------------
REM -----------------------------------------------

REM Definicion del tipo CuentaArray_t : Arreglo de numero de cuentas 
REM bancarias
set serveroutput on;

create or replace type cuenta_t as object (
       numero varchar(24),
       monto number(8,2),
       es_tai number(1));
/
create or replace type cuentaArray_t as varray(10) of cuenta_t;
/

REM Definicion de la clase telefono_t : Arreglo de numeros de telefono
create or replace type telefono_t as varray(5) of varchar2(15);
/

REM Definicion del tipo dia_t : Arreglo de nombres de los dias de la semana
create or replace type dia_t as varray(3) of varchar2(7);
/

REM Definicion del tipo hora_t: Arreglo que consiste en 
REM
create or replace type hora_t as varray(2) of char(3);
/

REM Definicion del tipo direccion: Arreglo bidimensional que guarda
REM una direccion de una habitacion.
create or replace type direccion_t as varray(2) of varchar(100);
/

REM Definicion del tipo periodo: Rango de fechas.
create or replace type periodo_t as object (
	fecha_inicio date,
	fecha_fin date
);
/

REM Definicion del tipo arrayPeriodo: Periodos trimestrales anuales
REM en formato de rango de fechas
create or replace type arrayPeriodo_t as varray(4) of periodo_t;
/

REM Definicion del tipo servicio: Datos basicos de un servicio
create or replace type servicio_t as object (
	nombre varchar(30),
	descripcion varchar(100),
	periodo_oferta arrayPeriodo_t,
	precio number(10,2)
);
/

REM Definicion del tipo solicitud_servicio: Datos de una solicitud de un servicio
create or replace type solicitud_servicio_t as object (
	fecha_solicitud date,
	precio number(10,2),
	modo_pago varchar(20),
	dato_entrega date,
	servicio_solicitado ref servicio_t
) NOT FINAL;
/
REM Definicion del tipo Persona: Datos personales de una persona.

create or replace type persona_t as object (
  nombre varchar(10),
  apellido varchar(10),
  correo_electronico varchar(30),
  fecha_nacimiento date,
  cedula_identidad varchar(10),
  telefonos telefono_t,
  direccion direccion_t,
  edad int,
  cuenta cuentaArray_t,
  estado number(1),
  member function calcular_Edad return int
) NOT FINAL;
/
create or replace type servicios_t as table of servicio_t;
/

REM Atributo en el tipo Persona para especificar el conjunto de servicios 
REM que puede utilizar esta persona.
alter type persona_t
	add attribute(servicios_p servicios_t) cascade;	

REM Atributo para referenciar quien realiza la solicitud de servicio
alter type solicitud_servicio_t
	add attribute(solicitante ref persona_t) cascade;

REM Definicion del tipo libro
create or replace type libro_t as object(
	titulo varchar(100),
	codigo_ISBN varchar(17),
	autor varchar(20),
	editorial varchar(20),
	cantidad_ejemplares number(3)
) NOT FINAL;
/
	
REM Definicion del tipo prestamo de libros que es un tipo de solicitud de servicio ERROR
create or replace type prestamo_libros_t under solicitud_servicio_t ( 
);
/

REM Definicion del tipo inscripcion_cursos extension: Es un tipo de solicitud
REM de servicio
create or replace type inscripcion_cursos_extension_t under solicitud_servicio_t ( 
);
/

REM Definicion del tipo Recarga de Saldo: Es un tipo de solicitud de servicio
REM en el cual se almacena el monto a recargar
create or replace type recarga_saldo_t under solicitud_servicio_t(
	monto_recarga number(8,2)
);
/

REM Definicion del tipo Pago Arancel: Es un tipo de solicitud de servicio
REM en el cual se almacenan los tipos de aranceles y descripciones
create or replace type pago_arancel_t under solicitud_servicio_t(
	tipo_arancel varchar(30),
	descripcion varchar(60)
);
/

REM Definicion del tipo reproduccion de Documentos: Es un tipo de solicitud de servicio
REM de impresion de archivos
create or replace type reproduccion_documentos_t under solicitud_servicio_t(
	numero_copias number(2),
	archivo_imprimir BFILE 
);
/

REM Definicion del tipo Almacenar Guias: Es un tipo de solicitud de servicio para
REM el almacen de guias para ser reproducidas.
create or replace type almacenar_guias_t under solicitud_servicio_t(
	nombre_guia varchar(50),
	tema_guia varchar(50),
	categoria_guia varchar(30),
	codigo_materia_guia varchar(8),
	num_paginas number (4,1),
	archivo BFILE
);
/

REM Definicion del tipo Venta de Articulos de Papeleria: Es un tipo de solicitud
REM de servicio 
create or replace type venta_articulos_papeleria_t under solicitud_servicio_t(
	nombre_articulo varchar(20),
	descripcion_articulo varchar(60),
	cantidad_en_stock number (2)
);
/
REM Definicion de la asignatura 
create or replace type asignatura_t as object(
	codigo varchar(8),
	nombre varchar(30)
);
/

REM Definicion del tipo guia: Documento academico que puede ser almacenado y reproducido
create or replace type guia_t as object (
	nombre varchar(30),
	fecha date,
	tema varchar(30),
	categoria varchar(30),
	costo_reproduccion number(6,2),
	archivo BFILE,
	almacenar_guias ref almacenar_guias_t,
	asignatura ref asignatura_t
);
/

alter type reproduccion_documentos_t
	add attribute (guia_imprimir ref guia_t);
	
REM Definicion del tipo Curso: Datos basicos de un curso

create or replace type curso_t as object (
	codigo_curso varchar(7),
	nombre varchar(30),
	contenido varchar(100),
	descripcion varchar(140),
	costo number (10,2),
	cupos number(5),
	area varchar(10),
	nivel number(2),
	inscripcion_curso ref inscripcion_cursos_extension_t
) NOT FINAL;
/

REM Creacion de un atributo tipo REF para denotar la dependencia
REM de un curso al curso que lo precede.
alter type curso_t
	add attribute (curso_req ref curso_t) cascade;


REM Definicion del tipo horario
create or replace type horario_t as object (
    dias dia_t,
    horas hora_t,
    
    member function obtener_cursos return curso_t);
/
	
REM Definicion del tipo es_dictado: Representa el horario y trimestre en el que un curso especifico
REM es dictado
create or replace type es_dictado_t as object (
	curso ref curso_t,
	horario ref horario_t,
	trimestre varchar(10)
);
/

alter type libro_t
	add member function obtener_prest return prestamo_libros_t cascade;

REM Definicion del tipo profesor_extension: Datos personales de un profesor
create or replace type profesor_extension_t under persona_t (
    cedula varchar(10),
    nombre_completo varchar(30),
    
    member function obtener_cursos return curso_t
);
/

create or replace type idioma_t under curso_t(
  tipo varchar(40),
  fecha_prueba date
);
/

REM -----------------------------------------------
REM -----------------------------------------------
REM	DECLARACION DE TABLAS                        --
REM -----------------------------------------------
REM -----------------------------------------------

REM Definicion de la tabla Solicitud_Servicio

create table solicitud of solicitud_servicio_t (
	fecha_solicitud not null,
	dato_entrega not null,
	servicio_solicitado not null,
	solicitante not null
);
	
REM Definicion tabla Curso

create table curso of curso_t (
	codigo_curso primary key,
	nombre not null,
	contenido not null,
	descripcion not null,
	costo not null check (costo>=0),
	cupos not null check (cupos>=0),
	area not null,
	nivel not null check (0 <= nivel and nivel<=7),
	inscripcion_curso not null
);

create table idioma of idioma_t (
	tipo not null
);

REM Definicion de la tabla Asignatura

create table asignatura of asignatura_t (
	codigo not null,
	nombre not null,
	constraint pk_asignatura primary key (codigo)
);

	
REM Definicion de la tabla Guia

create table guia of guia_t(
	nombre not null,
	fecha not null,
	costo_reproduccion not null check (costo_reproduccion>=0),
    archivo not null,
	constraint pk_guia primary key (nombre));
	
REM Definicion de la tabla Persona
REM Se le agrega el conjunto de servicios que puede utilizar
REM esta persona
create table persona of persona_t (
	nombre not null,
	apellido not null,
	correo_electronico primary key,
	telefonos not null,
	edad null check (edad>=0),
	cedula_identidad null,
	direccion not null
)
	nested table servicios_p store as servicios_persona;

REM Tabla profesor no hace falta, dado que habria que repetir
REM el nested table de los servicios y generaria redundancia

create table servicio of servicio_t (
	nombre primary key,
	descripcion not null,
	precio check (precio>=0));

REM Nota: Prestamo y recarga fueron eliminadas por estar vacias

create table pago_arancel of pago_arancel_t (
constraint pk_pago primary key(tipo_arancel,descripcion));

create table reproduccion of reproduccion_documentos_t (
	numero_copias not null);
	
create table almacen_guias of almacenar_guias_t (
	nombre_guia not null,
	tema_guia not null,
	categoria_guia not null,
	archivo not null);
	
create table venta_articulos of venta_articulos_papeleria_t (
	nombre_articulo not null,
	descripcion_articulo not null,
	cantidad_en_stock not null check(cantidad_en_stock>=0));

create table libros of libro_t (
	titulo not null,
	codigo_ISBN primary key,
	autor not null,
	editorial not null,
	cantidad_ejemplares not null check(cantidad_ejemplares>=0));

create table recarga of recarga_saldo_t (
	solicitante not null
);


