
/*Equipo que más ligas de primera división ha ganado.*/

/*                                                                                       
  ############################################################################################
  Resultados: puntos 
  ##########################################################################################*/
  select pts 
  from (select 
        E.nombreCorto as equipo,
        J.idJor as jor,
        T.tempCod as temp,
    ( 
        3*(Select count(*)
        from PARTIDOS P
        where 
           (((P.equipoLocal='At. Madrid') and (P.golesLocales>P.golesVisitantes))
           or ((P.equipoVisitante='At. Madrid') and (P.golesVisitantes>P.golesLocales)) )
            and (P.idJor=J.idJor)
            and (J.tempCod=T.tempCod)
    )+(Select count(*)
        from PARTIDOS P 
        where 
            ((P.equipoLocal='At. Madrid')or(P.equipoVisitante='At. Madrid'))
            and (P.golesLocales=P.golesVisitantes)
            and (P.idJor=J.idJor)
            and (J.tempCod=T.tempCod))) pts
  from EQUIPOS E, TEMPORADAS T, JORNADAS J 
  --where E.nombreCorto='At. Madrid' and T.inicio='2008'
) PUN, TEMPORADAS T1
where PUN.equipo='At. Madrid' and T1.tempCod=PUN.temp and T1.inicio='2008'
;
    



    Select pts
    from( 
        (Select T.inicio, 3*count(*)
        from PARTIDOS P, JORNADAS J, TEMPORADAS T
        where 
           (((P.equipoLocal='Barcelona') and (P.golesLocales>P.golesVisitantes))
           or ((P.equipoVisitante='Barcelona') and (P.golesVisitantes>P.golesLocales)) )
            and (P.idJor=J.idJor)
            and (J.tempCod=T.tempCod)
            group by T.inicio)
        +(Select T.inicio,count(*)
            from PARTIDOS P, JORNADAS J, TEMPORADAS T
            where 
            ((P.equipoLocal='Barcelona')or(P.equipoVisitante='Barcelona'))
            and (P.golesLocales=P.golesVisitantes)
            and (P.idJor=J.idJor)
            and (J.tempCod=T.tempCod)
            group by T.inicio)) pts
;







    Select T
    from( 
        (Select T.inicio as ini, 3*count(*) as g
        from PARTIDOS P, JORNADAS J, TEMPORADAS T
        where 
           (((P.equipoLocal='Barcelona') and (P.golesLocales>P.golesVisitantes))
           or ((P.equipoVisitante='Barcelona') and (P.golesVisitantes>P.golesLocales)) )
            and (P.idJor=J.idJor)
            and (J.tempCod=T.tempCod)
            group by T.inicio)
        +(Select T.inicio,count(*) as e
            from PARTIDOS P, JORNADAS J, TEMPORADAS T
            where 
            ((P.equipoLocal='Barcelona')or(P.equipoVisitante='Barcelona'))
            and (P.golesLocales=P.golesVisitantes)
            and (P.idJor=J.idJor)
            and (J.tempCod=T.tempCod)
            group by T.inicio)) pts
;













--TABLA DE PUNTOS

Select EMP.i,EMP.e+GAN.g
from (Select T.inicio as i,count(*) as e
            from PARTIDOS P, JORNADAS J, TEMPORADAS T
            where 
            ((P.equipoLocal='Barcelona')or(P.equipoVisitante='Barcelona'))
            and (P.golesLocales=P.golesVisitantes)
            and (P.idJor=J.idJor)
            and (J.tempCod=T.tempCod)
            group by T.inicio) EMP, 
            (Select T.inicio as ini, 3*count(*) as g
            from PARTIDOS P, JORNADAS J, TEMPORADAS T
            where 
            (((P.equipoLocal='Barcelona') and (P.golesLocales>P.golesVisitantes))
            or ((P.equipoVisitante='Barcelona') and (P.golesVisitantes>P.golesLocales)) )
            and (P.idJor=J.idJor)
            and (J.tempCod=T.tempCod)
            group by T.inicio) GAN
