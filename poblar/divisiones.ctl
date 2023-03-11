OPTIONS (SKIP = 1)
LOAD DATA
INFILE 'divisiones.csv'
INTO TABLE DIVISIONES
FIELDS TERMINATED BY ';'
( 
    denominacion 
)