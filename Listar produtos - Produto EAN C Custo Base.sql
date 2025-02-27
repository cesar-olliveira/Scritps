SELECT X.NROEMPRESA,
       X.SEQFAMILIA,
       X.SEQPRODUTO,
       X.FAMILIA, 
       X.PRODUTO, 
       X.QTDEMBALAGEM,
       X.EMBALAGEM,
       Y.CODACESSO CODIGO,
       DECODE(Y.TIPCODIGO, 'D', 'DUM', 'E', 'EAN', 'F', 'REF') TIPO,
       X.COMPRADOR,
       X.SEQFORNECEDOR,
       X.VLRCUSTOBASE,
       X.SEQCUSTO,
       X.RAZAO_SOCIAL,
       X.STATUS_COMPRA,
       X.ESTOQUE,
       X.GERARUPTURA,
       X.DTAINCLUSAO

  FROM (SELECT DISTINCT E.NROEMPRESA,
                        F.SEQFAMILIA SEQFAMILIA,
                        P.SEQPRODUTO,
                        I.QTDEMBALAGEM,
                        I.EMBALAGEM,
                        F.FAMILIA,
                        P.COMPLEMENTO PRODUTO,
                        C.APELIDO COMPRADOR,
                        G.SEQPESSOA SEQFORNECEDOR,
                        a.seqcustofornec SEQCUSTO,
                        ROUND(A.VLRCUSTOBASE, 6) VLRCUSTOBASE,
                        UPPER(G.NOMERAZAO) RAZAO_SOCIAL,
                        DECODE(E.STATUSCOMPRA,
                               'A',
                               'ATIVO',
                               'I',
                               'INATIVO',
                               NULL)STATUS_COMPRA,
                        FC5ESTOQUEBASEDISPONIVEL(P.SEQPRODUTO,
                                                 R.NROEMPRESA,
                                                 'N') ESTOQUE,
                        DECODE(E.INDGERARUPTURA,
                               'S',
                               'SIM',
                               'N',
                               'NAO',
                               'NAO') GERARUPTURA,
                        TO_CHAR(P.DTAHORINCLUSAO, 'DD/MM/YYYY HH24:MI:SS ') DTAINCLUSAO
        
          FROM MAP_FAMILIA F,
               MAP_PRODUTO P,
               MRL_PRODEMPSEG R,
               MAP_FAMFORNEC E,
               GE_PESSOA G,
               MAF_FORNECEDOR H,
               MAX_COMPRADOR C,
               MAP_FAMDIVISAO D,
               MRL_PRODUTOEMPRESA E,
               MAP_FAMEMBALAGEM I,
               MAC_CUSTOFORNECLOG A,
               (SELECT *
                  FROM (SELECT K.SEQFAMILIA,
                               K.SEQFORNECEDOR,
                               K.DTAULTALTERACAO,
                               RANK() OVER(PARTITION BY K.SEQFAMILIA, K.SEQFORNECEDOR ORDER BY K.DTAULTALTERACAO DESC) AS PRANK
                          FROM MAC_CUSTOFORNECLOG K) Z
                 WHERE Z.PRANK = 1) W
        
         WHERE F.SEQFAMILIA = P.SEQFAMILIA
           AND P.SEQPRODUTO = R.SEQPRODUTO
           AND P.SEQFAMILIA = W.SEQFAMILIA
           AND F.SEQFAMILIA = W.SEQFAMILIA
           AND E.SEQFAMILIA = W.SEQFAMILIA
           AND I.SEQFAMILIA = W.SEQFAMILIA
           AND D.SEQFAMILIA = W.SEQFAMILIA
           AND G.SEQPESSOA = W.SEQFORNECEDOR
           and e.seqfornecedor = W.seqfornecedor
           and a.DTAULTALTERACAO = w.DTAULTALTERACAO
           and w.PRANK = 1
           and C.SEQCOMPRADOR = A.SEQCOMPRADOR
           AND D.SEQCOMPRADOR = A.SEQCOMPRADOR
           AND P.SEQFAMILIA = A.SEQFAMILIA
           AND F.SEQFAMILIA = A.SEQFAMILIA
           AND E.SEQFAMILIA = A.SEQFAMILIA
           AND I.SEQFAMILIA = A.SEQFAMILIA
           AND D.SEQFAMILIA = A.SEQFAMILIA
           AND G.SEQPESSOA = A.SEQFORNECEDOR
           and e.seqfornecedor = a.seqfornecedor
           AND G.UF = A.UFEMPRESA
           AND D.NRODIVISAO = A.NRODIVISAO
           AND P.SEQFAMILIA = E.SEQFAMILIA
           AND P.SEQFAMILIA = I.SEQFAMILIA
           AND F.SEQFAMILIA = I.SEQFAMILIA
           AND E.SEQFAMILIA = I.SEQFAMILIA
           AND D.SEQFAMILIA = I.SEQFAMILIA
           AND G.SEQPESSOA = H.SEQFORNECEDOR
           AND E.SEQFORNECEDOR = H.SEQFORNECEDOR
           AND C.SEQCOMPRADOR = D.SEQCOMPRADOR
           AND E.SEQPRODUTO = P.SEQPRODUTO
           AND F.SEQFAMILIA = D.SEQFAMILIA
           AND R.NROEMPRESA = E.NROEMPRESA
           AND D.NRODIVISAO = 1) X,
       MAP_PRODCODIGO Y
 WHERE X.SEQPRODUTO = Y.SEQPRODUTO
   AND X.SEQFAMILIA = Y.SEQFAMILIA
   AND X.QTDEMBALAGEM = Y.QTDEMBALAGEM
   AND X.COMPRADOR IN ('NAELE')
   AND TO_CHAR(X.SEQFORNECEDOR) LIKE '%36529'
   AND X.NROEMPRESA IN (2)
   AND X.STATUS_COMPRA IN ('ATIVO')
   AND Y.TIPCODIGO IN ('E', 'D', 'F')
 ORDER BY 1, 3
 