where EMP.i=GAN.ini
;


Select temp.inicio, max(puntos.pts)
from (Select EMP.i as tIni, EMP.eq as nEq, EMP.e+GAN.g as pts
            from (Select T.inicio as i,E.nombreCorto as eq, count(*) as e
            from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
            where 
            ((P.equipoLocal=E.nombreCorto)or(P.equipoVisitante=E.nombreCorto))
            and (P.golesLocales=P.golesVisitantes)
            and (P.idJor=J.idJor)
            and (J.tempCod=T.tempCod)
            and (T.division='1')
            group by T.inicio,E.nombreCorto) EMP, 
            (Select T.inicio as ini, E.nombreCorto as equipo ,3*count(*) as g
            from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
            where 
            (((P.equipoLocal=E.nombreCorto) and (P.golesLocales>P.golesVisitantes))
            or ((P.equipoVisitante=E.nombreCorto) and (P.golesVisitantes>P.golesLocales)) )
            and (P.idJor=J.idJor)
            and (J.tempCod=T.tempCod)
            and (T.division='1')
            group by T.inicio,E.nombreCorto) GAN
            where EMP.i=GAN.ini and EMP.eq=GAN.equipo and EMP.i>2010) puntos, TEMPORADAS temp
where puntos.tIni=temp.inicio
GROUP by temp.inicio
;




Select EMP.i as tIni, EMP.eq as nEq, EMP.e+GAN.g as pts
                from (Select T.inicio as i,E.nombreCorto as eq, count(*) as e
                from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                where 
                ((P.equipoLocal=E.nombreCorto)or(P.equipoVisitante=E.nombreCorto))
                and (P.golesLocales=P.golesVisitantes)
                and (P.idJor=J.idJor)
                and (J.tempCod=T.tempCod)
                and (T.division='1')
                group by T.inicio,E.nombreCorto) EMP, 
                (Select T.inicio as ini, E.nombreCorto as equipo ,3*count(*) as g
                from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                where 
                (((P.equipoLocal=E.nombreCorto) and (P.golesLocales>P.golesVisitantes))
                or ((P.equipoVisitante=E.nombreCorto) and (P.golesVisitantes>P.golesLocales)) )
                and (P.idJor=J.idJor)
                and (J.tempCod=T.tempCod)
                and (T.division='1')
                group by T.inicio,E.nombreCorto) GAN
                where EMP.i=GAN.ini and EMP.eq=GAN.equipo and EMP.i='2008' and (EMP.e+GAN.g)=('87')
                ;





