-------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------ TABELÃO ---------------------------------- ATUALIZADO 27/08/2024  ------------
-------------------------------------------------------------------------------------------------------------------------------------

SELECT  AA.NROEMPRESA,
        AA.DATA,
        AA.SEQFAMILIA,
        AA.SEQPRODUTO,
        AA.FAMILIA,
        AA.DESCCOMPLETA PRODUTO,
        AA.PADRAOEMBCOMPRA,
        AA.PADRAOEMBTRANSF,
        AA.COMPRADOR,
        AA.SEQFORNECEDOR,
        AA.FORNECEDOR,
        AA.COD1,
        AA.NIVEL1,
        AA.COD2,
        AA.NIVEL2,
        AA.COD3,
        AA.NIVEL3,
        AA.COD4,
        AA.NIVEL4,
        AA.COD5,
        AA.NIVEL5,
        AA.ABC_VALOR CURVA_ABC,
        AA.FORMAABASTEC,
        AA.SENSIBILIDADE,
        AA.MEDVDIAGERAL MEDVDIAGERAL2 ,
        AA.ESTOQUE,
        AA.DTAULTCOMPRA,
     --   1 TOTAL,
     --   CASE WHEN AA.ESTOQUE = 0 THEN 1 ELSE 0 END RUPTURA,
      nvl(AA.NROPEDIDO, (SELECT MAX(AAA.nropedidosuprim) FROM MACV_PSITEMRECEBER AAA
          WHERE AAA.seqproduto =  AA.seqproduto
          AND AAA.nroempresa = 1
          AND AAA.QTDSOLICITADA - AAA.QTDRECEBIDA - AAA.QTDCANCELADA <> 0
           AND AAA.TIPPEDIDOSUPRIM = 'C'
           AND (AAA.QTDSALDO - AAA.QTDTRANSITO) > 0
           AND AAA.DTAEMISSAO BETWEEN '01-jan-2020' AND trunc(sysdate-1) 
            ))NROPEDIDO,
      /*  (SELECT MAX(AAA.nropedidosuprim) FROM MACV_PSITEMRECEBER AAA
          WHERE AAA.seqproduto =  AA.seqproduto
          AND AAA.nroempresa = 1
          AND AAA.QTDSOLICITADA - AAA.QTDRECEBIDA - AAA.QTDCANCELADA <> 0
           AND AAA.TIPPEDIDOSUPRIM = 'C'
           AND (AAA.QTDSALDO - AAA.QTDTRANSITO) > 0
           AND AAA.DTAEMISSAO BETWEEN '01-jan-2020' AND trunc(sysdate-1) 
            )NROPEDIDOCD, */
        DTAEMISSAOPEDIDO  
        
