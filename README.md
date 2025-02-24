# prueba-kiosko
Contiene archivos y contenido relativo a un challenge técnico para Kiosko y la posición de Ingeniero de Datos.

Mi experiencia particular para ingeniería de datos se basa principalmente en la nube de google. Sin embargo, busqué en internet equivalentes de mi conocimiento 
para después construir una arquitectura con Azure, Snowflake y Airflow.

En general, independientemente de las herramientas utilizadas, mi idea principal es construir una arquitectura que en líneas generales hará esto:

1. Que los archivos csv sean cargados a un depósito abierto para los usuarios determinados donde puedan colocar sus archivos csv.
2. Realizar un proceso de ingesta de datos cuyo resultado final sea una tabla en la capa bronce.
3. Realizar una limpieza de datos y estandarización de nombres de columnas en la capa de plata.
4. Consolidar las tablas de la capa de plata en un modelo de estrella en la capa oro.
5. Construir los tableros de power bi empleando las tablas de la capa oro.

Entonces, lo presentado en este repositorio será resultado de mi investigación de cómo lograr eso utilizando Azure, Snowflake y Airflow.

Guía de entregables:

1- La presentación general de resultados es el archivo llamado "Presentación - Detalles Prueba.pptx"

2- La carpeta "1 - Modelo de datos - Diagrama" contiene el modelo de datos elegido. Este modelo de datos final es un modelo tipo estrella y se seleccionó porque se cree
que facilita la realización de consultas sobre la fact table (fact_stocks), además que al aislar las dimensiones de calendario y empresa, se puede enriquecer la información sobre esas dimensiones y aportarían más detalle a los posibles análisis.

3- La carpeta "2 - Proceso ETL Ingestión (capa bronce)" contiene tanto el código de python para realizar la ingestión de datos y el código de python para la creación del DAG.
Se seleccionó como herramienta de ingestión un código de python usando pandas montado sobre una Azure Function porque se asemeja a lo que he hecho con mis proyectos en la nube de google (recientemente creé un proceso de ETL para datos de walmart que consistía en un script de python montado sobre composer y orquestado con airflow).
Básicamente la intención es orquestar mediante un dag de airflow la detonación de un script que sea capaz de leer los datos en csv desde Azure Data Lake y los consolide en un solo dataframe de pandas, para luego escribir esta información como una tabla en snowflake.

Es importante aclarar que el enfoque de la capa bronce (la tabla final de snowflake con la información del dataframe) procura mantener la estructura y nombres del archivo de origen, para conservar la integridad de los datos fuente.

4- La carpeta "3 - Scripts de sql para la capa plata" contiene los scripts de sql como se ejecutarían en snowflake y también su versión de bigquery (son los archivos nombrados al final _bigquery). En esta capa se procura realizar limpieza de datos de las tablas de la capa bronce (eliminación de duplicados), pero también se puede enriquecer la información. Las dimensiones están marcadas con el prefijo de md_ y las fact tables están marcadas con el prefijo txn_. Siguiendo la nomenclatura a la que estoy acostumbrado en Tyson.

5- La carpeta "4 - Scripts de sql para la capa oro" contiene los scripts de sql como se ejecutarían en snowflake y también su versión de bigquery (son los archivos nombrados al final _bigquery). En esta capa se toman las tablas de la capa plata y se les crea una llave surrogada a las dimensiones para que cuando sean referenciadas en la fact table, solo se necesite hacer un join simple entre foreign keys de la fact table y surrogate keys de las dimensiones creadas.

Esto se eligió porque facilita las consultas (al solo tener que hacer join con una columna) y el crear surrogate keys en las dimensiones puede ayudar al almacenamiento de las mismas (por ejemplo, ciertas funcionalidades de la nube o tecnología de bases de datos permiten particionar la información de acuerdo a la columna con tipo de dato integer que menos se repita, que en este caso sería la surrogate key creada para las dimensiones).

6- Los insights obtenidos mediante consultas se presentan en el power point "Presentación - Detalles Prueba.pptx" y sus consultas para obtener dichos resultados están guardadas en la carpeta "5 - Insights y reporte".

Con gusto se puede profundizar en cualquiera de los puntos anteriormente mencionados en la llamada que se agendaría.
