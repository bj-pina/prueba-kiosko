SELECT a.Name as nombre_corto_empresa, 
b.Company as nombre_largo_empresa,
b.Country as pais_origen
FROM `lab-atp-374297.bpina.all_stocks_csv_files` as a
join `lab-atp-374297.bpina.auxiliar_md_empresa` as b
  on a.Name = b.Name
where a.Name is not null
group by a.Name, b.Company, b.Country