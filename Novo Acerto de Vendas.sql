----------------------------------------------------------------------------------------------------
--- Insere os movimentos do taxi que ainda não subiram para tesouraria
----------------------------------------------------------------------------------------------------

INSERT INTO   FI_TSMOVENTRADAOUTROSOPER VV
SELECT 9 CODMOVIMENTO,
       2 NROEMPRESAME,
       X.CODOPERADOR,
       X.NROPDV,
       X.NROEMPRESA,
       X.NROTURNO,
       X.DTAMOVIMENTO,
       X.VLRLANCTO VALOR,
       'JOB-TI' USUALTERACAO,
       TRUNC(SYSDATE) DTAALTERACAO,
       S_FINANCEIRO.NEXTVAL SEQFINANCEIRO,
       'N' VERSAO,
       NULL NROCELULAR,
       NULL NROOPERADOR,
       NULL CODREDEOUTENT,
       NULL CODOPERADORAOUTENT,
       NULL SEQTITULO,
       0 QTDDOCS,
       NULL OPERADORORIGINAL,
       X.NRODOCUMENTO NROCUPOM,
       'N' GEROUTITULO,
       NULL NROPROCESSO,
       NULL SEQTITULODIRETO,
       NULL SEQPESSOA
       
FROM FI_TSNMOVIMENTODETALHADOIMP X
WHERE X.NROEMPRESA  IN (&Loja)
AND X.DTAMOVIMENTO= '&data'
AND X.TIPOREGISTRO='70'
AND X.NRODOCUMENTO NOT IN (SELECT VV.NROCUPOM FROM FI_TSMOVENTRADAOUTROSOPER VV WHERE VV.NROEMPRESA = X.NROEMPRESA AND VV.DTAMOVIMENTO = X.DTAMOVIMENTO AND VV.NROCUPOM = X.NRODOCUMENTO);



----------------------------------------------------------------------------------------------------
/* INSERT DE PAGAMENTO FATURAS VERAN CARD - MOVIMENTO 2 */
----------------------------------------------------------------------------------------------------
insert into fi_tsmoventradaoutrosoper
  select 2 codmovimento,
         2 nroempresamae,
         a.codoperador,
         a.nropdv,
         a.nroempresa,
         a.nroturno,
         a.dtamovimento,
         a.vlrlancto valor,
         'CASSORIELO' usualteracao,
         trunc(sysdate) dtaalteracao,
         a.seqfinanceiro,
         'N' versao,
        null nrocelular,
        null nrooperador,
        null codredeoutent,
        null codoperadoraoutent,
        null seqtitulo        
    from fi_tsnmovimentodetalhadoimp a
   where a.dtamovimento='&data_movimento'
     and a.nroempresa=&loja    
     and a.codmovimento in (3, 5, 12, 54, 55)
     and a.nroformapagto in (20, 21, 30)
    /* and a.seqfinanceiro not in
         (select seqfinanceiro from fi_tsmoventradaoutrosoper)*/;

COMMIT;  
         

----------------------------------------------------------------------------------------------------
/* INSERT DE PAGAMENTO FATURAS VERAN CARD - MOVIMENTO 2 */
----------------------------------------------------------------------------------------------------
insert into fi_tsmoventradaoutrosoper
  select 2 codmovimento,
         2 nroempresamae,
         a.codoperador,
         a.nropdv,
         a.nroempresa,
         a.nroturno,
         a.dtamovimento,
         a.vlrlancto valor,
         'CASSORIELO' usualteracao,
         trunc(sysdate) dtaalteracao,
         a.seqfinanceiro,
         'N' versao,
        null nrocelular,
        null nrooperador,
        null codredeoutent,
        null codoperadoraoutent,
        null seqtitulo        
    from fi_tsnmovimentodetalhadoimp a
   where a.dtamovimento='&data_movimento'
     and a.nroempresa=&loja    
     and a.codmovimento in (3, 5, 12, 54, 55)
     and a.nroformapagto in (20, 21, 30)
    /* and a.seqfinanceiro not in
         (select seqfinanceiro from fi_tsmoventradaoutrosoper)*/;

COMMIT;  
         
