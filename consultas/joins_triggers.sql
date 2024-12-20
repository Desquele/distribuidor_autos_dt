/*
    JOINS
*/

/*
    1. Lista los nombres y apellidos de los empleados, junto con el nombre del departamento y
    municipio donde viven.
*/
SELECT 
    CONCAT(e.nombres,CONCAT(' ', e.apellidos)) AS "NOMBRE COMPLETO", 
    d.nombre AS "DEPARTAMENTO", 
    m.nombre AS "MUNICIPIO"
FROM 
    empleado e
INNER JOIN departamento_municipio dm 
    ON (e.id_departamento_municipio = dm.id_departamento_municipio)
INNER JOIN departamento d 
    ON (d.id_departamento = dm.id_departamento)
INNER JOIN municipio m 
    ON (m.id_municipio = dm.id_municipio);

/*
    2. Muestra el nombre completo del vendedor y el total de ventas realizadas por �l. 
    Incluye en la lista a los vendedores que no han realizado ventas
*/

SELECT 
    CONCAT(e.nombres,CONCAT(' ', e.apellidos)) AS "NOMBRE COMPLETO", 
    NVL(rdv.numero_ventas, 0) AS "Total ventas" 
FROM 
    empleado e
LEFT JOIN reporte_desempeno_vendedor rdv 
    ON (e.id_empleado = rdv.id_empleado);

/*
    3. Muestra el modelo, color, y a�o de cada veh�culo junto con el pa�s y continente donde se
    fabricaron.
*/
SELECT 
    v.modelo, 
    v.color, 
    v.ano, 
    lf.pais, 
    c.nombre AS "CONTINENTE"
FROM 
    vehiculo v
INNER JOIN lugar_fabricacion lf 
    ON (lf.id_lugar_fabricacion = v.id_lugar_fabricacion)
INNER JOIN continente c 
    ON (c.id_continente = lf.id_continente);

/*
    4. Crea un reporte que incluya el nombre del cliente, correo, y el seguro adquirido en su compra
*/
SELECT 
    CONCAT(c.nombres,CONCAT(' ', c.apellidos)) AS "NOMBRE COMPLETO", 
    c.correo, 
    s.nombre  
FROM 
    cliente c
INNER JOIN detalle_venta dv 
    ON (dv.id_cliente = c.id_cliente)
INNER JOIN seguro s 
    ON (s.id_seguro = dv.id_seguro);

/*
    5.Muestra el modelo del veh�culo, el a�o de fabricaci�n, 
    el cliente que lo compr�, y el kilometraje actual
*/
SELECT 
    v.modelo, 
    v.ano, 
    c.kilometro_inicial, 
    dv.kilometraje_actual, 
    CONCAT(cl.nombres,CONCAT(' ', cl.apellidos)) AS "NOMBRE COMPLETO"
FROM 
    vehiculo v
INNER JOIN calcamonia  c ON 
    (c.id_vehiculo = v.id_vehiculo)
INNER JOIN detalle_venta dv ON 
    (dv.id_calcamonia = c.id_calcamonia)
INNER JOIN cliente cl ON  
    (cl.id_cliente = dv.id_cliente);

/*
    SUBCONSULTAS
*/

/*
    1. Encuentra el nombre completo del empleado con el salario m�s alto.
*/
SELECT 
    CONCAT(e.nombres,CONCAT(' ', e.apellidos)) AS "NOMBRE COMPLETO",
    e.salario
FROM 
    empleado e
WHERE 
    salario = (SELECT MAX(salario) FROM empleado);
    
/*
    2. Identifica a los clientes que han realizado m�s de una compra. 
*/

SELECT 
    id_cliente, 
    COUNT(id_cliente) AS "TOTAL DE COMPRAS"
FROM 
    detalle_venta
WHERE 
    id_cliente IN (SELECT id_cliente FROM detalle_venta GROUP BY id_cliente HAVING COUNT(id_cliente) > 1)
GROUP BY 
    id_cliente;
    
/*
    3. Encuentra todos los veh�culos que tienen una personalizaci�n �nica
*/

SELECT 
    * 
FROM 
    vehiculo
