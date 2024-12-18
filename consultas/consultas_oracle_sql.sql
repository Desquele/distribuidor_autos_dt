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
    2. Muestra el nombre completo del vendedor y el total de ventas realizadas por él. 
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
    3. Muestra el modelo, color, y año de cada vehículo junto con el país y continente donde se
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
FROM cliente c
INNER JOIN detalle_venta dv 
    ON (dv.id_cliente = c.id_cliente)
INNER JOIN seguro s 
    ON (s.id_seguro = dv.id_seguro);

/*
    5.Muestra el modelo del vehículo, el año de fabricación, 
    el cliente que lo compró, y el kilometraje actual
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
    1. Encuentra el nombre completo del empleado con el salario más alto.
*/
SELECT 
    CONCAT(e.nombres,CONCAT(' ', e.apellidos)) AS "NOMBRE COMPLETO",
    e.salario
FROM 
    empleado e
WHERE 
    salario = (SELECT MAX(salario) FROM empleado);
    
/*
    Identifica a los clientes que han realizado más de una compra. 
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
    3. Encuentra todos los vehículos que tienen una personalización única
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
    que el kilometraje promedio de todos los vehículos vendidos.
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