----------------------------------------------------------------------------------------------------
/* INSERT DE RECARGA DE CELULAR - MOVIMENTO 1 */
----------------------------------------------------------------------------------------------------          
--select * from fi_tsmoventradaoutrosoper
insert into fi_tsmoventradaoutrosoper
  select 1 codmovimento,
         2 nroempresamae,
         a.codoperador,
         a.nropdv,
         a.nroempresa,
         a.nroturno,
         a.dtamovimento,
         a.vlrlancto valor,
         'CASSORIELO' usualteracao,
         trunc(sysdate) dtaalteracao,
         a.seqfinanceiro,
         'N' versao,
          null nrocelular,
        null nrooperador,
        null codredeoutent,
        null codoperadoraoutent,
        null seqtitulo,
        null qtddocs,
        null operadororiginal,
        null nrocupom,
        'N' GEROUTITULO,
       NULL NROPROCESSO,
       NULL SEQTITULODIRETO,
       NULL SEQPESSOA      
 from fi_tsnmovimentodetalhadoimp a
   where a.dtamovimento='&data_movimento'
     and a.nroempresa in (&loja)
     and a.codmovimento in (4)
     and a.nroformapagto in (22)
     /*and a.seqfinanceiro not in
         (select seqfinanceiro from fi_tsmoventradaoutrosoper)*/;
         
COMMIT;

----------------------------------------------------------------------------------------------------
/* APAGA RECARGA DE CELULAR - MOVIMENTO 1 */
----------------------------------------------------------------------------------------------------   

DELETE fi_tsmoventradaoutrosoper
where DTAMOVIMENTO='&data'
and codmovimento = '1'
and nroempresa in (&loja)

----------------------------------------------------------------------------------------------------
/* VERIFICA DIFERENCA NAS VENDAS - APOS IMPORTACAO DE AMOVOP 1 */
---------------------------------------------------------------------------------------------------- 
SELECT A.DTAMOVIMENTO DATA,
       A.NROEMPRESA LOJA,
       A.NROPDV,
       A.CODOPERADOR,
       SUM(A.TOTAL) V_BRUTA_C5,
       SUM (X.VENDA_BRUTA) V_BRUTA_A,
       SUM(X.VENDA_BRUTA)-SUM(A.TOTAL) DIF
FROM FI_TSMOVTOOPERADOR A, AMOVOP X
WHERE A.DTAMOVIMENTO BETWEEN'&data' AND '&data'
AND X.LOJA(+)=A.NROEMPRESA
AND X.PDV(+)=A.NROPDV
AND X.DATA(+)=A.DTAMOVIMENTO
and x.operador(+)=a.codoperador
and x.loja not in (13,23,24,25,26,50)
GROUP BY A.DTAMOVIMENTO, A.NROEMPRESA, A.NROPDV, A.CODOPERADOR
HAVING SUM(NVL(X.VENDA_LIQUIDA,0))+SUM(NVL(X.CANCELAMENTOS,0))-SUM(A.TOTAL)<>0
ORDER BY 1, 2, 3;


----------------------------------------------------------------------------------------------------
/*INSTRUCAO PL/SQL PARA ACERTAR VENDA - APOS IMPORTACAO DO AMOVOP */ 
---------------------------------------------------------------------------------------------------- 
  Declare
  begin
    for t in (SELECT a.loja, 
                     a.pdv, 
                     a.operador,
                     A.DATA, 
                     a.venda_bruta, 
                     a.ind
                FROM AMOVOP a
               where a.ind is null
               order by 1, 2)
       loop
      update fi_tsmovtooperador l
         set l.total = t.venda_bruta
       where l.nroempresa = t.loja
         and l.nropdv = t.pdv
         AND l.dtamovimento = t.data
         and l.codoperador = t.operador;
      update AMOVOP z 
      set z.ind = 'X'
      WHERE Z.OPERADOR = T.OPERADOR;
      COMMIT;
  END LOOP;
  END;

---------------------------------------------------------------------------------------------------
/* VERIFICA SE HA VERANCARD LANÇADO */
---------------------------------------------------------------------------------------------------  

select * from fi_tsmoventradaoutrosoper
where nroempresa=6
and dtamovimento='03-jan-2011'
for update


----------------------------------------------------------------------------------------------------
/* ALTERACAO DE VENDA NO AMOVOP - INDIVIDUAL */
---------------------------------------------------------------------------------------------------- 
 
      
    select * from amovop
    where data='&data'
    and loja in(&Loja)
    FOR UPDATE
