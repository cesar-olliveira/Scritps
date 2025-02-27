select distinct a.chapa matricula,
                a.nome,
                a.cpf,
                74.45 valor,
                a.CODCCU,
                decode(a.CODCCU,
                       96,
                       1,
                       92,
                       109,
                       91,
                       109,
                       90,
                       1,
                       89,
                       109,
                       88,
                       109,
                       87,
                       109,
                       85,
                       109,
                       83,
                       109,
                       82,
                       109,
                       81,
                       85,
                       80,
                       1,
                       79,
                       1,
                       70,
                       1,
                       60,
                       1,
                       527,
                       180,
                       526,
                       1,
                       525,
                       178,
                       524,
                       1,
                       523,
                       180,
                       522,
                       1,
                       521,
                       171,
                       520,
                       1,
                       519,
                       1,
                       518,
                       1,
                       517,
                       1,
                       516,
                       1,
                       515,
                       1,
                       514,
                       1,
                       513,
                       1,
                       512,
                       1,
                       511,
                       1,
                       510,
                       1,
                       509,
                       1,
                       508,
                       1,
                       507,
                       178,
                       506,
                       1,
                       505,
                       1,
                       504,
                       1,
                       503,
                       1,
                       502,
                       1,
                       501,
                       1,
                       500,
                       1,
                       50,
                       1,
                       40,
                       1,
                       23,
                       1,
                       20,
                       1,
                       112,
                       1,
                       111,
                       1,
                       100,
                       1,
                       10,
                       1,
                       538,
                       1,
                       000) Empresa
  from usu_v_cesmen a    --- VERIFICAR SE O CODIGO 936 ESTA NO FILTRO (NÃO TRAZER 936)
 where A.CALCULO = &CALCULO
   and a.CESTA = 'SIM'
   AND A.CODCCU NOT IN (99)
 order by 5, 1;
 
 
 ------------------------------------------------------------------------------------------------
 ------------------------------ Consulta tabela de Afastamento ----------------------------------
 ------------------------------------------------------------------------------------------------
 
select r.nomfun, e.numcad, e.datafa, e.sitafa from R038AFA e, R034FUN r
where e.datafa between '&dt1' and '&dt2'
and e.sitafa in (14, 64, 938, 82)
and e.numcad = r.numcad
and e.numemp = r.numemp
and e.tipcol = r.tipcol
and e.numcad in (12000808) -- (109094, 602421)

 ------------------------------------------------------------------------------------------------
 ------------------------------ Consulta Férias -------------------------------------------------
 ------------------------------------------------------------------------------------------------
 
select r.nomfun, e.numcad, e.datafa, e.sitafa from R038AFA e, R034FUN r
where e.datafa between '&dt1' and '&dt2'
and e.sitafa in (2)
and e.numcad = r.numcad
and e.numemp = r.numemp
and e.tipcol = r.tipcol


205631, 200732
centro de custo 510

select * from all_all_tables
WHERE table_name like '%AFA%'


select *
  from r066sit
 where datapu between '26-dec-2022' and '25-jan-2023'
   and codsit in (2)
   and numcad in (100180, 702447, 14000200, 205475, 901506, 9800004, 202406) 
   for update


select * from r066sit
where datapu between '26-dec-2022' and '25-jan-2023'
and numcad in (200774) --,602421
for update


select * from r066sit
where numcad in (200774)


select * from R034FUN
where sitafa = 936
nomfun like 'Silvana%Otavio%'
 numcad = 205719
-- and nomfun like 'Kevin%'