FROM (        
        
SELECT B.*, A.ESTOQUE, A.DATA      
FROM CONSINCO.VERAN_VW_BASE_RUPTURAHISTMP A,
(
SELECT R.NROEMPRESA,
       B.SEQPRODUTO,
       B.SEQFAMILIA,
       J.FAMILIA,
       B.DESCCOMPLETA,
       B.DESCREDUZIDA,
       C.PADRAOEMBCOMPRA,
       C.PADRAOEMBTRANSF,
       F.APELIDO COMPRADOR,
       G.SEQFORNECEDOR,
       LPAD(H.NROCGCCPF, 12, 0) || LPAD(H.DIGCGCCPF, 2) CNPJFORNEC,
       H.NOMERAZAO FORNECEDOR,
       NVL(G.INDINDENIZAVARIA, 'N') INDINDENIZAVARIA,
       D.SEQCATEGORIA,
       E.COD1,
       E.NIVEL1,
       E.ESTQ1,
       E.COD2,
       E.NIVEL2,
       E.ESTQ2,
       E.COD3,
       E.NIVEL3,
       E.ESTQ3,
       E.COD4,
       E.NIVEL4,
       E.ESTQ4,
       E.COD5,
       E.NIVEL5,
       E.ESTQ5,
       C.FORMAABASTECIMENTO CODFORMAABASTEC,
       I.DESCRICAO FORMAABASTEC,
       K.PZOMEDVISITAREP,
       K.PZOMEDATRASO,
       K.PZOMEDENTREGA,
       B.DTAHORINCLUSAO,
       R.DTAULTCOMPRA,
       NVL(R.CLASSEABASTVLR, 'X') ABC_VALOR,
       R.MEDVDIAGERAL,
       TRUNC(SYSDATE) - R.DTAULTVENDA DIASSEMVENDA,
       CASE
         WHEN TRUNC(B.DTAHORINCLUSAO) >= TRUNC(SYSDATE - 30) AND
              R.ESTQLOJA = 0 THEN
          'N'
         ELSE
          'S'
       END CONTRUPT,

       NVL((SELECT SS.DESCRICAO FROM MAP_SENSIBILIDADE SS WHERE SS.SEQSENSIBILIDADE = R.SEQSENSIBILIDADE),'NORMAL') SENSIBILIDADE,
       CASE WHEN (SELECT SS.DESCRICAO FROM MAP_SENSIBILIDADE SS WHERE SS.SEQSENSIBILIDADE = R.SEQSENSIBILIDADE)='NORMAL' THEN 'NORMAL'
         WHEN (SELECT SS.DESCRICAO FROM MAP_SENSIBILIDADE SS WHERE SS.SEQSENSIBILIDADE = R.SEQSENSIBILIDADE)<> 'NORMAL' THEN 'COMPETITIVIDADE'
         ELSE 'NORMAL' END COMPETITIVIDADE,
         
          VERAN_F_ULTPEDCOMPPEND2(R.NROEMPRESA, B.SEQPRODUTO, 'N') NROPEDIDO,
          VERAN_F_ULTPEDCOMPPEND2(R.NROEMPRESA, B.SEQPRODUTO, 'E') DTAEMISSAOPEDIDO
         
         
     /*  NVL((SELECT MAX(CC.nropedidosuprim)
                   FROM MACV_PSITEMRECEBER CC, msu_pedidosuprim DD 
                   WHERE  CC.QTDSOLICITADA - CC.QTDRECEBIDA - CC.QTDCANCELADA <> 0
                 --   AND CC.TIPPEDIDOSUPRIM = 'C'
                    AND (CC.QTDSALDO - CC.QTDTRANSITO) > 0
                    AND DD.NROPEDIDOSUPRIM = CC.nropedidosuprim
                    AND CC.centralloja = DD.CENTRALLOJA
                    AND DD.NROEMPRESA = R.NROEMPRESA
                      AND CC.seqproduto = B.SEQPRODUTO 
                      AND CC.seqcomprador = F.SEQCOMPRADOR 
                        ),0 )NROPEDIDO  */
                         
         
         
  FROM MAP_PRODUTO B,
       MAP_FAMDIVISAO C,
       MAP_FAMDIVCATEG D,
       MAX_COMPRADOR F,
       (SELECT N1.SEQ1       COD1,
               N1.CATEGORIA1 NIVEL1,
               N1.ESTQ1,
               N2.SEQ2       COD2,
               N2.CATEGORIA2 NIVEL2,
               N2.ESTQ2,
               N3.SEQ3       COD3,
               N3.CATEGORIA3 NIVEL3,
               N3.ESTQ3,
               N4.SEQ4       COD4,
               N4.CATEGORIA4 NIVEL4,
               N4.ESTQ4,
               N5.SEQ5       COD5,
               N5.CATEGORIA5 NIVEL5,
               N5.ESTQ5
          FROM (SELECT SEQCATEGORIA     SEQ1,
                       SEQCATEGORIAPAI  SEQPAI1,
                       CATEGORIA        CATEGORIA1,
                       NIVELHIERARQUIA  NIVELHIERARQUIA1,
                       QTDPADRAODIAESTQ ESTQ1
                  FROM MAP_CATEGORIA A
                 WHERE NIVELHIERARQUIA = 1
                   AND NRODIVISAO = 1
                   AND TIPCATEGORIA = 'M'
                   AND STATUSCATEGOR = 'A') N1,
               (SELECT SEQCATEGORIA     SEQ2,
                       SEQCATEGORIAPAI  SEQPAI2,
                       CATEGORIA        CATEGORIA2,
                       NIVELHIERARQUIA  NIVELHIERARQUIA2,
                       QTDPADRAODIAESTQ ESTQ2
                  FROM MAP_CATEGORIA
                 WHERE NIVELHIERARQUIA = 2
                   AND NRODIVISAO = 1
                   AND TIPCATEGORIA = 'M'
                   AND STATUSCATEGOR = 'A') N2,
               (SELECT SEQCATEGORIA     SEQ3,
                       SEQCATEGORIAPAI  SEQPAI3,
                       CATEGORIA        CATEGORIA3,
                       NIVELHIERARQUIA  NIVELHIERARQUIA3,
                       QTDPADRAODIAESTQ ESTQ3
                  FROM MAP_CATEGORIA
                 WHERE NIVELHIERARQUIA = 3
                   AND NRODIVISAO = 1
                   AND TIPCATEGORIA = 'M'
                   AND STATUSCATEGOR = 'A') N3,
               (SELECT SEQCATEGORIA     SEQ4,
                       SEQCATEGORIAPAI  SEQPAI4,
                       CATEGORIA        CATEGORIA4,
                       NIVELHIERARQUIA  NIVELHIERARQUIA4,
                       QTDPADRAODIAESTQ ESTQ4
                  FROM MAP_CATEGORIA
                 WHERE NIVELHIERARQUIA = 4
                   AND NRODIVISAO = 1
                   AND TIPCATEGORIA = 'M'
                   AND STATUSCATEGOR = 'A') N4,
               (SELECT SEQCATEGORIA      SEQ5,
                       SEQCATEGORIAPAI   SEQPAI5,
                       CATEGORIA         CATEGORIA5,
                       NIVELHIERARQUIA   NIVELHIERARQUIA5,
                       MGMLUCROCATEGORIA MRG5,
                       QTDPADRAODIAESTQ  ESTQ5
                  FROM MAP_CATEGORIA
                 WHERE NIVELHIERARQUIA = 5
                   AND NRODIVISAO = 1
                   AND TIPCATEGORIA = 'M'
                   AND STATUSCATEGOR = 'A') N5
         WHERE N1.SEQ1 = N2.SEQPAI2
           AND N2.SEQ2 = N3.SEQPAI3
           AND N3.SEQ3 = N4.SEQPAI4
           AND N4.SEQ4 = N5.SEQPAI5) E,
       MAP_FAMFORNEC G,
       GE_PESSOA H,
       MAP_FORMAABASTEC I,
       MAP_FAMILIA J,
       MAF_FORNECDIVISAO K,
       MRL_PRODUTOEMPRESA R
       
 WHERE B.SEQFAMILIA = D.SEQFAMILIA
   AND B.SEQFAMILIA = C.SEQFAMILIA
   AND B.SEQFAMILIA = J.SEQFAMILIA
   AND C.SEQCOMPRADOR = F.SEQCOMPRADOR
   AND D.SEQCATEGORIA = E.COD5
   AND C.SEQFAMILIA = D.SEQFAMILIA
   AND C.NRODIVISAO = D.NRODIVISAO
   AND B.SEQFAMILIA = G.SEQFAMILIA
   AND G.SEQFORNECEDOR = H.SEQPESSOA
   AND G.SEQFORNECEDOR = K.SEQFORNECEDOR
   AND D.NRODIVISAO = K.NRODIVISAO
   AND C.FORMAABASTECIMENTO = I.FORMAABASTECIMENTO
   AND R.SEQPRODUTO = B.SEQPRODUTO
   AND G.PRINCIPAL = 'S'
   AND D.NRODIVISAO = 1
   AND D.STATUS = 'A'   
  -- AND B.SEQPRODUTO IN (40)
   AND R.NROEMPRESA IN (SELECT * FROM VERAN_EMPQUERY)) B
WHERE A.SEQPRODUTO = B.SEQPRODUTO
AND A.NROEMPRESA = B.NROEMPRESA
AND B.NIVEL1<>'SERVICOS'
AND A.SEQPRODUTO NOT IN (SELECT UU.SEQPRODFIN FROM PDA_RECREND UU WHERE UU.SEQPRODFIN = B.SEQPRODUTO)
AND NVL(A.CONTRUPT,'N')='S'
AND A.DATA=TRUNC(SYSDATE)
AND A.NROEMPRESA IN (1,2,3,5,6,7,8,9,10,11,12,32,33,34)
) AA;