---------------------------------------------------------------------------------
/* ALTERACAO DE VENDA NO AMOVOP - INDIVIDUAL PDV */
------------------------------- ---------------------------------------------------------------------    
             
 
              	       select * from amovop
                      where data ='&data' 
                      and loja='&Loja'
                     and pdv in (&PDV)
                     -- and operador = 229
                      FOR UPDATE
                        
----------------------------------------------------------------------------------------------------
/* Corrigir venda direto na tabela fi_tsmovtooperador */
---------------------------------------------------------------------------------------------------- 

 select * from fi_tsmovtooperador
where nroempresa = &loja
and dtamovimento = '&data'
and nropdv = &PDV
for update
  
--------------------------------------------------------------------------------
/* NAO EXECUTAR !!!! - ALTERA PARA NULL OS LANCAMENTOS QUE ESTAO COM PARCELATEF=0 */
----------------------------------------------------------------------------------------------------  
UPDATE FI_TSMOVTOOPEDETALHE A
   SET A.QTDPARCELATEF = NULL
 WHERE A.ROWID IN (select B.ROWID
                     from fi_tsmovtooperador a, fi_tsmovtoopedetalhe b
                    where a.codoperador = b.codoperador
                      and a.nropdv = b.nropdv
                      and a.nroempresa = b.nroempresa
                      and a.dtamovimento = b.dtamovimento
                      and a.nroempresamae = b.nroempresamae
                      and a.nroturno = b.nroturno
                      and b.qtdparcelatef = 0);
                      
                      
----------------------------------------------------------------------------------------------------
/* ALTERA IND PARA NULL DE TODOS OS REGISTROS DA TABELA AMOVOP */
---------------------------------------------------------------------------------------------------- 
update amovop
set ind=null
where data='&data'
and loja in (&loja)

----------------------------------------------------------------------------------------------------
/* PACKAGE CAPTACAO GZ - UTILIZADO PARA PROCESSAMENTO DE VENDAS E INTEGRACAO COM TESOURARIA */
---------------------------------------------------------------------------------------------------- 
    begin
      sp_captacaogz(&loja);
      end;

------- Loja com SAT

BEGIN
    PKG_ESPECPDVGZ.SP_CAPTACAOGZACRUX(&loja);
END;
----------------------------------------------------------------------------------------------------
/* LIMPA AMOVOP */
----------------------------------------------------------------------------------------------------
delete from amovop
where data between '&data_inicial_exclusao' and '&data_final_exclusao'

----------------------------------------------------------------------------------------------------
/* LIMPA VENDA QUANDO PARA DE SUBIR */
----------------------------------------------------------------------------------------------------

 SELECT * FROM FI_TSNMOVIMENTODETALHADOIMP
 WHERE NROEMPRESA=2
 AND DTAMOVIMENTO='18-JAN-2011'
 FOR UPDATE
 
 ---------------------------------------------------------------------------------------------------
 
 select *
 from fi_tsmoventradaoutrosoper
 where dtamovimento ='22-jan-2011'
 
 
 select * from veran_status_ti
 
 -----------------------------------------------------------------------------------------------------
--- Verificar último LV processado
 -----------------------------------------------------------------------------------------------------
 
 SELECT nroempresa Loja, max (dtahoramovto) "Data/Hora"
 FROM MFL_CUPOMFISCAL
 WHERE dtamovimento=trunc(sysdate)
 group by nroempresa
 order by nroempresa;
 
-----------------------------------------------------------------------------------------------------
-- Select de status 
-----------------------------------------------------------------------------------------------------

select *
from veran_status_ti

-----------------------------------------------------------------------------------------------------
 --ALTERA INFORMACOES NUTRICIONAIS COM VIRGULA
-----------------------------------------------------------------------------------------------------

UPDATE MAP_INFNUTRICTAB A
SET A.DESCQTDPORCAO=REPLACE(A.DESCQTDPORCAO,',','.')
WHERE A.DESCQTDPORCAO LIKE '%,%'

----------------------------------------------------------------------------------------------------
---- Excluir reduções Z não importadas
----------------------------------------------------------------------------------------------------
select * from mfl_reducaoz
where nroempresa = 10
and dtamovimento = '05-nov-2012'
for update

---------------------------------------------------------------------------------------------------
---- job 26
---------------------------------------------------------------------------------------------------

