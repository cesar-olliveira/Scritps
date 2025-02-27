--------------------------------------------------------------------------------------------------------------------
----------------------------------------- LEVANTAMENTO DE INFORMAÇÃOES LOJA 3 --------------------------------------
--------------------------------------------------------------------------------------------------------------------

select distinct loja,
                CODIGO,
                nvl(CASE
                    WHEN NVL(CODACESSO, 0) = 0
                    THEN CODBALANCA 
                    ELSE CODACESSO END,0) EAN,
                TIPO_PRODUTO, 
                UNID_VENDA,
                DECODE(PESAVEL, 'S', 'P', 'N', 'U') TIPO_BALANÇA,
                descricao,
                DESC_RESUM,
                DESC_RESUM DESC_PDV,
                veran_f_custobruto(loja, SEQPRODUTO, FAMILIA, (SYSDATE)) CUSTO,
                PRECO_VENDA,
                PRECO_PROMO,
                FAMILIA,
                FCATEGORIASEQNIVEL(FAMILIA, 1, 1, 'M') COD1,
                FCATEGORIAFAMILIANIVEL(FAMILIA, 1, 1, 'M') NIVEL1,
                FCATEGORIASEQNIVEL(FAMILIA, 1, 2, 'M') COD2,
                FCATEGORIAFAMILIANIVEL(FAMILIA, 1, 2, 'M') NIVEL2,
                FCATEGORIASEQNIVEL(FAMILIA, 1, 3, 'M') COD3,
                FCATEGORIAFAMILIANIVEL(FAMILIA, 1, 3, 'M') NIVEL3,
                FCATEGORIASEQNIVEL(FAMILIA, 1, 4, 'M') COD4,
                FCATEGORIAFAMILIANIVEL(FAMILIA, 1, 4, 'M') NIVEL4,
                FCATEGORIASEQNIVEL(FAMILIA, 1, 5, 'M') COD5,
                FCATEGORIAFAMILIANIVEL(FAMILIA, 1, 5, 'M') NIVEL5, 
                COD_FISCAL, 
                DESC_CLASS_FISC, 
                ncm,
                TIBUT_PDV,
                NVL(cest, 0) CEST,
                nvl(FMRL_ESTQINICIALPRODEMPDATA(seqproduto,
                                                loja,
                                                'F',
                                                (SYSDATE)),
                    0) ESTOQUE,
                PIS_SAI,    
                DESC_PIS_SAI,     
                CONFIS_SAI, 
                DESC_CONFIS_SAI,     
                NAT_RECEITA,
                VALIDADE,
                INDVASILHAME,
                CODINTERNOVASILHAME

  from (select CASE
                 WHEN PE.SEQPRODUTO =
                      (select DISTINCT s.seqproduto
                         from mrl_receitarendto r, MRL_RRCOMPONENTE s
                        where r.seqreceitarendto = s.seqreceitarendto
                          and s.seqproduto = p.seqproduto
                          and r.indcestabasicapdv = 'S'
                          AND R.STATUSRECRENDTO = 'A') THEN
                  'C - COMPOSTO'
               
                 WHEN PE.SEQPRODUTO =
                      (select DISTINCT s.seqproduto
                         from mrl_receitarendto r,
                              MRL_RRCOMPONENTE  s,
                              map_prodcodigo    PP,
                              map_familia       f
                        where r.seqreceitarendto = s.seqreceitarendto
                          AND S.SEQPRODUTO = PP.SEQPRODUTO
                          and s.seqproduto = p.seqproduto
                          AND PP.SEQFAMILIA = P.SEQFAMILIA
                          AND F.SEQFAMILIA = PP.SEQFAMILIA
                          AND F.PESAVEL = 'S'
                          AND PP.TIPCODIGO = 'B'
                          AND R.STATUSRECRENDTO = 'A') 
                   THEN
                  'B - BALANÇA'
                  
                   WHEN PE.SEQPRODUTO =
                                            
                  (select DISTINCT p1.seqproduto
                         from map_familia f, map_produto p1, map_prodcodigo PP, MRL_PRODUTOEMPRESA PE
                        where p1.seqfamilia = f.seqfamilia
                          and p1.seqproduto = pp.seqproduto
                          AND P1.SEQPRODUTO = PE.SEQPRODUTO
                           and P.seqproduto = p1.seqproduto
                          AND PP.SEQFAMILIA = P1.SEQFAMILIA
                          AND PE.NROEMPRESA = 3
                          AND F.PESAVEL = 'S'
                          AND PP.TIPCODIGO = 'B') 
                  THEN
               'B - BALANÇA'
                  

                 WHEN PE.SEQPRODUTO IN
                      (select DISTINCT s.seqproduto
                         from mrl_receitarendto r,
                              MRL_RRCOMPONENTE  s,
                              map_prodcodigo    PP
                        where r.seqreceitarendto = s.seqreceitarendto
                          AND S.SEQPRODUTO = PP.SEQPRODUTO
                          and s.seqproduto = p.seqproduto
                          AND PP.SEQFAMILIA = P.SEQFAMILIA
                          AND R.STATUSRECRENDTO = 'A'
                           AND r.indcestabasicapdv = 'N'
                          ) THEN
                  'F - FRACIONADO'
               
                 ELSE
                  'P - PRODUTO'
               END TIPO_PRODUTO, 
               
               pe.nroempresa loja,
               NVL(p.seqproduto, 0) codigo,
               NVL(p.seqproduto, 0) seqproduto,
               NVL(p.desccompleta, NULL) descricao,
               NVL(p.descreduzida, NULL) desc_resum,
               
               NVL(f.codnbmsh, 0) ncm,
               NVL(f.codcest, 0) cest,
               nvl(F.SEQFAMILIA, 0) FAMILIA,
               NVL(f.pesavel, NULL) PESAVEL,
               fcodacessoproduto(PE.SEQPRODUTO,
                                 'E',
                                 'S',
                                 Y.Qtdembalagem,
                                 E.NROEMPRESA) CODACESSO,
                fcodacessoproduto(PE.SEQPRODUTO,
                                 'B',
                                 'S',
                                 Y.Qtdembalagem,
                                 E.NROEMPRESA) CODBALANCA,                 
               F.CODNATREC NAT_RECEITA,
               NVL(Y.PRECOVDANORMAL, 0) PRECO_VENDA,
               NVL(Y.PRECOVDAPROMOC, 0) PRECO_PROMO,
               NVL(e.indgercustodiaemp, 0) CUSTODIAEMP,
               nvl(y.embalagem, 0) UNID_VENDA,
               nvl(F.INDVASILHAME, null) INDVASILHAME,
               nvl(F.SEQVASILHAME, 0) CODINTERNOVASILHAME,
               nvl(p.pzovalidadedia, 0) VALIDADE,
              (  SELECT DISTINCT max.LISTA
                FROM 	 MAX_ATRIBUTOFIXO max
                WHERE  max.TIPATRIBUTOFIXO = 'SIT_TRIBUT_COFINS_SAI'
                AND    max.seqatributofixo = f.situacaonfcofinssai)CONFIS_SAI,
              
               (  SELECT DISTINCT max.descricao
                FROM 	 MAX_ATRIBUTOFIXO max
                WHERE  max.TIPATRIBUTOFIXO = 'SIT_TRIBUT_COFINS_SAI'
                AND    max.seqatributofixo = f.situacaonfcofinssai)DESC_CONFIS_SAI, 
               
                (  SELECT DISTINCT max.LISTA
                FROM 	 MAX_ATRIBUTOFIXO max
                WHERE  max.TIPATRIBUTOFIXO = 'SIT_TRIBUT_PIS_SAI'
                AND    max.seqatributofixo = f.situacaonfcofinssai)PIS_SAI,
               
               (  SELECT DISTINCT max.descricao
                FROM 	 MAX_ATRIBUTOFIXO max
                WHERE  max.TIPATRIBUTOFIXO = 'SIT_TRIBUT_PIS_SAI'
                AND    max.seqatributofixo = f.situacaonfcofinssai)DESC_PIS_SAI,
               
                (SELECT T.NROTRIBUTACAO
                  FROM MAP_FAMDIVISAO D, MAP_TRIBUTACAO T
                 WHERE D.NROTRIBUTACAO = T.NROTRIBUTACAO
                   AND D.NRODIVISAO = 1
                   AND D.SEQFAMILIA = F.SEQFAMILIA) COD_FISCAL,
               (SELECT T.TRIBUTACAO
                  FROM MAP_FAMDIVISAO D, MAP_TRIBUTACAO T
                 WHERE D.NROTRIBUTACAO = T.NROTRIBUTACAO
                   AND D.NRODIVISAO = 1
                   AND D.SEQFAMILIA = F.SEQFAMILIA) DESC_CLASS_FISC ,
                   
             (SELECT DISTINCT DECODE(H.CODTRIBUTACAOPDV,
                                    1,
                                    'ST',
                                    2,
                                    'ISENTO',
                                    3,
                                    '18%',
                                    4,
                                    '25%',
                                    5,
                                    '12%',
                                    6,
                                    '7%',
                                    7,
                                    '11%',
                                    'OUTROS') 
                  FROM MAP_FAMDIVISAO  C,
                       MAP_FAMDIVCATEG D,
                       MAP_TRIBUTACAO    G,
                       MRL_TRIBUTACAOPDV H
                 WHERE G.NROTRIBUTACAO = H.NROTRIBUTACAO
                   AND C.SEQFAMILIA = D.SEQFAMILIA
                   AND G.NROTRIBUTACAO = C.NROTRIBUTACAO
                   AND C.NRODIVISAO = D.NRODIVISAO
                   AND C.NRODIVISAO = 1
                   AND D.STATUS = 'A'
                   AND D.SEQFAMILIA = F.SEQFAMILIA 
                   AND H.NROEMPRESA = PE.nroempresa) TIBUT_PDV        
                   
                   
        
          from max_empresa e,
               map_produto p,
               map_familia f,
               (select NVL(YY.PRECOVDANORMAL, 0) PRECOVDANORMAL,
                       NVL(YY.PRECOVDAPROMOC, 0) PRECOVDAPROMOC,
                       YY.Nroempresa,
                       NVL(YY.Seqproduto, 0) SEQPRODUTO,
                       NVL(YY.embalagem, 0) EMBALAGEM,
                       nvl(yy.Qtdembalagem, 0) QTDEMBALAGEM
                  from MAXV_CONSPROD_GPRECOS YY
                 where YY.NROSEGMENTO = 9
                   and YY.Nroempresa = 3
                   AND YY.embalagem IN ('UN 1', 'KG 1')) Y,
               mrl_produtoempresa PE
        
         where p.seqfamilia = f.seqfamilia
           AND Y.Seqproduto(+) = P.SEQPRODUTO
           AND Y.Nroempresa(+) = E.NROEMPRESA
           AND P.SEQPRODUTO = PE.SEQPRODUTO(+)
           AND E.NROEMPRESA = PE.NROEMPRESA(+)
           and pe.nroempresa in (3)
          and p.seqproduto =  (select DISTINCT p1.seqproduto
                         from map_familia f, map_produto p1, map_prodcodigo PP, MRL_PRODUTOEMPRESA PE
                        where p1.seqfamilia = f.seqfamilia
                          and p1.seqproduto = pp.seqproduto
                          AND P1.SEQPRODUTO = PE.SEQPRODUTO
                           and P.seqproduto = p1.seqproduto
                          AND PP.SEQFAMILIA = P1.SEQFAMILIA
                          AND pp.indutilvenda = 'S'
                          and pp.tipcodigo <> 'F'
                          AND PE.NROEMPRESA = 3)
        
        )
    WHERE FCATEGORIAFAMILIANIVEL(FAMILIA, 1, 1, 'M') NOT IN ('SERVICOS', ' A CLASSIFICAR')    

 order by 2;

