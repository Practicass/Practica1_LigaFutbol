OPTIONS (SKIP = 1)
LOAD DATA
INFILE '../data/jornada.csv'
INTO TABLE JORNADAS
FIELDS TERMINATED BY ';'
( numero, 
  tempCod, 
  idJor 
)