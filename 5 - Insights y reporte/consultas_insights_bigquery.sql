-- No conozco mucho del índice S&P 500 pero de acuerdo a una consulta con la IA. Me dice que no tengo los elementos necesarios
-- para el cálculo del índice y no considero que le deba dar tanto peso a eso de momento, como es un challenge para demostrar habilidades.
-- Sabiendo esto, aún así sacaré insights de los datos con la información que se tiene.

/*
Ajunto respuesta de la IA:

Analicemos tu conjunto de datos y veamos si tienes todo lo necesario para calcular el índice S&P 500.

Información que tienes:

fecha: La fecha de cada registro.
nombre_corto_empresa: El símbolo bursátil de la empresa (por ejemplo, AAL).
precio_inicial_accion: El precio de apertura de la acción.
precio_maximo_accion: El precio máximo alcanzado por la acción durante el día.
precio_minimo_accion: El precio mínimo alcanzado por la acción durante el día.
precio_cierre_accion: El precio de cierre de la acción.
numero_acciones: El número de acciones negociadas durante el día.
Información que te falta:

Número de acciones en circulación (flotación libre):
Para calcular la capitalización de mercado de cada empresa, necesitas el número de acciones en circulación disponibles para el público (flotación libre). Este número puede cambiar con el tiempo debido a recompras de acciones, emisiones adicionales, etc.
Tu conjunto de datos actual solo incluye el número de acciones negociadas durante el día (volumen), que es diferente del número total de acciones en circulación.
Lista de empresas del S&P 500:
Necesitas saber qué empresas están incluidas en el S&P 500 en cada momento. La composición del índice cambia periódicamente.
Para poder realizar el calculo, solo se deben de incluir las empresas que pertenezcan al indice S&P 500.
Divisor del índice S&P 500:
El cálculo del S&P 500 requiere un divisor que se ajusta para reflejar cambios en la capitalización de mercado que no están relacionados con el rendimiento de las empresas (como divisiones de acciones o fusiones). Este divisor es específico del S&P 500 y no se puede calcular a partir de tu conjunto de datos.
En resumen:

Tu conjunto de datos proporciona información valiosa sobre los precios y volúmenes de las acciones.
Sin embargo, para calcular el índice S&P 500, necesitas información adicional sobre el número de acciones en circulación, la lista de empresas del S&P 500 y el divisor del índice.
*/

--======================================================================================================================================

-- Día de la semana en donde se negocian el mayor número de acciones en promedio. Independientemente 
-- de la empresa.

with cte_para_consultas as
(
  select c.key_fecha as fecha, c.anio, c.mes, c.dia_semana, c.nombre_dia, b.nombre_corto_empresa,
  a.precio_inicial_accion, a.precio_maximo_accion, a.precio_minimo_accion, a.precio_cierre_accion, 
  a.numero_acciones
  from `lab-atp-374297.bpina.fact_stocks` as a
  inner join `lab-atp-374297.bpina.dim_empresa` as b
    on b.key_empresa = a.key_empresa
  inner join `lab-atp-374297.bpina.dim_calendario` as c
    on c.key_fecha = a.key_fecha
),

dias as
(
  select sum(numero_acciones) as acciones_totales, nombre_dia, fecha
  from cte_para_consultas
  group by nombre_dia, fecha
)

select avg( acciones_totales ) as numero_promedio_acciones_totales, nombre_dia
from dias
group by nombre_dia
order by numero_promedio_acciones_totales desc
;

-- Con esto se concluye que el día viernes es el día en el que históricamente suele haber más actividad en cuanto 
-- a negociación de acciones.


--======================================================================================================================================
-- Top 3 de empresas más importantes por año

with cte_para_consultas as
(
  select c.key_fecha as fecha, c.anio, c.mes, c.dia_semana, c.nombre_dia, b.nombre_corto_empresa,
  a.precio_inicial_accion, a.precio_maximo_accion, a.precio_minimo_accion, a.precio_cierre_accion, 
  a.numero_acciones
  from `lab-atp-374297.bpina.fact_stocks` as a
  inner join `lab-atp-374297.bpina.dim_empresa` as b
    on b.key_empresa = a.key_empresa
  inner join `lab-atp-374297.bpina.dim_calendario` as c
    on c.key_fecha = a.key_fecha
),

