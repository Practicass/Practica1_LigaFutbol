OPTIONS (SKIP = 1)
LOAD DATA
INFILE '../data/divisiones.csv'
INTO TABLE DIVISIONES
FIELDS TERMINATED BY ';'
( 
    denominacion 
)