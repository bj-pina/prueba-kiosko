-- Se partieron de base las consultas de bigquery las cuales yo puedo ejecutar desde mi espacio en gcp y se hizo uso de la IA para 
-- cambiarlo a un formato de snowflake (como no he utilizado snowflake, espero que la respuesta de la IA sea correcta).

-- Crear la tabla si no existe
CREATE TABLE IF NOT EXISTS schema_capa_oro.fact_stocks (
    key_fecha DATE,
    key_empresa NUMBER,
    precio_inicial_accion FLOAT,
    precio_maximo_accion FLOAT,
    precio_minimo_accion FLOAT,
    precio_cierre_accion FLOAT,
    numero_acciones INTEGER
);

-- Truncar la tabla si existe
TRUNCATE TABLE schema_capa_oro.fact_stocks;

-- Insertar los nuevos datos
INSERT INTO schema_capa_oro.fact_stocks (key_fecha, key_empresa, precio_inicial_accion, precio_maximo_accion, precio_minimo_accion, precio_cierre_accion, numero_acciones)
SELECT
    a.fecha as key_fecha,
    b.key_empresa,
    a.precio_inicial_accion,
    a.precio_maximo_accion,
    a.precio_minimo_accion,
    a.precio_cierre_accion,
    a.numero_acciones
FROM
    "base_datos_snowflake"."schema_capa_plata"."txn_stocks" as a
JOIN
    "base_datos_snowflake"."schema_capa_plata"."dim_empresa" as b ON a.nombre_corto_empresa = b.nombre_corto_empresa;
