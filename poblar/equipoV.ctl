OPTIONS (SKIP = 1)
LOAD DATA
 INFILE 'equipoV.csv'
 INTO TABLE EQUIPOV
 FIELDS TERMINATED BY ';'
 ( 
    equipoL, 
    equipoV 
)