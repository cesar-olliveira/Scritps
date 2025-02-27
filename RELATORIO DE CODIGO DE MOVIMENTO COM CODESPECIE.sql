-----------------------------------------------------------------------------------------------
------------------------------- RELATORIO DE CODIGO DE MOVIMENTO  -----------------------------
-----------------------------------------------------------------------------------------------

SELECT 'JANEIRO' MES, --X.MES,
       X.NROEMPRESA   LOJA,
       COD || ' - ' || X.MOVIMENTO MOVIMENTO,
       X.CODMOVIMENTO as QUANT,
       X.VALOR,
       NVL(X.TAXAADM, 0) TAXAADM
       
  FROM (SELECT MAX(TO_CHAR(A.DTAMOVIMENTO,'MM'))MES,
               A.NROEMPRESA,
               LPAD(A.CODMOVIMENTO, 3, '0') COD,
               COUNT(A.CODMOVIMENTO) CODMOVIMENTO,
               C.DESCRICAO MOVIMENTO,
               SUM(A.VALOR) valor,
               D.TIPO,
               D.TAXAADM TAXAADM
        -- DECODE(A.CONCILIADO, 'S', 'SIM', 'N', 'NAO', 'NAO') CONCILIADO
          FROM FI_TSMOVTOOPEDETALHE A,
               FI_TSOPERADORCAIXA   B,
               FI_TSCODMOVIMENTO    C,
               FI_TSEMPCODMOVIMENTO D
                       
         WHERE A.CODOPERADOR = B.CODOPERADOR
           AND C.NROEMPRESAMAE = 2
           AND A.CODMOVIMENTO = C.CODMOVIMENTO
           AND C.CODMOVIMENTO = D.CODMOVIMENTO(+)
           AND C.NROEMPRESAMAE = D.NROEMPRESAMAE(+)
           AND A.NROEMPRESA = D.NROEMPRESA(+)
           AND C.TIPO = D.TIPO(+)
           
          -- AND C.TIPO IN ('DIN')
          AND A.DTAMOVIMENTO BETWEEN '&DT1' AND '&DT2'
          AND A.CODMOVIMENTO NOT IN (224)
         group by A.NROEMPRESA, C.DESCRICAO, A.CODMOVIMENTO, D.TAXAADM, D.TIPO  --, A.DTAMOVIMENTO
        -- A.CONCILIADO
        ) X
 WHERE X.NROEMPRESA IN (6,10)--(2,3,5,6,7,8,9,10,11,12,32,33,34)
 order by 3, 2
    
 
 
Tirar movimento: DIFERENÇA NEGATIVA A CONCILIAR
 

select * from FI_TSCODMOVIMENTO C

-------------------------------------------------------------------------
2023 Dinheiro 
2024 janeiro a Maio
Diretorio: V:\financeiro\MRPAVAN\01. Contas a Receber\Reinaldo Pavan\BASE FECHAMENTO CAIXA_FINALIZADORA
    
  

SELECT * FROM FI_TSCODMOVIMENTO
where codmovimento IN (5,4)
 
--------------------------------------------------------------------------------------------------------


SELECT 'JANEIRO' MES, --X.MES,
       X.NROEMPRESA   LOJA,
       COD || ' - ' || X.MOVIMENTO MOVIMENTO,
       X.CODMOVIMENTO as QUANT,
       X.VALOR,
       NVL(X.TAXAADM, 0) TAXAADM
       
  FROM (SELECT MAX(TO_CHAR(A.DTAMOVIMENTO,'MM'))MES,
               A.NROEMPRESA,
               LPAD(A.CODMOVIMENTO, 3, '0') COD,
               COUNT(A.CODMOVIMENTO) CODMOVIMENTO,
               C.DESCRICAO MOVIMENTO,
               SUM(A.VALOR) valor,
               D.TIPO,
               D.TAXAADM TAXAADM
        -- DECODE(A.CONCILIADO, 'S', 'SIM', 'N', 'NAO', 'NAO') CONCILIADO
          FROM FI_TSMOVTOOPEDETALHE A,
               FI_TSOPERADORCAIXA   B,
               FI_TSCODMOVIMENTO    C,
               FI_TSEMPCODMOVIMENTO D
                       
         WHERE A.CODOPERADOR = B.CODOPERADOR(+)
           AND C.NROEMPRESAMAE = 2
           AND A.CODMOVIMENTO = C.CODMOVIMENTO
           AND C.CODMOVIMENTO = D.CODMOVIMENTO(+)
           AND C.NROEMPRESAMAE = D.NROEMPRESAMAE(+)
           AND A.NROEMPRESA = D.NROEMPRESA(+)
           AND C.TIPO = D.TIPO(+)
          -- AND C.TIPO IN ('DIN')
          AND A.DTAMOVIMENTO BETWEEN '01-JAN-2025' AND '31-JAN-2025'
          AND A.CODMOVIMENTO NOT IN (224)
         group by A.NROEMPRESA, C.DESCRICAO, A.CODMOVIMENTO, D.TAXAADM, D.TIPO   --, A.DTAMOVIMENTO
        -- A.CONCILIADO
        ) X
 WHERE X.NROEMPRESA IN (6,10)--,10)--(2,3,5,6,7,8,9,10,11,12,32,33,34)
 UNION ALL
 
 SELECT 'JANEIRO' MES,
       A.NROEMPRESA,
       LPAD(A.CODMOVIMENTO, 3, '0') || ' - ' || 'PAGAMENTO VERANCARD' MOVIMENTO, 
       COUNT(A.CODMOVIMENTO) QUANT,
       SUM(A.VALOR) VALOR,
       NVL(D.TAXAADM,0)TAXAADM
