OPTIONS(SKIP=1)
LOAD DATA
INFILE '../data/temporada.csv'
APPEND INTO TABLE TEMPORADAS
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
( 
    inicio, 
    fin, 
    division, 
    tempCod 
)
