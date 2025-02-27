 ---------------------------------------------------------------------------------------------------------------------------------
 ------------------------------------ RELATORIO DE TRANSFERENCIA CD -------- ADAPTADO 21-09 --------------------------------------
 ---------------------------------------------------------------------------------------------------------------------------------
 
 
 SELECT TO_CHAR(X.DTAHOREMISSAO, 'DD/MM/YYYY HH24:MI:SS') DTAEMISSAO,
       X.NUMERODF NUMERONF,
       NULL NFREFERENCIA,
       X.NROEMPRESA NROEMPRESA_ORIG,
       VERAN_F_RETORNANROEMPRESA(X.SEQPESSOA) NROEMPRESA_DEST,
       SUM(Z.VLRITEM) VALOR,
       COUNT(Z.SEQPRODUTO) QTDEITENS,
       DECODE(VERAN_F_INDTRANSFRECEBDEST(X.NFECHAVEACESSO), 1, 'SIM', 'NAO') IND_RECEB_EMP_DESTINO,
       Y.CODGERALOPER CGO, 
       Y.DESCRICAO 
  FROM MFL_DOCTOFISCAL X, MFL_DFITEM Z, MAX_CODGERALOPER Y
 WHERE X.DTAMOVIMENTO BETWEEN '&DT1' AND '&DT2'
   AND X.CODGERALOPER IN (521,522,525,527,528, 612)
   AND X.SEQNF = Z.SEQNF
   AND X.CODGERALOPER = Y.CODGERALOPER 
  AND X.STATUSDF <> 'C'
 AND X.NUMERODF NOT IN (select NVL(ML.NFREFERENCIANRO,0)NFREFERENCIANRO FROM mlf_notafiscal ML, MFL_DFITEM Z, MAX_CODGERALOPER Y   
                          WHERE 1=1  
                          AND Z.SEQNF(+) = ML.SEQNF
                          AND ML.CODGERALOPER = Y.CODGERALOPER(+)
                          AND ML.CODGERALOPER IN (221)
                          )  /**/
GROUP BY X.DTAHOREMISSAO,
          X.NUMERODF,
          VERAN_F_RETORNANROEMPRESA(X.SEQPESSOA),
          DECODE(VERAN_F_INDTRANSFRECEBDEST(X.NFECHAVEACESSO),
                 1,
                 'SIM',
                 'NAO'),
          X.NROEMPRESA,
          Y.CODGERALOPER, 
          Y.DESCRICAO,
          X.NFREFERENCIANRO

UNION

SELECT DTAEMISSAO,
       NUMERONF,
       NFREFERENCIANRO,
       NROEMPRESA_ORIG,
       NROEMPRESA_DEST,
       VALOR,
       QTDEITENS,
       CASE WHEN B3.NUMERODF =  B2.NFREFERENCIANRO THEN 'SIM' ELSE 'NÃO' END IND_RECEB_EMP_DESTINO,
       CGO,
       DESCRICAO
 FROM

(select ML.NUMERONF, NVL(ML.NFREFERENCIANRO,0)NFREFERENCIANRO, Y.CODGERALOPER, ML.SEQNF FROM mlf_notafiscal ML, MFL_DFITEM Z, MAX_CODGERALOPER Y   
WHERE 1=1  
AND Z.SEQNF(+) = ML.SEQNF
AND ML.CODGERALOPER = Y.CODGERALOPER(+)
AND ML.CODGERALOPER IN (221)

) B2,

