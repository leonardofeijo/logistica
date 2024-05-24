SELECT DISTINCT ARTIGO, UAP, FORNECEDOR, STKMAG, STKATE, COUVSTK, STATUS
FROM
(
-- RUTURAS
 
SELECT DISTINCT RUTURAS.USRLD3 AS ARTIGO, STORAGE.DE1713 AS UAP, RUTURAS.SA1512 AS FORNECEDOR, STOCK.SA1507 AS STKMAG, STOCK.SA1514 AS STKATE, STOCK.SA1509 AS COUVSTK, ('RUTURA') AS STATUS

FROM (SELECT DE100M.USRLD3, count(DE100M.USRLD3), DE100M.USRSD3, TSA015.SA1506, TSA015.SA1511, TSA015.SA1512, MIN(FET001K.ETK192), (SELECT (IC130M_0.LLBLT1+IC130M_0.LLBLT2+IC130M_0.LLBLT4) FROM AUTO.D805DATHPO.IC130M IC130M_0 WHERE (IC130M_0.LLPPN=DE100M.USRLD3) AND (IC130M_0.LLSTLC='QUALID')), (IC130M.LLBLT1+IC130M.LLBLT2+IC130M.LLBLT4), (IC140M.WBBLT4-(IC130M.LLBLT1+IC130M.LLBLT2+IC130M.LLBLT4)),(SELECT (IC130M_1.LLBLT1+IC130M_1.LLBLT2+IC130M_1.LLBLT4) FROM AUTO.D805DATHPO.IC130M IC130M_1 WHERE (IC130M_1.LLPPN=DE100M.USRLD3) AND (IC130M_1.LLSTLC='MPPORTO')), (SELECT (IC130M_2.LLBLT1+IC130M_2.LLBLT2+IC130M_2.LLBLT4) FROM AUTO.D805DATHPO.IC130M IC130M_2 WHERE (IC130M_2.LLPPN=DE100M.USRLD3) AND (IC130M_2.LLSTLC='MP-KANB')), (SELECT (IC130M_3.LLBLT1+IC130M_3.LLBLT2+IC130M_3.LLBLT4) FROM AUTO.D805DATHPO.IC130M IC130M_3 WHERE (IC130M_3.LLPPN=DE100M.USRLD3) AND (IC130M_3.LLSTLC='MPORTO2')), (SELECT (IC130M_4.LLBLT1+IC130M_4.LLBLT2+IC130M_4.LLBLT4) FROM AUTO.D805DATHPO.IC130M IC130M_4 WHERE (IC130M_4.LLPPN=DE100M.USRLD3) AND (IC130M_4.LLSTLC='MKANB2')), (SELECT (IC130M_5.LLBLT4) FROM AUTO.D805DATHPO.IC130M IC130M_5 WHERE (IC130M_5.LLPPN=DE100M.USRLD3) AND (IC130M_5.LLSTLC='KIPA')) FROM AUTO.D805DATHPO.DE100M DE100M, AUTO.D805DATHPO.FET001 FET001, AUTO.D805DATHPO.FET001K FET001K, AUTO.D805DATHPO.TSA015 TSA015, AUTO.D805DATHPO.IC130M IC130M, AUTO.D805DATHPO.IC140M IC140M WHERE FET001K.ETK101=FET001.ET0101 AND FET001.ET0102=DE100M.IZPN AND DE100M.USRLD3=TSA015.SA1501 AND DE100M.USRLD3=IC130M.LLPPN AND DE100M.USRLD3=IC140M.WBPPN AND ((FET001K.ETK103='R') AND (IC130M.LLSTLC='REC')) GROUP BY DE100M.USRLD3, DE100M.USRSD3, TSA015.SA1506, TSA015.SA1511, TSA015.SA1512, (IC130M.LLBLT1+IC130M.LLBLT2+IC130M.LLBLT4), (IC140M.WBBLT4-(IC130M.LLBLT1+IC130M.LLBLT2+IC130M.LLBLT4)),(SELECT (IC130M_1.LLBLT1+IC130M_1.LLBLT2+IC130M_1.LLBLT4) FROM AUTO.D805DATHPO.IC130M IC130M_1 WHERE (IC130M_1.LLPPN=DE100M.USRLD3) AND (IC130M_1.LLSTLC='MPPORTO')), (SELECT (IC130M_2.LLBLT1+IC130M_2.LLBLT2 + IC130M_2.LLBLT4) FROM AUTO.D805DATHPO.IC130M IC130M_2 WHERE (IC130M_2.LLPPN = DE100M.USRLD3) AND (IC130M_2.LLSTLC='MP-KANB')),(SELECT (IC130M_3.LLBLT1+IC130M_3.LLBLT2+IC130M_3.LLBLT4) FROM AUTO.D805DATHPO.IC130M IC130M_3 WHERE (IC130M_3.LLPPN=DE100M.USRLD3) AND (IC130M_3.LLSTLC='MPORTO2')), (SELECT (IC130M_4.LLBLT1+IC130M_4.LLBLT2 + IC130M_4.LLBLT4) FROM AUTO.D805DATHPO.IC130M IC130M_4 WHERE (IC130M_4.LLPPN=DE100M.USRLD3) AND (IC130M_4.LLSTLC='MKANB2')), (SELECT (IC130M_5.LLBLT4) FROM AUTO.D805DATHPO.IC130M IC130M_5 WHERE (IC130M_5.LLPPN=DE100M.USRLD3) AND (IC130M_5.LLSTLC='KIPA')) ORDER BY TSA015.SA1512) RUTURAS

LEFT JOIN AUTO.D805DATHPO.TSA015 STOCK

ON RUTURAS.USRLD3 = STOCK.SA1501

LEFT JOIN AUTO.D805DATHPO.TDE017 STORAGE

ON RUTURAS.USRLD3 = STORAGE.DE1730

 
UNION

 
-- TSA015X FIXME: CONVERTER PARA TSA015  
 
SELECT DISTINCT PARTNO AS ARTIGO, STORAGE.DE1713 AS UAP, SUP_NAME AS FORNECEDOR, STK_WARE AS STKMAG, STK_WORK AS STKATE, STK_COVER AS COUVSTK, ('STOCK LOW TSA') AS STATUS
FROM AUTO.D805DATHPO.TSA015X AS TSA015X

LEFT JOIN AUTO.D805DATHPO.TDE017 STORAGE

ON TSA015X.PARTNO = STORAGE.DE1730

WHERE TY = '03' AND STK_COVER < 2


UNION

 
-- TJT004B
SELECT DISTINCT TJT004B.JTB404 AS ARTIGO, STORAGE.DE1713 AS UAP, STOCK.SA1512 AS FORNECEDOR, TJT004B.JTB411 AS SKTMAG, TJT004B.JTB412 AS STKATE, TJT004B.JTB423 AS COUVSTK, ('STOCK LOW TJT') AS STATUS
FROM AUTO.D805DATHPO.TJT004B TJT004B

LEFT JOIN AUTO.D805DATHPO.TDE017 STORAGE
ON JTB404 = STORAGE.DE1730

LEFT JOIN AUTO.D805DATHPO.TSA015 STOCK
ON JTB404 = STOCK.SA1501
  
WHERE JTB410 = '03' AND JTB423 < 2


UNION

 
-- REC C

SELECT DISTINCT REC.LLPPN AS ARTIGO, STORAGE.DE1713 AS UAP, STOCK.SA1512 AS FORNECEDOR, STOCK.SA1507 AS STKMAG, STOCK.SA1514 AS STKATE, STOCK.SA1509 AS COUVSTK, ('REC-C') AS STATUS
FROM (SELECT IC130M.LLPPN, IC130M.LLSTLC, IC130M.LLBLT1, IC130M.LLBLT2, IC130M.LLBLT3, IC130M.LLBLT4 FROM AUTO.D805DATHPO.IC130M IC130M WHERE (((IC130M.LLBLT1)+(IC130M.LLBLT2)+(IC130M.LLBLT3)+(IC130M.LLBLT4))<>0) AND (IC130M.LLSTLC='REC') AND (IC130M.LLBLT2 > 0)) REC

LEFT JOIN AUTO.D805DATHPO.TDE017 STORAGE
ON REC.LLPPN = STORAGE.DE1730

LEFT JOIN AUTO.D805DATHPO.TSA015 STOCK
ON REC.LLPPN = STOCK.SA1501

WHERE STOCK.SA1509 < 20
)
ORDER BY UAP