------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------- EANs ALTERNATIVOS ----------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
  
SELECT SEQPRODUTO,
     nvl(CASE
  WHEN NVL(CODACESSO, 0) = 0
  THEN CODBALANCA 
  ELSE CODACESSO END,0) EAN,
       CODIGO ALTERNATIVO,
       EMBALAGEM,
       0 VALOR
  FROM (select DISTINCT NVL(pe.seqproduto, 0) SEQPRODUTO,
                        fcodacessoproduto(PE.SEQPRODUTO,
                                          'E',
                                          'S',
                                          Y.Qtdembalagem,
                                          PE.NROEMPRESA) CODACESSO,
                       fcodacessoproduto(PE.SEQPRODUTO,
                                           'B',
                                           'S',
                                           Y.Qtdembalagem,
                                           pE.NROEMPRESA) CODBALANCA,                    
                                          
                                          
                        NVL(pp.codacesso, 0) CODIGO,
                        Y.EMBALAGEM
                        
        
          from mrl_produtoempresa pe,
               map_prodcodigo PP,
               (select NVL(YY.PRECOVDANORMAL, 0) PRECOVDANORMAL,
                       NVL(YY.PRECOVDAPROMOC, 0) PRECOVDAPROMOC,
                       YY.Nroempresa,
                       YY.seqfamilia FAMILIA,
                       NVL(YY.Seqproduto, 0) SEQPRODUTO,
                       NVL(YY.embalagem, 0) EMBALAGEM,
                       nvl(yy.Qtdembalagem, 0) QTDEMBALAGEM
                  from MAXV_CONSPROD_GPRECOS YY
                 where YY.NROSEGMENTO = 9
                   and YY.Nroempresa = 3
                   AND YY.embalagem IN ('UN 1', 'KG 1')) Y
         where PE.nroempresa in (3)
         --  and PE.statuscompra = 'A'
           and pe.seqproduto = pp.seqproduto(+)
           AND Y.Seqproduto(+) = PE.SEQPRODUTO
           AND Y.Nroempresa(+) = PE.NROEMPRESA
           and pp.tipcodigo in ('E', 'D', 'B')
           and pe.seqproduto  =  (select DISTINCT p1.seqproduto
                         from map_familia f, map_produto p1, map_prodcodigo PP, MRL_PRODUTOEMPRESA PE1
                        where p1.seqfamilia = f.seqfamilia
                          and p1.seqproduto = pp.seqproduto
                          AND P1.SEQPRODUTO = PE1.SEQPRODUTO
                           and pe.seqproduto = p1.seqproduto
                          AND PP.SEQFAMILIA = P1.SEQFAMILIA
                          AND pp.indutilvenda = 'S'
                          and pp.tipcodigo <> 'F'
                          AND PE1.NROEMPRESA = 3)
           
           AND FCATEGORIAFAMILIANIVEL(FAMILIA, 1, 1, 'M') NOT IN ('SERVICOS', ' A CLASSIFICAR')
           )
 WHERE CASE
         WHEN CODACESSO = CODIGO THEN
          0
         ELSE
          1
       END = 1
       
