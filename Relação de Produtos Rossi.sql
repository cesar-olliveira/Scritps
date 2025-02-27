-------------------------------------------------------------------------------------------------------
-------------------------------- RELAÇÃO DE PRODUTOS DO ROSSI -----------------------------------------
-------------------------------------------------------------------------------------------------------


SELECT DISTINCT P.SEQPRODUTO,
       P.DESCCOMPLETA,
       R.CODPRODUTO,
       (SELECT MAX(PP.CODACESSO)
          from map_prodcodigo PP
         where PP.SEQPRODUTO = P.SEQPRODUTO
           and PP.tipcodigo = 'E') CODACESSO
  from MAP_PRODUTO P, RFV_PRODUTO R

 WHERE R.SEQPRODUTO = P.SEQPRODUTO
   AND upper(p.desccompleta) like 'RS%'
   AND R.NROEMPRESA IN (6,10)
-- AND R.CODPRODUTO = ''
  