(SELECT TO_CHAR(X.DTAHOREMISSAO, 'DD/MM/YYYY HH24:MI:SS') DTAEMISSAO,
       X.NUMERODF NUMERODF,
       X.NROEMPRESA NROEMPRESA_ORIG,
       VERAN_F_RETORNANROEMPRESA(X.SEQPESSOA) NROEMPRESA_DEST,
       SUM(Z.VLRITEM) VALOR,
       COUNT(Z.SEQPRODUTO) QTDEITENS,
       
       Y.CODGERALOPER CGO,
       Y.DESCRICAO
  FROM MFL_DOCTOFISCAL X, MFL_DFITEM Z, MAX_CODGERALOPER Y
    WHERE X.DTAMOVIMENTO BETWEEN '&DT1' AND '&DT2'
    AND X.NROSERIEECF = 'NF'
   AND X.CODGERALOPER IN (521, 522, 525, 527, 528, 612)
   AND X.SEQNF = Z.SEQNF
   AND X.CODGERALOPER = Y.CODGERALOPER
   AND X.STATUSDF <> 'C'
 GROUP BY X.DTAHOREMISSAO,
          X.NUMERODF,
          VERAN_F_RETORNANROEMPRESA(X.SEQPESSOA),
          DECODE(VERAN_F_INDTRANSFRECEBDEST(X.NFECHAVEACESSO),
                 1,
                 'SIM',
                 'NAO'),
          X.NROEMPRESA,
          Y.CODGERALOPER,
          Y.DESCRICAO,
          X.NFREFERENCIANRO)B3

WHERE 1=1
AND B3.NUMERODF = B2.NFREFERENCIANRO(+)
AND CASE WHEN B3.NUMERODF =  B2.NFREFERENCIANRO THEN 'SIM' ELSE 'NÃO' END IN 'SIM'

union

Select TO_CHAR(MLF_AUXNOTAFISCAL.DTAEMISSAO,'DD/MM/YYYY HH24:MI:SS') DTAEMISSAO,
        MLF_AUXNOTAFISCAL.NUMERONF,
        NULL NFREFERENCIANRO,      
       veran_f_retornanroempresa(MLF_AUXNOTAFISCAL.SEQPESSOA) NROEMPRESA_ORIG,
       MLF_AUXNOTAFISCAL.NROEMPRESA NROEMPRESA_DEST,
       MLF_AUXNOTAFISCAL.VLRTOTALNF,
       COUNT(M.SEQPRODUTO) QTDEITENS,
       DECODE(VERAN_F_INDTRANSFRECEBDEST(MLF_AUXNOTAFISCAL.NFECHAVEACESSO), 1, 'SIM', 'NAO') IND_RECEB_EMP_DESTINO,
       MLF_AUXNOTAFISCAL.CODGERALOPER,
       G.DESCRICAO
       
  From MLF_AUXNOTAFISCAL, MAX_CODGERALOPER G, MLF_AUXNFITEM M
 Where TIPNOTAFISCAL = 'E'
   AND MLF_AUXNOTAFISCAL.CODGERALOPER IN (210,701,138,548)
   AND MLF_AUXNOTAFISCAL.DTASAIDA BETWEEN '&DT1' AND '&DT2'
   AND MLF_AUXNOTAFISCAL.CODGERALOPER = G.CODGERALOPER
   AND MLF_AUXNOTAFISCAL.SEQAUXNOTAFISCAL = M.SEQAUXNOTAFISCAL
GROUP BY MLF_AUXNOTAFISCAL.DTAEMISSAO,
        MLF_AUXNOTAFISCAL.NUMERONF,        
       MLF_AUXNOTAFISCAL.SEQPESSOA,
       MLF_AUXNOTAFISCAL.NROEMPRESA,
       MLF_AUXNOTAFISCAL.VLRTOTALNF,
       MLF_AUXNOTAFISCAL.NFECHAVEACESSO,
       MLF_AUXNOTAFISCAL.CODGERALOPER,
       G.DESCRICAO


 ORDER BY 3, 7, 4
 
 
 ---------------------------------------------------------------

 
 ---------------------------------------------------------------------------------------------------------------------------
 
 SELECT CASE WHEN B3.NUMERODF =  B2.NFREFERENCIANRO THEN 'SIM' ELSE 'NÃO' END STATUS, B2.*, B3.* FROM  
(select ML.NUMERONF, ML.NFREFERENCIANRO, Y.CODGERALOPER, ML.SEQNF FROM mlf_notafiscal ML, MFL_DFITEM Z, MAX_CODGERALOPER Y   
WHERE 1=1  --Y.CODGERALOPER IN (521,522,525,527,528, 612, 221)
AND Z.SEQNF(+) = ML.SEQNF
AND ML.CODGERALOPER = Y.CODGERALOPER(+)
AND ML.NFREFERENCIANRO IN (74408, 272387, 272375, 272376, 272377, 272378, 272379 )
AND ML.CODGERALOPER IN (221)
) B2,