begin
  for t in (select a.nroempresa, a.dtamovimento
              from pdvv_reducaoz a
             where indexportacao = 'I'
             group by a.nroempresa, a.dtamovimento) loop
    pkg_adm_integracao.sp_gera_c5corp_tribute_ecf(t.nroempresa,
                                                  t.dtamovimento,
                                                  null);
  
    commit;
  end loop;

  for x in (select distinct nroempresa from rf_auxcupmestre a) loop
    pkg_rfintegracaocupom.RFP_INTEGRAR(0,
                                       99999999999999,
                                       'I',
                                       x.nroempresa,
                                       '01-jan-1900',
                                       '31-jan-2999');
    commit;
  end loop;
end;

-------------------------------------------------------------------------------------------------------
-- Descobrir produto que teve o EAN excluso do sistema
-------------------------------------------------------------------------------------------------------

select *
from mfl_cupomfiscal
where codacesso = (&códigoEAN)
and dtamovimento > '01-jan-2014'

-------------------------------------------------------------------------------------------------------
-- Deletar pgto V card duplicado e recarga celular
-------------------------------------------------------------------------------------------------------
delete fi_tsmoventradaoutrosoper x
where x.nroempresa = and x.dtamovimento = '21-may-2011'
and x.usualteracao = 'CASSORIELO'

------------------------------------------------------------------------------------------------------
-- Deletar os movimentos Pgto Vcard que subiram errado
------------------------------------------------------------------------------------------------------

DELETE fi_tsmoventradaoutrosoper
where DTAMOVIMENTO='23-jun-2011'

     
-------------------------------------------------------------------------------------------------------
--  Alterar reduções para (I) em INDEXPORTACAO para subir
-------------------------------------------------------------------------------------------------------

select w.* from mfl_reducaoz w
where w.nroempresa in (&loja)
and w.dtamovimento in '&data'
and w.nroserieecf in  (select y.nroserieecf from mfl_ecf y
--where y.nroecf not in (&ECF) and y.status = 'A')
where y.nroecf in (&ECF) and y.status = 'A')
for update
  
select * from mfl_reducaozaliq b
where b.nroserieecf = 'EP091220000000005199'
and b.dtamovimento = '30-mar-2016'
-------------------------------------------------------------------------------------------------------
--  Alterar reduções de 1 dia para (I) em INDEXPORTACAO para subir
-------------------------------------------------------------------------------------------------------

update mfl_reducaoz w
set w.indexportacao = 'I'
where w.nroempresa in (&loja)
and w.dtamovimento in '&data'
and w.nroserieecf in  (select y.nroserieecf from mfl_ecf y
where y.nroecf not in (&ECF) and y.status = 'A')
--where y.nroecf in (&ECF) and y.status = 'A')

  
-------------------------------------------------------------------------------------------------------
--  Descobrir data da última redução Z - Por ECF
-------------------------------------------------------------------------------------------------------

SELECT NROEMPRESA, NROMAQUINA ECF, DTAEMISSAO, NROREDUCZ, VLRGTINICIO, VLRGTFINAL, NROSERIE
FROM rf_cupommestre
WHERE NROSERIE = (select y.nroserieecf 
                  from mfl_ecf y
                  where y.nroecf = (&ECF)
                  and y.nroempresa = (&NROEMPRESA)
                  and y.status = 'A')
AND  DTAEMISSAO BETWEEN '01-JAN-2010' AND SYSDATE
order by dtaemissao desc

-------------------------------------------------------------------------------------------------------
--  Descobrir data da última redução Z - Por número de série
-------------------------------------------------------------------------------------------------------
SELECT *
--SELECT NROEMPRESA, NROMAQUINA ECF, DTAEMISSAO
FROM rf_cupommestre
WHERE NROSERIE = '&Serie'
AND  DTAEMISSAO BETWEEN '01-JAN-2010' AND SYSDATE
order by dtaemissao desc


    
--------------------------------------------------------------------------------------------------------
-- Deletar cupom a + no consinco
--------------------------------------------------------------------------------------------------------
select sittributaria, sum (vlrunitario) from rf_auxcupomitem
where seqcupom in (select seqcupom from rf_auxcupmestre 
where dtaemissao = '28-sep-2011' and nroempresa = 10
and nromaquina = 15)
group by sittributaria
where coo = 432759
for update


