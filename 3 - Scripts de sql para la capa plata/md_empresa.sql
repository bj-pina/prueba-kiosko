-- Se partieron de base las consultas de bigquery las cuales yo puedo ejecutar desde mi espacio en gcp y se hizo uso de la IA para 
-- cambiarlo a un formato de snowflake (como no he utilizado snowflake, espero que la respuesta de la IA sea correcta).

-- Si se toma de referencia únicamente el archivo crudo, md_empresa solo tendría una columna (nombre_corto_empresa). 
-- Pero lo que quiero plasmar aquí, es que en la capa plata podemos enriquecer la información además de hacer limpieza.

-- Crear la tabla si no existe

CREATE TABLE IF NOT EXISTS schema_capa_plata.md_empresa (
    nombre_corto_empresa VARCHAR,
    nombre_largo_empresa VARCHAR,
    pais_origen VARCHAR
);

-- Truncar la tabla si existe
TRUNCATE TABLE schema_capa_plata.md_empresa;

-- Insertar los nuevos datos
INSERT INTO mi_esquema.empresas_info (nombre_corto_empresa, nombre_largo_empresa, pais_origen)
SELECT
    a.Name as nombre_corto_empresa,
    b.Company as nombre_largo_empresa,
    b.Country as pais_origen
FROM
    "base_datos_snowflake"."schema_capa_bronce"."all_stocks_csv_files" as a
JOIN
    "base_datos_snowflake"."schema_capa_bronce"."auxiliar_md_empresa" as b ON a.Name = b.Name
WHERE
    a.Name IS NOT NULL
GROUP BY a.Name, b.Company, b.Country;