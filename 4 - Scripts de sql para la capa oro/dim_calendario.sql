-- Se partieron de base las consultas de bigquery las cuales yo puedo ejecutar desde mi espacio en gcp y se hizo uso de la IA para 
-- cambiarlo a un formato de snowflake (como no he utilizado snowflake, espero que la respuesta de la IA sea correcta).


-- Crear la tabla si no existe
CREATE TABLE IF NOT EXISTS schema_capa_oro.dim_calendario (
    key_fecha DATE,
    fecha_extendida VARCHAR,
    dia_semana INTEGER,
    nombre_dia VARCHAR,
    anio INTEGER,
    mes INTEGER
);

-- Truncar la tabla si existe
TRUNCATE TABLE schema_capa_oro.dim_calendario;

-- Insertar los nuevos datos
INSERT INTO schema_capa_oro.dim_calendario (key_fecha, fecha_extendida, dia_semana, nombre_dia, anio, mes)
SELECT
    fecha as key_fecha,
    TO_VARCHAR(fecha, 'Day DD, Month YYYY') AS fecha_extendida,
    DAYOFWEEK(fecha) - 1 AS dia_semana,
    TO_VARCHAR(fecha, 'Day') AS nombre_dia,
    YEAR(fecha) AS anio,
    MONTH(fecha) AS mes
FROM
    "base_datos_snowflake"."schema_capa_plata"."md_calendario";