---------------------------------------------------------------------------------------------------------   
----------------------------- Listagem De Todos Os Produtos - Código De Pdv -----------------------------
---------------------------------------------------------------------------------------------------------

SELECT H.NROEMPRESA,
       MAX(B.SEQPRODUTO) COD_PROD,
       L.CODNBMSH NCM,
       MAX(J.CODACESSO) EAN,
       B.DESCCOMPLETA,
       I.SEQFORNECEDOR COD_FORNEC,
       K.NOMERAZAO FORNECEDOR,
       K.UF,
       C.NROTRIBUTACAO TRIB_ENTRADA_COD,
       G.TRIBUTACAO TRIB_ENTRADA,
       H.CODTRIBUTACAOPDV TRIB_PDV_COD,
       DECODE(H.CODTRIBUTACAOPDV,
              1,
              'ST',
              2,
              'ISENTO',
              3,
              '18%',
              4,
              '25%',
              5,
              '12%',
              6,
              '7%',
              7,
              '11%',
              'OUTROS') TIBUT_PDV,
       L.SITUACAONFPIS || ' - ' || PE.DESCRICAO PIS_ENTRADA,
       L.SITUACAONFCOFINS || ' - ' || CE.DESCRICAO COFINS_ENTRADA,
       L.SITUACAONFPISSAI || ' - ' || PS.DESCRICAO PIS_SAIDA,
       L.SITUACAONFCOFINSSAI || ' - ' || CS.DESCRICAO COFINS_SAIDA
  FROM VERAN_PRODUTOS B,
       MAP_FAMDIVISAO C,
       MAP_FAMDIVCATEG D,
       MAX_COMPRADOR F,
       MAP_TRIBUTACAO G,
       MRL_TRIBUTACAOPDV H,
       VERAN_CATEGORIA E,
       MAF_FORNECEDOR I,
       MAP_PRODCODIGO J,
       GE_PESSOA K,
       MAP_FAMILIA L,
       (SELECT LISTA, DESCRICAO, TIPATRIBUTOFIXO
          FROM MAX_ATRIBUTOFIXO
         WHERE TIPATRIBUTOFIXO IN ('SIT_TRIBUT_PIS')) PE,
       (SELECT LISTA, DESCRICAO, TIPATRIBUTOFIXO
          FROM MAX_ATRIBUTOFIXO
         WHERE TIPATRIBUTOFIXO IN ('SIT_TRIBUT_COFINS')) CE,
       (SELECT LISTA, DESCRICAO, TIPATRIBUTOFIXO
          FROM MAX_ATRIBUTOFIXO
         WHERE TIPATRIBUTOFIXO IN ('SIT_TRIBUT_PIS_SAI')) PS,
       (SELECT LISTA, DESCRICAO, TIPATRIBUTOFIXO
          FROM MAX_ATRIBUTOFIXO
         WHERE TIPATRIBUTOFIXO IN ('SIT_TRIBUT_COFINS_SAI')) CS
 WHERE B.SEQFAMILIA = C.SEQFAMILIA
   AND C.SEQFAMILIA = D.SEQFAMILIA
   AND C.SEQCOMPRADOR = F.SEQCOMPRADOR
   AND D.SEQCATEGORIA = E.COD5
   AND G.NROTRIBUTACAO = C.NROTRIBUTACAO
   AND G.NROTRIBUTACAO = H.NROTRIBUTACAO
   AND B.SEQFORNECEDOR = I.SEQFORNECEDOR
   AND B.SEQPRODUTO = J.SEQPRODUTO
   AND C.NRODIVISAO = D.NRODIVISAO
   AND B.SEQFORNECEDOR = K.SEQPESSOA
   AND B.FORNECEDOR = K.NOMERAZAO
   AND B.SEQFAMILIA = L.SEQFAMILIA
   AND L.SITUACAONFPIS = PE.LISTA
   AND L.SITUACAONFCOFINS = CE.LISTA
   AND L.SITUACAONFPISSAI = PS.LISTA
   AND L.SITUACAONFCOFINSSAI = CS.LISTA
   AND C.NRODIVISAO = 1
   AND D.STATUS = 'A'
   AND H.NROEMPRESA IN (#LS1)
 GROUP BY L.CODNBMSH,
          H.NROEMPRESA,
          B.DESCCOMPLETA,
          K.NOMERAZAO,
          K.UF,
          I.SEQFORNECEDOR,
          C.NROTRIBUTACAO,
          G.TRIBUTACAO,
          H.CODTRIBUTACAOPDV,
          H.CODTRIBUTACAOPDV,
          SITUACAONFPIS,
          L.SITUACAONFCOFINS,
          PE.DESCRICAO,
          CE.DESCRICAO,
          L.SITUACAONFPISSAI,
          PS.DESCRICAO,
          L.SITUACAONFCOFINSSAI,
          CS.DESCRICAO
 ORDER BY 1, 2



