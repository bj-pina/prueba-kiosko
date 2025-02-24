-- Se partieron de base las consultas de bigquery las cuales yo puedo ejecutar desde mi espacio en gcp y se hizo uso de la IA para 
-- cambiarlo a un formato de snowflake (como no he utilizado snowflake, espero que la respuesta de la IA sea correcta).
-- Crear la tabla si no existe

CREATE TABLE IF NOT EXISTS schema_capa_plata.md_calendario (
    fecha DATE
);

-- Truncar la tabla si existe
TRUNCATE TABLE schema_capa_plata.md_calendario;

-- Insertar los nuevos datos
INSERT INTO schema_capa_plata.md_calendario (fecha)
SELECT CAST(date AS DATE) AS fecha
FROM "base_datos_snowflake"."schema_capa_bronce"."all_stocks_csv_files"
WHERE date IS NOT NULL
GROUP BY fecha;

