/* Máximo ganador de ligas en primera division*/

SELECT equipo
FROM (SELECT equipo, COUNT(equipo)
        FROM (SELECT E.nombreCorto as equipo,Tx.inicio
from Temporadas Tx, EQUIPOS E
    WHERE E.nombreCorto=(SELECT X.AVG
        FROM (SELECT Z.golaAve, Z.equipo as AVG
                    FROM (SELECT G.eq as equipo, (G.golesFavor-G.golesContra)  as golaAve
                    FROM  (select Equi.nombreCorto as eq, 
                                    ((Select sum(Par.golesLocales)
                                    from partidos Par, JORNADAS Jor
                                    where Par.equipoLocal=Equi.nombreCorto
                                        and Jor.tempCod=tx.tempCod and Jor.idJor = Par.idJor
                                        and Par.idJor<=(Select max(idJor)
                                                            from JORNADAS J
                                                            where J.tempCod=tx.tempCod)
                                    )+(Select sum(Par.golesVisitantes)
                                        from partidos Par, JORNADAS Jor 
                                        where Par.equipoVisitante=Equi.nombreCorto
                                                            and Jor.tempCod=tx.tempCod and Jor.idJor = Par.idJor
                                                            and Par.idJor<=(Select max(idJor)
                                                                                from JORNADAS J
                                                                                where J.tempCod=tx.tempCod))) as golesFavor,
                                    ((Select sum(Par.golesVisitantes)
                                    from partidos Par, JORNADAS Jor
                                    where Par.equipoLocal=Equi.nombreCorto
                                            and Jor.tempCod=tx.tempCod and Jor.idJor = Par.idJor
                                            and Par.idJor<=(Select max(idJor)
                                                            from JORNADAS J
                                                            where J.tempCod=tx.tempCod))
                                            +(Select sum(Par.golesLocales)
                                            from partidos Par, JORNADAS Jor
                                            where Par.equipoVisitante=Equi.nombreCorto
                                                    and Jor.tempCod=tx.tempCod and Jor.idJor = Par.idJor
                                                    and Par.idJor<=(Select max(idJor)
                                                                    from JORNADAS J
                                                                    where J.tempCod=tx.tempCod))) as golesContra
                            from (Select PUNTOS2.nEq as nombreCorto
    from       (Select pts
            from (Select unique EMP.i as tIni, EMP.eq as nEq, EMP.e+GAN.g as pts
                    from (Select T.tempCod as i,E.nombreCorto as eq, count(*) as e
                    from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                    where 
                    ((P.equipoLocal=E.nombreCorto)or(P.equipoVisitante=E.nombreCorto))
                    and (P.golesLocales=P.golesVisitantes)
                    and (P.idJor=J.idJor)
                    and (J.tempCod=T.tempCod)
                    and (T.division='1')
                    group by T.tempCod,E.nombreCorto) EMP, 
                    (Select T.tempCod as ini, E.nombreCorto as equipo ,3*count(*) as g
                    from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                    where 
                    (((P.equipoLocal=E.nombreCorto) and (P.golesLocales>P.golesVisitantes))
                    or ((P.equipoVisitante=E.nombreCorto) and (P.golesVisitantes>P.golesLocales)) )
                    and (P.idJor=J.idJor)
                    and (J.tempCod=T.tempCod)
                    and (T.division='1')
                    group by T.tempCod,E.nombreCorto) GAN
                where EMP.i=GAN.ini and EMP.eq=GAN.equipo and EMP.i=tx.tempCod
                order by pts DESC)
                where ROWNUM=1) PUNTOSMAX,
                (Select unique EMP.i as tIni, EMP.eq as nEq, EMP.e+GAN.g as pts
                    from (Select T.tempCod as i,E.nombreCorto as eq, count(*) as e
                    from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                    where 
                    ((P.equipoLocal=E.nombreCorto)or(P.equipoVisitante=E.nombreCorto))
                    and (P.golesLocales=P.golesVisitantes)
                    and (P.idJor=J.idJor)
                    and (J.tempCod=T.tempCod)
                    and (T.division='1')
                    group by T.tempCod,E.nombreCorto) EMP, 
                    (Select T.tempCod as ini, E.nombreCorto as equipo ,3*count(*) as g
                    from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                    where 
                    (((P.equipoLocal=E.nombreCorto) and (P.golesLocales>P.golesVisitantes))
                    or ((P.equipoVisitante=E.nombreCorto) and (P.golesVisitantes>P.golesLocales)) )
                    and (P.idJor=J.idJor)
                    and (J.tempCod=T.tempCod)
                    and (T.division='1')
                    group by T.tempCod,E.nombreCorto) GAN
                where EMP.i=GAN.ini and EMP.eq=GAN.equipo and EMP.i=tx.tempCod) PUNTOS2
            WHERE PUNTOSMAX.pts = PUNTOS2.pts) Equi) G
                            where G.golesContra>'0' and G.golesFavor>'0') Z) X
WHERE ROWNUM=1))
        GROUP BY equipo
        having count(equipo)>1
        order by count(equipo) DESC)
where ROWNUM=1;

        

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

                    