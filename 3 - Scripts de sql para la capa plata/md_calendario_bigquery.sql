SELECT cast( date as date ) as fecha
FROM `lab-atp-374297.bpina.all_stocks_csv_files` 
where date is not null
group by date