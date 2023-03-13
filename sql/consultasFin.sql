/* Máximo ganador de ligas en primera division*/

SELECT *
FROM (SELECT equipo, COUNT(equipo)
        FROM (SELECT MAXP.temporada, puntos2.nEq as equipo
                FROM TEMPORADAS T,
                        (SELECT temp.tempCod as temporada, max(puntos.pts) as maxpts
                         FROM (SELECT EMP.i as tIni, EMP.eq as nEq, EMP.e+GAN.g as pts
                                FROM (SELECT T.tempCod as i,E.nombreCorto as eq, count(*) as e
                                        FROM PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                                        WHERE  ((P.equipoLocal=E.nombreCorto)or(P.equipoVisitante=E.nombreCorto))
                                                AND (P.golesLocales=P.golesVisitantes)
                                                AND (P.idJor=J.idJor)
                                                AND (J.tempCod=T.tempCod)
                                                AND (T.division='1')
                                        GROUP BY T.tempCod,E.nombreCorto) EMP, 
                                                (SELECT T.tempCod as ini, E.nombreCorto as equipo ,3*count(*) as g
                                                 FROM PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                                                WHERE (((P.equipoLocal=E.nombreCorto) AND (P.golesLocales>P.golesVisitantes))
                                                        OR ((P.equipoVisitante=E.nombreCorto) AND (P.golesVisitantes>P.golesLocales)) )
                                                        AND (P.idJor=J.idJor)
                                                        AND (J.tempCod=T.tempCod)
                                                        AND (T.division='1')
                                                GROUP BY T.tempCod,E.nombreCorto) GAN
                                WHERE EMP.i=GAN.ini AND EMP.eq=GAN.equipo) puntos, TEMPORADAS temp , EQUIPOS equipos
                        WHERE puntos.tIni=temp.tempCod
                        GROUP BY temp.tempCod )  MAXP, 
                (SELECT EMP.i as tIni, EMP.eq as nEq, EMP.e+GAN.g as pts
                FROM (SELECT T.tempCod as i,E.nombreCorto as eq, count(*) as e
                        FROM PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                        WHERE ((P.equipoLocal=E.nombreCorto)
                                OR (P.equipoVisitante=E.nombreCorto))
                                AND (P.golesLocales=P.golesVisitantes)
                                AND (P.idJor=J.idJor)
                                AND (J.tempCod=T.tempCod)
                                AND (T.division='1')
                        GROUP BY T.tempCod,E.nombreCorto) EMP, 
                        (SELECT T.tempCod as ini, E.nombreCorto as equipo ,3*count(*) as g
                        FROM PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                        WHERE (((P.equipoLocal=E.nombreCorto) 
                                AND (P.golesLocales>P.golesVisitantes))
                                OR ((P.equipoVisitante=E.nombreCorto) 
                                AND (P.golesVisitantes>P.golesLocales)) )
                                AND (P.idJor=J.idJor)
                                AND (J.tempCod=T.tempCod)
                                AND (T.division='1')
                        GROUP BY T.tempCod,E.nombreCorto) GAN
                WHERE EMP.i=GAN.ini AND EMP.eq=GAN.equipo ) puntos2
        WHERE   puntos2.tIni=MAXP.temporada 
                AND MAXP.maxpts=puntos2.pts 
                AND  puntos2.nEq = (SELECT H.equipo   
                                        FROM  (SELECT max(Z.golaAve) as AVG
                                                FROM (SELECT G.eq as equipo, (G.golesFavor-G.golesContra)  as golaAve
                                                        FROM  (SELECT Equi.nombreCorto as eq, 
                                                                        ((SELECT sum(Par.golesLocales)
                                                                        FROM partidos Par, JORNADAS Jor
                                                                        WHERE Par.equipoLocal=Equi.nombreCorto
                                                                                AND Jor.tempCod=T.tempCod
                                                                                AND Jor.idJor = Par.idJor
                                                                                AND Par.idJor<=(SELECT max(idJor)
                                                                                                FROM JORNADAS J
                                                                                                WHERE J.tempCod=T.tempCod)
                                                                        )+(SELECT sum(Par.golesVisitantes)
                                                                           FROM partidos Par, JORNADAS Jor 
                                                                           WHERE Par.equipoVisitante=Equi.nombreCorto
                                                                                AND Jor.tempCod=T.tempCod 
                                                                                AND Jor.idJor = Par.idJor
                                                                                AND Par.idJor<=(SELECT max(idJor)
                                                                                                FROM JORNADAS J
                                                                                                WHERE J.tempCod=T.tempCod))) as golesFavor,
                                                                        ((SELECT sum(Par.golesVisitantes)
                                                                        FROM partidos Par, JORNADAS Jor
                                                                        WHERE Par.equipoLocal=Equi.nombreCorto
                                                                                AND Jor.tempCod=T.tempCod 
                                                                                AND Jor.idJor = Par.idJor
                                                                                AND Par.idJor<=(SELECT max(idJor)
                                                                                                FROM JORNADAS J
                                                                                                WHERE J.tempCod=T.tempCod))
                                                                        +(SELECT sum(Par.golesLocales)
                                                                        FROM partidos Par, JORNADAS Jor
                                                                        WHERE Par.equipoVisitante=Equi.nombreCorto
                                                                                AND Jor.tempCod=T.tempCod 
                                                                                AND Jor.idJor = Par.idJor
                                                                                AND Par.idJor<=(SELECT max(idJor)
                                                                                                FROM JORNADAS J
                                                                                                WHERE J.tempCod=T.tempCod))) as golesContra
                                                FROM equipos Equi) G) Z) MAX,
                                                (SELECT G.eq as equipo, (G.golesFavor-G.golesContra)  as golaAve
                                                FROM  (SELECT Equi.nombreCorto as eq, 
                                                                ((SELECT sum(Par.golesLocales)
                                                                FROM partidos Par, JORNADAS Jor
                                                                WHERE Par.equipoLocal=Equi.nombreCorto
                                                                        AND Jor.tempCod=T.tempCod 
                                                                        AND Jor.idJor = Par.idJor
                                                                        AND Par.idJor<=(SELECT max(idJor)
                                                                                        FROM JORNADAS J
                                                                                        WHERE J.tempCod=T.tempCod)
                                                                )+(SELECT sum(Par.golesVisitantes)
                                                                        FROM partidos Par, JORNADAS Jor 
                                                                        WHERE Par.equipoVisitante=Equi.nombreCorto
                                                                                AND Jor.tempCod=T.tempCod 
                                                                                AND Jor.idJor = Par.idJor
                                                                                AND Par.idJor<=(SELECT max(idJor)
                                                                                                FROM JORNADAS J
                                                                                                WHERE J.tempCod=T.tempCod))) as golesFavor,
                                                                ((SELECT sum(Par.golesVisitantes)
                                                                FROM partidos Par, JORNADAS Jor
                                                                WHERE Par.equipoLocal=Equi.nombreCorto
                                                                        AND Jor.tempCod=T.tempCod 
                                                                        AND Jor.idJor = Par.idJor
                                                                        AND Par.idJor<=(SELECT max(idJor)
                                                                                        FROM JORNADAS J
                                                                                        WHERE J.tempCod=T.tempCod))
                                                                +(SELECT sum(Par.golesLocales)
                                                                FROM partidos Par, JORNADAS Jor
                                                                WHERE Par.equipoVisitante=Equi.nombreCorto
                                                                        AND Jor.tempCod=T.tempCod AND Jor.idJor = Par.idJor
                                                                        AND Par.idJor<=(SELECT max(idJor)
                                                                                        FROM JORNADAS J
                                                                                        WHERE J.tempCod=T.tempCod))) as golesContra
                                                        FROM equipos Equi) G) H                           
WHERE H.golaAve = MAX.AVG AND MAXP.temporada = T.tempCod 
GROUP BY H.equipo))
        GROUP BY equipo
        HAVING count(equipo)>1
        ORDER BY count(equipo) DESC)
