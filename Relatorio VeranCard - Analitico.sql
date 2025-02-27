----------------------------------------------------------------------------
-------------  Relatório De Movimentos VeranCard - Analítico  --------------
----------------------------------------------------------------------------
-- 2,3,4,5,6,7,8,9,10,11,12,32,33,34
 -- ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY HH24:MI:SS';


SELECT TO_CHAR(X.DTAMOVIMENTO, 'DD/MM/YYYY') DTAMOVIMENTO,
       X.NROEMPRESA LOJA,
       X.NROPDV PDV,
       X.NROTURNO TURNO,
       X.OPERADOR,
       X.CODMOVIMENTO as CODMOV,
       X.MOVIMENTO,
       X.VALOR,
       X.CONCILIADO
FROM (
SELECT A.DTAMOVIMENTO,
       A.NROEMPRESA,
       A.NROPDV,
       A.NROTURNO,
       B.NOME OPERADOR,
       A.CODMOVIMENTO,
       LPAD(A.CODMOVIMENTO,3,0)||' - '||C.DESCRICAO MOVIMENTO,
       A.VALOR,
       DECODE(A.CONCILIADO,'S','SIM','N','NAO','NAO') CONCILIADO
FROM FI_TSMOVTOOPEDETALHE A, FI_TSOPERADORCAIXA B, FI_TSCODMOVIMENTO C
WHERE A.CODOPERADOR=B.CODOPERADOR
     AND C.NROEMPRESAMAE = 2  
      AND A.CODMOVIMENTO=C.CODMOVIMENTO
      AND A.CODMOVIMENTO IN (83,84,90,95,97,103,104,105,153,207,210,216,219,220,235,236,237,238,265,266,267,268,275,284,290,291,292,295,296,297,299,301,302)
      ) X
