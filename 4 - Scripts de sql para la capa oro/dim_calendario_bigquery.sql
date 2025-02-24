SELECT 
  fecha as key_fecha,
  FORMAT_TIMESTAMP('%A %e, %B %Y', CAST( fecha AS TIMESTAMP)) AS fecha_extendida,
  EXTRACT(DAYOFWEEK FROM fecha) - 1 AS dia_semana,
  FORMAT_TIMESTAMP('%A', CAST( fecha AS TIMESTAMP)) AS nombre_dia,
  EXTRACT(YEAR FROM fecha) AS anio,
  EXTRACT(MONTH FROM fecha) AS mes
from `lab-atp-374297.bpina.md_calendario`
;