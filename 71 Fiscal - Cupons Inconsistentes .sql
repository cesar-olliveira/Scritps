------------------------------------------------------------------------------------------------------------------------
-- DESCOBRIR A SITUAÇÃO DO CFOP PRODUTO NA INCONSISTÊNCIA --------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT (SUBSTR(SUBSTR(I.MOTIVO, INSTR(I.MOTIVO, ':', -1) + 2, 999),
                        1,
                        INSTR(SUBSTR(I.MOTIVO,
                                     INSTR(I.MOTIVO, ':', -1) + 2,
                                     999),
                              ',',
                              1) - 1)) CODIGO,
                C.NROEMPRESA,
                C.DTAEMISSAO,              
                C.CGO,
                U.CODTRIBUTACAO,
                U.SEQCUPOM,
                U.CFOP,
                U.SITUACAONF CST,
                C.CFECHAVEACESSO,
                P.DESCCOMPLETA,
                I.MOTIVO

  FROM RF_AUXCUPOMELETRONICO     C,
       RF_INCONSISTENC           I,
       RF_AUXCUPOMELETRONICOITEM U,
       MAP_PRODUTO               P
 WHERE C.SEQCUPOM = I.SEQNOTA
   AND C.SEQCUPOM = U.SEQCUPOM
   AND U.CODPRODUTO = P.SEQPRODUTO
   AND U.CODPRODUTO =
       (SUBSTR(SUBSTR(I.MOTIVO, INSTR(I.MOTIVO, ':', -1) + 2, 999),
               1,
               INSTR(SUBSTR(I.MOTIVO, INSTR(I.MOTIVO, ':', -1) + 2, 999),
                     ',',
                     1) - 1))
   AND C.NROEMPRESA IN (2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 32, 33, 34, 66)
   AND C.DTAEMISSAO BETWEEN '&DT1' AND '&DT2'
   AND EXISTS (SELECT 1
          FROM RF_INCONSISTENC I
         WHERE I.SEQNOTA = C.SEQCUPOM
           AND I.NROEMPRESA = C.NROEMPRESA
           AND I.IDENTTABELA = 'CFE')
 ORDER BY 3
--------------------------------------------------------------------------------------------------------------------------
-- RETORNA AS TIBUTACOES COM INCONSISTENCIA ---------------------------------------------------- COD + CGO + TRIBUTACAO --
--------------------------------------------------------------------------------------------------------------------------
 
SELECT DISTINCT (SUBSTR(SUBSTR(I.MOTIVO, INSTR(I.MOTIVO, ':', -1) + 2, 999),
                        1,
                        INSTR(SUBSTR(I.MOTIVO,
                                     INSTR(I.MOTIVO, ':', -1) + 2,
                                     999),
                              ',',
                              1) - 1)) CODIGO,
                              C.CGO,
                              U.CODTRIBUTACAO
                      
 FROM RF_AUXCUPOMELETRONICO C, RF_INCONSISTENC I, RF_AUXCUPOMELETRONICOITEM U
 WHERE C.SEQCUPOM = I.SEQNOTA
 AND C.SEQCUPOM = U.SEQCUPOM
 AND U.CODPRODUTO = (SUBSTR(SUBSTR(I.MOTIVO, INSTR(I.MOTIVO, ':', -1) + 2, 999),
                        1,
                        INSTR(SUBSTR(I.MOTIVO,
                                     INSTR(I.MOTIVO, ':', -1) + 2,
                                     999),
                              ',',
                              1) - 1))
   AND C.NROEMPRESA IN (2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 32, 33, 34, 66)
   AND C.DTAEMISSAO BETWEEN '&DT1' AND '&DT2'
   AND EXISTS (SELECT 1
          FROM RF_INCONSISTENC I
         WHERE I.SEQNOTA = C.SEQCUPOM
           AND I.NROEMPRESA = C.NROEMPRESA
           AND I.IDENTTABELA = 'CFE')
 ORDER BY 1
  
--------------------------------------------------------------------------------------------------------------------------
--- CORRIGE O CFOP NA TABELA ---------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------

UPDATE RF_AUXCUPOMELETRONICOITEM A ---------------------------------------- ALTERA PARA 5405
   SET A.CFOP = '5405'
 WHERE A.CFOP = '5102'
   AND A.VLRTOTOUTRA > '0'
   --AND A.SEQCUPOM in(23246899, 23248588)
   AND A.CODPRODUTO IN (1628208, 1628194)

UPDATE RF_AUXCUPOMELETRONICOITEM A ---------------------------------------- ALTERA PARA 5102
   SET A.CFOP = '5102'
 WHERE A.CFOP = '5405'
   AND A.VLRTOTOUTRA = '0'
--   AND A.SEQCUPOM in (23956999, 23957093)
   AND A.CODPRODUTO IN (1427652)

 UPDATE RF_AUXCUPOMELETRONICOITEM A ---------------------------------------- ALTERA CST
 SET A.SITUACAONF = '&CST_NEW'
 WHERE A.SITUACAONF = '&CST_OLD'
   --AND A.CFOP = '&CFOP'
   --AND A.SEQCUPOM = ''
   AND A.CODPRODUTO IN (12452, 1602675, 296811, 81051)


select * from RF_AUXCUPOMELETRONICOITEM A

------------------------------------------------------------------------------------------------------------------------- 
-- VERIFICAR INCONSISTÊNCIAS NO LVS - SAT ----------------------------------------------- (PASTA ERRO DA GZ) ------------
-------------------------------------------------------------------------------------------------------------------------

SELECT A.NROEMPRESA LOJA, A.HORA "DATA / HORA", A.RESUMO ERRO, A.DETALHE
  FROM GE_ESPECLOG A
 WHERE A.DATA = TRUNC(SYSDATE)
 ORDER BY 1;




