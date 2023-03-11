OPTIONS (SKIP = 1)
LOAD DATA
 INFILE 'equipoL.csv'
 INTO TABLE EQUIPOL
 FIELDS TERMINATED BY ';'
 ( equipoL, golesLocales, golesVisitantes, estadio )