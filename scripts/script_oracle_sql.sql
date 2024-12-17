SELECT 'DROP TABLE ' || table_name || ' CASCADE CONSTRAINTS;' AS cmd
FROM user_tables;




-- Creando las tablas
CREATE TABLE departamento (
    id_departamento NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(75) NOT NULL
);

CREATE TABLE municipio (
    id_municipio NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(75)
);

CREATE TABLE departamento_municipio (
    id_departamento_municipio NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    id_departamento NUMBER NOT NULL,
    id_municipio NUMBER NOT NULL,
    CONSTRAINT fk_departamento FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento),
    CONSTRAINT fk_municipio FOREIGN KEY (id_municipio) REFERENCES municipio(id_municipio)
);

CREATE TABLE puesto (
    id_puesto NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    descripcion VARCHAR2(255) NOT NULL
);

CREATE TABLE empleado (
    id_empleado NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    id_departamento_municipio NUMBER NOT NULL,
    id_puesto NUMBER NOT NULL,
    nombres VARCHAR2(100) NOT NULL,
    apellidos VARCHAR2(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    salario FLOAT NOT NULL,
    CONSTRAINT fk_departamento_municipio FOREIGN KEY (id_departamento_municipio) REFERENCES departamento_municipio(id_departamento_municipio),
    CONSTRAINT fk_puesto FOREIGN KEY (id_puesto) REFERENCES puesto(id_puesto)
);


CREATE TABLE reporte_desempeno_vendedor (
    id_reporte_desempeno_vendedor NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    id_empleado NUMBER NOT NULL,
    numero_ventas NUMBER NOT NULL,
    total_comisiones FLOAT NOT NULL,
    CONSTRAINT fk_empleado FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

CREATE TABLE continente (
    id_continente NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL
);

CREATE TABLE lugar_fabricacion (
    id_lugar_fabricacion NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    id_continente NUMBER NOT NULL,
    fecha_fabricacion DATE NOT NULL,
    pais VARCHAR2(75) NOT NULL,
    CONSTRAINT fk_continente FOREIGN KEY (id_continente) REFERENCES continente(id_continente)
);

CREATE TABLE vehiculo (
    id_vehiculo NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    id_lugar_fabricacion NUMBER NOT NULL,
    modelo VARCHAR2(100) NOT NULL,
    ano NUMBER NOT NULL,
    numero_puertas NUMBER NOT NULL,
    color VARCHAR2(75) NOT NULL,
    numero_cilindros NUMBER NOT NULL,
    peso FLOAT NOT NULL,
    capacidad_personas NUMBER NOT NULL,
    personalizacion VARCHAR2(100),
    estado_nuevo CHAR(1) NOT NULL,
    CONSTRAINT fk_lugar_fabricacion FOREIGN KEY (id_lugar_fabricacion) REFERENCES lugar_fabricacion(id_lugar_fabricacion)
);

CREATE TABLE tipo_garantia (
    id_tipo_garantia NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    precio FLOAT NOT NULL,
    duracion VARCHAR2(30)
);

CREATE TABLE calcamonia (
    id_calcamonia NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    id_vehiculo NUMBER NOT NULL,
    id_tipo_garantia NUMBER NOT NULL,
    fecha_recibido DATE NOT NULL,
    kilometro_inicial FLOAT NOT NULL,
    precio_estandar FLOAT NOT NULL,
    fabricante VARCHAR2(50) NOT NULL,
    CONSTRAINT fk_vehiculo FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo),
    CONSTRAINT fk_tipo_garantia FOREIGN KEY (id_tipo_garantia) REFERENCES tipo_garantia(id_tipo_garantia)
);

CREATE TABLE medio_encontrado (
    id_medio_encontrado NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL
);

CREATE TABLE potenciales_clientes (
    id_potenciales_clientes NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    nombres VARCHAR2(75) NOT NULL,
    apellidos VARCHAR2(75) NOT NULL,
    numero_celular VARCHAR2(10) NOT NULL,
    correo VARCHAR2(100) NOT NULL
);

CREATE TABLE detalle_potenciales_clientes (
    id_detalle_potenciales_clientes NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    id_potenciales_clientes NUMBER NOT NULL,
    id_medio_encontrado NUMBER NOT NULL,
    fecha DATE NOT NULL,
    mensaje_enviar VARCHAR2(255) NOT NULL,
    CONSTRAINT fk_potenciales_clientes FOREIGN KEY (id_potenciales_clientes) REFERENCES potenciales_clientes(id_potenciales_clientes),
    CONSTRAINT fk_medio_encontrado FOREIGN KEY (id_medio_encontrado) REFERENCES medio_encontrado(id_medio_encontrado)
);

CREATE TABLE seguro (
    id_seguro NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL
);

CREATE TABLE cliente (
    id_cliente NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    nombres VARCHAR2(100) NOT NULL,
    apellidos VARCHAR2(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    correo VARCHAR2(100) NOT NULL,
    numero_celular VARCHAR2(20) NOT NULL,
    dui CHAR(10) NOT NULL,
    licencia_conducir CHAR(1) NOT NULL
);

CREATE TABLE detalle_venta (
    id_detalle_venta NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    id_cliente NUMBER NOT NULL,
    id_seguro NUMBER NOT NULL,
    id_calcamonia NUMBER NOT NULL,
    kilometraje_actual FLOAT NOT NULL,
    financiamiento CHAR(1),
    CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_seguro FOREIGN KEY (id_seguro) REFERENCES seguro(id_seguro),
    CONSTRAINT fk_calcamonia FOREIGN KEY (id_calcamonia) REFERENCES calcamonia(id_calcamonia)
);

CREATE TABLE factura (
    id_factura NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    id_detalle_venta NUMBER NOT NULL,
    id_empleado NUMBER NOT NULL,
    fecha_venta TIMESTAMP NOT NULL,
    precio_de_venta FLOAT NOT NULL,
    CONSTRAINT fk_detalle_venta FOREIGN KEY (id_detalle_venta) REFERENCES detalle_venta(id_detalle_venta),
    CONSTRAINT fk_empleado_factura FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

CREATE TABLE informe_para_estado (
    id_informe_para_estado NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    id_detalle_venta NUMBER NOT NULL,
    costo_licencia FLOAT NOT NULL,
    impuesto_venta FLOAT NOT NULL,
    CONSTRAINT fk_detalle_venta_informe FOREIGN KEY (id_detalle_venta) REFERENCES detalle_venta(id_detalle_venta)
);

CREATE TABLE encuesta_cliente (
    id_encuesta_cliente NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    id_cliente NUMBER NOT NULL,
    opinion_automovil VARCHAR2(255) NOT NULL,
    opinion_distribuidor VARCHAR2(255) NOT NULL,
    fecha_encuesta DATE NOT NULL,
    CONSTRAINT fk_cliente_encuesta FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);


/*
    Inserci�n de datos
*/

-- INSERTAR REGISTROS EN LA TABLA departamento
INSERT INTO departamento (nombre) 
VALUES ('San Salvador');
INSERT INTO departamento (nombre) 
VALUES ('La Libertad');
INSERT INTO departamento (nombre) 
VALUES ('Santa Ana');
INSERT INTO departamento (nombre) 
VALUES ('Chalatenango');
INSERT INTO departamento (nombre) 
VALUES ('Usulut�n');

-- INSERTAR REGISTROS EN LA TABLA municipio
INSERT INTO municipio (nombre)
VALUES ('Antiguo Cuscatl�n');
INSERT INTO municipio (nombre)
VALUES ('Santa Tecla');
INSERT INTO municipio (nombre)
VALUES ('San Miguel');
INSERT INTO municipio (nombre)
VALUES ('Sonsonate');
INSERT INTO municipio (nombre)
VALUES ('Zacatecoluca');

-- INSERTAR REGISTROS EN LA TABLA departamento_municipio
INSERT INTO departamento_municipio (id_departamento, id_municipio) 
VALUES (1, 1);
INSERT INTO departamento_municipio (id_departamento, id_municipio) 
VALUES (1, 2);
INSERT INTO departamento_municipio (id_departamento, id_municipio) 
VALUES (2, 3);
INSERT INTO departamento_municipio (id_departamento, id_municipio) 
VALUES (3, 4);
INSERT INTO departamento_municipio (id_departamento, id_municipio) 
VALUES (4, 5);

-- INSERTAR REGISTROS EN LA TABLA 'puesto'
INSERT INTO puesto (nombre, descripcion)
VALUES ('Gerente', 'Encargado de dirigir la empresa.');
INSERT INTO puesto (nombre, descripcion)
VALUES ('Vendedor', 'Encargado de ventas.');
INSERT INTO puesto (nombre, descripcion)
VALUES ('Cajero', 'Encargado de realizar cobros.');
INSERT INTO puesto (nombre, descripcion)
VALUES ('Supervisor', 'Encargado de supervisar las operaciones.');
INSERT INTO puesto (nombre, descripcion)
VALUES ('Administrador', 'Encargado de la administraci�n.');

-- INSERTAR REGISTROS EN LA TABLA 'empleado'
INSERT INTO empleado (id_departamento_municipio, id_puesto, nombres, apellidos, fecha_nacimiento, salario) 
VALUES (1, 1, 'Carlos', 'Gonz�lez', TO_DATE('1985-05-15', 'YYYY-MM-DD'), 1200.00);
INSERT INTO empleado (id_departamento_municipio, id_puesto, nombres, apellidos, fecha_nacimiento, salario) 
VALUES (2, 2, 'Ana', 'Mart�nez', TO_DATE('1990-08-22', 'YYYY-MM-DD'), 800.00);
INSERT INTO empleado (id_departamento_municipio, id_puesto, nombres, apellidos, fecha_nacimiento, salario) 
VALUES (3, 3, 'Luis', 'P�rez', TO_DATE('1987-03-10', 'YYYY-MM-DD'), 700.00);
INSERT INTO empleado (id_departamento_municipio, id_puesto, nombres, apellidos, fecha_nacimiento, salario) 
VALUES (4, 4, 'Mar�a', 'L�pez', TO_DATE('1995-11-05', 'YYYY-MM-DD'), 950.00);
INSERT INTO empleado (id_departamento_municipio, id_puesto, nombres, apellidos, fecha_nacimiento, salario) 
VALUES (5, 5, 'Pedro', 'Ram�rez', TO_DATE('1980-02-25', 'YYYY-MM-DD'), 1000.00);

-- INSERTAR REGISTROS EN LA TABLA 'reporte_desempeno_vendedor'
INSERT INTO reporte_desempeno_vendedor (id_empleado, numero_ventas, total_comisiones) 
VALUES (2, 10, 150.00);
INSERT INTO reporte_desempeno_vendedor (id_empleado, numero_ventas, total_comisiones) 
VALUES (2, 20, 300.00);
INSERT INTO reporte_desempeno_vendedor (id_empleado, numero_ventas, total_comisiones) 
VALUES (3, 15, 225.00);
INSERT INTO reporte_desempeno_vendedor (id_empleado, numero_ventas, total_comisiones) 
VALUES (3, 5, 75.00);
INSERT INTO reporte_desempeno_vendedor (id_empleado, numero_ventas, total_comisiones) 
VALUES (4, 8, 120.00);

-- INSERTAR REGISTROS EN LA TABLA continente
INSERT INTO continente (nombre) VALUES ('Am�rica');
INSERT INTO continente (nombre) VALUES ('Europa');
INSERT INTO continente (nombre) VALUES ('Asia');
INSERT INTO continente (nombre) VALUES ('�frica');
INSERT INTO continente (nombre) VALUES ('Ocean�a');

-- INSERTAR REGISTROS EN LA TABLA lugar_fabricacion
INSERT INTO lugar_fabricacion (id_continente, fecha_fabricacion, pais) 
VALUES (1, DATE '2024-07-04', 'Estados Unidos');
INSERT INTO lugar_fabricacion (id_continente, fecha_fabricacion, pais) 
VALUES (2, DATE '2015-11-10', 'Alemania');
INSERT INTO lugar_fabricacion (id_continente, fecha_fabricacion, pais) 
VALUES (3, DATE '2023-09-23', 'Jap�n');
INSERT INTO lugar_fabricacion (id_continente, fecha_fabricacion, pais) 
VALUES (4, DATE '2021-04-16', 'Sud�frica');
INSERT INTO lugar_fabricacion (id_continente, fecha_fabricacion, pais) 
VALUES (5, DATE '2022-09-12', 'Australia');

-- INSERTAR REGISTROS EN LA TABLA vehiculo
INSERT INTO vehiculo (id_lugar_fabricacion, modelo, ano, numero_puertas, color, numero_cilindros, peso, capacidad_personas, personalizacion, estado_nuevo)
VALUES (7, 'Ford Mustang', 2022, 2, 'Rojo', 8, 1600.5, 4, 'Interior deportivo', 'Y');
INSERT INTO vehiculo (id_lugar_fabricacion, modelo, ano, numero_puertas, color, numero_cilindros, peso, capacidad_personas, personalizacion, estado_nuevo)
VALUES (8, 'BMW X5', 2021, 5, 'Negro', 6, 2400.7, 7, NULL, 'N');
INSERT INTO vehiculo (id_lugar_fabricacion, modelo, ano, numero_puertas, color, numero_cilindros, peso, capacidad_personas, personalizacion, estado_nuevo)
VALUES (9, 'Toyota Corolla', 2023, 4, 'Blanco', 4, 1400.3, 5, 'Pantalla t�ctil', 'Y');

-- INSERTAR REGISTROS EN LA TABLA tipo_garantia
INSERT INTO tipo_garantia (nombre, precio, duracion) VALUES ('Basica', 500.00, '1 a�o');
INSERT INTO tipo_garantia (nombre, precio, duracion) VALUES ('Extendida', 1200.00, '3 a�os');
INSERT INTO tipo_garantia (nombre, precio, duracion) VALUES ('Premium', 2000.00, '9 a�os');

-- INSERTAR REGISTROS EN LA TABLA calcamonia
INSERT INTO calcamonia (id_vehiculo, id_tipo_garantia, fecha_recibido, kilometro_inicial, precio_estandar, fabricante)
VALUES (5, 1, DATE '2022-06-01', 0.0, 500.00, 'Ford');
INSERT INTO calcamonia (id_vehiculo, id_tipo_garantia, fecha_recibido, kilometro_inicial, precio_estandar, fabricante)
VALUES (6, 2, DATE '2021-12-01', 5000.0, 1200.00, 'BMW');
INSERT INTO calcamonia (id_vehiculo, id_tipo_garantia, fecha_recibido, kilometro_inicial, precio_estandar, fabricante)
VALUES (7, 3, DATE '2023-02-01', 0.0, 2000.00, 'Toyota');

-- INSERTAR REGISTROS EN LA TABLA medio_encontrado
INSERT INTO medio_encontrado (nombre) VALUES ('Redes Sociales');
INSERT INTO medio_encontrado (nombre) VALUES ('Publicidad Televisiva');
INSERT INTO medio_encontrado (nombre) VALUES ('Recomendaci�n');

-- INSERTAR REGISTROS EN LA TABLA potenciales_clientes
INSERT INTO potenciales_clientes (nombres, apellidos, numero_celular, correo)
VALUES ('Carlos', 'Ram�rez', '1234567890', 'carlos.ramirez@example.com');
INSERT INTO potenciales_clientes (nombres, apellidos, numero_celular, correo)
VALUES ('Ana', 'L�pez', '0987654321', 'ana.lopez@example.com');

-- INSERTAR REGISTROS EN LA TABLA detalle_potenciales_clientes
INSERT INTO detalle_potenciales_clientes (id_potenciales_clientes, id_medio_encontrado, fecha, mensaje_enviar)
VALUES (1, 1, DATE '2023-07-10', 'Gracias por su inter�s, le contactaremos pronto.');
INSERT INTO detalle_potenciales_clientes (id_potenciales_clientes, id_medio_encontrado, fecha, mensaje_enviar)
VALUES (2, 3, DATE '2023-07-12', 'Un asesor se comunicar� con usted.');

-- INSERTAR REGISTROS EN LA TABLA seguro
INSERT INTO seguro (nombre) VALUES ('B�sico');
INSERT INTO seguro (nombre) VALUES ('Completo');
INSERT INTO seguro (nombre) VALUES ('Contra todo riesgo');

-- INSERTAR REGISTROS EN LA TABLA cliente
INSERT INTO cliente (nombres, apellidos, fecha_nacimiento, correo, numero_celular, dui, licencia_conducir)
VALUES ('Luis', 'Mart�nez', DATE '1990-05-10', 'luis.martinez@example.com', '1234567890', '0012345678', 'Y');
INSERT INTO cliente (nombres, apellidos, fecha_nacimiento, correo, numero_celular, dui, licencia_conducir)
VALUES ('Sof�a', 'P�rez', DATE '1985-08-15', 'sofia.perez@example.com', '0987654321', '0098765432', 'N');

-- INSERTAR REGISTROS EN LA TABLA detalle_venta
INSERT INTO detalle_venta (id_cliente, id_seguro, id_calcamonia, kilometraje_actual, financiamiento) 
VALUES (1, 2, 4, 15000.0, 1);
INSERT INTO detalle_venta (id_cliente, id_seguro, id_calcamonia, kilometraje_actual, financiamiento) 
VALUES (2, 1, 5, 30000.5, 0);

-- INSERTAR REGISTROS EN LA TABLA factura
INSERT INTO factura (id_detalle_venta, id_empleado, fecha_venta, precio_de_venta) 
VALUES (2, 1, TO_DATE('2024-09-01 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 25000.0);
INSERT INTO factura (id_detalle_venta, id_empleado, fecha_venta, precio_de_venta) 
VALUES (3, 4, TO_DATE('2024-09-02 09:15:00','YYYY-MM-DD HH24:MI:SS'), 35000.5);

-- INSERTAR REGISTROS EN LA TABLA informe_para_estado
INSERT INTO informe_para_estado (id_detalle_venta, costo_licencia, impuesto_venta) 
VALUES (2, 150.0, 2500.0);
INSERT INTO informe_para_estado (id_detalle_venta, costo_licencia, impuesto_venta)
VALUES (3, 200.0, 3500.0); 
INSERT INTO informe_para_estado (id_detalle_venta, costo_licencia, impuesto_venta)
VALUES (5, 100.0, 1500.0); 
INSERT INTO informe_para_estado (id_detalle_venta, costo_licencia, impuesto_venta)
VALUES (6, 180.0, 3000.0); 
INSERT INTO informe_para_estado (id_detalle_venta, costo_licencia, impuesto_venta)
VALUES (8, 120.0, 2000.0);

-- INSERTAR REGISTROS EN LA TABLA encuesta_cliente
INSERT INTO encuesta_cliente (id_cliente, opinion_automovil, opinion_distribuidor, fecha_encuesta) 
VALUES (1, 'Excelente desempe�o y dise�o moderno', 'Atenci�n muy profesional y r�pida', TO_DATE('2024-09-06', 'YYYY-MM-DD'));
INSERT INTO encuesta_cliente (id_cliente, opinion_automovil, opinion_distribuidor, fecha_encuesta) 
VALUES (2, 'Buena relaci�n calidad-precio', 'Distribuidor amable y resolutivo', TO_DATE('2024-09-07', 'YYYY-MM-DD'));

