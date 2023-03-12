/* Máximo ganador de ligas en primera division*/

SELECT *
FROM (SELECT equipo, COUNT(equipo)
        FROM (Select MAXP.temporada, puntos2.nEq as equipo
from TEMPORADAS T,
    (Select temp.tempCod as temporada, max(puntos.pts) as maxpts
    from (Select EMP.i as tIni, EMP.eq as nEq, EMP.e+GAN.g as pts
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
                where EMP.i=GAN.ini and EMP.eq=GAN.equipo) puntos, TEMPORADAS temp , EQUIPOS equipos
                where puntos.tIni=temp.tempCod
                GROUP by temp.tempCod )  MAXP, 
                (Select EMP.i as tIni, EMP.eq as nEq, EMP.e+GAN.g as pts
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
                where EMP.i=GAN.ini and EMP.eq=GAN.equipo ) puntos2
        where puntos2.tIni=MAXP.temporada and MAXP.maxpts=puntos2.pts AND  puntos2.nEq = (SELECT H.equipo   
  FROM  (SELECT max(Z.golaAve) as AVG
        FROM (SELECT G.eq as equipo, (G.golesFavor-G.golesContra)  as golaAve
                FROM  (select Equi.nombreCorto as eq, 
                                ((Select sum(Par.golesLocales)
                                from partidos Par, JORNADAS Jor
                                where Par.equipoLocal=Equi.nombreCorto
                                       and Jor.tempCod=T.tempCod and Jor.idJor = Par.idJor
                                       and Par.idJor<=(Select max(idJor)
                                                        from JORNADAS J
                                                        where J.tempCod=T.tempCod)
                                )+(Select sum(Par.golesVisitantes)
                                    from partidos Par, JORNADAS Jor 
                                    where Par.equipoVisitante=Equi.nombreCorto
                                                        and Jor.tempCod=T.tempCod and Jor.idJor = Par.idJor
                                                        and Par.idJor<=(Select max(idJor)
                                                                            from JORNADAS J
                                                                            where J.tempCod=T.tempCod))) as golesFavor,
                                ((Select sum(Par.golesVisitantes)
                                  from partidos Par, JORNADAS Jor
                                  where Par.equipoLocal=Equi.nombreCorto
                                        and Jor.tempCod=T.tempCod and Jor.idJor = Par.idJor
                                        and Par.idJor<=(Select max(idJor)
                                                        from JORNADAS J
                                                        where J.tempCod=T.tempCod))
                                        +(Select sum(Par.golesLocales)
                                          from partidos Par, JORNADAS Jor
                                          where Par.equipoVisitante=Equi.nombreCorto
                                                and Jor.tempCod=T.tempCod and Jor.idJor = Par.idJor
                                                and Par.idJor<=(Select max(idJor)
                                                                from JORNADAS J
                                                                where J.tempCod=T.tempCod))) as golesContra
                        from equipos Equi) G) Z) MAX,
            (SELECT G.eq as equipo, (G.golesFavor-G.golesContra)  as golaAve
            FROM  (select Equi.nombreCorto as eq, 
                        ((Select sum(Par.golesLocales)
                          from partidos Par, JORNADAS Jor
                          where Par.equipoLocal=Equi.nombreCorto
                                and Jor.tempCod=T.tempCod and Jor.idJor = Par.idJor
                                and Par.idJor<=(Select max(idJor)
                                                from JORNADAS J
                                                where J.tempCod=T.tempCod)
                            )+(Select sum(Par.golesVisitantes)
                                from partidos Par, JORNADAS Jor 
                                where Par.equipoVisitante=Equi.nombreCorto
                                      and Jor.tempCod=T.tempCod and Jor.idJor = Par.idJor
                                      and Par.idJor<=(Select max(idJor)
                                                      from JORNADAS J
                                                      where J.tempCod=T.tempCod))) as golesFavor,
                            ((Select sum(Par.golesVisitantes)
                                from partidos Par, JORNADAS Jor
                                where Par.equipoLocal=Equi.nombreCorto
                                        and Jor.tempCod=T.tempCod and Jor.idJor = Par.idJor
                                        and Par.idJor<=(Select max(idJor)
                                                        from JORNADAS J
                                                        where J.tempCod=T.tempCod))
                                        +(Select sum(Par.golesLocales)
                                        from partidos Par, JORNADAS Jor
                                        where Par.equipoVisitante=Equi.nombreCorto
                                               and Jor.tempCod=T.tempCod and Jor.idJor = Par.idJor
                                               and Par.idJor<=(Select max(idJor)
                                                                from JORNADAS J
                                                                where J.tempCod=T.tempCod))) as golesContra
                    from equipos Equi) G) H                           
WHERE H.golaAve = MAX.AVG and MAXP.temporada = T.tempCod 
GROUP BY H.equipo))
        GROUP BY equipo
        having count(equipo)>1
        order by count(equipo) DESC)
where ROWNUM=1;





        

/*Listar estadios en los que el local ha ganado o empatado más del 85% de las veces.*/

Select E.nombre
from ESTADIOS E
where (Select count(*)
        from PARTIDOS P
        where P.estadio=E.nombre)*85/100<(Select count(*)
                                            from PARTIDOS P1
                                            where P1.estadio=E.nombre and golesLocales>=golesVisitantes);




/*Número de goles marcados por el Real Zaragoza en cada temporada de liga en la que haya ganado al
menos a 4 equipos en ambos partidos de la temporada (ida y vuelta).*/

Select ty,golesLocal+golesVisitante
from (Select  T.inicio as ty,sum(par.golesLocales)  as golesLocal
                        from PARTIDOS par, JORNADAS jor, TEMPORADAS T
                        where  par.equipoLocal='Zaragoza' and 
                        par.idJor= jor.idJor and 
                        jor.tempCod=T.tempcod and 4<= 
                                    (select count(*)
                                    from PARTIDOS P, JORNADAS J
                                    where P.equipoLocal='Zaragoza' 
                                    and golesLocales>golesVisitantes 
                                    and P.idJor=J.idJor 
                                    and T.tempCod = J.tempCod
                                    and EXISTS( SELECT P1.idPar
                                                from PARTIDOS P1, JORNADAS J1
                                                where P.equipoVisitante=P1.equipoLocal 
                                                and P.equipoLocal=P1.equipoVisitante 
                                                and golesVisitantes>golesLocales 
                                                and P1.idJor=J1.idJor 
                                                and J1.tempCod=J.tempCod))
GROUP BY T.inicio) Y, (Select  T.inicio as tz ,sum(par.golesVisitantes) as golesVisitante
                        from PARTIDOS par, JORNADAS jor, TEMPORADAS T
                        where  par.equipoVisitante='Zaragoza' and 
                        par.idJor= jor.idJor and 
                        jor.tempCod=T.tempcod and 4<= 
                                    (select count(*)
                                    from PARTIDOS P, JORNADAS J
                                    where P.equipoLocal='Zaragoza' 
                                    and golesLocales>golesVisitantes 
                                    and P.idJor=J.idJor 
                                    and T.tempCod = J.tempCod
                                    and EXISTS( SELECT P1.idPar
                                                from PARTIDOS P1, JORNADAS J1
                                                where P.equipoVisitante=P1.equipoLocal 
                                                and P.equipoLocal=P1.equipoVisitante 
                                                and golesVisitantes>golesLocales 
                                                and P1.idJor=J1.idJor 
                                                and J1.tempCod=J.tempCod))
GROUP BY T.inicio) Z
where ty=tz;