------------------------------------------------------------------------------------------------------

                
SELECT *    
FROM VERAN_VW_BASE_RUPTURAHISTMP v
where v.DATA = trunc(sysdate) --'13-aug-2024'     
--and v.SEQPRODUTO in (1380010)                          
and v.NROEMPRESA = 1;



-------------------------------------------------------------------------------------------------------

SELECT K.NROEMPRESA,
       K.DATA,
--       nvl(VERAN_F_RETOR_COMPONENTE(K.SEQPRODUTO), K.SEQPRODUTO) SEQPRODUTO,
       K.SEQPRODUTO,
       K.ESTOQUE,
       CASE
         WHEN K.ESTOQUE = 0 THEN
          M.MEDVDIAGERAL * (CASE
            WHEN P.PRECOVALIDNORMAL = 0 THEN
             P.PRECOVALIDPROMOC
            ELSE
             P.PRECOVALIDNORMAL
          END)
         ELSE
          0
       END PERDAESTIMADAVDA,
       M.MEDVDIAGERAL,
       CASE
         WHEN P.PRECOVALIDNORMAL = 0 THEN
          P.PRECOVALIDPROMOC
         ELSE
          P.PRECOVALIDNORMAL
       END PRECO,
       CASE
         WHEN TRUNC(L.DTAHORINCLUSAO) >= TRUNC(K.DATA - 30) AND
              K.ESTOQUE = 0 THEN
          'N'
         ELSE
          'S'
       END CONTRUPT
  FROM VERAN_BASE_RUPTURA K,
       MAP_PRODUTO         L,
       MRL_PRODUTOEMPRESA  M,
       MAP_FAMDIVISAO      N,
       MRL_PRODEMPSEG      P,
       MAP_FAMILIA         U
 WHERE K.SEQPRODUTO = L.SEQPRODUTO
   AND K.NROEMPRESA = M.NROEMPRESA
   AND K.SEQPRODUTO = M.SEQPRODUTO
   AND L.SEQFAMILIA = N.SEQFAMILIA
   AND K.SEQPRODUTO = P.SEQPRODUTO
   AND K.NROEMPRESA = P.NROEMPRESA
   AND L.SEQFAMILIA = U.SEQFAMILIA
   AND P.NROSEGMENTO = (SELECT Q.NROSEGMENTOPRINC
                          FROM MAX_EMPRESA Q
                         WHERE Q.NROEMPRESA = K.NROEMPRESA)
   AND N.NRODIVISAO = 1
   AND P.QTDEMBALAGEM = 1