Select EMP.i as tIni, EMP.eq as nEq, EMP.e+GAN.g as pts
                from (Select T.inicio as i,E.nombreCorto as eq, count(*) as e
                from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                where 
                ((P.equipoLocal=E.nombreCorto)or(P.equipoVisitante=E.nombreCorto))
                and (P.golesLocales=P.golesVisitantes)
                and (P.idJor=J.idJor)
                and (J.tempCod=T.tempCod)
                and (T.division='1')
                group by T.inicio,E.nombreCorto) EMP, 
                (Select T.inicio as ini, E.nombreCorto as equipo ,3*count(*) as g
                from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                where 
                (((P.equipoLocal=E.nombreCorto) and (P.golesLocales>P.golesVisitantes))
                or ((P.equipoVisitante=E.nombreCorto) and (P.golesVisitantes>P.golesLocales)) )
                and (P.idJor=J.idJor)
                and (J.tempCod=T.tempCod)
                and (T.division='1')
                group by T.inicio,E.nombreCorto) GAN, TEMPORADAS tempor
                where EMP.i=GAN.ini and EMP.eq=GAN.equipo and tempor.inicio=EMP.i and (tempor.inicio,EMP.e+GAN.g) IN
                (Select temp.inicio as temporada, max(puntos.pts) as maxpts
                from (Select EMP.i as tIni, EMP.eq as nEq, EMP.e+GAN.g as pts
                from (Select T.inicio as i,E.nombreCorto as eq, count(*) as e
                from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                where 
                ((P.equipoLocal=E.nombreCorto)or(P.equipoVisitante=E.nombreCorto))
                and (P.golesLocales=P.golesVisitantes)
                and (P.idJor=J.idJor)
                and (J.tempCod=T.tempCod)
                and (T.division='1')
                group by T.inicio,E.nombreCorto) EMP, 
                (Select T.inicio as ini, E.nombreCorto as equipo ,3*count(*) as g
                from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                where 
                (((P.equipoLocal=E.nombreCorto) and (P.golesLocales>P.golesVisitantes))
                or ((P.equipoVisitante=E.nombreCorto) and (P.golesVisitantes>P.golesLocales)) )
                and (P.idJor=J.idJor)
                and (J.tempCod=T.tempCod)
                and (T.division='1')
                group by T.inicio,E.nombreCorto) GAN
                where EMP.i=GAN.ini and EMP.eq=GAN.equipo and (EMP.i=2003 or EMP.i=2004)) puntos, TEMPORADAS temp , EQUIPOS equipos
                where puntos.tIni=temp.inicio
        --where puntos.tIni=temp.inicio and equipos.nombreCorto=puntos.nEq and puntos2.pts=max(puntos.pts)
                GROUP by temp.inicio )
;





Select
from 
where (Select temp.inicio as temporada, max(puntos.pts) as maxpts
        from (Select EMP.i as tIni, EMP.eq as nEq, EMP.e+GAN.g as pts
                from (Select T.inicio as i,E.nombreCorto as eq, count(*) as e
                from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                where 
                ((P.equipoLocal=E.nombreCorto)or(P.equipoVisitante=E.nombreCorto))
                and (P.golesLocales=P.golesVisitantes)
                and (P.idJor=J.idJor)
                and (J.tempCod=T.tempCod)
                and (T.division='1')
                group by T.inicio,E.nombreCorto) EMP, 
                (Select T.inicio as ini, E.nombreCorto as equipo ,3*count(*) as g
                from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                where 
                (((P.equipoLocal=E.nombreCorto) and (P.golesLocales>P.golesVisitantes))
                or ((P.equipoVisitante=E.nombreCorto) and (P.golesVisitantes>P.golesLocales)) )
                and (P.idJor=J.idJor)
                and (J.tempCod=T.tempCod)
                and (T.division='1')
                group by T.inicio,E.nombreCorto) GAN
                where EMP.i=GAN.ini and EMP.eq=GAN.equipo and EMP.i=2008) puntos, TEMPORADAS temp , EQUIPOS equipos
                where puntos.tIni=temp.inicio
    --where puntos.tIni=temp.inicio and equipos.nombreCorto=puntos.nEq and puntos2.pts=max(puntos.pts)
                GROUP by temp.inicio )  MAXP,


-- select E.nombreCorto
-- from EQUIPOS E, TEMPORADAS T5,
--     (Select temp.inicio as temporada, max(puntos.pts) as maxpts, puntos.pts as puntosEq, puntos.nEq as nEquipo
--     from (Select EMP.i as tIni, EMP.eq as nEq, EMP.e+GAN.g as pts
--                 from (Select T.inicio as i,E.nombreCorto as eq, count(*) as e
--                 from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
--                 where 
--                 ((P.equipoLocal=E.nombreCorto)or(P.equipoVisitante=E.nombreCorto))
--                 and (P.golesLocales=P.golesVisitantes)
--                 and (P.idJor=J.idJor)
--                 and (J.tempCod=T.tempCod)
--                 and (T.division='1')
--                 group by T.inicio,E.nombreCorto) EMP, 
--                 (Select T.inicio as ini, E.nombreCorto as equipo ,3*count(*) as g
--                 from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
--                 where 
--                 (((P.equipoLocal=E.nombreCorto) and (P.golesLocales>P.golesVisitantes))
--                 or ((P.equipoVisitante=E.nombreCorto) and (P.golesVisitantes>P.golesLocales)) )
--                 and (P.idJor=J.idJor)
--                 and (J.tempCod=T.tempCod)
--                 and (T.division='1')
--                 group by T.inicio,E.nombreCorto) GAN
--                 where EMP.i=GAN.ini and EMP.eq=GAN.equipo and EMP.i>2010) puntos, TEMPORADAS temp
--     where puntos.tIni=temp.inicio) MAXP
-- where MAXP.temporada=T5.inicio and E.nombreCorto=MAXP.nEquipo and MAXP.puntosEq=MAXP.maxpts
--     ;





