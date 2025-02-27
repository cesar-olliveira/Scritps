SELECT YY.NROEMPRESA,
       YY.NROTITULO,
       YY.CODESPECIE,
       YY.CODOPERACAO,
       YY.SEQPESSOA,
       YY.NOMERAZAO,
       YY.VLROPERACAO,
       YY.VLR_LIQUIDO,
       YY.VLRDESCFINDISP,
       CASE
         WHEN YY.CODOPERACAO = 16 THEN
          YY.VLR_CRDESC
         ELSE
          NULL
       END VLR_CRDESC,
       YY.VLR_PAGO,
       YY.BANCO_PGTO,
       TO_CHAR(YY.DTAEMISSAO, 'DD/MM/YYYY') DTAEMISSAO,
       YY.DTAINCLUSAO,
       YY.DTAMOVIMENTO,
       YY.DTAVENCIMENTO,
       YY.DTAPROGRAMADA,
       YY.ABERTOQUITADO,
       (SELECT MAX(OO.APELIDO) 
                  FROM MAX_COMPRADOR OO,
                       MAF_FORNECDIVISAO D
           WHERE OO.SEQCOMPRADOR = D.SEQCOMPRADOR
              AND D.SEQFORNECEDOR = YY.SEQPESSOA) COMPRADOR,
       YY.USUARIO_INCLUSAO,
       YY.NOME_USR_INCLUSAO,
       YY.USUARIO_QUITACAO,
       YY.NOME_USR_QUITACAO,

        TRIM(REPLACE(REPLACE(YY.OBSERVACAO,CHR(10),' '), CHR(13),' ')) OBSERVACAO,
       (SELECT AA.CODHISTORICO ||' - '|| INITCAP(CC.DESCRICAO)
                      FROM OR_NFDESPESA        AA,
                           CT_HISTORICO        CC
                           WHERE AA.CODHISTORICO = CC.CODHISTORICO 
                             AND CC.NROEMPRESA = YY.NROEMPRESAMAE
                             AND AA.NROEMPRESA = YY.NROEMPRESA
                             AND AA.NRONOTA = YY.NROTITULO
                             AND AA.SEQPESSOA = YY.SEQPESSOA
                             AND AA.LINKERP = YY.LINKERP
                             AND AA.DTAEMISSAO = YY.DTAEMISSAO) NATUREZA,
      
       YY.FORMAPGTO,
       YY.CODBARRA,
       YY.TIPODOCUMENTO,

       NVL(YY.OBS,0)DETHALOPERC_OBS,
       YY.SEQCONTA,
       YY.BANCO,
       YY.AGENCIA,
       YY.DIGAGENCIA,
       YY.NROCONTA,
       YY.DIGCONTA,
       YY.NOME,
       YY.CNPJCPF,
       YY.DIGCNPJCPF
      
      
       
  FROM (SELECT A.NROEMPRESA,
               A.NROTITULO,
               A.CODESPECIE,
               B.CODOPERACAO,
               A.SEQPESSOA,
               C.NOMERAZAO,
               B.VLROPERACAO,
               NVL(B.OBSERVACAO,0) OBS,
               DECODE (FC.PAGTOBOLETO, 'S', 'BOLETO', 'N', 'CREDITO EM CONTA', NULL, 'BOLETO')FORMAPGTO,
               FC.CODBARRA,
               FC.TIPODOCUMENTO,
               FC.TIPOPAGAMENTO,
               FC.FORMAPAGAMENTO,
               FC.TIPOTRIBUTO,
               PKG_FINANCEIRO.FIF_DESCONTO(A.SEQTITULO, TRUNC(SYSDATE), 'R') AS VLR_LIQUIDO,
               PKG_FINANCEIRO.FIF_DESCONTO(A.SEQTITULO, TRUNC(SYSDATE), 'R') AS VLRDESCFINDISP,
               (SELECT SUM(G.VLROPERACAO)
                  FROM (SELECT A.NROEMPRESA,
                               A.NROTITULO,
                               A.SEQPESSOA,
                               B.VLROPERACAO,
                               NVL(B.OBSERVACAO,0) OBS,
                               DECODE (FC.PAGTOBOLETO, 'S', 'BOLETO', 'N', 'CREDITO EM CONTA', NULL, 'BOLETO')FORMAPGTO,
                               FC.CODBARRA,
                               FC.TIPODOCUMENTO,
                               FC.TIPOPAGAMENTO,
                               FC.FORMAPAGAMENTO,
                               FC.TIPOTRIBUTO
                          FROM FI_TITULO         A,
                               FI_TITOPERACAO    B,
                               GE_PESSOA         C,
                               FI_ESPECIE        F,
                               FI_COMPLTITULO    FC
                         WHERE A.SEQTITULO = B.SEQTITULO
                           AND A.SEQTITULO = FC.SEQTITULO
                           AND A.SEQPESSOA = C.SEQPESSOA
                           AND A.CODESPECIE = F.CODESPECIE
                           AND B.CODOPERACAO = 53
                           AND A.DTAPROGRAMADA BETWEEN '&DT1' AND '&DT2'
                           AND A.NROEMPRESA IN (&Loja)
                           AND A.CODESPECIE = 'CRDESC'
                           AND B.OPCANCELADA IS NULL
                           AND F.NROEMPRESAMAE IN
                               (SELECT DISTINCT G.MATRIZ
                                  FROM GE_EMPRESA G
                                 WHERE G.NROEMPRESA = A.NROEMPRESA)
                           AND F.OBRIGDIREITO = 'O') G
                 WHERE G.NROEMPRESA = A.NROEMPRESA
                   AND G.NROTITULO = A.NROTITULO
                   AND G.SEQPESSOA = A.SEQPESSOA) VLR_CRDESC,
                   
                   
                   
                      KK.VLROPERACAO VLR_PAGO,
                      KK.BANCO_PGTO,
                      KK.USUARIO_QUITACAO,
                      KK.NOME_USR_QUITACAO,                 
                       A.DTAEMISSAO,
               TO_CHAR(A.DTAINCLUSAO, 'DD/MM/YYYY') DTAINCLUSAO,
               TO_CHAR(A.DTAMOVIMENTO, 'DD/MM/YYYY') DTAMOVIMENTO,
               TO_CHAR(A.DTAVENCIMENTO, 'DD/MM/YYYY') DTAVENCIMENTO,
               TO_CHAR(A.DTAPROGRAMADA, 'DD/MM/YYYY') DTAPROGRAMADA,
             --  decode(a.abertoquitado, 'A', 'ABERTO', 'Q', 'QUITADO') abertoquitado,
             a.abertoquitado,
               B.USUALTERACAO USUARIO_INCLUSAO, 
               G.NOME NOME_USR_INCLUSAO,
               A.OBSERVACAO,
               A.LINKERP,
               A.NROEMPRESAMAE,
               FFF.SEQCONTA,
               FFF.BANCO,
               FFF.AGENCIA,
               FFF.DIGAGENCIA,
               FFF.NROCONTA,
               FFF.DIGCONTA,
               FFF.NOME,
               FFF.CNPJCPF,
               FFF.DIGCNPJCPF
              
              
            
          FROM FI_TITULO         A,
               FI_TITOPERACAO    B,
               GE_PESSOA         C,
               FI_ESPECIE        F,
               GE_USUARIO        G,
               FI_COMPLTITULO    FC,
               (SELECT FF.SEQCONTA,
                       FF.BANCO,
                       FF.AGENCIA,
                       FF.DIGAGENCIA,
                       FF.NROCONTA,
                       FF.DIGCONTA,
                       FF.NOME,
                       FF.CNPJCPF,
                       FF.DIGCNPJCPF,
                       FI_TITULO.SEQTITULO,
                       FI_TITULO.SEQPESSOA
                       
                 from FI_COMPLTITULO, FI_TITULO, FIV_FORNCONTAPESSOA FF
                 Where FI_COMPLTITULO.SEQTITULO = FI_TITULO.SEQTITULO
                 AND FI_COMPLTITULO.SEQCONTA = FF.SEQCONTA
                 AND FI_TITULO.SEQPESSOA = FF.SEQPESSOA
                 AND FI_TITULO.SEQPESSOA = FI_COMPLTITULO.SEQPESSOA)FFF,
               
               
               
               (SELECT K.NROEMPRESA, K.NROTITULO, K.SEQTITULO, K.SEQPESSOA, K.VLROPERACAO,
      CASE WHEN K.CODOPERACAO = 6 THEN K.DESCRICAO || ' - AG: ' || K.NROAGENCIA || ' CONTA: ' || K.NROCONTA || '-' || K.DIGCONTA
        ELSE K.DESCRICAO END BANCO_PGTO, K.USUARIO_QUITACAO, K.NOME NOME_USR_QUITACAO
 
FROM ( SELECT A.NROEMPRESA, A.NROTITULO, A.SEQTITULO, A.SEQPESSOA, B.VLROPERACAO, B.CODOPERACAO, H.DESCRICAO, H.NROCONTA, H.DIGCONTA,
                               (SELECT I.NROAGENCIA
                                       FROM GE_AGENCIA I
                                      WHERE I.SEQAGENCIA = H.SEQAGENCIA) NROAGENCIA,
                                B.USUALTERACAO USUARIO_QUITACAO, G.NOME, NVL(B.OBSERVACAO,0) OBS, 
                               DECODE (FC.PAGTOBOLETO, 'S', 'BOLETO', 'N', 'CREDITO EM CONTA', NULL, 'BOLETO')FORMAPGTO,
                               FC.CODBARRA,
                               FC.TIPODOCUMENTO,
                               FC.TIPOPAGAMENTO,
                               FC.FORMAPAGAMENTO,
                               FC.TIPOTRIBUTO
                          FROM FI_TITULO         A,
                               FI_TITOPERACAO    B,
                               GE_PESSOA         C,
                               FI_ESPECIE        F,
                               FI_CTACORRENTE    H,
                               GE_USUARIO        G,
                               FI_COMPLTITULO    FC
                         
                         WHERE A.SEQTITULO = B.SEQTITULO
                           AND A.SEQTITULO = FC.SEQTITULO
                           AND A.SEQPESSOA = C.SEQPESSOA
                           AND A.CODESPECIE = F.CODESPECIE
                           AND B.SEQCTACORRENTE = H.SEQCTACORRENTE 
                           AND B.USUALTERACAO = G.CODUSUARIO
                           AND B.CODOPERACAO in (6,19,61)
                           AND A.DTAPROGRAMADA BETWEEN '&DT1' AND '&DT2'
                           AND A.NROEMPRESA IN (&Loja)
                           AND A.CODESPECIE <> 'CRDESC'
                           AND B.OPCANCELADA IS NULL
                           AND F.NROEMPRESAMAE IN
                               (SELECT DISTINCT G.MATRIZ
                                  FROM GE_EMPRESA G
                                 WHERE G.NROEMPRESA = A.NROEMPRESA)
                           AND F.OBRIGDIREITO = 'O' ) K ) KK
               
         WHERE A.SEQTITULO = B.SEQTITULO
           AND A.SEQTITULO = FC.SEQTITULO
           AND A.SEQPESSOA = C.SEQPESSOA
           AND A.CODESPECIE = F.CODESPECIE
           AND FC.SEQTITULO = FFF.SEQTITULO(+)
           AND FC.SEQCONTA = FFF.SEQCONTA(+)
           AND A.SEQPESSOA = FFF.SEQPESSOA(+)

           AND KK.NROEMPRESA = A.NROEMPRESA (+)
           AND KK.NROTITULO = A.NROTITULO (+)
           AND KK.SEQTITULO = A.SEQTITULO (+)
           AND KK.SEQPESSOA = A.SEQPESSOA (+)
         
           
           AND B.USUALTERACAO = G.CODUSUARIO
           
           AND B.CODOPERACAO in (16, 53, 182,269, 308,388, 1028)
           AND A.DTAPROGRAMADA BETWEEN '&DT1' AND '&DT2'
           AND A.NROEMPRESA IN (&Loja)
           AND A.CODESPECIE <> 'CRDESC'
           AND B.OPCANCELADA IS NULL
           AND F.NROEMPRESAMAE IN
               (SELECT DISTINCT G.MATRIZ
                  FROM GE_EMPRESA G
                 WHERE G.NROEMPRESA = A.NROEMPRESA)
           AND F.OBRIGDIREITO = 'O') YY
 ORDER BY 1, 2


