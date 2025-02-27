--------------------------------------------------------------------------------------------------------
----------------------------------- Agenda Fornecedores ------------------------------------------------
--------------------------------------------------------------------------------------------------------


select TO_CHAR(A.DTAVISITA, 'DD/MM/YYYY')DTAVISITA,
       TO_CHAR(A.DTAVISITA, 'DY', 'NLS_DATE_LANGUAGE=PORTUGUESE') SEM,
       CASE
         WHEN A.HORVISITA = '0000' THEN
          '00:00'
         ELSE
          SUBSTR(A.HORVISITA, 1, 2) || ':' || SUBSTR(A.HORVISITA, 3, 2)
       END HORARIO,
       A.SEQFORNECEDOR CODIGO,
       B.NOMERAZAO FORNECEDOR,
       B.FANTASIA,
       (Select D.DIVISAO
          From MAX_DIVISAO D
         Where D.NRODIVISAO = A.NRODIVISAO) DIVISAO,
       (Select DESCRICAO
          From MAX_ATRIBUTOFIXO
         Where LISTA = '1'
           And TIPATRIBUTOFIXO = 'OCORR_AGENDA_FORN') OCORRENCIA,
       
       (Select C.APELIDO
          From MAX_COMPRADOR C
         Where C.SEQCOMPRADOR = A.SEQCOMPRADOR) COMPRADOR,
       A.OBSERVACAO,
       A.USUALTERACAO

  from MAF_FORNECAGENDA A, GE_PESSOA B

 where A.DTAVISITA >= TO_CHAR(SYSDATE, 'DD/MM/YYYY') 
   and A.SEQCOMPRADOR = '17'
   AND A.SEQFORNECEDOR = B.SEQPESSOA
 order by 1, 8