---SIN DESEMPATE
Select MAXP.temporada, puntos2.nEq
from
    (Select temp.inicio as temporada, max(puntos.pts) as maxpts
    from (Select EMP.i as tIni, EMP.eq as nEq, EMP.e+GAN.g as pts
                from (Select T.inicio as i,E.nombreCorto as eq, count(*) as e
                from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                where 
                ((P.equipoLocal=E.nombreCorto)or(P.equipoVisitante=E.nombreCorto))
                and (P.golesLocales=P.golesVisitantes)
                and (P.idJor=J.idJor)
                and (J.tempCod=T.tempCod)
                and (T.division='1')
                group by T.inicio,E.nombreCorto) EMP, 
                (Select T.inicio as ini, E.nombreCorto as equipo ,3*count(*) as g
                from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                where 
                (((P.equipoLocal=E.nombreCorto) and (P.golesLocales>P.golesVisitantes))
                or ((P.equipoVisitante=E.nombreCorto) and (P.golesVisitantes>P.golesLocales)) )
                and (P.idJor=J.idJor)
                and (J.tempCod=T.tempCod)
                and (T.division='1')
                group by T.inicio,E.nombreCorto) GAN
                where EMP.i=GAN.ini and EMP.eq=GAN.equipo and(EMP.i>'2000')) puntos, TEMPORADAS temp , EQUIPOS equipos
                where puntos.tIni=temp.inicio
    --where puntos.tIni=temp.inicio and equipos.nombreCorto=puntos.nEq and puntos2.pts=max(puntos.pts)
                GROUP by temp.inicio )  MAXP, 
                (Select EMP.i as tIni, EMP.eq as nEq, EMP.e+GAN.g as pts
                from (Select T.inicio as i,E.nombreCorto as eq, count(*) as e
                from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                where 
                ((P.equipoLocal=E.nombreCorto)or(P.equipoVisitante=E.nombreCorto))
                and (P.golesLocales=P.golesVisitantes)
                and (P.idJor=J.idJor)
                and (J.tempCod=T.tempCod)
                and (T.division='1')
                group by T.inicio,E.nombreCorto) EMP, 
                (Select T.inicio as ini, E.nombreCorto as equipo ,3*count(*) as g
                from PARTIDOS P, JORNADAS J, TEMPORADAS T, EQUIPOS E
                where 
                (((P.equipoLocal=E.nombreCorto) and (P.golesLocales>P.golesVisitantes))
                or ((P.equipoVisitante=E.nombreCorto) and (P.golesVisitantes>P.golesLocales)) )
                and (P.idJor=J.idJor)
                and (J.tempCod=T.tempCod)
                and (T.division='1')
                group by T.inicio,E.nombreCorto) GAN
                where EMP.i=GAN.ini and EMP.eq=GAN.equipo and EMP.i>'2000') puntos2
        where puntos2.tIni=MAXP.temporada and MAXP.maxpts=puntos2.pts
;













