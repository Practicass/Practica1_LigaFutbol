OPTIONS (SKIP = 1)
LOAD DATA
 INFILE '../data/otrosNombres.csv'
 INTO TABLE OTROS_NOMBRES
 FIELDS TERMINATED BY ';'
 ( 
    nombreCorto,
    otrosNombres
     
)