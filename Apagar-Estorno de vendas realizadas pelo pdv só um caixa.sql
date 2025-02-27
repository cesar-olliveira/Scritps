----Estorna de vendas realizadas pelo pdv só um caixa
----OLHAR CGOS FIXOS*******************************************************

DELETE RF_CUPOMPAGTO K
WHERE EXISTS ( SELECT 1 FROM RF_CUPOMMESTRE L
              WHERE L.SEQCUPOM = K.SEQCUPOM
              AND L.DTAEMISSAO between '&dtamovimento1' and '&dtamovimento2'
              AND L.NROEMPRESA = &nroempresa
              and l.nromaquina in (&nrocheckout));
             
DELETE RF_CUPOMITEM K
WHERE EXISTS ( SELECT 1 FROM RF_CUPOMMESTRE L
              WHERE L.SEQCUPOM = K.SEQCUPOM
              AND L.DTAEMISSAO between '&dtamovimento1' and '&dtamovimento2'
              AND L.NROEMPRESA = &nroempresa
              and l.nromaquina in (&nrocheckout));   
 
DELETE RF_CUPOMANALITICO K
WHERE EXISTS ( SELECT 1 FROM RF_CUPOMMESTRE L
              WHERE L.SEQCUPOM = K.SEQCUPOM
              AND L.DTAEMISSAO between '&dtamovimento1' and '&dtamovimento2'
              AND L.NROEMPRESA = &nroempresa
              and l.nromaquina in (&nrocheckout));

DELETE RF_CUPOMMESTRE K
WHERE  K.DTAEMISSAO between '&dtamovimento1' and '&dtamovimento2'
AND K.NROEMPRESA = &nroempresa
and k.nromaquina in (&nrocheckout);

delete
from   rf_cupomeletronicoitem b
where  b.seqcupom in (select a.seqcupom
                      from   rf_cupomeletronico a
                      where  a.nroempresa = &nroempresa
                      and    a.dtaemissao between '&dtamovimento1' and '&dtamovimento2'
                      and    a.nrocheckout in (&nrocheckout));
delete
from   rf_cupomeletronico a
where  a.nroempresa = &nroempresa
and    a.dtaemissao between '&dtamovimento1' and '&dtamovimento2'
and    a.nrocheckout in (&nrocheckout);

--TABELAS AUXILIARES DO FISCAL ---
             
DELETE RF_AUXCUPOMPAGTO K
WHERE EXISTS ( SELECT 1 FROM RF_AUXCUPMESTRE L
              WHERE L.SEQCUPOM = K.SEQCUPOM
              AND L.DTAEMISSAO between '&dtamovimento1' and '&dtamovimento2'
              AND L.NROEMPRESA = &nroempresa
              and l.nromaquina in (&nrocheckout));
             


DELETE RF_AUXCUPOMITEM K
WHERE EXISTS ( SELECT 1 FROM RF_AUXCUPMESTRE L
              WHERE L.SEQCUPOM = K.SEQCUPOM
              AND L.DTAEMISSAO between '&dtamovimento1' and '&dtamovimento2'
              AND L.NROEMPRESA = &nroempresa
              and l.nromaquina in (&nrocheckout));   
 
             
DELETE RF_AUXCUPANALIT K
WHERE EXISTS ( SELECT 1 FROM RF_AUXCUPMESTRE L
              WHERE L.SEQCUPOM = K.SEQCUPOM
              AND L.DTAEMISSAO between '&dtamovimento1' and '&dtamovimento2'
              AND L.NROEMPRESA = &nroempresa
              and l.nromaquina in (&nrocheckout));


DELETE FROM RF_INCONSISTENC K
WHERE K.Identtabela = 'CUP'
AND EXISTS  ( SELECT 1 FROM RF_AUXCUPMESTRE L
              WHERE L.SEQCUPOM = K.SEQNOTA
              AND L.DTAEMISSAO between '&dtamovimento1' and '&dtamovimento2'
              AND L.NROEMPRESA = &nroempresa
              and l.nromaquina in (&nrocheckout));


DELETE RF_AUXCUPMESTRE K
WHERE  K.DTAEMISSAO between '&dtamovimento1' and '&dtamovimento2'
AND K.NROEMPRESA = &nroempresa
and k.nromaquina in (&nrocheckout);

delete
from   rf_auxcupomeletronicoitem b
where  b.seqcupom in (select a.seqcupom
                      from   rf_cupomeletronico a
                      where  a.nroempresa = &nroempresa
                      and    a.dtaemissao between '&dtamovimento1' and '&dtamovimento2'
                      and    a.nrocheckout in (&nrocheckout));
delete
from   rf_auxcupomeletronico a
where  a.nroempresa = &nroempresa
and    a.dtaemissao between '&dtamovimento1' and '&dtamovimento2'
and    a.nrocheckout in (&nrocheckout);


--deleta tabelas de movimento do pdv
update pdv_movimento a
set    a.indexportacaocapitis = 'I',
       a.indexportacaofisci = 'I',
       a.indexportacaosm = 'I',
       a.seqexportacaofisci = null      
where  a.nroempresa = &nroempresa
and    a.dtamovimento between '&dtamovimento1' and '&dtamovimento2'
and    a.nrocheckout in (&nrocheckout); 

update pdv_docto a
set    a.indexportacaofisci = null,
       a.seqexportacaofisci = null,
       a.seqexportacaofiscicanc = null
where  a.nroempresa = &nroempresa
and    a.dtamovimento between '&dtamovimento1' and '&dtamovimento2'
and    a.nrocheckout in (&nrocheckout);       

