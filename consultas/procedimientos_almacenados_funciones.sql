/*
    PROCEDIMIENTOS ALMACENADOS
*/
/*
    1. Crea un procedimiento que reciba como parámetro el ID de un empleado 
    y devuelva el total de ventas realizadas
*/

-- Función que permite conocer si existe un empleado
CREATE OR REPLACE FUNCTION existe_empleado
(
    -- Declaración de parametros
    id_empleado_obtenido empleado.id_empleado%TYPE
)
RETURN BOOLEAN
IS
    -- Declaración de variables
    cantidad_empleado PLS_INTEGER;
BEGIN

    -- Verificar si existe el id del empleado
    SELECT
        COUNT(*)
    INTO
        cantidad_empleado
    FROM 
        empleado
    WHERE 
        id_empleado = id_empleado_obtenido;
        
    -- Si la variable tiene un número entonces si existe el empleado y devuelve true
    IF cantidad_empleado > 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
        
END;
/

-- Procedimiento almacenado que permite saber las ventas realizadas por el empleado
CREATE OR REPLACE PROCEDURE ventas_realizadas_empleado_pkg
(
    -- Declaración de parametros
    id_empleado_obtenido IN empleado.id_empleado%TYPE
)
IS
    -- Declaración de variables
    total_ventas PLS_INTEGER;
BEGIN
    -- Comprobamos si existe el emplado, en caso que si exista
    -- se cuenta el número de ventas que tiene
    IF existe_empleado(id_empleado_obtenido) = TRUE THEN
    
        SELECT
            COUNT (id_factura)
        INTO
            total_ventas
        FROM
            factura
        WHERE
            id_empleado = id_empleado_obtenido;
            
        -- Mostramos el total de ventas
        DBMS_OUTPUT.PUT_LINE('El total de ventas del empleado es: ' || total_ventas);
    ELSE
        -- En caso no exista el id, significa que no existe el empleado y se notifica
        DBMS_OUTPUT.PUT_LINE('No existe el empleado según el id proporcionado');
    END IF;
    
EXCEPTION    
    -- Cuando ocurre un error que no está controlado 
    WHEN OTHERS THEN
            -- Mostrar un mensaje con el código de error y su descripción
            DBMS_OUTPUT.PUT_LINE('Código del error: ' || SQLCODE || ', Descripción: ' || SQLERRM);
END;
/


-- Probando el procedimiento 
SET SERVEROUTPUT ON
BEGIN
    -- Se manda a llamar el procedimiento
    ventas_realizadas_empleado_pkg(3);
END;
/

/*
    2. Escribe un procedimiento para insertar un nuevo cliente en la tabla cliente
*/
-- Función que verifica que el cliente sea mayor de edad
CREATE OR REPLACE FUNCTION mayor_edad_cliente
(
    -- Declaración de parametros
    fecha_nacimiento date
)
RETURN BOOLEAN
IS
    -- Declaración de variables
    fecha_actual DATE;
    edad_cliente PLS_INTEGER;
BEGIN
    -- Obtenemos la fecha actual
    fecha_actual := SYSDATE;
    
    -- Obtenemos la edad del futuro cliente cliente
    edad_cliente := TRUNC(MONTHS_BETWEEN(fecha_actual, fecha_nacimiento) / 12);
    
    -- Si la edad del cliente es mayor o igual a 18 significa que es mayor de esad
    IF edad_cliente >= 18 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
/
CREATE OR REPLACE PROCEDURE insertar_cliente_pkg
(
    -- Declaración de parametros
    nombres_obtenido IN cliente.nombres%TYPE,
    apellidos_obtenido IN cliente.apellidos%TYPE,
    fecha_nacimiento_obtenido IN cliente.fecha_nacimiento%TYPE,
    correo_obtenido IN cliente.correo%TYPE,
    numero_celular IN cliente.numero_celular%TYPE,
    dui IN cliente.dui%TYPE,
    licencia_conducir IN cliente.licencia_conducir%TYPE
)
IS
BEGIN
    -- Verificamos la edad del cliente y si tiene 18 o más años se procede a insertar
    IF mayor_edad_cliente(fecha_nacimiento_obtenido) = TRUE THEN
    
        INSERT INTO cliente (nombres, apellidos, fecha_nacimiento, correo, numero_celular, dui, licencia_conducir)
        VALUES (nombres_obtenido, apellidos_obtenido, fecha_nacimiento_obtenido, correo_obtenido, numero_celular, dui, licencia_conducir);
        
        DBMS_OUTPUT.PUT_LINE('Registro insertado');
    ELSE
        -- De lo contrario se notifica que debe de ser mayor de edad
        DBMS_OUTPUT.PUT_LINE('Debe de ser mayor de edad');
    END IF;
END;
/

-- Probando el procedimiento almacenado
SET SERVEROUTPUT ON
BEGIN
    
   -- insertar_cliente_pkg('Douglas', 'Quele', '16-11-2001', 'douglas.quele@example.com', 
   -- '1234567890', '0012345678', 'Y');
    
    -- Dirá que debe de ser mayor de edad. Fecha en que se realizó: 20/12/2024
    insertar_cliente_pkg('Enrique', 'Siguenza', '21-12-2006', 'enrique.Siguenza@example.com', 
    '2827238791', '0012345675', 'Y');
END;
/


SELECT * FROM cliente;
DELETE FROM cliente
WHERE id_cliente = 21;