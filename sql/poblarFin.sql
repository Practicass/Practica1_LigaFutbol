/*Inicialización de tabla resultados*/
insert into Resultados (equipo, idJor, tempCod) 
  select p.equipoLocal, p.idJor, j.tempCod from partidos p, jornadas j
  where p.idJor = j.idJor
  UNION
  select p.equipoVisitante, p.idJor, j.tempCod from partidos p, jornadas j
  where p.idJor = j.idJor;

/*Primer update goles*/
UPDATE RESULTADOS RESU set golesFavor = (
  Select sum(Par.golesLocales)
        from partidos Par, JORNADAS Jor, EQUIPOS Equi
        where Par.equipoLocal=Equi.nombreCorto and RESU.equipo=Equi.nombreCorto
                and Jor.tempCod=RESU.tempCod and Jor.idJor = Par.idJor
                and Par.idJor<= RESU.idJor 
);
/*Segundo update goles*/

UPDATE RESULTADOS RESU set golesFavor = (
  Select sum(Par.golesVisitantes)+ RESU.golesFavor
            from PARTIDOS Par, JORNADAS Jor, EQUIPOS Equi
        where Par.equipoVisitante=Equi.nombreCorto and RESU.equipo=Equi.nombreCorto
                and Jor.tempCod=RESU.tempCod and Jor.idJor = Par.idJor
                and Par.idJor<= RESU.idJor 
);

/*Primer update puntos*/
UPDATE RESULTADOS RESU set  puntos = (
  Select count(*)
  from (SELECT unique P.golesVisitantes as e, J.idJor as jor
                        FROM PARTIDOS P, JORNADAS J, EQUIPOS E
                        WHERE    ((P.equipoLocal=RESU.equipo)
                                OR (P.equipoVisitante=RESU.equipo))
                                AND (P.golesLocales=P.golesVisitantes)
                                AND (P.idJor=J.idJor)
                                AND ((J.tempCod=RESU.tempCod))
                                AND J.idJor<=RESU.idJor )H
);






/*Segundo update puntos*/
UPDATE RESULTADOS RESU set  puntos = (
Select RESU.puntos+3*count(*)
from (SELECT unique P.golesVisitantes as e, J.idJor as jor
                        FROM PARTIDOS P, JORNADAS J, EQUIPOS E
                        WHERE    (((P.equipoLocal=RESU.equipo) 
                                AND (P.golesLocales>P.golesVisitantes))
                                OR ((P.equipoVisitante=RESU.equipo) 
                                AND (P.golesVisitantes>P.golesLocales)) )
                                AND (P.idJor=J.idJor)
                                AND ((J.tempCod=RESU.tempCod))
                                AND J.idJor<=RESU.idJor)H);


/*Update de puesto*/

UPDATE Resultados Res
SET puesto = (SELECT RowN 
FROM (
  SELECT 
        ROW_NUMBER() OVER(
            partition by idJor, tempCod
            ORDER BY puntos DESC, golesFavor-golesContra DESC
        ) AS RowN,
        equipo,
        idJor, 
        tempCod 
        FROM Resultados
        order by  tempCod, idJor,RowN  
) Par
where Res.equipo=Par.equipo and Res.idJor=Par.idJor and Res.tempCod=Par.tempCod);