--GANADOR DE LIGA POR TEMPORADA
Select MAXP.temporada, puntos2.nEq
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
                where EMP.i=GAN.ini and EMP.eq=GAN.equipo and(EMP.i>='2010')) puntos, TEMPORADAS temp , EQUIPOS equipos
                where puntos.tIni=temp.tempCod
    --where puntos.tIni=temp.inicio and equipos.nombreCorto=puntos.nEq and puntos2.pts=max(puntos.pts)
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
                where EMP.i=GAN.ini and EMP.eq=GAN.equipo and EMP.i>='2010') puntos2
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
WHERE H.golaAve = MAX.AVG and  T.tempCod = '110' --MAXP.temporada = T.tempCod
GROUP BY H.equipo);




Select MAXP.temporada, puntos2.nEq
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
                where EMP.i=GAN.ini and EMP.eq=GAN.equipo and(EMP.i>='2010')) puntos, TEMPORADAS temp , EQUIPOS equipos
                where puntos.tIni=temp.tempCod
    --where puntos.tIni=temp.inicio and equipos.nombreCorto=puntos.nEq and puntos2.pts=max(puntos.pts)
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
                where EMP.i=GAN.ini and EMP.eq=GAN.equipo and EMP.i>='2010') puntos2
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
WHERE H.golaAve = MAX.AVG and  T.tempCod = '110' --MAXP.temporada = T.tempCod
GROUP BY H.equipo);





--GANADOR DEL MAYOR NUM LIGAS POR TEMPORADA
Select puntos2.nEq as elEquipo, count(puntos2.nEq) as veces
from(
    Select MAXP.temporada, puntos2.nEq
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
                    where EMP.i=GAN.ini and EMP.eq=GAN.equipo and(EMP.i>='2010')) puntos, TEMPORADAS temp , EQUIPOS equipos
                    where puntos.tIni=temp.tempCod
        --where puntos.tIni=temp.inicio and equipos.nombreCorto=puntos.nEq and puntos2.pts=max(puntos.pts)
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
                    where EMP.i=GAN.ini and EMP.eq=GAN.equipo and EMP.i>='2010') puntos2
            where puntos2.tIni=MAXP.temporada and MAXP.maxpts=puntos2.pts   (SELECT max(Z.golaAve), Z.equipo as AVG
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
                            from equipos Equi) G) Z     ) MAX,
                                      
    

;

CREATE TABLE PRUEBA (
    num NUMBER(2) ,
    equipo VARCHAR(100), 
    tempCod NUMBER (5) PRIMARY KEY
);

INSERT into PRUEBA (equipo,num, tempCod)
VALUES ('BARCELONA',1,110);
INSERT into PRUEBA (equipo,num, tempCod)
VALUES ('BARCELONA',2,120);
INSERT into PRUEBA (equipo,num, tempCod)
VALUES ('MADRID',1,820);
INSERT into PRUEBA (equipo,num, tempCod)
VALUES ('MADRID',1,720);
INSERT into PRUEBA (equipo,num, tempCod)
VALUES ('MADRID',1,1620);

SELECT *
FROM (SELECT equipo, COUNT(equipo)
        FROM PRUEBA
        GROUP BY equipo
        having count(equipo)>1
        order by count(equipo) DESC)
where ROWNUM=1;



SELECT nombrecampo, COUNT(nombrecampo) maximo
FROM nombretabla
GROUP BY nombrecampo
HAVING COUNT(nombrecampo) = maximo;