WHERE 
    personalizacion IS NOT NULL 
AND 
    personalizacion 
IN (
      SELECT personalizacion 
      FROM vehiculo
      GROUP BY personalizacion
      HAVING COUNT(personalizacion) = 1
    );

/*
    4. Lista los detalles de ventas cuyo kilometraje actual es mayor 
    que el kilometraje promedio de todos los veh�culos vendidos.
*/

SELECT 
    * 
FROM 
    detalle_venta
WHERE 
    kilometraje_actual > (SELECT AVG(Kilometraje_actual) FROM detalle_venta);

/*
     5. Muestra el nombre completo y salario de los empleados cuyo salario 
     sea mayor al promedio de la empresa.
*/
SELECT 
    CONCAT(nombres, CONCAT(' ', apellidos)), 
    salario  
FROM 
    empleado
WHERE 
    salario > (SELECT AVG(salario) FROM empleado);
    
/*
    TRIGGERS
*/

/*
    1. Crea un trigger que registre en una tabla de auditor�a
    cualquier cambio en el salario de un empleado
*/

-- 1.1 Creaci�n de la tabla auditoria
CREATE TABLE auditoria (
    id_auditoria NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    usuario VARCHAR2(100) NOT NULL,
    fecha DATE NOT NULL,
    salario_anterior FLOAT NULL,
    salario_nuevo FLOAT NULL,
    accion VARCHAR2(20)
);

-- 1.2 creaci�n del trigger
CREATE OR REPLACE TRIGGER tr_control_auditoria
FOR INSERT OR UPDATE OR DELETE ON empleado
COMPOUND TRIGGER

    -- Declaraci�n de variables globales
    usuario VARCHAR2(100);
    fecha DATE;
    
    -- Inicializaci�n de variables globales
    BEFORE STATEMENT 
    IS
    BEGIN
        usuario := USER;
        fecha := SYSDATE;
    END BEFORE STATEMENT;
    
    AFTER EACH ROW
    IS
    BEGIN
        -- Cuando se inserta
        IF INSERTING THEN
            INSERT INTO auditoria (usuario, fecha, salario_anterior ,salario_nuevo,  accion)
            VALUES(usuario, fecha, 0, :NEW.salario, 'Insert');
        END IF;
        
        -- Cuando se actualiza el salario
         IF UPDATING('salario') THEN
            INSERT INTO auditoria (usuario, fecha, salario_anterior ,salario_nuevo,  accion)
            VALUES(usuario, fecha, :OLD.salario, :NEW.salario, 'Update');
        END IF;
        
        -- Cuando se elimina
        IF DELETING THEN
            INSERT INTO auditoria (usuario, fecha, salario_anterior ,salario_nuevo,  accion)
            VALUES(usuario, fecha, :OLD.salario, 0, 'Delete');
        END IF;
    END AFTER EACH ROW;
    
    
END;
/

/*
    2. Implementa un trigger que bloquee la inserci�n de ventas en 
    la tabla detalle_venta si el cliente tiene menos de 18 a�os.
*/

CREATE OR REPLACE TRIGGER tr_detalle_venta_restriccion
BEFORE INSERT ON detalle_venta
FOR EACH ROW
BEGIN
    -- Declaraci�n de variables
    DECLARE
        fecha_nacimiento_cliente date;
        fecha_actual date;
        edad_cliente number;
    BEGIN
        
        -- 1. Consulta para obtener la fecha de nacimiento del cliente
        SELECT 
            fecha_nacimiento
        INTO 
            fecha_nacimiento_cliente
        FROM 
            cliente 
        WHERE 
            id_cliente = :NEW.id_cliente;
        
        -- 2. Obtiene la fecha actual
        fecha_actual := sysdate;
        
        -- 3. Obteniendo la edad del cliente
        edad_cliente := TRUNC(MONTHS_BETWEEN(fecha_actual, fecha_nacimiento_cliente) / 12);
                
        -- 4. Si la edad del cliente es menor de 18 a�os, entonces se le notifica
        -- que no puede comprar porue es menor de edad
        IF edad_cliente < 18 THEN
            RAISE_APPLICATION_ERROR(-20080, 'No se puede efectuar la compra porque es menor de edad');
        END IF;
    

    END;