(SELECT X.NUMERODF, X.CODGERALOPER FROM MFL_DOCTOFISCAL X
WHERE X.NUMERODF IN (74408, 272387, 272375, 272376, 272377, 272378, 272379)
AND X.DTAHOREMISSAO  >= '01-AUG-2023'
AND X.NROSERIEECF = 'NF')B3
WHERE 1=1
AND B3.NUMERODF = B2.NFREFERENCIANRO(+)


------------------------------  validação --------------------------------------------

SELECT DTAEMISSAO,
       NUMERONF,
       NFREFERENCIANRO,
       NROEMPRESA_ORIG,
       NROEMPRESA_DEST,
       CASE WHEN B3.NUMERODF =  B2.NFREFERENCIANRO THEN 'SIM' ELSE 'NÃO' END STATUS,
       VALOR,
       QTDEITENS,
       CGO,
       DESCRICAO
 FROM

(select ML.NUMERONF, NVL(ML.NFREFERENCIANRO,0)NFREFERENCIANRO, Y.CODGERALOPER, ML.SEQNF, ml.* FROM mlf_notafiscal ML, MFL_DFITEM Z, MAX_CODGERALOPER Y   
WHERE 1=1  
AND Z.SEQNF(+) = ML.SEQNF
AND ML.CODGERALOPER = Y.CODGERALOPER(+)
AND ML.CODGERALOPER IN (221)

) B2,

(SELECT TO_CHAR(X.DTAHOREMISSAO, 'DD/MM/YYYY HH24:MI:SS') DTAEMISSAO,
       X.NUMERODF NUMERODF,
       X.NROEMPRESA NROEMPRESA_ORIG,
       VERAN_F_RETORNANROEMPRESA(X.SEQPESSOA) NROEMPRESA_DEST,
       SUM(Z.VLRITEM) VALOR,
       COUNT(Z.SEQPRODUTO) QTDEITENS,
       
       Y.CODGERALOPER CGO,
       Y.DESCRICAO
  FROM MFL_DOCTOFISCAL X, MFL_DFITEM Z, MAX_CODGERALOPER Y
    WHERE X.DTAMOVIMENTO BETWEEN '&DT1' AND '&DT2'
    AND X.NROSERIEECF = 'NF'
    -- X.DTAHOREMISSAO BETWEEN '01-AUG-2023' AND '18-AUG-2023'  
   AND X.CODGERALOPER IN (521, 522, 525, 527, 528, 612)
   AND X.SEQNF = Z.SEQNF
   AND X.CODGERALOPER = Y.CODGERALOPER
   AND X.STATUSDF <> 'C'
 GROUP BY X.DTAHOREMISSAO,
          X.NUMERODF,
          VERAN_F_RETORNANROEMPRESA(X.SEQPESSOA),
          DECODE(VERAN_F_INDTRANSFRECEBDEST(X.NFECHAVEACESSO),
                 1,
                 'SIM',
                 'NAO'),
          X.NROEMPRESA,
          Y.CODGERALOPER,
          Y.DESCRICAO,
          X.NFREFERENCIANRO)B3

WHERE 1=1
AND B3.NUMERODF = B2.NFREFERENCIANRO(+)





(SELECT X.NUMERODF, X.CODGERALOPER FROM MFL_DOCTOFISCAL X
WHERE X.NUMERODF IN (74408, 272387, 272375, 272376, 272377, 272378, 272379)
AND X.DTAHOREMISSAO  >= '01-AUG-2023'
AND X.NROSERIEECF = 'NF')B3


-------------------------------------------------------------------------------------------