------------------------------------------------------------------------------------------------


       SELECT  FF.SEQCONTA,
               FF.BANCO,
               FF.AGENCIA,
               FF.DIGAGENCIA,
               FF.NROCONTA,
               FF.DIGCONTA,
               FF.NOME FAVORECIDO,
               FF.CNPJCPF || '' || FF.DIGCNPJCPF CPFCNPJ,
               FF.* 
         FROM  FIV_FORNCONTAPESSOA FF, FI_COMPLTITULO



-------------------------------------------------------------------------------
-------------------- Backup Junho/2023 ----------------------------------------
-------------------------------------------------------------------------------

SELECT YY.NROEMPRESA,
       YY.NROTITULO,
       YY.CODESPECIE,
       YY.CODOPERACAO,
       YY.SEQPESSOA,
       YY.NOMERAZAO,
       YY.VLROPERACAO,
       YY.VLR_LIQUIDO,
       YY.VLRDESCFINDISP,
       CASE
         WHEN YY.CODOPERACAO = 16 THEN
          YY.VLR_CRDESC
         ELSE
          NULL
       END VLR_CRDESC,
       YY.VLR_PAGO,
       YY.BANCO_PGTO,
       TO_CHAR(YY.DTAEMISSAO, 'DD/MM/YYYY') DTAEMISSAO,
       YY.DTAINCLUSAO,
       YY.DTAMOVIMENTO,
       YY.DTAVENCIMENTO,
       YY.DTAPROGRAMADA,
       YY.ABERTOQUITADO,
       (SELECT MAX(OO.APELIDO) 
                  FROM MAX_COMPRADOR OO,
                       MAF_FORNECDIVISAO D
           WHERE OO.SEQCOMPRADOR = D.SEQCOMPRADOR
              AND D.SEQFORNECEDOR = YY.SEQPESSOA) COMPRADOR,
       YY.USUARIO_INCLUSAO,
       YY.NOME_USR_INCLUSAO,
       YY.USUARIO_QUITACAO,
       YY.NOME_USR_QUITACAO,

        TRIM(REPLACE(REPLACE(YY.OBSERVACAO,CHR(10),' '), CHR(13),' ')) OBSERVACAO,
       (SELECT AA.CODHISTORICO ||' - '|| INITCAP(CC.DESCRICAO)
                      FROM OR_NFDESPESA        AA,
                           CT_HISTORICO        CC
                           WHERE AA.CODHISTORICO = CC.CODHISTORICO 
                             AND CC.NROEMPRESA = YY.NROEMPRESAMAE
                             AND AA.NROEMPRESA = YY.NROEMPRESA
                             AND AA.NRONOTA = YY.NROTITULO
                             AND AA.SEQPESSOA = YY.SEQPESSOA
                             AND AA.LINKERP = YY.LINKERP
                             AND AA.DTAEMISSAO = YY.DTAEMISSAO) NATUREZA
       
  FROM (SELECT A.NROEMPRESA,
               A.NROTITULO,
               A.CODESPECIE,
               B.CODOPERACAO,
               A.SEQPESSOA,
               C.NOMERAZAO,
               B.VLROPERACAO,
               PKG_FINANCEIRO.FIF_DESCONTO(A.SEQTITULO, TRUNC(SYSDATE), 'R') AS VLR_LIQUIDO,
               PKG_FINANCEIRO.FIF_DESCONTO(A.SEQTITULO, TRUNC(SYSDATE), 'R') AS VLRDESCFINDISP,
               (SELECT SUM(G.VLROPERACAO)
                  FROM (SELECT A.NROEMPRESA,
                               A.NROTITULO,
                               A.SEQPESSOA,
                               B.VLROPERACAO
                          FROM FI_TITULO         A,
                               FI_TITOPERACAO    B,
                               GE_PESSOA         C,
                               FI_ESPECIE        F
                         WHERE A.SEQTITULO = B.SEQTITULO
                           AND A.SEQPESSOA = C.SEQPESSOA
                           AND A.CODESPECIE = F.CODESPECIE
                           AND B.CODOPERACAO = 53
                           AND A.DTAPROGRAMADA BETWEEN '&DT1' AND '&DT2'
                           AND A.NROEMPRESA IN (&lOJA)
                           AND A.CODESPECIE = 'CRDESC'
                           AND B.OPCANCELADA IS NULL
                           AND F.NROEMPRESAMAE IN
                               (SELECT DISTINCT G.MATRIZ
                                  FROM GE_EMPRESA G
                                 WHERE G.NROEMPRESA = A.NROEMPRESA)
                           AND F.OBRIGDIREITO = 'O') G
                 WHERE G.NROEMPRESA = A.NROEMPRESA
                   AND G.NROTITULO = A.NROTITULO
                   AND G.SEQPESSOA = A.SEQPESSOA) VLR_CRDESC,
                      KK.VLROPERACAO VLR_PAGO,
                      KK.BANCO_PGTO,
                      KK.USUARIO_QUITACAO,
                      KK.NOME_USR_QUITACAO,                 
                       A.DTAEMISSAO,
               TO_CHAR(A.DTAINCLUSAO, 'DD/MM/YYYY') DTAINCLUSAO,
               TO_CHAR(A.DTAMOVIMENTO, 'DD/MM/YYYY') DTAMOVIMENTO,
               TO_CHAR(A.DTAVENCIMENTO, 'DD/MM/YYYY') DTAVENCIMENTO,
               TO_CHAR(A.DTAPROGRAMADA, 'DD/MM/YYYY') DTAPROGRAMADA,
               a.abertoquitado,
               B.USUALTERACAO USUARIO_INCLUSAO, 
               G.NOME NOME_USR_INCLUSAO,
               A.OBSERVACAO,
               A.LINKERP,
               A.NROEMPRESAMAE
            
          FROM FI_TITULO         A,
               FI_TITOPERACAO    B,
               GE_PESSOA         C,
               FI_ESPECIE        F,
               GE_USUARIO        G,
               
               (SELECT K.NROEMPRESA, K.NROTITULO, K.SEQTITULO, K.SEQPESSOA, K.VLROPERACAO,
      CASE WHEN K.CODOPERACAO = 6 THEN K.DESCRICAO || ' - AG: ' || K.NROAGENCIA || ' CONTA: ' || K.NROCONTA || '-' || K.DIGCONTA
        ELSE K.DESCRICAO END BANCO_PGTO, K.USUARIO_QUITACAO, K.NOME NOME_USR_QUITACAO
 
FROM ( SELECT A.NROEMPRESA, A.NROTITULO, A.SEQTITULO, A.SEQPESSOA, B.VLROPERACAO, B.CODOPERACAO, H.DESCRICAO, H.NROCONTA, H.DIGCONTA,
                               (SELECT I.NROAGENCIA
                                       FROM GE_AGENCIA I
                                      WHERE I.SEQAGENCIA = H.SEQAGENCIA) NROAGENCIA,
                                B.USUALTERACAO USUARIO_QUITACAO, G.NOME
                          FROM FI_TITULO         A,
                               FI_TITOPERACAO    B,
                               GE_PESSOA         C,
                               FI_ESPECIE        F,
                               FI_CTACORRENTE    H,
                               GE_USUARIO        G
                         WHERE A.SEQTITULO = B.SEQTITULO
                           AND A.SEQPESSOA = C.SEQPESSOA
                           AND A.CODESPECIE = F.CODESPECIE
                           AND B.SEQCTACORRENTE = H.SEQCTACORRENTE 
                           AND B.USUALTERACAO = G.CODUSUARIO
                           AND B.CODOPERACAO in (6,19,61)
                           AND A.DTAPROGRAMADA BETWEEN '&DT1' AND '&DT2'
                           AND A.NROEMPRESA IN (&lOJA)
                           AND A.CODESPECIE <> 'CRDESC'
                           AND B.OPCANCELADA IS NULL
                           AND F.NROEMPRESAMAE IN
                               (SELECT DISTINCT G.MATRIZ
                                  FROM GE_EMPRESA G
                                 WHERE G.NROEMPRESA = A.NROEMPRESA)
                           AND F.OBRIGDIREITO = 'O' ) K ) KK
               
         WHERE A.SEQTITULO = B.SEQTITULO
           AND A.SEQPESSOA = C.SEQPESSOA
           AND A.CODESPECIE = F.CODESPECIE
           
           AND KK.NROEMPRESA = A.NROEMPRESA (+)
           AND KK.NROTITULO = A.NROTITULO (+)
           AND KK.SEQTITULO = A.SEQTITULO (+)
           AND KK.SEQPESSOA = A.SEQPESSOA (+)
           
           AND B.USUALTERACAO = G.CODUSUARIO
           
           AND B.CODOPERACAO in (16, 53, 182,269, 308,388, 1028)
           AND A.DTAPROGRAMADA BETWEEN '&DT1' AND '&DT2'
           AND A.NROEMPRESA IN (&lOJA)
           AND A.CODESPECIE <> 'CRDESC'
           AND B.OPCANCELADA IS NULL
           AND F.NROEMPRESAMAE IN
               (SELECT DISTINCT G.MATRIZ
                  FROM GE_EMPRESA G
                 WHERE G.NROEMPRESA = A.NROEMPRESA)
           AND F.OBRIGDIREITO = 'O') YY
 ORDER BY 1, 2

   
 --------------------------------------------------------------------------------
 ---- Versão Publicada 03/07/2023
 --------------------------------------------------------------------------------
 
 SELECT YY.NROEMPRESA,
       YY.NROTITULO,
       YY.CODESPECIE,
       YY.CODOPERACAO,
       YY.SEQPESSOA,
       YY.NOMERAZAO,
       YY.VLROPERACAO,
       YY.VLR_LIQUIDO,
       YY.VLRDESCFINDISP,
       CASE
         WHEN YY.CODOPERACAO = 16 THEN
          YY.VLR_CRDESC
         ELSE
          NULL
       END VLR_CRDESC,
       YY.VLR_PAGO,
       YY.BANCO_PGTO,
       TO_CHAR(YY.DTAEMISSAO, 'DD/MM/YYYY') DTAEMISSAO,
       YY.DTAINCLUSAO,
       YY.DTAMOVIMENTO,
       YY.DTAVENCIMENTO,
       YY.DTAPROGRAMADA,
       YY.ABERTOQUITADO,
       (SELECT MAX(OO.APELIDO) 
                  FROM MAX_COMPRADOR OO,
                       MAF_FORNECDIVISAO D
           WHERE OO.SEQCOMPRADOR = D.SEQCOMPRADOR
              AND D.SEQFORNECEDOR = YY.SEQPESSOA) COMPRADOR,
       YY.USUARIO_INCLUSAO,
       YY.NOME_USR_INCLUSAO,
       YY.USUARIO_QUITACAO,
       YY.NOME_USR_QUITACAO,

        TRIM(REPLACE(REPLACE(YY.OBSERVACAO,CHR(10),' '), CHR(13),' ')) OBSERVACAO,
       (SELECT AA.CODHISTORICO ||' - '|| INITCAP(CC.DESCRICAO)
                      FROM OR_NFDESPESA        AA,
                           CT_HISTORICO        CC
                           WHERE AA.CODHISTORICO = CC.CODHISTORICO 
                             AND CC.NROEMPRESA = YY.NROEMPRESAMAE
                             AND AA.NROEMPRESA = YY.NROEMPRESA
                             AND AA.NRONOTA = YY.NROTITULO
                             AND AA.SEQPESSOA = YY.SEQPESSOA
                             AND AA.LINKERP = YY.LINKERP
                             AND AA.DTAEMISSAO = YY.DTAEMISSAO) NATUREZA,
      
       YY.FORMAPGTO,
       YY.CODBARRA,
       YY.TIPODOCUMENTO,

       NVL(YY.OBS,0)DETHALOPERC_OBS,
       YY.SEQCONTA,
       YY.BANCO,
       YY.AGENCIA,
       YY.DIGAGENCIA,
       YY.NROCONTA,
       YY.DIGCONTA,
       YY.NOME,
       YY.CNPJCPF,
       YY.DIGCNPJCPF
      
      
       
  FROM (SELECT A.NROEMPRESA,
               A.NROTITULO,
               A.CODESPECIE,
               B.CODOPERACAO,
               A.SEQPESSOA,
               C.NOMERAZAO,
               B.VLROPERACAO,
               NVL(B.OBSERVACAO,0) OBS,
               DECODE (FC.PAGTOBOLETO, 'S', 'BOLETO', 'N', 'CREDITO EM CONTA', NULL, 'BOLETO')FORMAPGTO,
               FC.CODBARRA,
               FC.TIPODOCUMENTO,
               FC.TIPOPAGAMENTO,
               FC.FORMAPAGAMENTO,
               FC.TIPOTRIBUTO,
               PKG_FINANCEIRO.FIF_DESCONTO(A.SEQTITULO, TRUNC(SYSDATE), 'R') AS VLR_LIQUIDO,
               PKG_FINANCEIRO.FIF_DESCONTO(A.SEQTITULO, TRUNC(SYSDATE), 'R') AS VLRDESCFINDISP,
               (SELECT SUM(G.VLROPERACAO)
                  FROM (SELECT A.NROEMPRESA,
                               A.NROTITULO,
                               A.SEQPESSOA,
                               B.VLROPERACAO,
                               NVL(B.OBSERVACAO,0) OBS,
                               DECODE (FC.PAGTOBOLETO, 'S', 'BOLETO', 'N', 'CREDITO EM CONTA', NULL, 'BOLETO')FORMAPGTO,
                               FC.CODBARRA,
                               FC.TIPODOCUMENTO,
                               FC.TIPOPAGAMENTO,
                               FC.FORMAPAGAMENTO,
                               FC.TIPOTRIBUTO
                          FROM FI_TITULO         A,
                               FI_TITOPERACAO    B,
                               GE_PESSOA         C,
                               FI_ESPECIE        F,
                               FI_COMPLTITULO    FC
                         WHERE A.SEQTITULO = B.SEQTITULO
                           AND A.SEQTITULO = FC.SEQTITULO
                           AND A.SEQPESSOA = C.SEQPESSOA
                           AND A.CODESPECIE = F.CODESPECIE
                           AND B.CODOPERACAO = 53
                           AND A.DTAPROGRAMADA BETWEEN '#DT1' AND '#DT2'
                           AND A.NROEMPRESA IN (#LS1)
                           AND A.CODESPECIE = 'CRDESC'
                           AND B.OPCANCELADA IS NULL
                           AND F.NROEMPRESAMAE IN
                               (SELECT DISTINCT G.MATRIZ
                                  FROM GE_EMPRESA G
                                 WHERE G.NROEMPRESA = A.NROEMPRESA)
                           AND F.OBRIGDIREITO = 'O') G
                 WHERE G.NROEMPRESA = A.NROEMPRESA
                   AND G.NROTITULO = A.NROTITULO
                   AND G.SEQPESSOA = A.SEQPESSOA) VLR_CRDESC,
                   
                   
                   
                      KK.VLROPERACAO VLR_PAGO,
                      KK.BANCO_PGTO,
                      KK.USUARIO_QUITACAO,
                      KK.NOME_USR_QUITACAO,                 
                       A.DTAEMISSAO,
               TO_CHAR(A.DTAINCLUSAO, 'DD/MM/YYYY') DTAINCLUSAO,
               TO_CHAR(A.DTAMOVIMENTO, 'DD/MM/YYYY') DTAMOVIMENTO,
               TO_CHAR(A.DTAVENCIMENTO, 'DD/MM/YYYY') DTAVENCIMENTO,
               TO_CHAR(A.DTAPROGRAMADA, 'DD/MM/YYYY') DTAPROGRAMADA,
               a.abertoquitado,
               B.USUALTERACAO USUARIO_INCLUSAO, 
               G.NOME NOME_USR_INCLUSAO,
               A.OBSERVACAO,
               A.LINKERP,
               A.NROEMPRESAMAE,
               FFF.SEQCONTA,
               FFF.BANCO,
               FFF.AGENCIA,
               FFF.DIGAGENCIA,
               FFF.NROCONTA,
               FFF.DIGCONTA,
               FFF.NOME,
               FFF.CNPJCPF,
               FFF.DIGCNPJCPF
              
              
            
          FROM FI_TITULO         A,
               FI_TITOPERACAO    B,
               GE_PESSOA         C,
               FI_ESPECIE        F,
               GE_USUARIO        G,
               FI_COMPLTITULO    FC,
               (SELECT FF.SEQCONTA,
                       FF.BANCO,
                       FF.AGENCIA,
                       FF.DIGAGENCIA,
                       FF.NROCONTA,
                       FF.DIGCONTA,
                       FF.NOME,
                       FF.CNPJCPF,
                       FF.DIGCNPJCPF,
                       FI_TITULO.SEQTITULO,
                       FI_TITULO.SEQPESSOA
                       
                 from FI_COMPLTITULO, FI_TITULO, FIV_FORNCONTAPESSOA FF
                 Where FI_COMPLTITULO.SEQTITULO = FI_TITULO.SEQTITULO
                 AND FI_COMPLTITULO.SEQCONTA = FF.SEQCONTA
                 AND FI_TITULO.SEQPESSOA = FF.SEQPESSOA
                 AND FI_TITULO.SEQPESSOA = FI_COMPLTITULO.SEQPESSOA)FFF,
               
               
               
               (SELECT K.NROEMPRESA, K.NROTITULO, K.SEQTITULO, K.SEQPESSOA, K.VLROPERACAO,
      CASE WHEN K.CODOPERACAO = 6 THEN K.DESCRICAO || ' - AG: ' || K.NROAGENCIA || ' CONTA: ' || K.NROCONTA || '-' || K.DIGCONTA
        ELSE K.DESCRICAO END BANCO_PGTO, K.USUARIO_QUITACAO, K.NOME NOME_USR_QUITACAO
 
FROM ( SELECT A.NROEMPRESA, A.NROTITULO, A.SEQTITULO, A.SEQPESSOA, B.VLROPERACAO, B.CODOPERACAO, H.DESCRICAO, H.NROCONTA, H.DIGCONTA,
                               (SELECT I.NROAGENCIA
                                       FROM GE_AGENCIA I
                                      WHERE I.SEQAGENCIA = H.SEQAGENCIA) NROAGENCIA,
                                B.USUALTERACAO USUARIO_QUITACAO, G.NOME, NVL(B.OBSERVACAO,0) OBS, 
                               DECODE (FC.PAGTOBOLETO, 'S', 'BOLETO', 'N', 'CREDITO EM CONTA', NULL, 'BOLETO')FORMAPGTO,
                               FC.CODBARRA,
                               FC.TIPODOCUMENTO,
                               FC.TIPOPAGAMENTO,
                               FC.FORMAPAGAMENTO,
                               FC.TIPOTRIBUTO
                          FROM FI_TITULO         A,
                               FI_TITOPERACAO    B,
                               GE_PESSOA         C,
                               FI_ESPECIE        F,
                               FI_CTACORRENTE    H,
                               GE_USUARIO        G,
                               FI_COMPLTITULO    FC
                         
                         WHERE A.SEQTITULO = B.SEQTITULO
                           AND A.SEQTITULO = FC.SEQTITULO
                           AND A.SEQPESSOA = C.SEQPESSOA
                           AND A.CODESPECIE = F.CODESPECIE
                           AND B.SEQCTACORRENTE = H.SEQCTACORRENTE 
                           AND B.USUALTERACAO = G.CODUSUARIO
                           AND B.CODOPERACAO in (6,19,61)
                           AND A.DTAPROGRAMADA BETWEEN '#DT1' AND '#DT2'
                           AND A.NROEMPRESA IN (#LS1)
                           AND A.CODESPECIE <> 'CRDESC'
                           AND B.OPCANCELADA IS NULL
                           AND F.NROEMPRESAMAE IN
                               (SELECT DISTINCT G.MATRIZ
                                  FROM GE_EMPRESA G
                                 WHERE G.NROEMPRESA = A.NROEMPRESA)
                           AND F.OBRIGDIREITO = 'O' ) K ) KK
               
         WHERE A.SEQTITULO = B.SEQTITULO
           AND A.SEQTITULO = FC.SEQTITULO
           AND A.SEQPESSOA = C.SEQPESSOA
           AND A.CODESPECIE = F.CODESPECIE
           AND FC.SEQTITULO = FFF.SEQTITULO(+)
           AND FC.SEQCONTA = FFF.SEQCONTA(+)
           AND A.SEQPESSOA = FFF.SEQPESSOA(+)

           AND KK.NROEMPRESA = A.NROEMPRESA (+)
           AND KK.NROTITULO = A.NROTITULO (+)
           AND KK.SEQTITULO = A.SEQTITULO (+)
           AND KK.SEQPESSOA = A.SEQPESSOA (+)
         
           
           AND B.USUALTERACAO = G.CODUSUARIO
           
           AND B.CODOPERACAO in (16, 53, 182, 269, 308, 388, 1028)
           AND A.DTAPROGRAMADA BETWEEN '#DT1' AND '#DT2'
           AND A.NROEMPRESA IN (#LS1)
           AND A.CODESPECIE <> 'CRDESC'
           AND B.OPCANCELADA IS NULL
           AND F.NROEMPRESAMAE IN
               (SELECT DISTINCT G.MATRIZ
                  FROM GE_EMPRESA G
                 WHERE G.NROEMPRESA = A.NROEMPRESA)
           AND F.OBRIGDIREITO = 'O') YY
 ORDER BY 1, 2
 
--------------------------------------------------------------------------------- 
 --Selecione a Espécie:
 select a.codespecie
from fi_especie a
where nroempresamae=2
and obrigdireito='O'
                      
select nroempresa
from ge_empresa
where nroempresa in (1,2,3,4,5,6,7,8,9,10,11,12,32,33,34,21,66)
order by 1

---------------------------------------------------------------------------------
------------------------ BACKUP 15/07 -------------------------------------------
--------------- Rel Dta Programada Tit X Quitados - Auditoria -------------------
---------------------------------------------------------------------------------

SELECT YY.NROEMPRESA,
       YY.NROTITULO,
       YY.CODESPECIE,
       YY.CODOPERACAO,
       YY.SEQPESSOA,
       YY.NOMERAZAO,
       YY.VLROPERACAO,
       YY.VLR_LIQUIDO,
       YY.VLRDESCFINDISP,
       CASE
         WHEN YY.CODOPERACAO = 16 THEN
          YY.VLR_CRDESC
         ELSE
          NULL
       END VLR_CRDESC,
       YY.VLR_PAGO,
       YY.BANCO_PGTO,
       TO_CHAR(YY.DTAEMISSAO, 'DD/MM/YYYY') DTAEMISSAO,
       YY.DTAINCLUSAO,
       YY.DTAMOVIMENTO,
       YY.DTAVENCIMENTO,
       YY.DTAPROGRAMADA,
       YY.ABERTOQUITADO,
       (SELECT MAX(OO.APELIDO) 
                  FROM MAX_COMPRADOR OO,
                       MAF_FORNECDIVISAO D
           WHERE OO.SEQCOMPRADOR = D.SEQCOMPRADOR
              AND D.SEQFORNECEDOR = YY.SEQPESSOA) COMPRADOR,
       YY.USUARIO_INCLUSAO,
       YY.NOME_USR_INCLUSAO,
       YY.USUARIO_QUITACAO,
       YY.NOME_USR_QUITACAO,

        TRIM(REPLACE(REPLACE(YY.OBSERVACAO,CHR(10),' '), CHR(13),' ')) OBSERVACAO,
       (SELECT AA.CODHISTORICO ||' - '|| INITCAP(CC.DESCRICAO)
                      FROM OR_NFDESPESA        AA,
                           CT_HISTORICO        CC
                           WHERE AA.CODHISTORICO = CC.CODHISTORICO 
                             AND CC.NROEMPRESA = YY.NROEMPRESAMAE
                             AND AA.NROEMPRESA = YY.NROEMPRESA
                             AND AA.NRONOTA = YY.NROTITULO
                             AND AA.SEQPESSOA = YY.SEQPESSOA
                             AND AA.LINKERP = YY.LINKERP
                             AND AA.DTAEMISSAO = YY.DTAEMISSAO) NATUREZA,
      
       YY.FORMAPGTO,
       YY.CODBARRA,
       YY.TIPODOCUMENTO,

       NVL(YY.OBS,0)DETHALOPERC_OBS,
       YY.SEQCONTA,
       YY.BANCO,
       YY.AGENCIA,
       YY.DIGAGENCIA,
       YY.NROCONTA,
       YY.DIGCONTA,
       YY.NOME,
       YY.CNPJCPF,
       YY.DIGCNPJCPF
      
      
       
  FROM (SELECT A.NROEMPRESA,
               A.NROTITULO,
               A.CODESPECIE,
               B.CODOPERACAO,
               A.SEQPESSOA,
               C.NOMERAZAO,
               B.VLROPERACAO,
               NVL(B.OBSERVACAO,0) OBS,
               DECODE (FC.PAGTOBOLETO, 'S', 'BOLETO', 'N', 'CREDITO EM CONTA', NULL, 'BOLETO')FORMAPGTO,
               FC.CODBARRA,
               FC.TIPODOCUMENTO,
               FC.TIPOPAGAMENTO,
               FC.FORMAPAGAMENTO,
               FC.TIPOTRIBUTO,
               PKG_FINANCEIRO.FIF_DESCONTO(A.SEQTITULO, TRUNC(SYSDATE), 'R') AS VLR_LIQUIDO,
               PKG_FINANCEIRO.FIF_DESCONTO(A.SEQTITULO, TRUNC(SYSDATE), 'R') AS VLRDESCFINDISP,
               (SELECT SUM(G.VLROPERACAO)
                  FROM (SELECT A.NROEMPRESA,
                               A.NROTITULO,
                               A.SEQPESSOA,
                               B.VLROPERACAO,
                               NVL(B.OBSERVACAO,0) OBS,
                               DECODE (FC.PAGTOBOLETO, 'S', 'BOLETO', 'N', 'CREDITO EM CONTA', NULL, 'BOLETO')FORMAPGTO,
                               FC.CODBARRA,
                               FC.TIPODOCUMENTO,
                               FC.TIPOPAGAMENTO,
                               FC.FORMAPAGAMENTO,
                               FC.TIPOTRIBUTO
                          FROM FI_TITULO         A,
                               FI_TITOPERACAO    B,
                               GE_PESSOA         C,
                               FI_ESPECIE        F,
                               FI_COMPLTITULO    FC
                         WHERE A.SEQTITULO = B.SEQTITULO
                           AND A.SEQTITULO = FC.SEQTITULO
                           AND A.SEQPESSOA = C.SEQPESSOA
                           AND A.CODESPECIE = F.CODESPECIE
                           AND B.CODOPERACAO = 53
                           AND A.DTAPROGRAMADA BETWEEN '#DT1' AND '#DT2'
                           AND A.NROEMPRESA IN (#LS1)
                           AND A.CODESPECIE = 'CRDESC'
                           AND B.OPCANCELADA IS NULL
                           AND F.NROEMPRESAMAE IN
                               (SELECT DISTINCT G.MATRIZ
                                  FROM GE_EMPRESA G
                                 WHERE G.NROEMPRESA = A.NROEMPRESA)
                           AND F.OBRIGDIREITO = 'O') G
                 WHERE G.NROEMPRESA = A.NROEMPRESA
                   AND G.NROTITULO = A.NROTITULO
                   AND G.SEQPESSOA = A.SEQPESSOA) VLR_CRDESC,
                   
                   
                   
                      KK.VLROPERACAO VLR_PAGO,
                      KK.BANCO_PGTO,
                      KK.USUARIO_QUITACAO,
                      KK.NOME_USR_QUITACAO,                 
                       A.DTAEMISSAO,
               TO_CHAR(A.DTAINCLUSAO, 'DD/MM/YYYY') DTAINCLUSAO,
               TO_CHAR(A.DTAMOVIMENTO, 'DD/MM/YYYY') DTAMOVIMENTO,
               TO_CHAR(A.DTAVENCIMENTO, 'DD/MM/YYYY') DTAVENCIMENTO,
               TO_CHAR(A.DTAPROGRAMADA, 'DD/MM/YYYY') DTAPROGRAMADA,
               DECODE(A.ABERTOQUITADO, 'A', 'ABERTO', 'Q', 'QUITADO') ABERTOQUITADO,
               B.USUALTERACAO USUARIO_INCLUSAO, 
               G.NOME NOME_USR_INCLUSAO,
               A.OBSERVACAO,
               A.LINKERP,
               A.NROEMPRESAMAE,
               FFF.SEQCONTA,
               FFF.BANCO,
               FFF.AGENCIA,
               FFF.DIGAGENCIA,
               FFF.NROCONTA,
               FFF.DIGCONTA,
               FFF.NOME,
               FFF.CNPJCPF,
               FFF.DIGCNPJCPF
              
              
            
          FROM FI_TITULO         A,
               FI_TITOPERACAO    B,
               GE_PESSOA         C,
               FI_ESPECIE        F,
               GE_USUARIO        G,
               FI_COMPLTITULO    FC,
               (SELECT FF.SEQCONTA,
                       FF.BANCO,
                       FF.AGENCIA,
                       FF.DIGAGENCIA,
                       FF.NROCONTA,
                       FF.DIGCONTA,
                       FF.NOME,
                       FF.CNPJCPF,
                       FF.DIGCNPJCPF,
                       FI_TITULO.SEQTITULO,
                       FI_TITULO.SEQPESSOA
                       
                 from FI_COMPLTITULO, FI_TITULO, FIV_FORNCONTAPESSOA FF
                 Where FI_COMPLTITULO.SEQTITULO = FI_TITULO.SEQTITULO
                 AND FI_COMPLTITULO.SEQCONTA = FF.SEQCONTA
                 AND FI_TITULO.SEQPESSOA = FF.SEQPESSOA
                 AND FI_TITULO.SEQPESSOA = FI_COMPLTITULO.SEQPESSOA)FFF,
               
               
               
               (SELECT K.NROEMPRESA, K.NROTITULO, K.SEQTITULO, K.SEQPESSOA, K.VLROPERACAO,
      CASE WHEN K.CODOPERACAO = 6 THEN K.DESCRICAO || ' - AG: ' || K.NROAGENCIA || ' CONTA: ' || K.NROCONTA || '-' || K.DIGCONTA
        ELSE K.DESCRICAO END BANCO_PGTO, K.USUARIO_QUITACAO, K.NOME NOME_USR_QUITACAO
 
FROM ( SELECT A.NROEMPRESA, A.NROTITULO, A.SEQTITULO, A.SEQPESSOA, B.VLROPERACAO, B.CODOPERACAO, H.DESCRICAO, H.NROCONTA, H.DIGCONTA,
                               (SELECT I.NROAGENCIA
                                       FROM GE_AGENCIA I
                                      WHERE I.SEQAGENCIA = H.SEQAGENCIA) NROAGENCIA,
                                B.USUALTERACAO USUARIO_QUITACAO, G.NOME, NVL(B.OBSERVACAO,0) OBS, 
                               DECODE (FC.PAGTOBOLETO, 'S', 'BOLETO', 'N', 'CREDITO EM CONTA', NULL, 'BOLETO')FORMAPGTO,
                               FC.CODBARRA,
                               FC.TIPODOCUMENTO,
                               FC.TIPOPAGAMENTO,
                               FC.FORMAPAGAMENTO,
                               FC.TIPOTRIBUTO
                          FROM FI_TITULO         A,
                               FI_TITOPERACAO    B,
                               GE_PESSOA         C,
                               FI_ESPECIE        F,
                               FI_CTACORRENTE    H,
                               GE_USUARIO        G,
                               FI_COMPLTITULO    FC
                         
                         WHERE A.SEQTITULO = B.SEQTITULO
                           AND A.SEQTITULO = FC.SEQTITULO
                           AND A.SEQPESSOA = C.SEQPESSOA
                           AND A.CODESPECIE = F.CODESPECIE
                           AND B.SEQCTACORRENTE = H.SEQCTACORRENTE 
                           AND B.USUALTERACAO = G.CODUSUARIO
                           AND B.CODOPERACAO in (6,19,61)
                           AND A.DTAPROGRAMADA BETWEEN '#DT1' AND '#DT2'
                           AND A.NROEMPRESA IN (#LS1)
                           AND A.CODESPECIE <> 'CRDESC'
                           AND B.OPCANCELADA IS NULL
                           AND F.NROEMPRESAMAE IN
                               (SELECT DISTINCT G.MATRIZ
                                  FROM GE_EMPRESA G
                                 WHERE G.NROEMPRESA = A.NROEMPRESA)
                           AND F.OBRIGDIREITO = 'O' ) K ) KK
               
         WHERE A.SEQTITULO = B.SEQTITULO
           AND A.SEQTITULO = FC.SEQTITULO
           AND A.SEQPESSOA = C.SEQPESSOA
           AND A.CODESPECIE = F.CODESPECIE
           AND FC.SEQTITULO = FFF.SEQTITULO(+)
           AND FC.SEQCONTA = FFF.SEQCONTA(+)
           AND A.SEQPESSOA = FFF.SEQPESSOA(+)

           AND KK.NROEMPRESA = A.NROEMPRESA (+)
           AND KK.NROTITULO = A.NROTITULO (+)
           AND KK.SEQTITULO = A.SEQTITULO (+)
           AND KK.SEQPESSOA = A.SEQPESSOA (+)
         
           
           AND B.USUALTERACAO = G.CODUSUARIO
           
           AND B.CODOPERACAO in (16, 53, 182, 269, 308, 388, 1028)
           AND A.DTAPROGRAMADA BETWEEN '#DT1' AND '#DT2'
           AND A.NROEMPRESA IN (#LS1)
           AND A.CODESPECIE <> 'CRDESC'
          /* AND A.CODESPECIE IN (#LS2) */
           AND B.OPCANCELADA IS NULL
           AND F.NROEMPRESAMAE IN
               (SELECT DISTINCT G.MATRIZ
                  FROM GE_EMPRESA G
                 WHERE G.NROEMPRESA = A.NROEMPRESA)
           AND F.OBRIGDIREITO = 'O') YY
 ORDER BY 1, 2


---------------------------------------------------------------------------------
------------------------ BACKUP 15/07 -------------------------------------------
--------------- Rel Dta Inclusao Tit X Quitados - Auditoria ---------------------
---------------------------------------------------------------------------------


SELECT YY.NROEMPRESA,
       YY.NROTITULO,
       YY.CODESPECIE,
       YY.CODOPERACAO,
       YY.SEQPESSOA,
       YY.NOMERAZAO,
       YY.VLROPERACAO,
       YY.VLR_LIQUIDO,
       YY.VLRDESCFINDISP,
       CASE
         WHEN YY.CODOPERACAO = 16 THEN
          YY.VLR_CRDESC
         ELSE
          NULL
       END VLR_CRDESC,
       YY.VLR_PAGO,
       YY.BANCO_PGTO,
       TO_CHAR(YY.DTAEMISSAO, 'DD/MM/YYYY') DTAEMISSAO,
       YY.DTAINCLUSAO,
       YY.DTAMOVIMENTO,
       YY.DTAVENCIMENTO,
       YY.DTAPROGRAMADA,
       YY.ABERTOQUITADO,
       (SELECT MAX(OO.APELIDO) 
                  FROM MAX_COMPRADOR OO,
                       MAF_FORNECDIVISAO D
           WHERE OO.SEQCOMPRADOR = D.SEQCOMPRADOR
              AND D.SEQFORNECEDOR = YY.SEQPESSOA) COMPRADOR,
       YY.USUARIO_INCLUSAO,
       YY.NOME_USR_INCLUSAO,
       YY.USUARIO_QUITACAO,
       YY.NOME_USR_QUITACAO,

        TRIM(REPLACE(REPLACE(YY.OBSERVACAO,CHR(10),' '), CHR(13),' ')) OBSERVACAO,
       (SELECT AA.CODHISTORICO ||' - '|| INITCAP(CC.DESCRICAO)
                      FROM OR_NFDESPESA        AA,
                           CT_HISTORICO        CC
                           WHERE AA.CODHISTORICO = CC.CODHISTORICO 
                             AND CC.NROEMPRESA = YY.NROEMPRESAMAE
                             AND AA.NROEMPRESA = YY.NROEMPRESA
                             AND AA.NRONOTA = YY.NROTITULO
                             AND AA.SEQPESSOA = YY.SEQPESSOA
                             AND AA.LINKERP = YY.LINKERP
                             AND AA.DTAEMISSAO = YY.DTAEMISSAO) NATUREZA,
      
       YY.FORMAPGTO,
       YY.CODBARRA,
       YY.TIPODOCUMENTO,

       NVL(YY.OBS,0)DETHALOPERC_OBS,
       YY.SEQCONTA,
       YY.BANCO,
       YY.AGENCIA,
       YY.DIGAGENCIA,
       YY.NROCONTA,
       YY.DIGCONTA,
       YY.NOME,
       YY.CNPJCPF,
       YY.DIGCNPJCPF
      
      
       
  FROM (SELECT A.NROEMPRESA,
               A.NROTITULO,
               A.CODESPECIE,
               B.CODOPERACAO,
               A.SEQPESSOA,
               C.NOMERAZAO,
               B.VLROPERACAO,
               NVL(B.OBSERVACAO,0) OBS,
               DECODE (FC.PAGTOBOLETO, 'S', 'BOLETO', 'N', 'CREDITO EM CONTA', NULL, 'BOLETO')FORMAPGTO,
               FC.CODBARRA,
               FC.TIPODOCUMENTO,
               FC.TIPOPAGAMENTO,
               FC.FORMAPAGAMENTO,
               FC.TIPOTRIBUTO,
               PKG_FINANCEIRO.FIF_DESCONTO(A.SEQTITULO, TRUNC(SYSDATE), 'R') AS VLR_LIQUIDO,
               PKG_FINANCEIRO.FIF_DESCONTO(A.SEQTITULO, TRUNC(SYSDATE), 'R') AS VLRDESCFINDISP,
               (SELECT SUM(G.VLROPERACAO)
                  FROM (SELECT A.NROEMPRESA,
                               A.NROTITULO,
                               A.SEQPESSOA,
                               B.VLROPERACAO,
                               NVL(B.OBSERVACAO,0) OBS,
                               DECODE (FC.PAGTOBOLETO, 'S', 'BOLETO', 'N', 'CREDITO EM CONTA', NULL, 'BOLETO')FORMAPGTO,
                               FC.CODBARRA,
                               FC.TIPODOCUMENTO,
                               FC.TIPOPAGAMENTO,
                               FC.FORMAPAGAMENTO,
                               FC.TIPOTRIBUTO
                          FROM FI_TITULO         A,
                               FI_TITOPERACAO    B,
                               GE_PESSOA         C,
                               FI_ESPECIE        F,
                               FI_COMPLTITULO    FC
                         WHERE A.SEQTITULO = B.SEQTITULO
                           AND A.SEQTITULO = FC.SEQTITULO
                           AND A.SEQPESSOA = C.SEQPESSOA
                           AND A.CODESPECIE = F.CODESPECIE
                           AND B.CODOPERACAO = 53
                           AND A.DTAINCLUSAO BETWEEN '#DT1' AND '#DT2'
                           AND A.NROEMPRESA IN (#LS1)
                           AND A.CODESPECIE = 'CRDESC'
                           AND B.OPCANCELADA IS NULL
                           AND F.NROEMPRESAMAE IN
                               (SELECT DISTINCT G.MATRIZ
                                  FROM GE_EMPRESA G
                                 WHERE G.NROEMPRESA = A.NROEMPRESA)
                           AND F.OBRIGDIREITO = 'O') G
                 WHERE G.NROEMPRESA = A.NROEMPRESA
                   AND G.NROTITULO = A.NROTITULO
                   AND G.SEQPESSOA = A.SEQPESSOA) VLR_CRDESC,
                   
                   
                   
                      KK.VLROPERACAO VLR_PAGO,
                      KK.BANCO_PGTO,
                      KK.USUARIO_QUITACAO,
                      KK.NOME_USR_QUITACAO,                 
                       A.DTAEMISSAO,
               TO_CHAR(A.DTAINCLUSAO, 'DD/MM/YYYY') DTAINCLUSAO,
               TO_CHAR(A.DTAMOVIMENTO, 'DD/MM/YYYY') DTAMOVIMENTO,
               TO_CHAR(A.DTAVENCIMENTO, 'DD/MM/YYYY') DTAVENCIMENTO,
               TO_CHAR(A.DTAPROGRAMADA, 'DD/MM/YYYY') DTAPROGRAMADA,
               DECODE(A.ABERTOQUITADO, 'A', 'ABERTO', 'Q', 'QUITADO') ABERTOQUITADO,
               B.USUALTERACAO USUARIO_INCLUSAO, 
               G.NOME NOME_USR_INCLUSAO,
               A.OBSERVACAO,
               A.LINKERP,
               A.NROEMPRESAMAE,
               FFF.SEQCONTA,
               FFF.BANCO,
               FFF.AGENCIA,
               FFF.DIGAGENCIA,
               FFF.NROCONTA,
               FFF.DIGCONTA,
               FFF.NOME,
               FFF.CNPJCPF,
               FFF.DIGCNPJCPF
              
              
            
          FROM FI_TITULO         A,
               FI_TITOPERACAO    B,
               GE_PESSOA         C,
               FI_ESPECIE        F,
               GE_USUARIO        G,
               FI_COMPLTITULO    FC,
               (SELECT FF.SEQCONTA,
                       FF.BANCO,
                       FF.AGENCIA,
                       FF.DIGAGENCIA,
                       FF.NROCONTA,
                       FF.DIGCONTA,
                       FF.NOME,
                       FF.CNPJCPF,
                       FF.DIGCNPJCPF,
                       FI_TITULO.SEQTITULO,
                       FI_TITULO.SEQPESSOA
                       
                 from FI_COMPLTITULO, FI_TITULO, FIV_FORNCONTAPESSOA FF
                 Where FI_COMPLTITULO.SEQTITULO = FI_TITULO.SEQTITULO
                 AND FI_COMPLTITULO.SEQCONTA = FF.SEQCONTA
                 AND FI_TITULO.SEQPESSOA = FF.SEQPESSOA
                 AND FI_TITULO.SEQPESSOA = FI_COMPLTITULO.SEQPESSOA)FFF,
               
               
               
               (SELECT K.NROEMPRESA, K.NROTITULO, K.SEQTITULO, K.SEQPESSOA, K.VLROPERACAO,
      CASE WHEN K.CODOPERACAO = 6 THEN K.DESCRICAO || ' - AG: ' || K.NROAGENCIA || ' CONTA: ' || K.NROCONTA || '-' || K.DIGCONTA
        ELSE K.DESCRICAO END BANCO_PGTO, K.USUARIO_QUITACAO, K.NOME NOME_USR_QUITACAO
 
FROM ( SELECT A.NROEMPRESA, A.NROTITULO, A.SEQTITULO, A.SEQPESSOA, B.VLROPERACAO, B.CODOPERACAO, H.DESCRICAO, H.NROCONTA, H.DIGCONTA,
                               (SELECT I.NROAGENCIA
                                       FROM GE_AGENCIA I
                                      WHERE I.SEQAGENCIA = H.SEQAGENCIA) NROAGENCIA,
                                B.USUALTERACAO USUARIO_QUITACAO, G.NOME, NVL(B.OBSERVACAO,0) OBS, 
                               DECODE (FC.PAGTOBOLETO, 'S', 'BOLETO', 'N', 'CREDITO EM CONTA', NULL, 'BOLETO')FORMAPGTO,
                               FC.CODBARRA,
                               FC.TIPODOCUMENTO,
                               FC.TIPOPAGAMENTO,
                               FC.FORMAPAGAMENTO,
                               FC.TIPOTRIBUTO
                          FROM FI_TITULO         A,
                               FI_TITOPERACAO    B,
                               GE_PESSOA         C,
                               FI_ESPECIE        F,
                               FI_CTACORRENTE    H,
                               GE_USUARIO        G,
                               FI_COMPLTITULO    FC
                         
                         WHERE A.SEQTITULO = B.SEQTITULO
                           AND A.SEQTITULO = FC.SEQTITULO
                           AND A.SEQPESSOA = C.SEQPESSOA
                           AND A.CODESPECIE = F.CODESPECIE
                           AND B.SEQCTACORRENTE = H.SEQCTACORRENTE 
                           AND B.USUALTERACAO = G.CODUSUARIO
                           AND B.CODOPERACAO in (6,19,61)
                           AND A.DTAINCLUSAO BETWEEN '#DT1' AND '#DT2'
                           AND A.NROEMPRESA IN (#LS1)
                           AND A.CODESPECIE <> 'CRDESC'
                           AND B.OPCANCELADA IS NULL
                           AND F.NROEMPRESAMAE IN
                               (SELECT DISTINCT G.MATRIZ
                                  FROM GE_EMPRESA G
                                 WHERE G.NROEMPRESA = A.NROEMPRESA)
                           AND F.OBRIGDIREITO = 'O' ) K ) KK
               
         WHERE A.SEQTITULO = B.SEQTITULO
           AND A.SEQTITULO = FC.SEQTITULO
           AND A.SEQPESSOA = C.SEQPESSOA
           AND A.CODESPECIE = F.CODESPECIE
           AND FC.SEQTITULO = FFF.SEQTITULO(+)
           AND FC.SEQCONTA = FFF.SEQCONTA(+)
           AND A.SEQPESSOA = FFF.SEQPESSOA(+)

           AND KK.NROEMPRESA = A.NROEMPRESA (+)
           AND KK.NROTITULO = A.NROTITULO (+)
           AND KK.SEQTITULO = A.SEQTITULO (+)
           AND KK.SEQPESSOA = A.SEQPESSOA (+)
         
           
           AND B.USUALTERACAO = G.CODUSUARIO
           
           AND B.CODOPERACAO in (16, 53, 182,269, 308,388, 1028)
           AND A.DTAINCLUSAO BETWEEN '#DT1' AND '#DT2'
           AND A.NROEMPRESA IN (#LS1)
           AND A.CODESPECIE <> 'CRDESC'
       /*    AND A.CODESPECIE IN (#LS2) */
           AND B.OPCANCELADA IS NULL
           AND F.NROEMPRESAMAE IN
               (SELECT DISTINCT G.MATRIZ
                  FROM GE_EMPRESA G
                 WHERE G.NROEMPRESA = A.NROEMPRESA)
           AND F.OBRIGDIREITO = 'O') YY
 ORDER BY 1, 2
 

---------------------------------------------------------------------------------
------------------------ BACKUP 07/08 -------------------------------------------
--------------- Rel Dta Programada Tit X Quitados - Auditoria -------------------
---------------------------------------------------------------------------------


SELECT YY.NROEMPRESA,
       YY.NROTITULO,
       YY.CODESPECIE,
       YY.CODOPERACAO,
       YY.SEQPESSOA,
       YY.NOMERAZAO,
       YY.VLROPERACAO,
       YY.VLR_LIQUIDO,
       YY.VLRDESCFINDISP,
       CASE
         WHEN YY.CODOPERACAO = 16 THEN
          YY.VLR_CRDESC
         ELSE
          NULL
       END VLR_CRDESC,
       YY.VLR_PAGO,
       YY.BANCO_PGTO,
       TO_CHAR(YY.DTAEMISSAO, 'DD/MM/YYYY') DTAEMISSAO,
       YY.DTAINCLUSAO,
       YY.DTAMOVIMENTO,
       YY.DTAVENCIMENTO,
       YY.DTAPROGRAMADA,
       YY.ABERTOQUITADO,
       (SELECT MAX(OO.APELIDO) 
                  FROM MAX_COMPRADOR OO,
                       MAF_FORNECDIVISAO D
           WHERE OO.SEQCOMPRADOR = D.SEQCOMPRADOR
              AND D.SEQFORNECEDOR = YY.SEQPESSOA) COMPRADOR,
       YY.USUARIO_INCLUSAO,
       YY.NOME_USR_INCLUSAO,
       YY.USUARIO_QUITACAO,
       YY.NOME_USR_QUITACAO,

        TRIM(REPLACE(REPLACE(YY.OBSERVACAO,CHR(10),' '), CHR(13),' ')) OBSERVACAO,
       (SELECT AA.CODHISTORICO ||' - '|| INITCAP(CC.DESCRICAO)
                      FROM OR_NFDESPESA        AA,
                           CT_HISTORICO        CC
                           WHERE AA.CODHISTORICO = CC.CODHISTORICO 
                             AND CC.NROEMPRESA = YY.NROEMPRESAMAE
                             AND AA.NROEMPRESA = YY.NROEMPRESA
                             AND AA.NRONOTA = YY.NROTITULO
                             AND AA.SEQPESSOA = YY.SEQPESSOA
                             AND AA.LINKERP = YY.LINKERP
                             AND AA.DTAEMISSAO = YY.DTAEMISSAO) NATUREZA,
      
       YY.FORMAPGTO,
       YY.CODBARRA,
       YY.TIPODOCUMENTO,

       NVL(YY.OBS,0)DETHALOPERC_OBS,
       YY.SEQCONTA,
       YY.BANCO,
       YY.AGENCIA,
       YY.DIGAGENCIA,
       YY.NROCONTA,
       YY.DIGCONTA,
       YY.NOME,
       YY.CNPJCPF,
       YY.DIGCNPJCPF
      
      
       
  FROM (SELECT A.NROEMPRESA,
               A.NROTITULO,
               A.CODESPECIE,
               B.CODOPERACAO,
               A.SEQPESSOA,
               C.NOMERAZAO,
               B.VLROPERACAO,
               NVL(B.OBSERVACAO,0) OBS,
               DECODE (FC.PAGTOBOLETO, 'S', 'BOLETO', 'N', 'CREDITO EM CONTA', NULL, 'BOLETO')FORMAPGTO,
               FC.CODBARRA,
               FC.TIPODOCUMENTO,
               FC.TIPOPAGAMENTO,
               FC.FORMAPAGAMENTO,
               FC.TIPOTRIBUTO,
               PKG_FINANCEIRO.FIF_DESCONTO(A.SEQTITULO, TRUNC(SYSDATE), 'R') AS VLR_LIQUIDO,
               PKG_FINANCEIRO.FIF_DESCONTO(A.SEQTITULO, TRUNC(SYSDATE), 'R') AS VLRDESCFINDISP,
               (SELECT SUM(G.VLROPERACAO)
                  FROM (SELECT A.NROEMPRESA,
                               A.NROTITULO,
                               A.SEQPESSOA,
                               B.VLROPERACAO,
                               NVL(B.OBSERVACAO,0) OBS,
                               DECODE (FC.PAGTOBOLETO, 'S', 'BOLETO', 'N', 'CREDITO EM CONTA', NULL, 'BOLETO')FORMAPGTO,
                               FC.CODBARRA,
                               FC.TIPODOCUMENTO,
                               FC.TIPOPAGAMENTO,
                               FC.FORMAPAGAMENTO,
                               FC.TIPOTRIBUTO
                          FROM FI_TITULO         A,
                               FI_TITOPERACAO    B,
                               GE_PESSOA         C,
                               FI_ESPECIE        F,
                               FI_COMPLTITULO    FC
                         WHERE A.SEQTITULO = B.SEQTITULO
                           AND A.SEQTITULO = FC.SEQTITULO
                           AND A.SEQPESSOA = C.SEQPESSOA
                           AND A.CODESPECIE = F.CODESPECIE
                           AND B.CODOPERACAO = 53
                           AND A.DTAPROGRAMADA BETWEEN '#DT1' AND '#DT2'
                           AND A.NROEMPRESA IN (#LS1)
                           AND A.CODESPECIE = 'CRDESC'
                           AND B.OPCANCELADA IS NULL
                           AND F.NROEMPRESAMAE IN
                               (SELECT DISTINCT G.MATRIZ
                                  FROM GE_EMPRESA G
                                 WHERE G.NROEMPRESA = A.NROEMPRESA)
                           AND F.OBRIGDIREITO = 'O') G
                 WHERE G.NROEMPRESA = A.NROEMPRESA
                   AND G.NROTITULO = A.NROTITULO
                   AND G.SEQPESSOA = A.SEQPESSOA) VLR_CRDESC,
                   
                   
                   
                      KK.VLROPERACAO VLR_PAGO,
                      KK.BANCO_PGTO,
                      KK.USUARIO_QUITACAO,
                      KK.NOME_USR_QUITACAO,                 
                       A.DTAEMISSAO,
               TO_CHAR(A.DTAINCLUSAO, 'DD/MM/YYYY') DTAINCLUSAO,
               TO_CHAR(A.DTAMOVIMENTO, 'DD/MM/YYYY') DTAMOVIMENTO,
               TO_CHAR(A.DTAVENCIMENTO, 'DD/MM/YYYY') DTAVENCIMENTO,
               TO_CHAR(A.DTAPROGRAMADA, 'DD/MM/YYYY') DTAPROGRAMADA,
               DECODE(A.ABERTOQUITADO, 'A', 'ABERTO', 'Q', 'QUITADO', NULL) ABERTOQUITADO,
               B.USUALTERACAO USUARIO_INCLUSAO, 
               G.NOME NOME_USR_INCLUSAO,
               A.OBSERVACAO,
               A.LINKERP,
               A.NROEMPRESAMAE,
               FFF.SEQCONTA,
               FFF.BANCO,
               FFF.AGENCIA,
               FFF.DIGAGENCIA,
               FFF.NROCONTA,
               FFF.DIGCONTA,
               FFF.NOME,
               FFF.CNPJCPF,
               FFF.DIGCNPJCPF
              
              
            
          FROM FI_TITULO         A,
               FI_TITOPERACAO    B,
               GE_PESSOA         C,
               FI_ESPECIE        F,
               GE_USUARIO        G,
               FI_COMPLTITULO    FC,
               (SELECT FF.SEQCONTA,
                       FF.BANCO,
                       FF.AGENCIA,
                       FF.DIGAGENCIA,
                       FF.NROCONTA,
                       FF.DIGCONTA,
                       FF.NOME,
                       FF.CNPJCPF,
                       FF.DIGCNPJCPF,
                       FI_TITULO.SEQTITULO,
                       FI_TITULO.SEQPESSOA
                       
                 from FI_COMPLTITULO, FI_TITULO, FIV_FORNCONTAPESSOA FF
                 Where FI_COMPLTITULO.SEQTITULO = FI_TITULO.SEQTITULO
               /*  AND FI_TITULO.CODESPECIE IN (#LS2) */
                 AND FI_COMPLTITULO.SEQCONTA = FF.SEQCONTA
                 AND FI_TITULO.SEQPESSOA = FF.SEQPESSOA
                 AND FI_TITULO.SEQPESSOA = FI_COMPLTITULO.SEQPESSOA)FFF,
               
               
               
               (SELECT K.NROEMPRESA, K.NROTITULO, K.SEQTITULO, K.SEQPESSOA, K.VLROPERACAO,
      CASE WHEN K.CODOPERACAO = 6 THEN K.DESCRICAO || ' - AG: ' || K.NROAGENCIA || ' CONTA: ' || K.NROCONTA || '-' || K.DIGCONTA
        ELSE K.DESCRICAO END BANCO_PGTO, K.USUARIO_QUITACAO, K.NOME NOME_USR_QUITACAO
 
FROM ( SELECT A.NROEMPRESA, A.NROTITULO, A.SEQTITULO, A.SEQPESSOA, B.VLROPERACAO, B.CODOPERACAO, H.DESCRICAO, H.NROCONTA, H.DIGCONTA,
                               (SELECT I.NROAGENCIA
                                       FROM GE_AGENCIA I
                                      WHERE I.SEQAGENCIA = H.SEQAGENCIA) NROAGENCIA,
                                B.USUALTERACAO USUARIO_QUITACAO, G.NOME, NVL(B.OBSERVACAO,0) OBS, 
                               DECODE (FC.PAGTOBOLETO, 'S', 'BOLETO', 'N', 'CREDITO EM CONTA', NULL, 'BOLETO')FORMAPGTO,
                               FC.CODBARRA,
                               FC.TIPODOCUMENTO,
                               FC.TIPOPAGAMENTO,
                               FC.FORMAPAGAMENTO,
                               FC.TIPOTRIBUTO
                          FROM FI_TITULO         A,
                               FI_TITOPERACAO    B,
                               GE_PESSOA         C,
                               FI_ESPECIE        F,
                               FI_CTACORRENTE    H,
                               GE_USUARIO        G,
                               FI_COMPLTITULO    FC
                         
                         WHERE A.SEQTITULO = B.SEQTITULO
                           AND A.SEQTITULO = FC.SEQTITULO
                           AND A.SEQPESSOA = C.SEQPESSOA
                           AND A.CODESPECIE = F.CODESPECIE
                           AND B.SEQCTACORRENTE = H.SEQCTACORRENTE 
                           AND B.USUALTERACAO = G.CODUSUARIO
                           AND B.CODOPERACAO in (6,19,61)
                           AND A.DTAPROGRAMADA BETWEEN '#DT1' AND '#DT2'
                           AND A.NROEMPRESA IN (#LS1)
                           AND F.CODESPECIE IN (#LS2) 
                          AND DECODE (A.ABERTOQUITADO, 'A', 'ABERTO', 'Q', 'QUITADO') IN (#LS3)
                           AND A.CODESPECIE <> 'CRDESC'
                           AND B.OPCANCELADA IS NULL
                           AND F.NROEMPRESAMAE IN
                               (SELECT DISTINCT G.MATRIZ
                                  FROM GE_EMPRESA G
                                 WHERE G.NROEMPRESA = A.NROEMPRESA)
                           AND F.OBRIGDIREITO = 'O' ) K ) KK
               
         WHERE A.SEQTITULO = B.SEQTITULO
           AND A.SEQTITULO = FC.SEQTITULO
           AND A.SEQPESSOA = C.SEQPESSOA
           AND A.CODESPECIE = F.CODESPECIE
           AND FC.SEQTITULO = FFF.SEQTITULO(+)
           AND FC.SEQCONTA = FFF.SEQCONTA(+)
           AND A.SEQPESSOA = FFF.SEQPESSOA(+)

           AND KK.NROEMPRESA = A.NROEMPRESA (+)
           AND KK.NROTITULO = A.NROTITULO (+)
           AND KK.SEQTITULO = A.SEQTITULO (+)
           AND KK.SEQPESSOA = A.SEQPESSOA (+)
         
           
           AND B.USUALTERACAO = G.CODUSUARIO
           
           AND B.CODOPERACAO in (16, 53, 182, 269, 308, 388, 1028)
           AND A.DTAPROGRAMADA BETWEEN '#DT1' AND '#DT2'
           AND A.NROEMPRESA IN (#LS1)
           AND A.CODESPECIE <> 'CRDESC'
           AND F.CODESPECIE IN (#LS2) 
           AND DECODE (A.ABERTOQUITADO, 'A', 'ABERTO', 'Q', 'QUITADO') IN (#LS3)
           AND B.OPCANCELADA IS NULL
           AND F.NROEMPRESAMAE IN
               (SELECT DISTINCT G.MATRIZ
                  FROM GE_EMPRESA G
                 WHERE G.NROEMPRESA = A.NROEMPRESA)
           AND F.OBRIGDIREITO = 'O') YY
 ORDER BY 1, 2                                                                                             


-------------------------------------------------------------------------------------------------------------------
---------------------------- Titulos Quitados Backup 25/08 --------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

SELECT YY.NROEMPRESA,
       YY.NROTITULO,
       YY.CODESPECIE,
       YY.CODOPERACAO,
       YY.SEQPESSOA,
       YY.NOMERAZAO,
       YY.VLROPERACAO,
       YY.VLR_LIQUIDO,
       YY.VLRDESCFINDISP,
       CASE
         WHEN YY.CODOPERACAO = 16 THEN
          YY.VLR_CRDESC
         ELSE
          NULL
       END VLR_CRDESC,
       YY.VLR_PAGO,
       YY.BANCO_PGTO,
       TO_CHAR(YY.DTAEMISSAO, 'DD/MM/YYYY') DTAEMISSAO,
       YY.DTAINCLUSAO,
       YY.DTAMOVIMENTO,
       YY.DTAVENCIMENTO,
       YY.DTAPROGRAMADA,
       YY.ABERTOQUITADO,
       (SELECT MAX(OO.APELIDO) 
                  FROM MAX_COMPRADOR OO,
                       MAF_FORNECDIVISAO D
           WHERE OO.SEQCOMPRADOR = D.SEQCOMPRADOR
              AND D.SEQFORNECEDOR = YY.SEQPESSOA) COMPRADOR,
       YY.USUARIO_INCLUSAO,
       YY.NOME_USR_INCLUSAO,
       YY.USUARIO_QUITACAO,
       YY.NOME_USR_QUITACAO,

        TRIM(REPLACE(REPLACE(YY.OBSERVACAO,CHR(10),' '), CHR(13),' ')) OBSERVACAO, 
       (SELECT AA.CODHISTORICO ||' - '|| INITCAP(CC.DESCRICAO)
                      FROM OR_NFDESPESA        AA,
                           CT_HISTORICO        CC
                           WHERE AA.CODHISTORICO = CC.CODHISTORICO 
                             AND CC.NROEMPRESA = YY.NROEMPRESAMAE
                             AND AA.NROEMPRESA = YY.NROEMPRESA
                             AND AA.NRONOTA = YY.NROTITULO
                             AND AA.SEQPESSOA = YY.SEQPESSOA
                             AND AA.LINKERP = YY.LINKERP
                             AND AA.DTAEMISSAO = YY.DTAEMISSAO) NATUREZA,
      
       YY.FORMAPGTO,
       YY.CODBARRA,
       YY.TIPODOCUMENTO,

       NVL(YY.OBS,0)DETHALOPERC_OBS,
       YY.SEQCONTA,
       YY.BANCO,
       YY.AGENCIA,
       YY.DIGAGENCIA,
       YY.NROCONTA,
       YY.DIGCONTA,
       YY.NOME,
       YY.CNPJCPF,
       YY.DIGCNPJCPF
      
      
       
  FROM (SELECT A.NROEMPRESA,
               A.NROTITULO,
               A.CODESPECIE,
               B.CODOPERACAO,
               A.SEQPESSOA,
               C.NOMERAZAO,
               B.VLROPERACAO,
               NVL(B.OBSERVACAO,0) OBS,
               DECODE (FC.PAGTOBOLETO, 'S', 'BOLETO', 'N', 'CREDITO EM CONTA', NULL, 'BOLETO')FORMAPGTO,
               FC.CODBARRA,
               FC.TIPODOCUMENTO,
               FC.TIPOPAGAMENTO,
               FC.FORMAPAGAMENTO,
               FC.TIPOTRIBUTO,
               PKG_FINANCEIRO.FIF_DESCONTO(A.SEQTITULO, TRUNC(SYSDATE), 'R') AS VLR_LIQUIDO,
               PKG_FINANCEIRO.FIF_DESCONTO(A.SEQTITULO, TRUNC(SYSDATE), 'R') AS VLRDESCFINDISP,
               (SELECT SUM(G.VLROPERACAO)
                  FROM (SELECT A.NROEMPRESA,
                               B.CODOPERACAO,
                               A.NROTITULO,
                               A.SEQPESSOA,
                               B.VLROPERACAO,
                               NVL(B.OBSERVACAO,0) OBS,
                               DECODE (FC.PAGTOBOLETO, 'S', 'BOLETO', 'N', 'CREDITO EM CONTA', NULL, 'BOLETO')FORMAPGTO,
                               FC.CODBARRA,
                               FC.TIPODOCUMENTO,
                               FC.TIPOPAGAMENTO,
                               FC.FORMAPAGAMENTO,
                               FC.TIPOTRIBUTO
                          FROM FI_TITULO         A,
                               FI_TITOPERACAO    B,
                               GE_PESSOA         C,
                               FI_ESPECIE        F,
                               FI_COMPLTITULO    FC
                         WHERE A.SEQTITULO = B.SEQTITULO
                           AND A.SEQTITULO = FC.SEQTITULO
                           AND A.SEQPESSOA = C.SEQPESSOA
                           AND A.CODESPECIE = F.CODESPECIE
                           AND B.CODOPERACAO in (53)
                           AND A.DTAINCLUSAO BETWEEN '&DT1' AND '&DT2'
                           AND A.NROEMPRESA IN (1,2,3,5,6,7,8,9,10,11,12,32,33,34,21,66)
                           AND A.CODESPECIE = 'CRDESC'
                           AND B.OPCANCELADA IS NULL
                           AND F.NROEMPRESAMAE IN
                               (SELECT DISTINCT G.MATRIZ
                                  FROM GE_EMPRESA G
                                 WHERE G.NROEMPRESA = A.NROEMPRESA)
                           AND F.OBRIGDIREITO = 'O') G
                 WHERE G.NROEMPRESA = A.NROEMPRESA
                   AND G.NROTITULO = A.NROTITULO
                   AND G.SEQPESSOA = A.SEQPESSOA) VLR_CRDESC,
                   
                   
                   
                      KK.VLROPERACAO VLR_PAGO,
                      KK.BANCO_PGTO,
                      KK.USUARIO_QUITACAO,
                      KK.NOME_USR_QUITACAO,                 
                       A.DTAEMISSAO,
               TO_CHAR(A.DTAINCLUSAO, 'DD/MM/YYYY') DTAINCLUSAO,
               TO_CHAR(A.DTAMOVIMENTO, 'DD/MM/YYYY') DTAMOVIMENTO,
               TO_CHAR(A.DTAVENCIMENTO, 'DD/MM/YYYY') DTAVENCIMENTO,
               TO_CHAR(A.DTAPROGRAMADA, 'DD/MM/YYYY') DTAPROGRAMADA,
               DECODE(A.ABERTOQUITADO, 'A', 'ABERTO', 'Q', 'QUITADO') ABERTOQUITADO,
               B.USUALTERACAO USUARIO_INCLUSAO, 
               G.NOME NOME_USR_INCLUSAO,
               A.OBSERVACAO,
               A.LINKERP,
               A.NROEMPRESAMAE,
               FFF.SEQCONTA,
               FFF.BANCO,
               FFF.AGENCIA,
               FFF.DIGAGENCIA,
               FFF.NROCONTA,
               FFF.DIGCONTA,
               FFF.NOME,
               FFF.CNPJCPF,
               FFF.DIGCNPJCPF
              
              
            
          FROM FI_TITULO         A,
               FI_TITOPERACAO    B,
               GE_PESSOA         C,
               FI_ESPECIE        F,
               GE_USUARIO        G,
               FI_COMPLTITULO    FC,
               (SELECT FF.SEQCONTA,
                       FF.BANCO,
                       FF.AGENCIA,
                       FF.DIGAGENCIA,
                       FF.NROCONTA,
                       FF.DIGCONTA,
                       FF.NOME,
                       FF.CNPJCPF,
                       FF.DIGCNPJCPF,
                       FI_TITULO.SEQTITULO,
                       FI_TITULO.SEQPESSOA
                       
                 from FI_COMPLTITULO, FI_TITULO, FIV_FORNCONTAPESSOA FF
                 Where FI_COMPLTITULO.SEQTITULO = FI_TITULO.SEQTITULO
                 AND FI_COMPLTITULO.SEQCONTA = FF.SEQCONTA
                 AND FI_TITULO.SEQPESSOA = FF.SEQPESSOA
                 AND FI_TITULO.SEQPESSOA = FI_COMPLTITULO.SEQPESSOA)FFF,
               
               
               
               (SELECT K.NROEMPRESA, K.NROTITULO, K.SEQTITULO, K.SEQPESSOA, K.VLROPERACAO,
      CASE WHEN K.CODOPERACAO = 6 THEN K.DESCRICAO || ' - AG: ' || K.NROAGENCIA || ' CONTA: ' || K.NROCONTA || '-' || K.DIGCONTA
        ELSE K.DESCRICAO END BANCO_PGTO, K.USUARIO_QUITACAO, K.NOME NOME_USR_QUITACAO
 
FROM ( SELECT A.NROEMPRESA, A.NROTITULO, A.SEQTITULO, A.SEQPESSOA, B.VLROPERACAO, B.CODOPERACAO, H.DESCRICAO, H.NROCONTA, H.DIGCONTA,
                               (SELECT I.NROAGENCIA
                                       FROM GE_AGENCIA I
                                      WHERE I.SEQAGENCIA = H.SEQAGENCIA) NROAGENCIA,
                                B.USUALTERACAO USUARIO_QUITACAO, G.NOME, NVL(B.OBSERVACAO,0) OBS, 
                               DECODE (FC.PAGTOBOLETO, 'S', 'BOLETO', 'N', 'CREDITO EM CONTA', NULL, 'BOLETO')FORMAPGTO,
                               FC.CODBARRA,
                               FC.TIPODOCUMENTO,
                               FC.TIPOPAGAMENTO,
                               FC.FORMAPAGAMENTO,
                               FC.TIPOTRIBUTO
                          FROM FI_TITULO         A,
                               FI_TITOPERACAO    B,
                               GE_PESSOA         C,
                               FI_ESPECIE        F,
                               FI_CTACORRENTE    H,
                               GE_USUARIO        G,
                               FI_COMPLTITULO    FC
                         
                         WHERE A.SEQTITULO = B.SEQTITULO
                           AND A.SEQTITULO = FC.SEQTITULO
                           AND A.SEQPESSOA = C.SEQPESSOA
                           AND A.CODESPECIE = F.CODESPECIE
                           AND B.SEQCTACORRENTE = H.SEQCTACORRENTE 
                           AND  B.USUALTERACAO = G.CODUSUARIO-- (+) 
                           AND B.CODOPERACAO in (6,19,61)
                           AND A.DTAINCLUSAO BETWEEN '&DT1' AND '&DT2'
                           AND A.NROEMPRESA IN (1,2,3,5,6,7,8,9,10,11,12,32,33,34,21,66)
                           AND A.CODESPECIE <> 'CRDESC'
                          -- AND F.CODESPECIE IN (#LS2) 
                        --  AND DECODE (A.ABERTOQUITADO, 'A', 'ABERTO', 'Q', 'QUITADO') IN (#LS3)
                           AND B.OPCANCELADA IS NULL
                           AND F.NROEMPRESAMAE IN
                               (SELECT DISTINCT G.MATRIZ
                                  FROM GE_EMPRESA G
                                 WHERE G.NROEMPRESA = A.NROEMPRESA)
                           AND F.OBRIGDIREITO = 'O' ) K ) KK
               
         WHERE A.SEQTITULO = B.SEQTITULO
           AND A.SEQTITULO = FC.SEQTITULO
           AND A.SEQPESSOA = C.SEQPESSOA
           AND A.CODESPECIE = F.CODESPECIE
           AND FC.SEQTITULO = FFF.SEQTITULO(+)
           AND FC.SEQCONTA = FFF.SEQCONTA(+)
           AND A.SEQPESSOA = FFF.SEQPESSOA(+)

           AND KK.NROEMPRESA(+) = A.NROEMPRESA
           AND KK.NROTITULO(+) = A.NROTITULO 
           AND KK.SEQTITULO(+) = A.SEQTITULO 
           AND KK.SEQPESSOA(+) = A.SEQPESSOA 
         
           
           AND B.USUALTERACAO = G.CODUSUARIO(+)
           
           AND B.CODOPERACAO in (16, 53, 182, 197, 269, 308,388, 1028)
           AND A.DTAINCLUSAO BETWEEN '&DT1' AND '&DT2'    --'#DT1' AND '#DT2'
           AND A.NROEMPRESA IN (1,2,3,5,6,7,8,9,10,11,12,32,33,34,21,66)--(#LS1)
           AND A.CODESPECIE <> 'CRDESC'
          -- AND F.CODESPECIE IN (#LS2) 
         --  AND DECODE (A.ABERTOQUITADO, 'A', 'ABERTO', 'Q', 'QUITADO') IN (#LS3)
           AND B.OPCANCELADA IS NULL
           AND F.NROEMPRESAMAE IN
               (SELECT DISTINCT G.MATRIZ
                  FROM GE_EMPRESA G
                 WHERE G.NROEMPRESA = A.NROEMPRESA)
           AND F.OBRIGDIREITO = 'O') YY
 ORDER BY 1, 2;
 
--------------------------------------------------------------------
select * from GE_USUARIO 
where CODUSUARIO like '%CRED' 

SELECT * FROM FI_TITULO         A,
              FI_TITOPERACAO    B
WHERE A.SEQTITULO = B.SEQTITULO
AND A.CODESPECIE IN ('DESPJU', 'PROCCV')
--AND b.codoperacao in (197)



-----------------------------------------------------------------------















