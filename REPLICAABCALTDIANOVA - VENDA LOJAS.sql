-----------------------------------------------------------------------------------------------------
-------------------------------- REPLICAABCALTDIANOVA - VENDA LOJAS ---------------------------------
-----------------------------------------------------------------------------------------------------

select /*+OPTIMIZER_FEATURES_ENABLE('10.2.0.4')*/  
V.NROEMPRESA,

TO_CHAR(V.dtavda, 'DD/MM/YYYY') DIA_MES,

sum( V.QTDITEM / K.QTDEMBALAGEM )
as QUANTIDADE,

sum( ( round( V.VLRITEM, 2 ) ) )
as VLRVENDANORMAL,

sum( 
( ( (Y.CMDIAVLRNF ) + Y.CMDIAIPI - Y.CMDIACREDICMS - nvl( Y.CMDIACREDPIS, 0 ) - nvl( Y.CMDIACREDCOFINS, 0 ) - nvl( Y.CMDIACREDIPI, 0 ) + Y.CMDIAICMSST + Y.CMDIADESPNF + Y.CMDIADESPFORANF - Y.CMDIADCTOFORANF ) 

*
 CASE WHEN DV.UTILACRESCCUSTPRODRELAC = 'S' AND NVL(A.SEQPRODUTOBASE, A.SEQPRODUTOBASEANTIGO) IS NOT NULL THEN 
 COALESCE(PR.PERCACRESCCUSTORELACVIG, NVL(F_RETACRESCCUSTORELACABC(V.SEQPRODUTO, V.DTAVDA), 1))
 ELSE 
 1
 END

*
DECODE('S', 'N', 1, NVL( a.propqtdprodutobase, 1) )
- ( decode( Y.QTDVERBAVDA, 0, 0, Y.VLRVERBAVDA * NVL( a.propqtdprodutobase, 1 ) /
 DECODE(NVL(Y.QTDVDA,0), 0, Y.QTDVERBAVDA, Y.QTDVDA) ) )
+ decode (V.ACMCOMPRAVENDA,'N', 0,
 decode( 'N', 'S', 0,
 ( decode( nvl( Y.VLRVERBAVDAACR, 0 ), 0, 0, Y.VLRVERBAVDAACR * NVL( a.propqtdprodutobase, 1 ) /
 DECODE(NVL(Y.QTDVDA,0), 0, 1, Y.QTDVDA) ) ) )
 ) )
 * (V.QTDITEM))
as VLRCTOLIQVDA,


sum( 
( decode( Y.QTDVERBAVDA, 0, 0,
 ( Y.VLRVERBAVDA - nvl( Y.VLRverbaVDAindevida, 0 ) )
 * nvl( a.propqtdprodutobase, 1 )
 / Y.QTDVDA )
)
*
( V.QTDITEM ) ) 
as VLRVERBA,

sum(
decode( V.ACMCOMPRAVENDA, 'I', ( V.VLRITEM * ( V.PERCPMF + V.PEROUTROIMPOSTO ) / 100 ), 
 decode( Y.QTDVDA * V.QTDITEM, 0, 0, ( Y.VLRIMPOSTOVDA - nvl( Y.VLRIPIVDA, 0 ) ) * DECODE('S','N',1, NVL( a.propqtdprodutobase, 1) ) / Y.QTDVDA * V.QTDITEM ) )
+ decode( V.ACMCOMPRAVENDA, 'I', 0, 
 decode( V.ICMSEFETIVOITEM, 0, V.ICMSITEM, V.ICMSEFETIVOITEM ) 
 + V.VLRFCPICMS + V.PISITEM + V.COFINSITEM )
) 
as VLRIMPOSTOVDA,

CP.APELIDO COMPRADOR,

VC.COD1,
VC.NIVEL1,
VC.COD2,
VC.NIVEL2,

sum( V.ICMSITEM )
as VLRICMS,

sum( V.PISITEM )
as VLRPIS,

sum( V.COFINSITEM )
as VLRCOFINS

from MRL_CUSTODIA Y, (SELECT * FROM
                     MAXV_ABCDISTRIBBASE V
                     WHERE V.nroformapagto NOT IN (68, 73)) V, MAX_COMPRADOR CP, MAP_PRODUTO A, MAP_PRODUTO PB, MAP_FAMDIVISAO D, MAP_FAMEMBALAGEM K, MAX_EMPRESA E, MAX_DIVISAO DV, MAP_PRODACRESCCUSTORELAC PR, MRLV_DESCONTOREGRA RE,
VERAN_CATEGORIA VC, MAP_FAMDIVCATEG FD 
where D.SEQFAMILIA = A.SEQFAMILIA
and D.NRODIVISAO = V.NRODIVISAO
and V.SEQPRODUTO = A.SEQPRODUTO
and V.SEQPRODUTOCUSTO = PB.SEQPRODUTO
and V.NROEMPRESA IN (2,3,4,5,6,7,8,9,10,11,12,32,33,34)
and V.NROSEGMENTO in ( 3,8,9,2,12,14,13,1,11 )
and V.NRODIVISAO = D.NRODIVISAO
and E.NROEMPRESA = V.NROEMPRESA
and E.NRODIVISAO = DV.NRODIVISAO
AND V.SEQPRODUTO = PR.SEQPRODUTO(+)
AND V.DTAVDA = PR.DTAMOVIMENTACAO(+)
AND CP.SEQCOMPRADOR = D.SEQCOMPRADOR
AND D.SEQFAMILIA = FD.SEQFAMILIA
AND E.NRODIVISAO = FD.NRODIVISAO
AND FD.SEQCATEGORIA = VC.COD5
AND FD.STATUS='A'
and Y.DTAENTRADASAIDA BETWEEN (TRUNC(LAST_DAY(SYSDATE-1)) - TO_CHAR(TRUNC(LAST_DAY(SYSDATE-1)), 'DD') + 1) AND TRUNC(SYSDATE-1)
-- and Y.DTAENTRADASAIDA BETWEEN '01-oct-2023' and '08-oct-2023'
and Y.NROEMPRESA = nvl( E.NROEMPCUSTOABC, E.NROEMPRESA ) 
and Y.DTAENTRADASAIDA = V.DTAVDA
 and K.SEQFAMILIA = A.SEQFAMILIA and K.QTDEMBALAGEM = 1 AND V.SEQPRODUTO = RE.SEQPRODUTO (+) 
AND V.DTAVDA = RE.DATAFATURAMENTO (+)
AND V.NRODOCTO = RE.NUMERODF (+)
AND V.SERIEDOCTO = RE.SERIEDF (+) 
AND V.NROEMPRESA = RE.NROEMPRESA (+) 
and Y.SEQPRODUTO = PB.SEQPRODUTO

and V.QTDITEM != 0
and DECODE(V.TIPTABELA, 'S', V.CGOACMCOMPRAVENDA, V.ACMCOMPRAVENDA) in ( 'S', 'I' ) 
and V.CODGERALOPER <> 517
and V.CODGERALOPER = 309


group by CP.APELIDO,
V.NROEMPRESA,
TO_CHAR(V.dtavda, 'DD/MM/YYYY'),
VC.COD1,
VC.NIVEL1,
VC.COD2,
VC.NIVEL2
 

