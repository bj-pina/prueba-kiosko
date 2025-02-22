# prueba-kiosko
Contiene archivos y contenido relativo a un challenge técnico para Kiosko y la posición de Ingeniero de Datos.

Mi experiencia particular para ingeniería de datos se basa principalmente en la nube de google. Sin embargo, busqué en internet equivalentes de mi conocimiento 
para después construir una arquitectura con Azure, Snowflake y Airflow.

En general, independientemente de las herramientas utilizadas, mi idea principal es construir una arquitectura que en líneas generales hará esto:

1. Que los archivos csv sean cargados a un depósito abierto para los usuarios determinados donde puedan depositar sus archivos csv.
2. Realizar un proceso de ingesta de datos cuyo resultado final sea una tabla en la capa bronce.
3. Realizar una limpieza de datos y estandarización de nombres de columnas en la capa de plata.
4. Consolidar las tablas de la capa de plata en un modelo de estrella en la capa oro.
5. Construir los tableros de power bi empleando las tablas de la capa oro.

Entonces, lo presentado en este repositorio será resultado de mi investigación de cómo lograr eso utilizando Azure, Snowflake y Airflow.
