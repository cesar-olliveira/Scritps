-------------------------------------------------------------------------------------------------------------------
----------------------------------------- CASH MARGEM E IMAGEM ----------------------------------------------------
-------------------------------------------------------------------------------------------------------------------


SELECT DISTINCT Y.NROEMPRESA,
                Y.SEQPRODUTO,
                P.SEQFAMILIA,
                P.DESCCOMPLETA,
                NVL(S.DESCRICAO, 'NORMAL') DESCRICAO,
                DECODE(F.Seqcomprador, 17,	'EDER', 1,	'GERAL', 44,	'JOSE LUCAS',32,	'RENAN',15,	'RODRIGO',46,	'TATIELLE',47, 'FELIPE FERRARI',48,	'LUCAS RIBEIRO',51,	'EVELIN ALEXIA',52,	'MARCELO',53,	'LEONARDO') COMPRADOR,
                PP.NROSEGMENTO,
                Y.STATUSCOMPRA,
                PP.STATUSVENDA
  FROM MRL_PRODUTOEMPRESA Y, map_produto p, MAP_SENSIBILIDADE S, MRL_PRODEMPSEG PP, MAP_FAMDIVISAO F
 WHERE Y.SEQPRODUTO = P.SEQPRODUTO
   AND Y.SEQPRODUTO = PP.SEQPRODUTO
   AND Y.NROEMPRESA = PP.NROEMPRESA
   AND P.SEQFAMILIA = F.SEQFAMILIA
   AND Y.SEQSENSIBILIDADE = S.SEQSENSIBILIDADE
   AND Y.NROEMPRESA IN (2)
   AND PP.NROSEGMENTO IN (9,11,12,13,14)
   AND F.NRODIVISAO = 1
   ORDER BY 2
  

-- AND Y.SEQPRODUTO = 5 ----- 42498

select fstatusvendaproduto(Y.SEQPRODUTO, Y.NROEMPRESA, PP.NROSEGMENTO) STATUSV from MRL_PRODUTOEMPRESA Y
where ROWNUM <= 10
select * from MAD_SEGMENTO

select owner, table_name from all_tab_columns where column_name like '%NROSEGMENTO%' 