WHERE ROWNUM=1;





        

/*Listar estadios en los que el local ha ganado o empatado más del 85% de las veces.*/

SELECT E.nombre
FROM ESTADIOS E
WHERE (SELECT count(*)
        FROM PARTIDOS P
        WHERE P.estadio=E.nombre)*85/100<(SELECT count(*)
                                            FROM PARTIDOS P1
                                            WHERE P1.estadio=E.nombre AND golesLocales>=golesVisitantes);




/*Número de goles marcados por el Real Zaragoza en cada temporada de liga en la que haya ganado al
menos a 4 equipos en ambos partidos de la temporada (ida y vuelta).*/

SELECT temp,golesLocal+golesVisitante as golesMarcados
FROM (SELECT  T.inicio as temp,sum(par.golesLocales)  as golesLocal
        FROM PARTIDOS par, JORNADAS jor, TEMPORADAS T
        WHERE  par.equipoLocal='Zaragoza' 
        AND par.idJor= jor.idJor
        AND jor.tempCod=T.tempcod AND 4<= (SELECT count(*)
                                           FROM PARTIDOS P, JORNADAS J
                                           WHERE P.equipoLocal='Zaragoza' 
                                                AND golesLocales>golesVisitantes 
                                                AND P.idJor=J.idJor 
                                                AND T.tempCod = J.tempCod
                                                AND EXISTS( SELECT P1.idPar
                                                            FROM PARTIDOS P1, JORNADAS J1
                                                            WHERE P.equipoVisitante=P1.equipoLocal 
                                                                AND P.equipoLocal=P1.equipoVisitante 
                                                                AND golesVisitantes>golesLocales 
                                                                AND P1.idJor=J1.idJor 
                                                                AND J1.tempCod=J.tempCod))
                                           GROUP BY T.inicio) Y, 
                                           (SELECT  T.inicio as tz ,sum(par.golesVisitantes) as golesVisitante
                                            FROM PARTIDOS par, JORNADAS jor, TEMPORADAS T
                                            WHERE  par.equipoVisitante='Zaragoza' 
                                                        AND par.idJor= jor.idJor 
                                                        AND jor.tempCod=T.tempcod 
                                                        AND 4<= (SELECT count(*)
                                                                FROM PARTIDOS P, JORNADAS J
                                                                WHERE P.equipoLocal='Zaragoza' 
                                                                        AND golesLocales>golesVisitantes 
                                                                        AND P.idJor=J.idJor 
                                                                        AND T.tempCod = J.tempCod
                                                                        AND EXISTS( SELECT P1.idPar
                                                                                    FROM PARTIDOS P1, JORNADAS J1
                                                                                    WHERE P.equipoVisitante=P1.equipoLocal 
                                                                                        AND P.equipoLocal=P1.equipoVisitante 
                                                                                        AND golesVisitantes>golesLocales 
                                                                                        AND P1.idJor=J1.idJor 
                                                                                        AND J1.tempCod=J.tempCod))
                                           GROUP BY T.inicio) Z
