SELECT date as fecha,	
cast( open as float64) as precio_inicial_accion,	
cast( high as float64) as precio_maximo_accion,	
cast( low as float64) as precio_minimo_accion,	
cast( close as float64) as precio_cierre_accion,	
cast( volume as int64) as numero_acciones,
Name as nombre_corto_empresa
FROM `lab-atp-374297.bpina.all_stocks_csv_files` 
where date is not null and Name is not null
group by date,	open,	high,	low,	close,	volume,	Name
;