------------------------------------------------------------------------------------- 
 

 
 
Digite o código do fornecedor:
Para selecionar todos os fornecedores coloque o caracter especial %

Selecione o comprador:

SELECT A.APELIDO
FROM MAX_COMPRADOR A
ORDER BY 1

Selecione as lojas:
1,2,3,4,5,6,7,8,9,10,11,12,32

Ativo compras:
ATIVO, INATIVO

Listar Produtos - Produto EAN C/CUSTO BASE
Listar produtos - PRODUTO
-------------------------------------------------------------------------------

SELECT X.NROEMPRESA,
       X.SEQFAMILIA,
       X.SEQPRODUTO,
       X.FAMILIA,
       X.PRODUTO,
       X.QTDEMBALAGEM,
       X.EMBALAGEM,
       Y.CODACESSO CODIGO,
       DECODE(Y.TIPCODIGO, 'D', 'DUM', 'E', 'EAN', 'F', 'REF') TIPO,
       X.COMPRADOR,
       X.SEQFORNECEDOR,
       X.VLRCUSTOBASE,
       X.SEQCUSTO,
       X.RAZAO_SOCIAL,
       X.STATUS_COMPRA,
       X.ESTOQUE,
       X.GERARUPTURA,
       X.DTAINCLUSAO

  FROM (SELECT DISTINCT E.NROEMPRESA,
                        F.SEQFAMILIA SEQFAMILIA,
                        P.SEQPRODUTO,
                        I.QTDEMBALAGEM,
                        I.EMBALAGEM,
                        F.FAMILIA,
                        P.COMPLEMENTO PRODUTO,
                        C.APELIDO COMPRADOR,
                        G.SEQPESSOA SEQFORNECEDOR,
                        a.seqcustofornec SEQCUSTO,
                        ROUND(A.VLRCUSTOBASE, 6) VLRCUSTOBASE,
                        UPPER(G.NOMERAZAO) RAZAO_SOCIAL,
                        DECODE(E.STATUSCOMPRA,
                               'A',
                               'ATIVO',
                               'I',
                               'INATIVO',
                               NULL) STATUS_COMPRA,
                        FC5ESTOQUEBASEDISPONIVEL(P.SEQPRODUTO,
                                                 R.NROEMPRESA,
                                                 'N') ESTOQUE,
                        DECODE(E.INDGERARUPTURA,
                               'S',
                               'SIM',
                               'N',
                               'NAO',
                               'NAO') GERARUPTURA,
                        TO_CHAR(P.DTAHORINCLUSAO, 'DD/MM/YYYY') DTAINCLUSAO
          FROM MAP_FAMILIA        F,
               MAP_PRODUTO        P,
               MRL_PRODEMPSEG     R,
               MAP_FAMFORNEC      E,
               GE_PESSOA          G,
               MAF_FORNECEDOR     H,
               MAX_COMPRADOR      C,
               MAP_FAMDIVISAO     D,
               MRL_PRODUTOEMPRESA E,
               MAP_FAMEMBALAGEM   I,
               MAC_CUSTOFORNECLOG A
        
         WHERE F.SEQFAMILIA = P.SEQFAMILIA
           AND P.SEQPRODUTO = R.SEQPRODUTO
           and C.SEQCOMPRADOR = A.SEQCOMPRADOR
           AND D.SEQCOMPRADOR = A.SEQCOMPRADOR
           AND P.SEQFAMILIA = A.SEQFAMILIA
           AND F.SEQFAMILIA = A.SEQFAMILIA
           AND E.SEQFAMILIA = A.SEQFAMILIA
           AND I.SEQFAMILIA = A.SEQFAMILIA
           AND D.SEQFAMILIA = A.SEQFAMILIA
           AND G.SEQPESSOA = A.SEQFORNECEDOR
           and e.seqfornecedor = a.seqfornecedor
           AND G.UF = A.UFEMPRESA
           AND D.NRODIVISAO = A.NRODIVISAO
           AND P.SEQFAMILIA = E.SEQFAMILIA
           AND P.SEQFAMILIA = I.SEQFAMILIA
           AND F.SEQFAMILIA = I.SEQFAMILIA
           AND E.SEQFAMILIA = I.SEQFAMILIA
           AND D.SEQFAMILIA = I.SEQFAMILIA
           AND G.SEQPESSOA = H.SEQFORNECEDOR
           AND E.SEQFORNECEDOR = H.SEQFORNECEDOR
           AND C.SEQCOMPRADOR = D.SEQCOMPRADOR
           AND E.SEQPRODUTO = P.SEQPRODUTO
           AND F.SEQFAMILIA = D.SEQFAMILIA
           AND R.NROEMPRESA = E.NROEMPRESA
           AND D.NRODIVISAO = 1) X,
       MAP_PRODCODIGO Y
 WHERE X.SEQPRODUTO = Y.SEQPRODUTO
   AND X.SEQFAMILIA = Y.SEQFAMILIA
   AND X.QTDEMBALAGEM = Y.QTDEMBALAGEM
   AND X.COMPRADOR IN (#LS1)
   AND TO_CHAR(X.SEQFORNECEDOR) LIKE '#LT1'
   AND X.NROEMPRESA IN (#LS2)
   AND X.STATUS_COMPRA IN (#LS3)
   AND Y.TIPCODIGO IN ('E', 'D', 'F')
 ORDER BY 1, 3
-------------------------------------------------------------------------------
SELECT X.NROEMPRESA,
       X.SEQFAMILIA,
       X.SEQPRODUTO,
       X.FAMILIA,
       X.PRODUTO,
       X.QTDEMBALAGEM,
       X.EMBALAGEM,
       Y.CODACESSO CODIGO,
       DECODE(Y.TIPCODIGO, 'D', 'DUM', 'E', 'EAN', 'F', 'REF') TIPO,
       X.COMPRADOR,
       X.SEQFORNECEDOR,
       X.VLRCUSTOBASE,
       X.SEQCUSTO,
       X.RAZAO_SOCIAL,
       X.STATUS_COMPRA,
       X.ESTOQUE,
       X.GERARUPTURA,
       X.DTAINCLUSAO,
       X.*
  FROM (SELECT DISTINCT E.NROEMPRESA,
                        F.SEQFAMILIA SEQFAMILIA,
                        P.SEQPRODUTO,
                        I.QTDEMBALAGEM,
                        I.EMBALAGEM,
                        F.FAMILIA,
                        P.COMPLEMENTO PRODUTO,
                        C.APELIDO COMPRADOR,
                        G.SEQPESSOA SEQFORNECEDOR,
                        a.seqcustofornec SEQCUSTO,
                        ROUND(A.VLRCUSTOBASE, 6) VLRCUSTOBASE,
                        (SELECT ROUND(A.VLRCUSTOBASE,6),
       
                        A.SEQCOMPRADOR,
                        A.SEQFAMILIA,
                        A.SEQFORNECEDOR,
                        A.DTAULTALTERACAO,
                        RANK() OVER(PARTITION BY A.VLRCUSTOBASE, A.SEQCOMPRADOR, A.SEQFAMILIA, A.SEQFORNECEDOR ORDER BY A.DTAULTALTERACAO DESC) AS PRANK
                         FROM MAC_CUSTOFORNECLOG A
                         WHERE A.SEQFAMILIA IN (58294, 58910)
                         and A.SEQFORNECEDOR = 208)-- LIKE '#LT1'
                        
                         ) X
                         WHERE X.PRANK = 2) W
                        
                        
                        (SELECT MAX(ROUND(A.QTDEMBCUSTO*A.VLRCUSTOBASE,6))FROM MAC_CUSTOFORNECLOG A
                         WHERE C.SEQCOMPRADOR = A.SEQCOMPRADOR
                         AND D.SEQCOMPRADOR = A.SEQCOMPRADOR
                         AND P.SEQFAMILIA = A.SEQFAMILIA
                         AND F.SEQFAMILIA = A.SEQFAMILIA
                         AND E.SEQFAMILIA = A.SEQFAMILIA
                         AND I.SEQFAMILIA = A.SEQFAMILIA
                         AND D.SEQFAMILIA = A.SEQFAMILIA
                           AND G.SEQPESSOA = A.SEQFORNECEDOR
                            and e.seqfornecedor = a.seqfornecedor
                             -- and a.nroempresa = e.nroempresa
                              AND G.UF = A.UFEMPRESA
                               AND D.NRODIVISAO = A.NRODIVISAO)VLRCUSTOBASE, */
                        UPPER(G.NOMERAZAO) RAZAO_SOCIAL,
                        DECODE(E.STATUSCOMPRA,
                               'A',
                               'ATIVO',
                               'I',
                               'INATIVO',
                               NULL) STATUS_COMPRA,
                        FC5ESTOQUEBASEDISPONIVEL(P.SEQPRODUTO,
                                                 R.NROEMPRESA,
                                                 'N') ESTOQUE,
                        DECODE(E.INDGERARUPTURA,
                               'S',
                               'SIM',
                               'N',
                               'NAO',
                               'NAO') GERARUPTURA,
                        TO_CHAR(P.DTAHORINCLUSAO, 'DD/MM/YYYY') DTAINCLUSAO
          FROM MAP_FAMILIA        F,
               MAP_PRODUTO        P,
               MRL_PRODEMPSEG     R,
               MAP_FAMFORNEC      E,
               GE_PESSOA          G,
               MAF_FORNECEDOR     H,
               MAX_COMPRADOR      C,
               MAP_FAMDIVISAO     D,
               MRL_PRODUTOEMPRESA E,
               MAP_FAMEMBALAGEM   I,
               MAC_CUSTOFORNECLOG A  
        
         WHERE F.SEQFAMILIA = P.SEQFAMILIA
           AND P.SEQPRODUTO = R.SEQPRODUTO
           and C.SEQCOMPRADOR = A.SEQCOMPRADOR
           AND D.SEQCOMPRADOR = A.SEQCOMPRADOR
           AND P.SEQFAMILIA = A.SEQFAMILIA
           AND F.SEQFAMILIA = A.SEQFAMILIA
           AND E.SEQFAMILIA = A.SEQFAMILIA
           AND I.SEQFAMILIA = A.SEQFAMILIA
           AND D.SEQFAMILIA = A.SEQFAMILIA
           AND G.SEQPESSOA = A.SEQFORNECEDOR
           and e.seqfornecedor = a.seqfornecedor
              -- and a.nroempresa = e.nroempresa
           AND G.UF = A.UFEMPRESA
           AND D.NRODIVISAO = A.NRODIVISAO
           AND P.SEQFAMILIA = E.SEQFAMILIA
           AND P.SEQFAMILIA = I.SEQFAMILIA
           AND F.SEQFAMILIA = I.SEQFAMILIA
           AND E.SEQFAMILIA = I.SEQFAMILIA
           AND D.SEQFAMILIA = I.SEQFAMILIA
           AND G.SEQPESSOA = H.SEQFORNECEDOR
           AND E.SEQFORNECEDOR = H.SEQFORNECEDOR
           AND C.SEQCOMPRADOR = D.SEQCOMPRADOR
           AND E.SEQPRODUTO = P.SEQPRODUTO
           AND F.SEQFAMILIA = D.SEQFAMILIA
           AND R.NROEMPRESA = E.NROEMPRESA
           AND D.NRODIVISAO = 1) X,
       MAP_PRODCODIGO Y
 WHERE X.SEQPRODUTO = Y.SEQPRODUTO
   AND X.SEQFAMILIA = Y.SEQFAMILIA
   AND X.QTDEMBALAGEM = Y.QTDEMBALAGEM
      -- AND X.COMPRADOR IN ('&LS1')
   AND TO_CHAR(X.SEQFORNECEDOR) IN (26506) -- LIKE '#LT1'
   AND X.SEQPRODUTO IN (717)
   AND X.NROEMPRESA IN (2)
      --   AND X.STATUS_COMPRA = 'A'
   AND Y.TIPCODIGO IN ('E', 'D', 'F')
 ORDER BY 1, 3







--------------------------------------------------------------------------------
SELECT * FROM MAC_CUSTOFORNEC



 select * FROM MAC_CUSTOFORNECLOG J
 WHERE J.SEQFAMILIA IN (58294, 58910)
 and J.SEQFORNECEDOR = 208
 AND P.SEQFAMILIA = 55395
 AND J.SEQFAMILIA = P.SEQFAMILIA;
 SELECT * FROM MAF_FORNECEDOR ;
 SELECT * FROM MAP_FAMILIA;
 SELECT * FROM MAP_PRODUTO;
SELECT * FROM MRL_PRODEMPSEG ;
SELECT * FROM MAP_FAMFORNEC ; 
SELECT * FROM GE_PESSOA;          
SELECT * FROM MAX_COMPRADOR;    
SELECT * FROM  MAP_FAMDIVISAO;     
SELECT * FROM MRL_PRODUTOEMPRESA; 
SELECT * FROM  MAP_FAMEMBALAGEM;   