select * from rf_inconsistenc a
where a.seqnota in (select seqcupom from rf_auxcupmestre
                   where nroempresa=&loja
                         and dtaemissao='&data'
                         and nromaquina=&ecf)
for update     


--------------------------------------------------------------------------------------------------------
-- Consultar Inconsistências no Fiscal
--------------------------------------------------------------------------------------------------------

select * from veran_ti_status2

---------------------------------------------------------------------- 
-- Verificar Inconsistências no LVs - SAT
----------------------------------------------------------------------

select *
from   ge_especlog a
where  a.data = '28-jul-2016'
order by a.hora desc;

---------------------------------------------------------------------- 
-- Captação GZ - SAT
----------------------------------------------------------------------
BEGIN
    PKG_ESPECPDVGZ.SP_CAPTACAOGZACRUX(&Loja);
END;

-------------------------------------------------------------------------------------------------------
--  Alterar reduções para (I) em INDEXPORTACAO para subir - Lojas com SAT
-------------------------------------------------------------------------------------------------------

select seqmovimento, nroempresa, dtamovimento, nroserieecf, nrocheckout, indexportacaofisci 
--select *
from pdv_movimento 
where nroempresa = &Loja
and dtamovimento = '&data'
--and nrocheckout in (&ECF) 
and nrocheckout not in (&ECF) 
--and indexportacaofisci = 'I'
for update


-------------------------------------------------------------------------------------------------------
--  Verificar inconsistências na integração Fiscal Lojas com SAT
-------------------------------------------------------------------------------------------------------
 
select *
from   ge_especlog a
where  a.data = '&data'
--where  a.data = '18-jan-2016'
and a.nroempresa= &Loja
order by a.hora desc;


select *
from   mrl_impacruxint_inconsist a
where  a.nroempresa = &Loja
--and    a.dtamovimento = trunc(sysdate)
and  a.dtamovimento = '&data';



---- ECFs não integrados

select * from veran_ti_status2 a
where a.TIPO_INCOSISTENCIA = 'CUPONS NAO INTEGRADOS'



----------------------------------------------------------------------

select * from pdv_docto a
where a.nrocheckout in (&PDV)
and a.nroempresa = &LOJA
and a.dtamovimento BETWEEN '&DATA1' AND '&DATA2' 
and a.numerodf = &CUPOM for update
AND A.VLRTOTDOCTO = '39.90'

and a.modelodf = '59';




-------------------------------------------------------------------------------------------------------
-- Encontrar Diferença Arius x Consinco - PDV
-------------------------------------------------------------------------------------------------------

SELECT A.NROEMPRESA, TO_CHAR(A.DATA,'DD/MM/YYYY') DATA, A.Pdv,  SUM(A.VENDA_LIQUIDA) VENDA_ARIUS, V.VENDA_LIQUIDA VENDA_CONSINCO, SUM(A.VENDA_LIQUIDA)-V.VENDA_LIQUIDA DIFERENCA
  FROM VERANARIUS_VENDAECF_PDV A,
       (SELECT X.NROEMPRESA, X.DTAENTRADASAIDA, LPAD(X.NROECF,3,0) NROECF, SUM(X.VALORVLRNF) VENDA_LIQUIDA
          FROM MRL_LANCTOESTOQUE X
         WHERE X.CODGERALOPER in (307,309)
           AND X.DTAENTRADASAIDA = '&DATA'
           AND X.NROEMPRESA = '&LOJA'
         GROUP BY X.NROEMPRESA, X.DTAENTRADASAIDA, X.NROECF) V
 WHERE A.DATA = V.DTAENTRADASAIDA
   AND A.NROEMPRESA = V.NROEMPRESA
   AND A.Pdv = V.NROECF
   AND A.data = '&DATA'
   AND A.nroempresa = '&LOJA'
   group by a.nroempresa, a.data, a.Pdv, v.venda_liquida
   order by 3
   
   
-------------------------------------------------------------------------------------------------------
-- Cancelamentos Arius
-------------------------------------------------------------------------------------------------------
   
   select a.nroempresa, sum(a.Cancelamentos) FROM VERANARIUS_VENDAECF_PDV A
   where a.data = '&data'
   group by a.nroempresa
   order by 1
   
   select * from VERANARIUS_VENDAECF_PDV b

   
