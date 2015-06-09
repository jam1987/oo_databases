delete from persona where correo_electronico = 'gg@g.com';
delete from solicitud where deref(solicitante).correo_electronico = 'gg@g.com';
delete from servicio where nombre='Almacen de Guias';


insert into persona values ('grace', 'gimon', 'gg@g.com',SYSDATE,'20683336',telefono_t(123), direccion_t('casa'),1,cuentaArray_t(),1,servicios_t()); 

REM para agregar datos en una nested table se tiene que hacer un procedimiento

REM agregar servicio
insert into servicio values('Almacen de Guias', 'Servicio solicitado por profesores', arrayPeriodo_t(periodo_t(SYSDATE,SYSDATE)), 0.0);

REM agregar asignaturas

insert into asignatura values('CI-5311', 'Base de Datos II');
insert into asignatura values ('CI-4325', 'Traductores');


REM Agregar solicitud de servicio

insert into solicitud select SYSDATE, NULL, NULL, SYSDATE, NULL, ref(p) from persona p where correo_electronico = 'gg@g.com';


REM agregar almacenar guias
insert into almacen_guias(nombre_guia,
							tema_guia,
							categoria_guia,
							archivo) values ('Guia de Bebedores','Practica de calculo','Academico',
							BFILENAME('dir', 'SubconjuntoAImplementar.jpeg'));

REM hay que hacer el procedimiento de obtener las personas que pueden utilizar un servicio (de ser necesario
REM para algun trigger)






REM formas de insertar:
REM insert into values
REM insert into select 
