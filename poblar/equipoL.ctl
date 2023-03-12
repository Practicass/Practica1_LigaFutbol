OPTIONS (SKIP = 1)
LOAD DATA
 INFILE '../data/equipoL.csv'
 INTO TABLE EQUIPOL
 FIELDS TERMINATED BY ';'
 ( 
    equipoL, 
    golesLocales, 
    golesVisitantes, 
    estadio
)