END;
/

-- Insertar cliente
INSERT INTO cliente (nombres, apellidos, fecha_nacimiento, correo, numero_celular, dui, licencia_conducir)
VALUES ('Douglas 2', 'Quele', DATE '2007-01-16', 'douglas16@example.com', '60422591', '8211231', 'N');

-- Insertar detalle_venta
INSERT INTO detalle_venta (id_cliente, id_seguro, id_calcamonia, kilometraje_actual, financiamiento) 
VALUES (11, 1, 5, 30000.5, 0);

/*
    3. Crea un trigger que cambie el campo estado_nuevo a 'N' en la tabla vehiculo al momento de
    realizar una venta
*/

CREATE OR REPLACE TRIGGER tr_cambio_estado_vehiculo
AFTER INSERT ON detalle_venta
FOR EACH ROW
BEGIN
    
    -- Declaraci�n de variables
    DECLARE
        id_vehiculo_obtenido NUMBER;
    BEGIN
                
        -- 1. Obtener el id del vehiculo
            SELECT
                id_vehiculo
            INTO
                id_vehiculo_obtenido
            FROM
                calcamonia
            WHERE
                id_calcamonia = :NEW.id_calcamonia;
                
        -- 2. Hacer la modificacion
            UPDATE 
                vehiculo
            SET 
                estado_nuevo = 'N'
            WHERE
                id_vehiculo = id_vehiculo_obtenido;
    END;
END;
/

INSERT INTO detalle_venta (id_cliente, id_seguro, id_calcamonia, kilometraje_actual, financiamiento) 
VALUES (2, 1, 6, 30000.5, 0);

/*
    4. Implementa un trigger que valide que el kilometraje_actual 
    en la tabla detalle_venta no sea menor al kilometro_inicial en la tabla calcamonia
*/

CREATE OR REPLACE TRIGGER tr_control_kilometraje
BEFORE INSERT ON detalle_venta
FOR EACH ROW
BEGIN
    
    -- Declaraci�n de variables
    DECLARE
        kilometraje_inicial_obtenido FLOAT;
        kilometraje_actual_obtenido FLOAT;
    BEGIN
      
        -- 1. Obtener el kilometro 
        kilometraje_actual_obtenido := :NEW.kilometraje_actual;
            
        -- 2. Obtener el kilometraje_inicial
        SELECT 
            kilometro_inicial
        INTO
            kilometraje_inicial_obtenido
        FROM
            calcamonia
        WHERE
            id_calcamonia = :NEW.id_calcamonia;
            
        -- 3. Verificar que el kilometraje_actual no sea menor al kilometraje_inicial
        IF  kilometraje_actual_obtenido < kilometraje_inicial_obtenido THEN
            RAISE_APPLICATION_ERROR(-20030, 'El kilometraje actual no puede ser menor que el inicial');
        END IF;
        
    END;
END;
/

INSERT INTO detalle_venta (id_cliente, id_seguro, id_calcamonia, kilometraje_actual, financiamiento) 
VALUES (2, 1, 5, 100.2, 0);

/*
     5. Implementa un trigger que valide la longitud al momento de insertar un municipio
*/
SELECT * FROM municipio;

CREATE OR REPLACE TRIGGER tr_municipio_longitud
BEFORE INSERT ON municipio
FOR EACH ROW
BEGIN
    -- Declaraci�n de variables
    DECLARE
        longitud NUMBER;
    BEGIN
        -- 1. Obtener la longitud sin espacios vacios en ambos lados
        longitud := LENGTH(TRIM(:NEW.nombre));
        
        -- 2. Validar que no sea mayor a 73 (columna definida a m�ximo 75 caracteres)
        IF longitud > 73 THEN
            RAISE_APPLICATION_ERROR(-20009, 'EL limite m�ximo de longitud es de 73 caracteres');
        END IF;
    END;
END;
/

INSERT INTO municipio (nombre)
VALUES ('Lorem ipsum dolor sit amet consectetur adipiscing elit sagittis donec Lor');