WHERE temp=tz
ORDER BY temp;










--GANADOR MAS A PARTI DE RESULTADOS
SELECT equipo
FROM (SELECT equipo, COUNT(equipo)
        FROM  (SELECT Equipo
                FROM RESULTADOS R, TEMPORADAS T
                WHERE R.tempCod = T.tempCod 
                and puesto = '1' 
                and division = '1'
                and idJor = (SELECT max(idJor)
                             FROM JORNADAS J
                             WHERE J.tempCod=T.tempCod))
        GROUP BY equipo
        having count(equipo)>1
        order by count(equipo) DESC)
where ROWNUM=1;



/*Número de goles marcados por el Real Zaragoza en cada temporada de liga en la que haya ganado al
menos a 4 equipos en ambos partidos de la temporada (ida y vuelta). USANDO RESULTADOS*/

SELECT T.inicio as temp, R.golesFavor as golesMarcados
FROM RESULTADOS R, TEMPORADAS T       
WHERE R.tempCod = T.tempcod 
        and R.equipo = 'Zaragoza'
    and  R.idJor = (SELECT max(idJor)
                        FROM JORNADAS J
                        WHERE J.tempCod=R.tempCod)
        and 4<= (SELECT count(*)
                FROM PARTIDOS P1, PARTIDOS P2, JORNADAS J1, JORNADAS J2
                WHERE P1.equipoLocal='Zaragoza' 
                    AND P1.golesLocales>P1.golesVisitantes 
                    AND P1.idJor=J1.idJor 
                    AND T.tempCod = J1.tempCod
                    AND P2.equipoVisitante='Zaragoza' 
                    AND P2.golesLocales<P2.golesVisitantes 
                    AND P2.idJor=J2.idJor 
                    AND T.tempCod = J2.tempCod
                    and J1.tempcod = J2.tempCod
                    and P2.equipoLocal = P1.equipoVisitante);