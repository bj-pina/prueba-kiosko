import logging
import azure.functions as func
import pandas as pd
from azure.storage.filedatalake import DataLakeServiceClient
import snowflake.connector

def main():

    # Variables de configuración para Azure Data Lake
    account_name = "nombre_cuenta_azure_data_lake"
    file_system_name = "nombre_sistema_de_archivos"
    directory_name = "ruta_directorio_en_lake"
    credential = "valor_cadena_conexión" 
    # Realmente puede ser cualquier manera de autenticar, pero elegí la cadena de conexión por ser la más sencilla.

    # Configuración de Snowflake
    snowflake_account = "cuenta_snowflake"
    snowflake_user = "nombre_usuario"
    snowflake_password = "valor_contraseña"
    snowflake_database = "base_datos_kiosko"
    snowflake_schema = "schema_capa_bronce"
    # Lo único de lo que podríamos tener visibilidad es de guardar la tabla con un nombre adecuado al tipo de archivo que la crea
    snowflake_table = "all_stocks_csv_files"

    try:
        # Iniciamos la conexión a Azure Data Lake
        service_client = DataLakeServiceClient(account_url=f"https://{account_name}.dfs.core.windows.net", credential=credential)
        file_system_client = service_client.get_file_system_client(file_system=file_system_name)
        directory_client = file_system_client.get_directory_client(directory_name)

        # Se itera sobre el directorio para obtener en una lista todos los archivos csv.
        paths = directory_client.get_paths()
        csv_files = [path.name for path in paths if path.name.endswith(".csv")]

        # Leer archivos csv en el directorio e ingresar los dataframes a una lista
        dfs = []
        for file_name in csv_files:
            file_client = file_system_client.get_file_client(file_name)
            download = file_client.download_file()
            file_contents = download.readall()
            df = pd.read_csv(pd.compat.StringIO(file_contents.decode('utf-8')))
            dfs.append(df)
        # Consolidar los dataframes de la lista en uno solo
        combined_df = pd.concat(dfs, ignore_index=True)

        # Conexión a Snowflake
        snowflake_connection_data = snowflake.connector.connect(
            user=snowflake_user,
            password=snowflake_password,
            account=snowflake_account,
            database=snowflake_database,
            schema=snowflake_schema
        )
        cursor = snowflake_connection_data.cursor()

        # Crear tabla si no existe. Se elige el tipo de datos como varchar porque es el que menos problemas podría dar al momento de escribir
        # Y además en la capa de plata se puede cambiar el tipo de datos sin problemas.
        columns_sql = ", ".join([f"{col} VARCHAR" for col in combined_df.columns]) 
        create_table_sql = f"CREATE TABLE IF NOT EXISTS {snowflake_table} ({columns_sql})"
        cursor.execute(create_table_sql)

        # Escribir DataFrame en Snowflake
        for index, row in combined_df.iterrows():
            placeholders = ', '.join(['%s'] * len(row))
            columns = ', '.join(combined_df.columns)
            sql = f"INSERT INTO {snowflake_table} ({columns}) VALUES ({placeholders})"
            cursor.execute(sql, tuple(row))
        snowflake_connection_data.commit()

        return func.HttpResponse("Data successfully loaded into Snowflake.", status_code=200)

    except Exception as e:
        logging.error(f"Error al ejecutar la funcion: {e}")
        return func.HttpResponse(f"Se tuvo error al momento de ejecutar: {e}", status_code=500)

# Ejecución del código

if __name__ == "__main__":
    main()