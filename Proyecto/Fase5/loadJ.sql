insert into servicio values('Reproduccion de Documentos','Servicio solicitado por personas',arrayPeriodo_t(periodo_t(SYSDATE,SYSDATE)), 0.0 );

insert into reproduccion(fecha_solicitud,precio,modo_pago,dato_entrega,servicio_solicitado,solicitante,numero_copias,archivo_imprimir,blanco_negro,numero_paginas,guia_imprimir) values(SYSDATE, NULL, NULL, NULL, NULL,NULL, 1,NULL,NULL,NULL, (select ref(g) from guia g where nombre = 'Guia de Bebedores'));