precio_accion_promedio as
(
  select (precio_inicial_accion + precio_maximo_accion + precio_minimo_accion + precio_cierre_accion) / 4.0
  as precio_promedio_accion, numero_acciones, nombre_corto_empresa, fecha, anio, 
  (precio_inicial_accion + precio_maximo_accion + precio_minimo_accion + precio_cierre_accion) * numero_acciones / 4.0 as dinero_movilizado_x_dia
  from cte_para_consultas
)

select anio, nombre_corto_empresa, sum( dinero_movilizado_x_dia ) as dinero_total_x_anio
from precio_accion_promedio
group by anio, nombre_corto_empresa
qualify row_number() over ( partition by anio order by dinero_total_x_anio desc ) < 4
order by anio desc
;

--De acuerdo a los datos, AAPL sería la empresa más importante de 2013 a 2018, puesto que alcanzó el primer lugar en cuanto a 
--dinero movilizado en el año (compra y venta de acciones) en 5 de los años mostrados en la tabla.

--======================================================================================================================================
-- Top 10 de incrementos más importantes en ganancias por mes de las distintas empresas

with cte_para_consultas as
(
  select c.key_fecha as fecha, c.anio, c.mes, c.dia_semana, c.nombre_dia, b.nombre_corto_empresa,
  a.precio_inicial_accion, a.precio_maximo_accion, a.precio_minimo_accion, a.precio_cierre_accion, 
  a.numero_acciones
  from `lab-atp-374297.bpina.fact_stocks` as a
  inner join `lab-atp-374297.bpina.dim_empresa` as b
    on b.key_empresa = a.key_empresa
  inner join `lab-atp-374297.bpina.dim_calendario` as c
    on c.key_fecha = a.key_fecha
),

precio_accion_promedio as
(
  select (precio_inicial_accion + precio_maximo_accion + precio_minimo_accion + precio_cierre_accion) / 4.0
  as precio_promedio_accion, numero_acciones, nombre_corto_empresa, fecha, anio, mes,
  (precio_inicial_accion + precio_maximo_accion + precio_minimo_accion + precio_cierre_accion) * numero_acciones / 4.0 as dinero_movilizado_x_dia
  from cte_para_consultas
),

ganancias_x_mes as 
(
  select anio, mes, nombre_corto_empresa, sum( dinero_movilizado_x_dia ) as ganancias_monetarias_mensuales, count( * ) as numero_dias_x_mes
  from precio_accion_promedio
  group by  anio, mes, nombre_corto_empresa

),

estadisticas as 
(
select anio, mes, nombre_corto_empresa, ganancias_monetarias_mensuales, numero_dias_x_mes, lag( ganancias_monetarias_mensuales , 1 ) over ( partition by nombre_corto_empresa order by mes, anio  ) as ganancias_mes_anio_pasado,
lag( numero_dias_x_mes , 1 ) over ( partition by nombre_corto_empresa order by mes, anio  ) as dias_del_mes_anio_pasado,
( ganancias_monetarias_mensuales - lag( ganancias_monetarias_mensuales , 1 ) over ( partition by nombre_corto_empresa order by mes, anio  ) ) / lag( ganancias_monetarias_mensuales , 1 ) over ( partition by nombre_corto_empresa order by mes, anio  ) * 100.0 as incremento_respecto_anio_pasado
from ganancias_x_mes
)

select anio, mes, nombre_corto_empresa, ganancias_monetarias_mensuales,
ganancias_mes_anio_pasado, incremento_respecto_anio_pasado, 
row_number() over ( order by incremento_respecto_anio_pasado desc ) as ranking
from estadisticas
where ganancias_mes_anio_pasado is not null
and numero_dias_x_mes = dias_del_mes_anio_pasado
order by incremento_respecto_anio_pasado desc
limit 10
;