FROM FI_TSMOVENTRADAOUTROSOPER A, GE_EMPRESA B, FI_TSEMPCODMOVIMENTO D
WHERE A.NROEMPRESA=B.NROEMPRESA
      and a.nroempresamae = d.nroempresamae(+)
      and a.codmovimento = d.codmovimento(+)
      and a.nroempresa = d.nroempresa(+)
      AND B.NROEMPRESA IN (6,10)
      AND A.DTAMOVIMENTO BETWEEN '01-JAN-2025' AND '31-JAN-2025'
      AND A.CODMOVIMENTO IN (2,4,5)           
GROUP BY A.NROEMPRESA, D.TAXAADM, A.CODMOVIMENTO
 
  UNION ALL
 
 SELECT 'JANEIRO' MES,
       A.NROEMPRESA,
       LPAD(A.CODMOVIMENTO, 3, '0') || ' - ' || 'RECARGA CELULAR' MOVIMENTO, 
       COUNT(A.CODMOVIMENTO) QUANT,
       SUM(A.VALOR) VALOR,
       NVL(D.TAXAADM,0)TAXAADM
FROM FI_TSMOVENTRADAOUTROSOPER A, GE_EMPRESA B, FI_TSEMPCODMOVIMENTO D
WHERE A.NROEMPRESA=B.NROEMPRESA
      and a.nroempresamae = d.nroempresamae(+)
      and a.codmovimento = d.codmovimento(+)
      and a.nroempresa = d.nroempresa(+)
      AND B.NROEMPRESA IN (6,10)
      AND A.DTAMOVIMENTO BETWEEN '01-JAN-2025' AND '31-JAN-2025'
      AND A.CODMOVIMENTO IN (1)           
GROUP BY A.NROEMPRESA, D.TAXAADM, A.CODMOVIMENTO
UNION ALL 

SELECT 'JANEIRO' MES,
       A.NROEMPRESA,
       LPAD(A.CODMOVIMENTO, 3, '0') || ' - ' || 'TAXI' MOVIMENTO, 
       COUNT(A.CODMOVIMENTO) QUANT,
       SUM(A.VALOR) VALOR,
       NVL(D.TAXAADM,0)TAXAADM
FROM FI_TSMOVENTRADAOUTROSOPER A, GE_EMPRESA B, FI_TSEMPCODMOVIMENTO D
WHERE A.NROEMPRESA=B.NROEMPRESA
      and a.nroempresamae = d.nroempresamae(+)
      and a.codmovimento = d.codmovimento(+)
      and a.nroempresa = d.nroempresa(+)
      AND B.NROEMPRESA IN (6,10)
      AND A.DTAMOVIMENTO BETWEEN '01-JAN-2025' AND '31-JAN-2025'
      AND A.CODMOVIMENTO IN (9, 317, 305, 306,309)           
GROUP BY A.NROEMPRESA, D.TAXAADM, A.CODMOVIMENTO


 order by 3, 2;
 
 -------------------------------------------------------------------------------------                

SELECT 'JANEIRO' MES,
       A.NROEMPRESA,
       LPAD(A.CODMOVIMENTO, 3, '0') || ' - ' || 'TAXI' MOVIMENTO, 
       COUNT(A.CODMOVIMENTO) QUANT,
       SUM(A.VALOR) VALOR,
       D.TAXAADM
FROM FI_TSMOVENTRADAOUTROSOPER A, GE_EMPRESA B, FI_TSEMPCODMOVIMENTO D
WHERE A.NROEMPRESA=B.NROEMPRESA
      and a.nroempresamae = d.nroempresamae(+)
      and a.codmovimento = d.codmovimento(+)
      and a.nroempresa = d.nroempresa(+)
      AND B.NROEMPRESA IN (6)
      AND A.DTAMOVIMENTO BETWEEN '01-JAN-2025' AND '31-JAN-2025'
      AND A.CODMOVIMENTO IN (9, 317, 305, 306,309)           
GROUP BY A.NROEMPRESA, D.TAXAADM, A.CODMOVIMENTO