SELECT A.ave,A.EE
FROM TEMPORADAS T 
where (SELECT max(Z.golaAve) as av, Z.equipo as E
                FROM (SELECT G.eq as equipo, (G.golesFavor-G.golesContra)  as golaAve
                        FROM  (select Equi.nombreCorto as eq, 
                                        ((Select sum(Par.golesLocales)
                                        from partidos Par, JORNADAS Jor
                                        where Par.equipoLocal=Equi.nombreCorto
                                            and Jor.tempCod='3510' and Jor.idJor = Par.idJor
                                            and Par.idJor<=(Select max(idJor)
                                                                from JORNADAS J
                                                                where J.tempCod='3510')
                                        )+(Select sum(Par.golesVisitantes)
                                            from partidos Par, JORNADAS Jor 
                                            where Par.equipoVisitante=Equi.nombreCorto
                                                                and Jor.tempCod='3510' and Jor.idJor = Par.idJor
                                                                and Par.idJor<=(Select max(idJor)
                                                                                    from JORNADAS J
                                                                                    where J.tempCod='3510'))) as golesFavor,
                                        ((Select sum(Par.golesVisitantes)
                                        from partidos Par, JORNADAS Jor
                                        where Par.equipoLocal=Equi.nombreCorto
                                                and Jor.tempCod='3510' and Jor.idJor = Par.idJor
                                                and Par.idJor<=(Select max(idJor)
                                                                from JORNADAS J
                                                                where J.tempCod='3510'))
                                                +(Select sum(Par.golesLocales)
                                                from partidos Par, JORNADAS Jor
                                                where Par.equipoVisitante=Equi.nombreCorto
                                                        and Jor.tempCod='3510' and Jor.idJor = Par.idJor
                                                        and Par.idJor<=(Select max(idJor)
                                                                        from JORNADAS J
                                                                        where J.tempCod='3510'))) as golesContra
                                from equipos Equi) G) Z     )
                                ;




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

                    

SELECT T.inicio as temp, R.golesFavor as golesMarcados, r.idJor as jor
FROM RESULTADOS R, TEMPORADAS T       
WHERE   R.tempCod = T.tempcod 
        and  R.idJor = (SELECT max(idJor)
                        FROM JORNADAS J
                        WHERE J.tempCod=R.tempCod)
        and 4<= (SELECT count(*)
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
                                    AND J1.tempCod=J.tempCod));
                          








--------------------
SELECT X.AVG
FROM (SELECT Z.golaAve, Z.equipo as AVG
                    FROM (SELECT G.eq as equipo, (G.golesFavor-G.golesContra)  as golaAve
                    FROM  (select Equi.nombreCorto as eq, 
                                    ((Select sum(Par.golesLocales)
                                    from partidos Par, JORNADAS Jor
                                    where Par.equipoLocal=Equi.nombreCorto
                                        and Jor.tempCod='3510' and Jor.idJor = Par.idJor
                                        and Par.idJor<=(Select max(idJor)
                                                            from JORNADAS J
                                                            )
                                    )+(Select sum(Par.golesVisitantes)
                                        from partidos Par, JORNADAS Jor 
                                        where Par.equipoVisitante=Equi.nombreCorto
                                                            and Jor.tempCod='3510' and Jor.idJor = Par.idJor
                                                            and Par.idJor<=(Select max(idJor)
                                                                                from JORNADAS J
                                                                                ))) as golesFavor,
                                    ((Select sum(Par.golesVisitantes)
                                    from partidos Par, JORNADAS Jor
                                    where Par.equipoLocal=Equi.nombreCorto
                                            and Jor.tempCod='3510' and Jor.idJor = Par.idJor
                                            and Par.idJor<=(Select max(idJor)
                                                            from JORNADAS J
                                                            where J.tempCod='3510'))
                                            +(Select sum(Par.golesLocales)
                                            from partidos Par, JORNADAS Jor
                                            where Par.equipoVisitante=Equi.nombreCorto
                                                     and Jor.idJor = Par.idJor
                                                    and Par.idJor<=(Select max(idJor)
                                                                    from JORNADAS J
                                                                    ))) as golesContra
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
                where EMP.i=GAN.ini and EMP.eq=GAN.equipo 
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
                where EMP.i=GAN.ini and EMP.eq=GAN.equipo ) PUNTOS2
            WHERE PUNTOSMAX.pts = PUNTOS2.pts) Equi) G
                            where G.golesContra>'0' and G.golesFavor>'0') Z) X
WHERE ROWNUM=1;