select NVL(ML.NFREFERENCIANRO,0)NFREFERENCIANRO FROM mlf_notafiscal ML, MFL_DFITEM Z, MAX_CODGERALOPER Y   
WHERE 1=1  
AND Z.SEQNF(+) = ML.SEQNF
AND ML.CODGERALOPER = Y.CODGERALOPER(+)
AND ML.CODGERALOPER IN (221)
 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
 -----------------------------------------------------------------------------------------
 
  SELECT TO_CHAR(X.DTAHOREMISSAO, 'DD/MM/YYYY HH24:MI:SS') DTAEMISSAO,
       X.NUMERODF NUMERONF,
       X.NROEMPRESA NROEMPRESA_ORIG,
       VERAN_F_RETORNANROEMPRESA(X.SEQPESSOA) NROEMPRESA_DEST,
       SUM(Z.VLRITEM) VALOR,
       COUNT(Z.SEQPRODUTO) QTDEITENS,
    --   CASE WHEN (SELECT MAX(ML.NFREFERENCIANRO) FROM mlf_notafiscal ML WHERE ML.NUMERONF(+) = X.NUMERODF) = X.NUMERODF THEN 'NAO' ELSE 'SIM' END TESTE,
       DECODE(VERAN_F_INDTRANSFRECEBDEST(X.NFECHAVEACESSO), 1, 'SIM', 'NAO') IND_RECEB_EMP_DESTINO,
       Y.CODGERALOPER CGO, 
       Y.DESCRICAO 
  FROM MFL_DOCTOFISCAL X, MFL_DFITEM Z, MAX_CODGERALOPER Y
 WHERE X.DTAMOVIMENTO BETWEEN '&DT1' AND '&DT2'
   AND X.CODGERALOPER IN (521,522,525,527,528, 612)
   AND X.SEQNF = Z.SEQNF
   AND X.CODGERALOPER = Y.CODGERALOPER 
  AND X.STATUSDF <> 'C'
 GROUP BY X.DTAHOREMISSAO,
          X.NUMERODF,
          VERAN_F_RETORNANROEMPRESA(X.SEQPESSOA),
          DECODE(VERAN_F_INDTRANSFRECEBDEST(X.NFECHAVEACESSO),
                 1,
                 'SIM',
                 'NAO'),
          X.NROEMPRESA,
          Y.CODGERALOPER, 
          Y.DESCRICAO 

UNION
 Select TO_CHAR(MLF_AUXNOTAFISCAL.DTAEMISSAO,'DD/MM/YYYY HH24:MI:SS') DTAEMISSAO,
        MLF_AUXNOTAFISCAL.NUMERONF,        
       veran_f_retornanroempresa(MLF_AUXNOTAFISCAL.SEQPESSOA) NROEMPRESA_ORIG,
       MLF_AUXNOTAFISCAL.NROEMPRESA NROEMPRESA_DEST,
       MLF_AUXNOTAFISCAL.VLRTOTALNF,
       COUNT(M.SEQPRODUTO) QTDEITENS,
       DECODE(VERAN_F_INDTRANSFRECEBDEST(MLF_AUXNOTAFISCAL.NFECHAVEACESSO), 1, 'SIM', 'NAO') IND_RECEB_EMP_DESTINO,
       MLF_AUXNOTAFISCAL.CODGERALOPER,
       G.DESCRICAO
       
  From MLF_AUXNOTAFISCAL, MAX_CODGERALOPER G, MLF_AUXNFITEM M
 Where TIPNOTAFISCAL = 'E'
   AND MLF_AUXNOTAFISCAL.CODGERALOPER IN (210,701,138,548)
   AND MLF_AUXNOTAFISCAL.DTASAIDA BETWEEN '&DT1' AND '&DT2'
   AND MLF_AUXNOTAFISCAL.CODGERALOPER = G.CODGERALOPER
   AND MLF_AUXNOTAFISCAL.SEQAUXNOTAFISCAL = M.SEQAUXNOTAFISCAL
GROUP BY MLF_AUXNOTAFISCAL.DTAEMISSAO,
        MLF_AUXNOTAFISCAL.NUMERONF,        
       MLF_AUXNOTAFISCAL.SEQPESSOA,
       MLF_AUXNOTAFISCAL.NROEMPRESA,
       MLF_AUXNOTAFISCAL.VLRTOTALNF,
       MLF_AUXNOTAFISCAL.NFECHAVEACESSO,
       MLF_AUXNOTAFISCAL.CODGERALOPER,
       G.DESCRICAO


 ORDER BY 3, 7, 4
 
