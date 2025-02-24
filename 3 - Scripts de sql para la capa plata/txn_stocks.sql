-- Se partieron de base las consultas de bigquery las cuales yo puedo ejecutar desde mi espacio en gcp y se hizo uso de la IA para 
-- cambiarlo a un formato de snowflake (como no he utilizado snowflake, espero que la respuesta de la IA sea correcta).

-- Crear la tabla si no existe

CREATE TABLE IF NOT EXISTS schema_capa_plata.txn_stocks (
    fecha DATE,
    precio_inicial_accion FLOAT,
    precio_maximo_accion FLOAT,
    precio_minimo_accion FLOAT,
    precio_cierre_accion FLOAT,
    numero_acciones INTEGER,
    nombre_corto_empresa VARCHAR
);

-- Truncar la tabla si existe
TRUNCATE TABLE schema_capa_plata.txn_stocks;

-- Insertar los nuevos datos
INSERT INTO schema_capa_plata.txn_stocks (fecha, precio_inicial_accion, precio_maximo_accion, precio_minimo_accion, precio_cierre_accion, numero_acciones, nombre_corto_empresa)
SELECT
    CAST(date AS DATE) as fecha,
    CAST(open AS FLOAT) as precio_inicial_accion,
    CAST(high AS FLOAT) as precio_maximo_accion,
    CAST(low AS FLOAT) as precio_minimo_accion,
    CAST(close AS FLOAT) as precio_cierre_accion,
    CAST(volume AS INTEGER) as numero_acciones,
    Name as nombre_corto_empresa
FROM
    "base_datos_snowflake"."schema_capa_bronce"."all_stocks_csv_files"
WHERE
    date IS NOT NULL AND Name IS NOT NULL
GROUP BY
    date, open, high, low, close, volume, Name;
