OPTIONS (SKIP = 1)
LOAD DATA
INFILE '../data/estadios.csv'
INTO TABLE ESTADIOS
FIELDS TERMINATED BY ';'
( 
    nombre, 
    fechaInauguracion, 
    capacidad 
)