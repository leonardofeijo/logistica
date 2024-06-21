-- Seleciona as primeiras datas entre os períodos firmes para cada fornecedor.
-- ADPF - Todas as datas de período firme
-- PDPF - Primeira data de período firme

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