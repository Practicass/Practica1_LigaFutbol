OPTIONS (SKIP = 1)
LOAD DATA
INFILE '../data/partido.csv'
INTO TABLE PARTIDOS
FIELDS TERMINATED BY ';'
( 
    equipoLocal,
    equipoVisitante,
    golesLocales,
    golesVisitantes,
    estadio, 
    idJor, 
    idPar 
)