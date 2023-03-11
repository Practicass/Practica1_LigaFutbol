OPTIONS (SKIP = 1)
LOAD DATA
 INFILE 'partido.csv'
 INTO TABLE PARTIDOS
 FIELDS TERMINATED BY ';'
 ( equipoVisitante, idJor, idPar )