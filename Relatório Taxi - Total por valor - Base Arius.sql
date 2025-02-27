 ------------------------------------------------------------------
 ---------- Relatório Taxi - Total por valor - Base Arius ----------
--------------------------------------------------------------------
 
 
 select nroloja,
	      COUNT(Valor),
        valor,
        sum(Valor)
from retag.receb_diversos
where codreceb = 2
and confirmada = 1
and dataproc BETWEEN '2024-07-07' and '2024-07-21'
group by nroloja, valor




/*
select              null T,
                    nroempresa Loja ,
                    count(valor) Quantidade,
                    valor, 
                    sum (valor) TOTAL
                    
from veranarius_receb_taxi
where dtamovimento between '#DT1' and '#DT2'
and nroempresa in (#LS1)
and codreceb = 2
group by nroempresa, valor, rollup (null)  
union
select  
      'TOTAL GERAL >>>',
      null,
      count(valor) Quantidade,   
       null,
       sum(valor) 
       
   
     
     from veranarius_receb_taxi
where dtamovimento between '#DT1' and '#DT2'
and nroempresa in (#LS1)
and codreceb = 2

 
     
order by 2 */




