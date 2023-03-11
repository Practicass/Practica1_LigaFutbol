/*Listar estadios en los que el local ha ganado o empatado más del 85% de las veces.*/

Select E.nombre
from ESTADIOS E
where (Select count(*)
        from PARTIDOS P
        where P.estadio=E.nombre)*85/100<(Select count(*)
                                            from PARTIDOS P1
                                            where P1.estadio=E.nombre and golesLocales>=golesVisitantes)




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
where ty=tz
;
