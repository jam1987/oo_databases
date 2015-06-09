INSERT INTO servicio 
VALUES('Recarga de Saldo',
	   'Recarga del saldo utilizado para hacer uso de los servicios del comedor universitario.',
	   arrayPeriodo_t(periodo_t(SYSDATE,SYSDATE)), 
	   0.0 );
	   
INSERT INTO persona
VALUES ('Jesus', 
		'Martinez', 
		'jaxex706@gmail.com', 
		NULL, 
		'V20335803', 
		telefono_t('04241941110'), 
		direccion_t('Caracas'), 
		NULL, 
		cuentaArray_t(cuenta_t('1234', 100, 1)), 
		NULL, 
		NULL);

INSERT INTO recarga(monto_recarga, solicitante) VALUES (-4, (SELECT ref(p) FROM persona p WHERE correo_electronico = 'jaxex706@gmail.com'));