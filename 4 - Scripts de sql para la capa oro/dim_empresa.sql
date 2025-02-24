-- Se partieron de base las consultas de bigquery las cuales yo puedo ejecutar desde mi espacio en gcp y se hizo uso de la IA para 
-- cambiarlo a un formato de snowflake (como no he utilizado snowflake, espero que la respuesta de la IA sea correcta).

-- Crear la tabla si no existe
CREATE TABLE IF NOT EXISTS schema_capa_oro.dim_empresa (
    key_empresa INTEGER,
    nombre_largo_empresa VARCHAR,
    nombre_corto_empresa VARCHAR,
    pais_origen VARCHAR
);

-- Truncar la tabla si existe
TRUNCATE TABLE schema_capa_oro.dim_empresa;

-- Insertar los nuevos datos
INSERT INTO schema_capa_oro.dim_empresa (key_empresa, nombre_largo_empresa, nombre_corto_empresa, pais_origen)
SELECT
    ABS(HASH(nombre_corto_empresa)) as key_empresa,
    nombre_largo_empresa,
    nombre_corto_empresa,
    pais_origen
FROM
    "base_datos_snowflake"."schema_capa_plata"."md_empresa";