delete
from   pdv_reducaozaliq a
where  a.seqreducao in (select b.seqreducao
                        from   pdv_reducaoz b, pdv_movimento c
                        where  b.seqmovimento = c.seqmovimento
                        and    c.nroempresa = &nroempresa
                        and    c.dtamovimento between '&dtamovimento1' and '&dtamovimento2'
                        and    c.nrocheckout in (&nrocheckout));
                       
delete
from   pdv_reducaoz a
where  a.seqmovimento in (select b.seqmovimento
                          from   pdv_movimento b
                          where  b.nroempresa = &nroempresa
                           and   b.dtamovimento between '&dtamovimento1' and '&dtamovimento2'
                           and   b.nrocheckout in (&nrocheckout));
                          
delete
from   pdv_movtofinanceiro a
where  a.seqmovimento in (select b.seqmovimento
                          from   pdv_movimento b
                          where  b.nroempresa = &nroempresa
                           and   b.dtamovimento between '&dtamovimento1' and '&dtamovimento2'
                           and   b.nrocheckout in (&nrocheckout)); 
                          
delete
from   pdv_doctopagto x
where  x.seqdocto in (select c.seqdocto
                          from   pdv_movimento b, pdv_docto c
                          where  b.seqmovimento = c.seqmovimento
                          and    b.nroempresa = &nroempresa
                           and   b.dtamovimento between '&dtamovimento1' and '&dtamovimento2'
                           and   b.nrocheckout in (&nrocheckout));  
                          
delete
from   pdv_doctoitem x
where  x.seqdocto in (select c.seqdocto
                          from   pdv_movimento b, pdv_docto c
                          where  b.seqmovimento = c.seqmovimento
                          and    b.nroempresa = &nroempresa
                           and   b.dtamovimento between '&dtamovimento1' and '&dtamovimento2'
                           and   b.nrocheckout in (&nrocheckout));
                          
update pdv_docto a
set    a.indexportacaofisci = 'I',
       A.STATUSDOCTO = 'X'
where  a.seqmovimento in (select b.seqmovimento
                          from   pdv_movimento b
                          where  b.nroempresa = &nroempresa
                           and   b.dtamovimento between '&dtamovimento1' and '&dtamovimento2'
                           and   b.nrocheckout in (&nrocheckout));                           
                          
delete
from   pdv_docto a
where  a.seqmovimento in (select b.seqmovimento
                          from   pdv_movimento b
                          where  b.nroempresa = &nroempresa
                           and   b.dtamovimento between '&dtamovimento1' and '&dtamovimento2'
                           and   b.nrocheckout in (&nrocheckout));

update  PDV_MOVIMENTO b
set     b.indexportacaofisci = null
where  b.nroempresa = &nroempresa
and   b.dtamovimento between '&dtamovimento1' and '&dtamovimento2'
and   b.nrocheckout in (&nrocheckout);
                                                                                                                            
delete
from   PDV_MOVIMENTO b
where  b.nroempresa = &nroempresa
and   b.dtamovimento between '&dtamovimento1' and '&dtamovimento2'
and   b.nrocheckout in (&nrocheckout);


DELETE MFL_CUPOMFISCAL A
 WHERE A.NROEMPRESA = &nroempresa
   AND A.DTAMOVIMENTO between '&dtamovimento1' and '&dtamovimento2'
  and   a.nrocheckout in (&nrocheckout);
COMMIT;    

--------------------------------------------------------------------
------------ daqui para baixo só deleta no comercial e não fiscal
--------------------------------------------------------------------

------ DELETANDO A REDUÇÃO Z E ALIQ ----

delete MRL_LANCTOESTOQUE A
 where A.CODGERALOPER in (307, 309)
   and a.nroempresa = &nroempresa
   and a.dtaentradasaida between '&dtamovimento1' and '&dtamovimento2'
 -- and a.nrodocumento in (&Cupom)
   and a.nroecf in (&nrocheckout);

commit;


delete from mfl_dfitem x
 where x.rowid in
       (select b.rowid
          from mfl_doctofiscal a, mfl_dfitem b, max_empresa c
         where b.numerodf = a.numerodf
           and b.seriedf = a.seriedf
           and b.nroempresa = a.nroempresa
           and b.nroserieecf = a.nroserieecf
           and c.nroempresa = a.nroempresa
           and a.nroempresa = &nroempresa
           and a.nrocheckout in (&nrocheckout)
          -- and a.numerodf in (&Cupom)
           and a.codgeraloper in (307, 309)/*nvl(c.cgoauxbaixapdv, c.cgobaixasaidapdv)*/
           and a.dtamovimento between '&dtamovimento1' and '&dtamovimento2');
           
commit;


delete from mfl_doctofiscal a
 where a.nroempresa = &nroempresa
   and a.dtamovimento between '&dtamovimento1' and '&dtamovimento2'
   and a.nrocheckout in (&nrocheckout)
   and a.codgeraloper in (307, 309)
  -- and a.numerodf in (&cupom)
       /*(select nvl(x.cgoauxbaixapdv, x.cgobaixasaidapdv)
          from max_empresa x
         where x.nroempresa = a.nroempresa)*/;


commit;      
/*
delete mrl_conveniocompra a
 where a.dtacompra between '&dtamovimento1' and '&dtamovimento2'
   and a.nroempresa = &nroempresa
   and a.nroserieecf = (select x.nroserieecf || to_char(sysdate, 'yyMMdd')
                        from   mfl_ecf x
                        where  x.nroempresa = &nroempresa
                        and    x.nroecf = &nroecf);


commit;*/
