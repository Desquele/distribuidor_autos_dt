-- Creando la base de datos
CREATE DATABASE distribuidor_autos_dt;

-- Utilizando la base de datos
use distribuidor_autos_dt;

-- Creando las diferentes tablas que contiene la base de datos
CREATE TABLE departamento (
    id_departamento INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(75) NOT NULL
);

CREATE TABLE municipio (
    id_municipio INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(75) NOT NULL
);

CREATE TABLE departamento_municipio (
    id_departamento_municipio INT IDENTITY(1,1) PRIMARY KEY,
    id_departamento INT NOT NULL FOREIGN KEY REFERENCES departamento(id_departamento),
    id_municipio INT NOT NULL FOREIGN KEY REFERENCES municipio(id_municipio)
);

CREATE TABLE puesto (
    id_puesto INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE empleado (
    id_empleado INT IDENTITY(1,1) PRIMARY KEY,
    id_departamento_municipio INT NOT NULL FOREIGN KEY REFERENCES departamento_municipio(id_departamento_municipio),
    id_puesto INT NOT NULL FOREIGN KEY REFERENCES puesto(id_puesto),
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    salario FLOAT NOT NULL
);

CREATE TABLE reporte_desempeno_vendedor (
    id_reporte_desempeno_vendedor INT IDENTITY(1,1) PRIMARY KEY,
    id_empleado INT NOT NULL FOREIGN KEY REFERENCES empleado(id_empleado),
    numero_ventas INT NOT NULL,
    total_comisiones MONEY NOT NULL
);

CREATE TABLE continente (
    id_continente INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE lugar_fabricacion (
    id_lugar_fabricacion INT IDENTITY(1,1) PRIMARY KEY,
    id_continente INT NOT NULL FOREIGN KEY REFERENCES continente(id_continente),
    fecha_fabricacion DATE NOT NULL,
    pais VARCHAR(75) NOT NULL
);

CREATE TABLE vehiculo (
    id_vehiculo INT IDENTITY(1,1) PRIMARY KEY,
    id_lugar_fabricacion INT NOT NULL FOREIGN KEY REFERENCES lugar_fabricacion(id_lugar_fabricacion),
    modelo VARCHAR(100) NOT NULL,
    ano INT NOT NULL,
    numero_puertas INT NOT NULL,
    color VARCHAR(75) NOT NULL,
    numero_cilindros INT NOT NULL,
    peso FLOAT NOT NULL,
    capacidad_personas INT NOT NULL,
    personalizacion VARCHAR(100),
    estado_nuevo BIT NOT NULL
);

CREATE TABLE tipo_garantia (
    id_tipo_garantia INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    precio FLOAT NOT NULL,
    duracion VARCHAR(30)
);

CREATE TABLE calcamonia (
    id_calcamonia INT IDENTITY(1,1) PRIMARY KEY,
    id_vehiculo INT NOT NULL FOREIGN KEY REFERENCES vehiculo(id_vehiculo),
    id_tipo_garantia INT NOT NULL FOREIGN KEY REFERENCES tipo_garantia(id_tipo_garantia),
    fecha_recibido DATE NOT NULL,
    kilometro_inicial FLOAT NOT NULL,
    precio_estandar FLOAT NOT NULL,
    fabricante VARCHAR(50) NOT NULL
);

CREATE TABLE medio_encontrado (
    id_medio_encontrado INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE potenciales_clientes (
    id_potenciales_clientes INT IDENTITY(1,1) PRIMARY KEY,
    nombres VARCHAR(75) NOT NULL,
    apellidos VARCHAR(75) NOT NULL,
    numero_celular VARCHAR(10) NOT NULL,
    correo VARCHAR(100) NOT NULL
);

CREATE TABLE detalle_potenciales_clientes (
    id_detalle_potenciales_clientes INT IDENTITY(1,1) PRIMARY KEY,
    id_potenciales_clientes INT NOT NULL FOREIGN KEY REFERENCES potenciales_clientes(id_potenciales_clientes),
    id_medio_encontrado INT NOT NULL FOREIGN KEY REFERENCES medio_encontrado(id_medio_encontrado),
    fecha DATE NOT NULL,
    mensaje_enviar VARCHAR(255) NOT NULL
);

CREATE TABLE seguro (
    id_seguro INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE cliente (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    correo VARCHAR(100) NOT NULL,
    numero_celular VARCHAR(20) NOT NULL,
    dui CHAR(10) NOT NULL,
    licencia_conducir BIT NOT NULL
);

CREATE TABLE detalle_venta (
    id_detalle_venta INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL FOREIGN KEY REFERENCES cliente(id_cliente),
    id_seguro INT NOT NULL FOREIGN KEY REFERENCES seguro(id_seguro),
    id_calcamonia INT NOT NULL FOREIGN KEY REFERENCES calcamonia(id_calcamonia),
    kilometraje_actual FLOAT NOT NULL,
    financiamiento BIT
);

CREATE TABLE factura (
    id_factura INT IDENTITY(1,1) PRIMARY KEY,
    id_detalle_venta INT NOT NULL FOREIGN KEY REFERENCES detalle_venta(id_detalle_venta),
    id_empleado INT NOT NULL FOREIGN KEY REFERENCES empleado(id_empleado),
    fecha_venta DATETIME NOT NULL,
    precio_de_venta FLOAT NOT NULL
);

CREATE TABLE informe_para_estado (
    id_informe_para_estado INT IDENTITY(1,1) PRIMARY KEY,
    id_detalle_venta INT NOT NULL FOREIGN KEY REFERENCES detalle_venta(id_detalle_venta),
    costo_licencia FLOAT NOT NULL,
    impuesto_venta FLOAT NOT NULL
);

CREATE TABLE encuesta_cliente (
    id_encuesta_cliente INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL FOREIGN KEY REFERENCES cliente(id_cliente),
    opinion_automovil VARCHAR(255) NOT NULL,
    opinion_distribuidor VARCHAR(255) NOT NULL,
    fecha_encuesta DATE NOT NULL
);