SELECT SUM(LE.VALORVLRNF), LE.NRODOCUMENTO
  FROM MRL_LANCTOESTOQUE LE
 WHERE LE.NROEMPRESA = 34
   AND LE.NROECF = 110
   AND LE.DTAENTRADASAIDA = '14-sep-2018'
 GROUP BY LE.NRODOCUMENTO
 ORDER BY 2




------------------------------------------------------------------------------------------------------------------------- 
-- VERIFICAR INCONSISTÊNCIAS NO LVS - SAT ----------------------------------------------- (QDO NÃO GERA LV PUTTY) -------
-------------------------------------------------------------------------------------------------------------------------
--select '/retag/gera_log_gz '||to_char(a.dataproc,'dd')||' '||to_char(a.dataproc,'mm')||' '||to_char(a.dataproc,'yyyy')||' '||a.nroloja||' 0 '||a.pdv||' '||a.cupom2
select *
from 
(SELECT A.NROLOJA,
       A.PDV,
       A.CUPOM,
       A.CUPOM2,
       A.DATAPROC,
       A.VENDA_ARIUS,
       B.VENDA_VAREJO,
       C.VENDA_DISTR,
       A.VENDA_ARIUS - B.VENDA_VAREJO DIV_ARIUS_VAREJO,
       A.VENDA_ARIUS - C.VENDA_DISTR DIV_ARIUS_DISTR
  FROM (SELECT b."DataProc" DATAPROC,
               b."nroloja" NROLOJA,
               b."Pdv" PDV,
               c."numero_nfe" CUPOM,
               b."NroCupom" CUPOM2,
               SUM(b."total") VENDA_ARIUS
          FROM "cupom"@arius b, "nfce"@arius c
         WHERE b."DataProc" BETWEEN '&DT1' AND '&DT2'
           AND b."NroCupom" = c."NroCupom"
           and b."Pdv" = c."Pdv"
           and b."DataProc" = c."DataProc"
           and b."nroloja" = c."nroloja"
           AND b."codnoiva" <> 'P'
           AND b."nroloja" IN (&LOJA)
           AND b."Recebimento" <> 1
           AND b."RecargaCelular" <> 1
           AND b."FlagEstorno" <> 1
           AND b."tipooperacao" <> 12
           AND b."NroItens" <> 0
         GROUP BY b."DataProc", b."nroloja", b."Pdv", c."numero_nfe", b."NroCupom") A,
       (SELECT X.NROEMPRESA,
               X.DTAENTRADASAIDA,
               lpad(x.nroecf,3,0) nroecf,
               x.nrodocumento,
               SUM(X.VALORVLRNF) VENDA_VAREJO
          FROM MRL_LANCTOESTOQUE X
         WHERE X.NROEMPRESA IN (&PDV)
           AND X.CODGERALOPER IN (307, 309)
           AND X.DTAENTRADASAIDA BETWEEN '&DT1' AND '&DT2'
         GROUP BY X.NROEMPRESA, X.DTAENTRADASAIDA, x.nroecf, x.nrodocumento) B,
       (SELECT G.NROEMPRESA,
               G.DTAMOVIMENTO,
               lpad(g.nroecf,3,0) nroecf,
               g.numerodf,
               SUM(H.VLRITEM) - SUM(H.VLRDESCONTO) VENDA_DISTR
          FROM MFL_DOCTOFISCAL G, MFL_DFITEM H
         WHERE G.STATUSDF = 'V'
           AND G.NUMERODF = H.NUMERODF
           AND G.NROEMPRESA = H.NROEMPRESA
           AND G.NROSERIEECF = H.NROSERIEECF
           AND G.DTAMOVIMENTO BETWEEN '&DT1' AND '&DT2'
           AND G.NROEMPRESA IN (&PDV)
           AND H.STATUSITEM = 'V'
           AND G.CODGERALOPER IN (307, 309)
         GROUP BY G.NROEMPRESA, G.DTAMOVIMENTO, g.nroecf, g.numerodf) C
 WHERE A.NROLOJA = B.NROEMPRESA  
   AND A.NROLOJA = C.NROEMPRESA  
   AND A.DATAPROC = B.DTAENTRADASAIDA  
   AND A.DATAPROC = C.DTAMOVIMENTO  
   and a.pdv = b.nroecf  
   and a.pdv = c.nroecf  
   and a.cupom = b.nrodocumento  
   and a.cupom = c.numerodf  
--   AND A.PDV=41
ORDER BY 1, 2) a
where div_arius_varejo != 0

---------------------------------------------------------------------------------------------------
---- job 26 - Integração fiscal
---------------------------------------------------------------------------------------------------


declare
vddtaini date;
vddtafim date;

begin
for t in (select a.nroempresa, a.dtamovimento
from pdv_docto a
where a.indexportacaofisci = 'I'
and a.modelodf = '59'
group by a.nroempresa, a.dtamovimento
order by a.nroempresa, a.dtamovimento) loop
pkg_adm_integracao.sp_gera_c5corp_tribute_ecf(t.nroempresa,
t.dtamovimento,
'Max-Int');
commit;
end loop;

for t in (select distinct x.nroempresa from rf_auxcupomeletronico x) loop
select min(c.dtaemissao), max(c.dtaemissao)
into vddtaini, vddtafim
from rf_auxcupomeletronico c
where c.nroempresa = t.nroempresa;

pkg_rfintegracaocupomeletr.rfp_integrar(null,
'I',
t.nroempresa,
vddtaini,
vddtafim,
'Max-Int');

commit;

end loop;

end;
