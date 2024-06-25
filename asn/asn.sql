-- Listagem de todos os artigos com firmes
-- AJBZST > FERM OR PROV
-- AJE4ST > RECEIVED OUI OR NO
-- HPO - TODOS OS PEDIDOS FIRMES QUE NÃO FORAM ENTREGUES
-- SUP - TODOS OS ASNs ENVIADOS PELOS FORNECEDORES
-- PDPF - PRIMEIRA DATA PERÍODO FIRME
-- ADPF - TODAS AS DATAS PERÍODO FIRME
-- FIXME - APAGAR AS LINHAS DE RECECÃO DO DIA ATUAL - PESQUISAR NAS TABELAS DE RUTURA
    -- CONFIRMAR SE ISTO SÓ ACONTECE PARA RECEÇÃO MANUAL, QUE NÃO TENHA AVIES
    -- SE HÁ UMA TABELA QUE MOSTRE AS RECEÇÕES DE HOJE, PARA PEGAR AS QUANTIDADES E DEDU
    -- ZIR DA COLUNA BCKLOG
-- FIXME - SE FORNECEDOR ESTIVER EM ATRASO, NAO APARECE PEDIDO, APARECE AVIES SEM PEDIDO
    -- CASO ISTO ACONTEÇA, VALIDAR SE ARTIGO ESTÁ EM ATRASO, CASO ESTEJA, EXIBIR INFORMAÇÕES DO ASN
    -- USAR FUNÇÃO COALESCE E ADICIONAR UMA COLUNA CONTENDO F QUANDO ESIVER FIRME
    -- COLETAR INFORMACÕES DE OUTRAS TABELAS PARA O ARTIGO, MENOS DATA PROVISÃO E QUANTIDADE E USAR COM COALESCE NO SELECT PRINCIPAL

SELECT COALESCE(HPO.CODE, SUP.CODE) AS CODE, COALESCE(HPO.FORNSACHA, SUP.FORNSACHA) AS FORNSACHA, COALESCE(HPO.COMPONENT, SUP.COMPONENT) AS COMPONENT, 
    COALESCE(HPO.BCKLOG, SUP.BCKLOG) AS BCKLOG, DATE(HPO.PROVDATE) AS PROVDATE, HPO.PROVQTF, COALESCE(HPO.APRO, SUP.APRO) AS APRO, SUP.DN, SUP.DNDATE, SUP.PLACE, SUP.STATUS, SUP.DNQTF

    FROM (
        SELECT DISTINCT PDPF.CODE, PDPF.COMPONENT, ADPF.PROVQTF, APRO.AEGGCD AS APRO, FORN.ASAUCD AS FORNSACHA, ( APRO.AEQTDU - APRO.AEQTRE ) AS BCKLOG,
            CONCAT('20', SUBSTR(PDPF.INTDATE, 2,2))||'-'||SUBSTR(PDPF.INTDATE, 4,2)||'-'||SUBSTR(PDPF.INTDATE, 6,2) AS PROVDATE

            FROM (
                
                SELECT CODE, COMPONENT, MIN(INTDATE) AS INTDATE

                    FROM (

                        SELECT DISTINCT PROV.AJARCD AS CODE, PROV.AJD5CD AS COMPONENT, INT(PROV.AJAFDT) AS INTDATE

                            FROM AUTO.YSACHAHPO.YDAJREP PROV

                        WHERE PROV.AJBZST = 'F' AND PROV.AJE4ST = 'N'
                    
                    )

                GROUP BY COMPONENT, CODE

            ) PDPF

            LEFT JOIN (

                SELECT DISTINCT PROV.AJARCD AS CODE, PROV.AJD5CD AS COMPONENT, INT(PROV.AJAFDT) AS INTDATE, PROV.AJAIQT AS PROVQTF

                FROM AUTO.YSACHAHPO.YDAJREP PROV

                WHERE PROV.AJBZST = 'F' AND PROV.AJE4ST = 'N'

            ) ADPF
            ON  ADPF.CODE = PDPF.CODE AND ADPF.COMPONENT = PDPF.COMPONENT AND ADPF.INTDATE = PDPF.INTDATE

            LEFT JOIN  AUTO.YSACHAHPO.YDAEREP APRO
            ON APRO.AEARCD = PDPF.CODE AND APRO.AED5CD = PDPF.COMPONENT

            LEFT JOIN AUTO.YSACHAHPO.YDASREP FORN
            ON APRO.AEARCD = FORN.ASARCD

    ) HPO

    FULL JOIN (
        
        SELECT ASN.HIARCD AS CODE, ASN.HIUNCD AS DN, ART.HJD5CD AS COMPONENT, ART.HJHONB AS DNQTF, 
            DATE( CONCAT('20', SUBSTR(ASN.HIC5DT, 2,2))||'-'||SUBSTR(ASN.HIC5DT, 4,2)||'-'||SUBSTR(ASN.HIC5DT, 6,2) ) AS DNDATE, 
            ASN.HIUPCD AS PLACE, ASN.HITEST AS STATUS, APRO.AEGGCD AS APRO, FORN.ASAUCD AS FORNSACHA, ( APRO.AEQTDU - APRO.AEQTRE ) AS BCKLOG
            
            FROM AUTO.YSACHAHPO.YDHIREP ASN

            RIGHT JOIN AUTO.YSACHAHPO.YDHJREP ART
            ON ART.HJUNCD = ASN.HIUNCD
            AND ART.HJARCD = ASN.HIARCD

            LEFT JOIN  AUTO.YSACHAHPO.YDAEREP APRO
            ON APRO.AEARCD = ASN.HIARCD AND APRO.AED5CD = ART.HJD5CD

            LEFT JOIN AUTO.YSACHAHPO.YDASREP FORN
            ON APRO.AEARCD = FORN.ASARCD

        WHERE ASN.HITEST < 4
        
    ) SUP
    ON SUP.COMPONENT = HPO.COMPONENT AND SUP.CODE = HPO.CODE

-- FIXME: WHERE NOT IN ( (SELECT COMPONENT RECEIVED TODAY) REC ) AND HPO.CODE = REC.CODE

ORDER BY HPO.PROVDATE, HPO.CODE