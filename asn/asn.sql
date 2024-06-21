-- Listagem de todos os artigos com firmes
-- AJBZST > FERM OR PROV
-- AJE4ST > RECEIVED OUI OR NO
-- HPO - TODOS OS PEDIDOS FIRMES QUE NÃO FORAM ENTREGUES
-- SUP - TODOS OS ASNs ENVIADOS PELOS FORNECEDORES
-- FIXME - APAGAR AS LINHAS DE RECECÃO DO DIA ATUAL

SELECT HPO.CODE, HPO.FORNSACHA, HPO.COMPONENT, HPO.BCKLOG, HPO.PROVDATE, HPO.PROVQTF, HPO.APRO, SUP.DN, SUP.DNDATE, SUP.PLACE, SUP.STATUS, SUP.DNQTF

FROM (
    SELECT DISTINCT PDPF.CODE, PDPF.COMPONENT, ADPF.PROVQTF, APRO.AEGGCD AS APRO, FORN.ASAUCD AS FORNSACHA, ( APRO.AEQTDU - APRO.AEQTRE ) AS BCKLOG,
    DATE( CONCAT('20', substr(PDPF.INTDATE, 2,2))||'-'||substr(PDPF.INTDATE, 4,2)||'-'||substr(PDPF.INTDATE, 6,2) ) AS PROVDATE

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

) AS HPO

FULL JOIN (SELECT ASN.HIARCD AS CODE, ASN.HIUNCD AS DN, ART.HJD5CD AS COMPONENT, ART.HJHONB AS DNQTF, 
	DATE( CONCAT('20', substr(ASN.HIC5DT, 2,2))||'-'||substr(ASN.HIC5DT, 4,2)||'-'||substr(ASN.HIC5DT, 6,2) ) AS DNDATE, 
	ASN.HIUPCD AS PLACE, ASN.HITEST AS STATUS
	
FROM AUTO.YSACHAHPO.YDHIREP ASN

RIGHT JOIN AUTO.YSACHAHPO.YDHJREP ART
ON ART.HJUNCD = ASN.HIUNCD
AND ART.HJARCD = ASN.HIARCD

WHERE ASN.HITEST < 4) AS SUP
ON SUP.COMPONENT = HPO.COMPONENT

ORDER BY HPO.PROVDATE, HPO.CODE