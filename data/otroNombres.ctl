OPTIONS (SKIP = 1)
LOAD DATA
 INFILE 'otrosNombres.csv'
 INTO TABLE OTROS_NOMBRES
 FIELDS TERMINATED BY ';'
 ( otrosNombres, nombreCorto )