--   AND K.NROEMPRESA <> 1
   AND (N.FINALIDADEFAMILIA IS NULL OR N.FINALIDADEFAMILIA = 'R')
   AND K.NROEMPRESA IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 32, 33, 34)
   AND K.DATA BETWEEN /*TRUNC((LAST_DAY(SYSDATE)-TO_CHAR(TRUNC(LAST_DAY(SYSDATE)), 'DD'))+1)*/
   TRUNC((LAST_DAY(SYSDATE-2)-TO_CHAR(TRUNC(LAST_DAY(SYSDATE-2)), 'DD'))+1) AND TRUNC(SYSDATE)
   AND K.SEQPRODUTO IN (40)
   --((TRUNC(LAST_DAY(SYSDATE)-1)) - to_char((TRUNC(LAST_DAY(SYSDATE)-1) - TO_CHAR(TRUNC(LAST_DAY(SYSDATE)), 'DD') + 1),'DD') +1) AND TRUNC(SYSDATE)
   AND M.INDGERARUPTURA = 'S'
   AND K.SEQPRODUTO NOT IN
       (SELECT X.SEQPRODUTO
          FROM VERAN_PRODUTOS X
         WHERE X.SEQPRODUTO = K.SEQPRODUTO
           AND X.NIVEL1 = 'SERVICOS')
   AND K.SEQPRODUTO NOT IN (SELECT UU.SEQPRODUTO
                              FROM MRL_RRPRODUTOFINAL UU
                             WHERE UU.SEQPRODUTO = K.SEQPRODUTO
                               AND UU.STATUS = 'A'
                               --AND UU.SEQPRODUTO NOT IN (SELECT SEQPRODUTO FROM MRL_PRODUTOEMPRESA WHERE NROEMPRESA = 2 AND SEQSENSIBILIDADE IN (4,5))
                                                              );
