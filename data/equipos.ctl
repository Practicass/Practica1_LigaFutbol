OPTIONS (SKIP = 1)
LOAD DATA
 INFILE 'equipos.csv'
 INTO TABLE EQUIPOS
 FIELDS TERMINATED BY ';'
 ( nombreCorto, nombreOficial, ciudad, fechaFundacion, fechaLegal, nombreHistorico, nomEstadio  )