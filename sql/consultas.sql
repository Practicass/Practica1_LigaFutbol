
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


Select puntos.tIni, puntos.nEq ,max(puntos.pts)
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
;








Select puntos.tIni, puntos.nEq , max(puntos.pts)
from (Select temp.ini as tIni, EMP.eq as nEq, max(EMP.e+GAN.g) as pts
            from (Select E.nombreCorto as eq, count(*) as e
            from PARTIDOS P, JORNADAS J, EQUIPOS E
            where 
            ((P.equipoLocal=E.nombreCorto)or(P.equipoVisitante=E.nombreCorto))
            and (P.golesLocales=P.golesVisitantes)
            and (P.idJor=J.idJor)
            --and (J.tempCod=temp.tempCod)
            group by E.nombreCorto) EMP, 
            (Select E.nombreCorto as equipo ,3*count(*) as g
            from PARTIDOS P, JORNADAS J , EQUIPOS E
            where 
            (((P.equipoLocal=E.nombreCorto) and (P.golesLocales>P.golesVisitantes))
            or ((P.equipoVisitante=E.nombreCorto) and (P.golesVisitantes>P.golesLocales)) )
            and (P.idJor=J.idJor)
            --and (J.tempCod=temp.tempCod)
            group by E.nombreCorto) GAN, Temporadas temp
            where EMP.i=GAN.ini and EMP.eq=GAN.equipo and temp.ini>'2010' and temp.division='1') puntos, TEMPORADAS temp
where temp.division='1'
;




/*                                                                                       
  ############################################################################################
  Resultados:  puesto
  ##########################################################################################*/

UPDATE Resultados R
SET puesto = (SELECT RowN 
FROM (
  SELECT 
        ROW_NUMBER() OVER(
            partition by njornada, ntemporada
            ORDER BY puntos DESC, golesfav-golescon DESC
        ) AS RowN,
        equipo,
        njornada, 
        ntemporada 
        FROM Resultados
        order by  ntemporada, njornada,RowN  
) P
where R.equipo=P.equipo and R.njornada=P.njornada and R.ntemporada=P.ntemporada);



/*
UPDATE RESULTADOS R set golesFavor = (
    Select golesFavor 
    from (Select sum(golesLocales)
         from PARTIDOS P, EQUIPOL E
         where (P.equipo=E.nombreCorto) and
             (P.idJor<=R.idJor) and
             (P.tempCod=R.tempCod)
         )UNION(
         Select sum(golesVisitantes)
         from PARTIDOS P, EQUIPOV E
         where (P.equipo=E.nombreCorto) and
             (P.idJor<=R.idJor) and
             (P.tempCod=R.tempCod)
         )

);


UPDATE RESULTADOS R set golesFavor = (
    Select sum(goles)

);
*/

/*
SELECT nombre
FROM ESTADIOS
Where capacidad = '12642';



SELECT equipoLocal
FROM partidos
where idJor = '1972061' and idPar = '51';
*/



UPDATE RESULTADOS R set golesFavor = (
  select golesFavor from 
    (select 
    ( 
        (Select sum(golesLocal)
        from partido P 
        where 
            (P.equipoL=E.nombre_oficial)
            and (P.ntemporada=R.ntemporada)
            and (P.Njornada<=R.Njornada)
    )+(Select sum(golesVisitante)
        from partido P 
        where 
            (P.equipoV=E.nombre_oficial)
            and (P.ntemporada=R.ntemporada)
            and (P.Njornada<=R.Njornada))) golesfav
  from equipo E, Resultados R
where  E.nombre_oficial=R.equipo) G
where G.equipo=R.equipo and G.njornada=R.njornada and G.ntemporada=R.ntemporada
);


UPDATE RESULTADOS R set golescon = (
  select golescon from 
    (select 
    E.nombre_oficial as equipo,
        R.Njornada as njornada,
        R.ntemporada as ntemporada,
    ( 
        (Select sum(golesLocal)
        from partido P 
        where 
            (P.equipoV=E.nombre_oficial)
            and (P.ntemporada=R.ntemporada)
            and (P.Njornada<=R.Njornada)
    )+(Select sum(golesVisitante)
        from partido P 
        where 
            (P.equipoL=E.nombre_oficial)
            and (P.ntemporada=R.ntemporada)
            and (P.Njornada<=R.Njornada))) golescon
  from equipo E, Resultados R
where E.nombre_oficial=R.equipo) G
where G.equipo=R.equipo and G.njornada=R.njornada and G.ntemporada=R.ntemporada
);









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


Select sum(par.golesLocales)
from PARTIDOS par, JORNADAS jor
where   par.equipoLocal='Zaragoza' and
        par.idJor=jor.idJor and
        jor.tempCod=(   Select T.tempCod
                        from TEMPORADAS T
                        where  4<= (select count(*)
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
                                                and J1.tempCod=J.tempCod
)));


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





Select T.inicio,sum(par.golesVisitantes)
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
GROUP BY T.inicio


Select R.golesFavor
from RESULTADOS R
where (R.nombreCorto="Zaragoza") and 4<=

