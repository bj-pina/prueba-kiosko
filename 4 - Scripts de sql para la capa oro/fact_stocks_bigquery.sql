select fecha as key_fecha,
b.key_empresa,
precio_inicial_accion, precio_maximo_accion, precio_minimo_accion, precio_cierre_accion, numero_acciones
from `lab-atp-374297.bpina.txn_stocks` as a
join `lab-atp-374297.bpina.dim_empresa` as b
  on a.nombre_corto_empresa = b.nombre_corto_empresa
;