WHERE X.NROEMPRESA IN (#LS1)
      AND X.DTAMOVIMENTO between '&DT1' and '&DT2'
      
       union all
       
       select null,
       null,
       null,
       null,
       NULL,
       NULL,
       'TOTAL GERAL >>>',
       SUM(X.VALOR),
       NULL
       FROM (
SELECT A.DTAMOVIMENTO,
       A.NROEMPRESA,
       A.NROPDV,
       A.NROTURNO,
       B.NOME OPERADOR,
       A.CODMOVIMENTO,
       LPAD(A.CODMOVIMENTO,3,0)||' - '||C.DESCRICAO MOVIMENTO,
       nvl(A.VALOR,0) valor,
       DECODE(A.CONCILIADO,'S','SIM','N','NAO','NAO') CONCILIADO
FROM FI_TSMOVTOOPEDETALHE A, FI_TSOPERADORCAIXA B, FI_TSCODMOVIMENTO C
WHERE A.CODOPERADOR=B.CODOPERADOR
     AND C.NROEMPRESAMAE = 2  
      AND A.CODMOVIMENTO = C.CODMOVIMENTO
      AND A.CODMOVIMENTO IN (83,84,90,95,97,103,104,105,153,207,210,216,219,220,235,236,237,238,265,266,267,268,275,284,290,291,292,295,296,297,299,301,302)
      ) X

WHERE X.NROEMPRESA IN (#LS1)
      AND X.DTAMOVIMENTO between '&DT1' and '&DT2'
 
ORDER BY 1, 2, 3



--------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------  Relatório De Movimentos VeranCard - Analítico  ------  VENDA E PAGAMENTO ----------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT TO_CHAR(X.DTAMOVIMENTO, 'DD/MM/YYYY') DTAMOVIMENTO,
       X.NROEMPRESA LOJA,
       X.NROPDV PDV,
       X.NROTURNO TURNO,
       X.OPERADOR,
       X.CODMOVIMENTO as CODMOV,
       X.MOVIMENTO,
       X.VALOR,
       X.CONCILIADO
FROM (
SELECT A.DTAMOVIMENTO,
       A.NROEMPRESA,
       A.NROPDV,
       A.NROTURNO,
       B.NOME OPERADOR,
       A.CODMOVIMENTO,
       LPAD(A.CODMOVIMENTO,3,0)||' - '||C.DESCRICAO MOVIMENTO,
       A.VALOR,
       DECODE(A.CONCILIADO,'S','SIM','N','NAO','NAO') CONCILIADO
FROM FI_TSMOVTOOPEDETALHE A, FI_TSOPERADORCAIXA B, FI_TSCODMOVIMENTO C
WHERE A.CODOPERADOR=B.CODOPERADOR
     AND C.NROEMPRESAMAE = 2  
      AND A.CODMOVIMENTO=C.CODMOVIMENTO
      AND A.CODMOVIMENTO IN (83,84,90,95,97,103,104,105,153,207,210,216,219,220,235,236,237,238,265,266,267,268,275,284,290,291,292,295,296,297,299,301,302,303)
      ) X
WHERE X.NROEMPRESA IN (2) --,3,5,6,7,8,9,10,11,12,32,33,34) --(#LS1)
      AND X.DTAMOVIMENTO between '&DT1' and '&DT2'

      
       union all
       
       select null,
       null,
       null,
       null,
       NULL,
       NULL,
       'TOTAL VENDA >>>',
       SUM(X.VALOR),
       NULL
       FROM (
SELECT A.DTAMOVIMENTO,
       A.NROEMPRESA,
       A.NROPDV,
       A.NROTURNO,
       B.NOME OPERADOR,
       A.CODMOVIMENTO,
       LPAD(A.CODMOVIMENTO,3,0)||' - '||C.DESCRICAO MOVIMENTO,
       nvl(A.VALOR,0) valor,
       DECODE(A.CONCILIADO,'S','SIM','N','NAO','NAO') CONCILIADO
FROM FI_TSMOVTOOPEDETALHE A, FI_TSOPERADORCAIXA B, FI_TSCODMOVIMENTO C
WHERE A.CODOPERADOR=B.CODOPERADOR
     AND C.NROEMPRESAMAE = 2  
      AND A.CODMOVIMENTO = C.CODMOVIMENTO
      AND A.CODMOVIMENTO IN (83,84,90,95,97,103,104,105,153,207,210,216,219,220,235,236,237,238,265,266,267,268,275,284,290,291,292,295,296,297,299,301,302)
      ) X

WHERE X.NROEMPRESA IN (2) --(#LS1)
      AND X.DTAMOVIMENTO between '&DT1' and '&DT2'
      
 UNION ALL     

SELECT TO_CHAR(X.DTAMOVIMENTO, 'DD/MM/YYYY') DTAMOVIMENTO,
       X.NROEMPRESA LOJA,
       X.NROPDV PDV,
       X.NROTURNO TURNO,
       X.OPERADOR,
       X.CODMOVIMENTO as CODMOV,
       X.MOVIMENTO,
       X.VALOR,
       X.CONCILIADO
FROM (SELECT AA.DTAMOVIMENTO,
       AA.NROEMPRESA,
       AA.NROPDV,
       AA.NROTURNO,
       (SELECT B.NOME FROM  FI_TSOPERADORCAIXA B
       WHERE B.CODOPERADOR = AA.CODOPERADOR)OPERADOR,
       AA.CODMOVIMENTO,
       LPAD(AA.CODMOVIMENTO,3,0)||' - '||E.DESCRICAO MOVIMENTO,
       AA.VALOR,
       'S/INF' CONCILIADO
                          FROM FI_TSMOVENTRADAOUTROSOPER AA, FI_TSCODMOVTOENTRADA E, GE_EMPRESA BB
                         WHERE AA.NROEMPRESA = BB.NROEMPRESA
                         AND E.CODMOVIMENTO = AA.CODMOVIMENTO
                         AND E.NROEMPRESAMAE = AA.NROEMPRESAMAE
                         AND AA.NROEMPRESAMAE = 2
                           AND AA.DTAMOVIMENTO BETWEEN '&DT1' AND '&DT2'
                           AND AA.CODMOVIMENTO IN (2)
                            ) X
        WHERE X.NROEMPRESA IN (2) --,3,5,6,7,8,9,10,11,12,32,33,34) --(#LS1)
      AND X.DTAMOVIMENTO between '&DT1' and '&DT2'
               
                     
 union all
       
       select null,
       null,
       null,
       null,
       NULL,
       NULL,
       'TOTAL PAGAMENTO >>>',
       SUM(X.VALOR),
       NULL
       FROM (
SELECT AA.DTAMOVIMENTO,
       AA.NROEMPRESA,
       AA.NROPDV,
       AA.NROTURNO,
       (SELECT B.NOME FROM  FI_TSOPERADORCAIXA B
       WHERE B.CODOPERADOR = AA.CODOPERADOR)OPERADOR,
       AA.CODMOVIMENTO,
       LPAD(AA.CODMOVIMENTO,3,0)||' - '||E.DESCRICAO MOVIMENTO,
       NVL(AA.VALOR,0)VALOR,
       NULL CONCILIADO
                          FROM FI_TSMOVENTRADAOUTROSOPER AA, FI_TSCODMOVTOENTRADA E, GE_EMPRESA BB
                         WHERE AA.NROEMPRESA = BB.NROEMPRESA
                         AND E.CODMOVIMENTO = AA.CODMOVIMENTO
                         AND E.NROEMPRESAMAE = AA.NROEMPRESAMAE
                         AND AA.NROEMPRESAMAE = 2
                           AND AA.DTAMOVIMENTO BETWEEN '&DT1' AND '&DT2'
                           AND AA.CODMOVIMENTO IN (2)
                            ) X
        WHERE X.NROEMPRESA IN (2) --,3,5,6,7,8,9,10,11,12,32,33,34) --(#LS1)
      AND X.DTAMOVIMENTO between '&DT1' and '&DT2'  
 

------------------------------------------------------------------------------------------------------------------------------
----------------------------------------- VERSÃO PUBLICADA 21/03/2024 --------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

SELECT TO_CHAR(X.DTAMOVIMENTO, 'DD/MM/YYYY') DTAMOVIMENTO,
       X.NROEMPRESA LOJA,
       X.NROPDV PDV,
       X.NROTURNO TURNO,
       X.OPERADOR,
       X.CODMOVIMENTO as CODMOV,
       X.MOVIMENTO,
       X.VALOR,
       X.CONCILIADO
FROM (
SELECT A.DTAMOVIMENTO,
       A.NROEMPRESA,
       A.NROPDV,
       A.NROTURNO,
       B.NOME OPERADOR,
       A.CODMOVIMENTO,
       LPAD(A.CODMOVIMENTO,3,0)||' - '||C.DESCRICAO MOVIMENTO,
       A.VALOR,
       DECODE(A.CONCILIADO,'S','SIM','N','NAO','NAO') CONCILIADO
FROM FI_TSMOVTOOPEDETALHE A, FI_TSOPERADORCAIXA B, FI_TSCODMOVIMENTO C
WHERE A.CODOPERADOR=B.CODOPERADOR
     AND C.NROEMPRESAMAE = 2  
      AND A.CODMOVIMENTO=C.CODMOVIMENTO
      AND A.CODMOVIMENTO IN (83,84,90,95,97,103,104,105,153,207,210,216,219,220,235,236,237,238,265,266,267,268,275,284,290,291,292,295,296,297,299,301,302,303)
      ) X
WHERE X.NROEMPRESA IN (#LS1)
      AND X.DTAMOVIMENTO between '&DT1' and '&DT2'

      
       union all
       
       select null,
       null,
       null,
       null,
       NULL,
       NULL,
       'TOTAL VENDA >>>',
       SUM(X.VALOR),
       NULL
       FROM (
SELECT A.DTAMOVIMENTO,
       A.NROEMPRESA,
       A.NROPDV,
       A.NROTURNO,
       B.NOME OPERADOR,
       A.CODMOVIMENTO,
       LPAD(A.CODMOVIMENTO,3,0)||' - '||C.DESCRICAO MOVIMENTO,
       nvl(A.VALOR,0) valor,
       DECODE(A.CONCILIADO,'S','SIM','N','NAO','NAO') CONCILIADO
FROM FI_TSMOVTOOPEDETALHE A, FI_TSOPERADORCAIXA B, FI_TSCODMOVIMENTO C
WHERE A.CODOPERADOR=B.CODOPERADOR
     AND C.NROEMPRESAMAE = 2  
      AND A.CODMOVIMENTO = C.CODMOVIMENTO
      AND A.CODMOVIMENTO IN (83,84,90,95,97,103,104,105,153,207,210,216,219,220,235,236,237,238,265,266,267,268,275,284,290,291,292,295,296,297,299,301,302)
      ) X

WHERE X.NROEMPRESA IN (#LS1)
      AND X.DTAMOVIMENTO between '&DT1' and '&DT2'
      
 UNION ALL     

SELECT TO_CHAR(X.DTAMOVIMENTO, 'DD/MM/YYYY') DTAMOVIMENTO,
       X.NROEMPRESA LOJA,
       X.NROPDV PDV,
       X.NROTURNO TURNO,
       X.OPERADOR,
       X.CODMOVIMENTO as CODMOV,
       X.MOVIMENTO,
       X.VALOR,
       X.CONCILIADO
FROM (SELECT AA.DTAMOVIMENTO,
       AA.NROEMPRESA,
       AA.NROPDV,
       AA.NROTURNO,
       (SELECT B.NOME FROM  FI_TSOPERADORCAIXA B
       WHERE B.CODOPERADOR = AA.CODOPERADOR)OPERADOR,
       AA.CODMOVIMENTO,
       LPAD(AA.CODMOVIMENTO,3,0)||' - '||E.DESCRICAO MOVIMENTO,
       AA.VALOR,
       'S/INF' CONCILIADO
                          FROM FI_TSMOVENTRADAOUTROSOPER AA, FI_TSCODMOVTOENTRADA E, GE_EMPRESA BB
                         WHERE AA.NROEMPRESA = BB.NROEMPRESA
                         AND E.CODMOVIMENTO = AA.CODMOVIMENTO
                         AND AA.NROEMPRESAMAE = 2
                         AND E.NROEMPRESAMAE = AA.NROEMPRESAMAE
                           AND AA.DTAMOVIMENTO BETWEEN '&DT1' AND '&DT2'
                           AND AA.CODMOVIMENTO IN (2)
                            ) X
        WHERE X.NROEMPRESA IN (#LS1)
      AND X.DTAMOVIMENTO between '#DT1' and '#DT2'
               
                     
 union all
       
       select null,
       null,
       null,
       null,
       NULL,
       NULL,
       'TOTAL PAGAMENTO >>>',
       SUM(X.VALOR),
       NULL
       FROM (
SELECT AA.DTAMOVIMENTO,
       AA.NROEMPRESA,
       AA.NROPDV,
       AA.NROTURNO,
       (SELECT B.NOME FROM  FI_TSOPERADORCAIXA B
       WHERE B.CODOPERADOR = AA.CODOPERADOR)OPERADOR,
       AA.CODMOVIMENTO,
       LPAD(AA.CODMOVIMENTO,3,0)||' - '||E.DESCRICAO MOVIMENTO,
       NVL(AA.VALOR,0)VALOR,
       NULL CONCILIADO
                          FROM FI_TSMOVENTRADAOUTROSOPER AA, FI_TSCODMOVTOENTRADA E, GE_EMPRESA BB
                         WHERE AA.NROEMPRESA = BB.NROEMPRESA
                         AND E.CODMOVIMENTO = AA.CODMOVIMENTO
                         AND E.NROEMPRESAMAE = AA.NROEMPRESAMAE
                         AND AA.NROEMPRESAMAE = 2
                           AND AA.DTAMOVIMENTO BETWEEN '&DT1' AND '&DT2'
                           AND AA.CODMOVIMENTO IN (2)
                            ) X
        WHERE X.NROEMPRESA IN (#LS1)
      AND X.DTAMOVIMENTO between '#DT1' and '#DT2' 