Select 
from JORNADAS J
where 

Select equipoVisitante
from EQUIPOL EL, JORNADAS J
where EL.equipoL=R.nombreCorto and golesLocales>golesVisitantes and 

Select tempCod
from TEMPORADAS T
where T.tempCod=Select J.tempCod
        from JORNADAS J
        where 4<= Select count(*)
                    from 




-- /** Numero de goles del Zag cuando haya ganado a mas de 4 equipos en ambos partidos***/

-- select  MOD(ntemporada,10000)as temporada,golesfav as GolZaragoza
-- from resultados R
-- where R.ntemporada IN (select  DISTINCT temporada 
--                 from (
--                         select temporada,
--                         count(*) as ganIyV
--                         from (
--                                 select DISTINCT P1.ntemporada as temporada, P1.equipoL, P1.equipoV
--                                 from partido P1, partido P2
--                                         where P1.equipoL='Zaragoza' 
--                                         and (P1.golesLocal>P1.golesVisitante)
--                                         and (P2.equipoL=P1.equipoV)
--                                         and (P2.golesLocal<P2.golesVisitante)
--                         )
--                         group by temporada
--                         having count(*)>4
--                         order by temporada
--                 ) 
-- )
-- and  R.njornada = (select max(J.numero) 
--                         from jornada J 
--                         group by temporada
--                         having R.ntemporada= J.temporada        
--                 )
-- and R.equipo='Zaragoza'
-- order by ntemporada
-- ;




Select sum(par.golesLocales)
from PARTIDOS par, JORNADAS jor
where   par.equipoLocal='Zaragoza' and
        par.idJor=jor.idJor and
        jor.tempCod=(   Select T.inicio
                        from TEMPORADAS T
                        where  4<= (select count(*)
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
                                                and J1.tempCod=J.tempCod
)))
group by T.inicio;


Select Y.ini,sum(Y.p), sum(W.pa)
from (Select Z.inicio as ini, par.golesLocales as p
    from  PARTIDOS par , JORNADAS jor , (Select T.inicio
                            from TEMPORADAS T
                            where  4<= (select count(*)
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
                                                    and J1.tempCod=J.tempCod
    )))  Z
    where jor.tempCod=Z.inicio and par.idJor=jor.idJor and par.equipoLocal='Zaragoza')  Y,
    (Select Z.inicio as i, par.golesVisitantes as pa
        from  PARTIDOS par, JORNADAS jor, (Select T.inicio
                                from TEMPORADAS T
                                where  4<= (select count(*)
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
                                                        and J1.tempCod=J.tempCod
        )))  Z
    where jor.tempCod=Z.inicio and par.idJor=jor.idJor and par.equipoVisitante='Zaragoza')  W
where Y.ini=W.i
GROUP BY Y.ini;





























SELECT equipo.nombre
  FROM (select pts from 
    (select 
        E.nombre_oficial as equipo,
        R.Njornada as njornada,
        R.ntemporada as ntemporada,
    ( 
        3*(Select count(*)
        from partido P, (select golesfav from 
    (select 
    E.nombre_oficial as equipo,
        R.Njornada as njornada,
        R.ntemporada as ntemporada,
    ( 
        (Select sum(golesLocal)
        from partido P 
        where 
            (P.equipoL=E.nombre_oficial)
            and (P.ntemporada=R.ntemporada)
            and (P.Njornada<=R.Njornada)
    )+(Select sum(golesVisitante)
        from partido P 
        where 
            (P.equipoV=E.nombre_oficial)
            and (P.ntemporada=R.ntemporada)
            and (P.Njornada<=R.Njornada))) golesfav
  from equipo E, Resultados R
where  E.nombre_oficial=R.equipo)  ) G
        where 
           (((P.equipoL=E.nombre_oficial) and (P.golesLocal>P.golesVisitante))
           or ((P.equipoV=E.nombre_oficial) and (P.golesVisitante>P.golesLocal)) )
            and (P.ntemporada=R.ntemporada)
            and (P.Njornada<=R.Njornada)
    )+(Select count(*)
        from partido P 
        where 
            ((P.equipoL=E.nombre_oficial)or(P.equipoV=E.nombre_oficial))
            and (P.golesLocal=P.golesVisitante)
            and (P.ntemporada=R.ntemporada)
            and (P.Njornada<=R.Njornada))) pts
  from equipo E, Resultados R
where  E.nombre_oficial=R.equipo  
) PUNTOS, 
) --listar equipos
;
    

    


/*                                                                                       
  ############################################################################################
  Resultados:  puesto
  ##########################################################################################*/

UPDATE Resultados R
SET puesto = (SELECT RowN 
FROM (
  SELECT 
        ROW_NUMBER() OVER(
            partition by njornada, ntemporada
            ORDER BY puntos DESC, golesfav-golescon DESC
        ) AS RowN,
        equipo,
        njornada, 
        ntemporada 
        FROM Resultados
        order by  ntemporada, njornada,RowN  
) P
where R.equipo=P.equipo and R.njornada=P.njornada and R.ntemporada=P.ntemporada);


