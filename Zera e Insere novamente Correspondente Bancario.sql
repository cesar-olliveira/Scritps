--ZERA CORRESPONDENTE BANCARIO
update fi_tsmovtooperador a
set a.vlrbancario=0, a.qtdedocbancario=0
where a.rowid in (  
select rowid from fi_tsmovtooperador
where dtamovimento='&datamovimento'
and nroempresa in (&empresas))
and rowid not in (select b.rowid
                   from fi_tsnmovimentodetalhadoimp a, fi_tsmovtooperador b
                  where a.codoperador = b.codoperador
                    and a.nropdv = b.nropdv
                    and a.nroempresa = b.nroempresa
                    and a.nroturno = b.nroturno
                    and a.dtamovimento = b.dtamovimento
                    and a.dtamovimento = '&datamovimento'
                    and a.codmovimento in (5)
                    and a.nroempresa in (&empresas)
                    and a.nroformapagto in (23)
                    );
                    
commit;                    

--INSERE CORRESPONDENTE BANCARIO
DECLARE
BEGIN
  FOR vtLOOP IN (select count(*) qtde,
                        a.codoperador,
                        a.nropdv,
                        a.nroempresa,
                        a.nroturno,
                        a.dtamovimento,
                        sum(a.vlrlancto) valor,
                        b.rowid
                   from fi_tsnmovimentodetalhadoimp a, fi_tsmovtooperador b
                  where a.codoperador = b.codoperador
                    and a.nropdv = b.nropdv
                    and a.nroempresa = b.nroempresa
                    and a.nroturno = b.nroturno
                    and a.dtamovimento = b.dtamovimento
                    and a.dtamovimento = '&datamovimento'
                    and a.codmovimento in (5)
                    and a.nroformapagto in (23)
                  and a.nroempresa in (&empresas)
                  group by a.codoperador,
                           a.nropdv,
                           a.nroempresa,
                           a.nroturno,
                           a.dtamovimento,
                           b.rowid)
  
   LOOP
  
    UPDATE fi_tsmovtooperador a
       SET a.vlrbancario = vtLOOP.valor, a.qtdedocbancario = vtLOOP.qtde
     WHERE A.ROWID = vtLOOP.Rowid;
  
  END LOOP;

COMMIT;

END;
