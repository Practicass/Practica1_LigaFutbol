/*                                                                                       
  ############################################################################################
  Resultados: equipos njor ntmp
  ##########################################################################################*/
  insert into Resultados (equipo, idJor, tempCod) 
  select p.equipoLocal, p.idJor, j.tempCod from partidos p, jornadas j
  where p.idJor = j.idJor
  UNION
  select p.equipoVisitante, p.idJor, j.tempCod from partidos p, jornadas j
  where p.idJor = j.idJor;


/* select  R.equipo, golesFavor
from RESULTADOS R
where R.idJor = '1972011' and R.tempCod = '110';
GROUP BY R.equipo;
 */


  /*                                                                                       
  ############################################################################################
  Resultados:  golesFavor golecon 
  ##########################################################################################*/


UPDATE RESULTADOS RESU set golesFavor = (
    SELECT G.golesFavor 
    FROM  RESULTADOS RESU, (select Equi.nombreCorto as eq,
                                R.idJor as Jor,
                                R.tempCod as temp,
                            ((Select sum(Par.golesLocales)
                             from partidos Par, JORNADAS Jor
                             where (Par.equipoLocal=Equi.nombreCorto)
                                    and (Jor.tempCod=R.tempCod) and (Jor.idJor = Par.idjor)
                                    and (Par.idJor<=R.idJor))
                                +(Select sum(Par.golesVisitantes)
                                from partidos Par, JORNADAS Jor
                                    where (Par.equipoVisitante=Equi.nombreCorto)
                        and (Jor.tempCod=R.tempCod) and (Jor.idJor = Par.idjor)
                        and (Par.idJor<=R.idJor))) as golesFavor
                        from equipos Equi, Resultados R
                        where  Equi.nombreCorto=R.equipo) G
                         WHERE G.eq=RESU.equipo and G.Jor=RESU.idJor and G.temp=RESU.tempCod );


-------------------------------------------------------------------------------

UPDATE RESULTADOS RESU set golesFavor = (
Select T.TOTAL
FROM RESULTADOS RESU, (SELECT (H.golesFavorL + G.golesFavorV as TOTAL, 
  FROM  (Select sum(Par.golesLocales) as golesFavorL
          from partidos Par, JORNADAS Jor, EQUIPOS Equi, TEMPORADAS T1
          where Par.equipoLocal=Equi.nombreCorto and RESU.equipo=Equi.nombreCorto 
                  and Jor.tempCod=T1.tempCod and Jor.idJor = Par.idJor and Jor.idJor = RESU.idJor
                  and Par.idJor<= RESU.idJor and T1.tempCod= RESU.tempCod
        ) H, (Select sum(Par.golesVisitantes)  as golesFavorV
          from partidos Par, JORNADAS Jor, EQUIPOS Equi, TEMPORADAS T2
          where Par.equipoVisitante=Equi.nombreCorto and RESU.equipo=Equi.nombreCorto
                  and Jor.tempCod=T2.tempCod and Jor.idJor = Par.idJor and Jor.idJor = RESU.idJor
                  and Par.idJor<=RESU.idJor and T2.tempCod= RESU.tempCod) G)T
  where RESU.tem
  );






UPDATE RESULTADOS RESU set golesFavor = (
SELECT G.golesFavor
FROM ( ((Select sum(Par.golesLocales) as golesFavor, Equi.nombreCorto
        from partidos Par, JORNADAS Jor, EQUIPOS Equi
        where Par.equipoLocal=Equi.nombreCorto and RESU.equipo=Equi.nombreCorto
                and Jor.tempCod=T.tempCod and Jor.idJor = Par.idJor
                and Par.idJor<= RESU.idJor
),(Select sum(Par.golesVisitantes)
        from partidos Par, JORNADAS Jor, EQUIPOS Equi
        where Par.equipoVisitante=Equi.nombreCorto and RESU.equipo=Equi.nombreCorto
                and Jor.tempCod=T.tempCod and Jor.idJor = Par.idJor
                and Par.idJor<=RESU.idJor)) as golesFavor) G
                
                
                
                );
--HOLAAAAAAAA goles favor locales 3910  // comentar en la memoria el problema que nos ha dado la memoria, si vamos de una en una funciona pero suponemos que si tenemos más recursos iría bien 
UPDATE RESULTADOS RESU set golesFavor = (
  Select sum(Par.golesLocales)
        from partidos Par, JORNADAS Jor, EQUIPOS Equi
        where Par.equipoLocal=Equi.nombreCorto and RESU.equipo=Equi.nombreCorto
                and Jor.tempCod=RESU.tempCod and Jor.idJor = Par.idJor
                and Par.idJor<= RESU.idJor and RESU.tempCod>='2910'
);

UPDATE RESULTADOS RESU set golesFavor = (
  Select sum(Par.golesVisitantes)+ RESU.golesFavor
            from PARTIDOS Par, JORNADAS Jor, EQUIPOS Equi
        where Par.equipoVisitante=Equi.nombreCorto and RESU.equipo=Equi.nombreCorto
                and Jor.tempCod=RESU.tempCod and Jor.idJor = Par.idJor
                and Par.idJor<= RESU.idJor and RESU.tempCod>='2910'
);


select R.golesFavor
from Resultados R
where R.tempCod='3510' and R.equipo='Barcelona' and R.idJor=(Select max(idJor)
                              from JORNADAS J
                              where J.tempCod=R.tempCod);
 
--SIGOOOOO

UPDATE RESULTADOS RESU set golesContra = (
  Select sum(Par.golesVisitantes)
        from partidos Par, JORNADAS Jor, EQUIPOS Equi
        where Par.equipoLocal=Equi.nombreCorto and RESU.equipo=Equi.nombreCorto
                and Jor.tempCod=RESU.tempCod and Jor.idJor = Par.idJor
                and Par.idJor<= RESU.idJor and RESU.tempCod>='2910'
);

UPDATE RESULTADOS RESU set golesContra = (
  Select sum(Par.golesLocales)+ RESU.golesContra
            from PARTIDOS Par, JORNADAS Jor, EQUIPOS Equi
        where Par.equipoVisitante=Equi.nombreCorto and RESU.equipo=Equi.nombreCorto
                and Jor.tempCod=RESU.tempCod and Jor.idJor = Par.idJor
                and Par.idJor<= RESU.idJor and RESU.tempCod>='2910'
);


select R.golesContra
from Resultados R
where R.tempCod='3510' and R.equipo='Barcelona' and R.idJor=(Select max(idJor)
                              from JORNADAS J
                              where J.tempCod=R.tempCod);


--and G.tempCod= '110' and RESU.tempCod = '110' 
--TABLA DE GOLES COMO LOCAL
(Select sum(Par.golesLocales) as golL, equi.nombreCorto, R.tempCod
from partidos Par, JORNADAS Jor, RESULTADOS R, EQUIPOS equi
where (Par.equipoLocal=Equi.nombreCorto)
        and (Jor.tempCod=R.tempCod) and (Jor.idJor = Par.idjor)
        and (Par.idJor<=R.idJor)
GROUP BY equi.nombreCorto, R.tempCod
) LO

--TABLA DE GOLES COMO VISITANTE
(Select sum(Par.golesVisitantes) as golV
from partidos Par, JORNADAS Jor
where (Par.equipoLocal=Equi.nombreCorto)
        and (Jor.tempCod=R.tempCod) and (Jor.idJor = Par.idjor)
        and (Par.idJor<=R.idJor)) VI









UPDATE RESULTADOS RESU set golesFavor = (
    SELECT G.golesFavor 
    FROM (select
                             Equi.nombreCorto as equipos,
                                R.idJor as idJor,
                                R.tempCod as tempCod,
                ((Select sum(Par.golesLocales)
                    from partidos Par, JORNADAS Jor
                    where (Par.equipoLocal=Equi.nombreCorto)
                                    and (Jor.tempCod=R.tempCod) and (Jor.idJor = Par.idjor)
                                    and (Par.idJor<=R.idJor))
                +(Select sum(Par.golesVisitantes)
                    from partidos Par, JORNADAS Jor
                    where (Par.equipoVisitante=Equi.nombreCorto)
                        and (Jor.tempCod=R.tempCod) and (Jor.idJor = Par.idjor)
                        and (Par.idJor<=R.idJor))) as golesFavor
          from equipos Equi, Resultados R
          where  Equi.nombreCorto=R.equipo) G
    WHERE G.equipos=RESU.equipo and G.idJor=RESU.idJor and G.tempCod= '110' and RESU.tempCod = '110');

UPDATE RESULTADOS R set golesFavor = 20 where R.idJor = '1972011' and R.tempCod = '110';
    
    Barcelona;Osasuna;2;0;Camp Nou;2010331;29478;




/* select R.equipo, R.golesFavor
from RESULTADOS R
where R.idJor = '1972011' and R.tempCod = '110'
group by R.equipo; */

UPDATE RESULTADOS Res set golesContra = (
  select golesContra from 
    (select 
    Equi.nombreCorto as equipos,
        Res.idJor as idJor,
        Res.tempCod as tempCod,
    ( 
        (Select sum(golesLocal)
        from partido Par 
        where 
            (Par.equipoVisitante=Equi.nombreCorto)
            and (Par.tempCod=Res.tempCod)
            and (Par.idJor<=Res.idJor)
    )+(Select sum(golesVisitante)
        from partido Par 
        where 
            (Par.equipoLocal=Equi.nombreCorto)
            and (Par.tempCod=Res.tempCod)
            and (Par.idJor<=Res.idJor))) golesContra
  from equipos Equi, Resultados Res
where Equi.nombreCorto=Res.equipos) Gol
where Gol.equipos=Res.equipos and Gol.idJor=Res.idJor and Gol.tempCod=Res.tempCod
);

/*                                                                                       
  ############################################################################################
  Resultados: puntos 
  ##########################################################################################*/
UPDATE Resultados Res
  set puntos = (
  select pts from 
    (select 
        Equi.nombreCorto as equipos,
        Res.idJor as idJor,
        Res.tempCod as tempCod,
    ( 
        3*(Select count(*)
        from partido Par 
        where 
           (((Par.equipoLocal=Equi.nombreCorto) and (Par.golesLocal>Par.golesVisitante))
           or ((Par.equipoVisitante=Equi.nombreCorto) and (Par.golesVisitante>Par.golesLocal)) )
            and (Par.tempCod=Res.tempCod)
            and (Par.idJor<=Res.idJor)
    )+(Select count(*)
        from partido Par 
        where 
            ((Par.equipoLocal=Equi.nombreCorto)or(Par.equipoVisitante=Equi.nombreCorto))
            and (Par.golesLocal=Par.golesVisitante)
            and (Par.tempCod=Res.tempCod)
            and (Par.idJor<=Res.idJor))) pts
  from equipos Equi, Resultados Res
where  Equi.nombreCorto=Res.equipos  
) PUNTOS
where PUNTOS.equipos=Res.equipos and PUNTOS.idJor=Res.idJor and PUNTOS.tempCod=Res.tempCod
);


UPDATE Resultados Res
  set puntos = (
  select pts from 
    (select 
        Equi.nombreCorto as equipos,
        Res.idJor as idJor,
        Res.tempCod as tempCod,
    ( 
        3*(Select count(*)
        from partidos Par 
        where 
           (((Par.equipoLocal=Equi.nombreCorto) and (Par.golesLocales>Par.golesVisitantes))
           or ((Par.equipoVisitante=Equi.nombreCorto) and (Par.golesVisitantes>Par.golesLocales)) )
            and (Par.idJor=J.idJor) 
            and (J.tempCod=Res.tempCod)
            and (Par.idJor<=Res.idJor)
    )+(Select count(*)
        from partidos Par 
        where 
            ((Par.equipoLocal=Equi.nombreCorto)or(Par.equipoVisitante=Equi.nombreCorto))
            and (Par.golesLocales=Par.golesVisitantes)
            and (Par.idJor=J.idJor) 
            and (J.tempCod=Res.tempCod)
            and (Par.idJor<=Res.idJor))) pts
  from equipos Equi, JORNADAS J
where  Equi.nombreCorto=Res.equipo
) PUNTOS
where PUNTOS.equipos=Res.equipo and PUNTOS.idJor=Res.idJor and PUNTOS.tempCod=Res.tempCod and Res.tempCod='3510'
group by PUNTOS.equipos, PUNTOS.idJor,PUNTOS.tempCod
);
    

    


UPDATE RESULTADOS RESU set puntos = (
Select puntos.pts
FROM (SELECT EMP.i as tIni, EMP.eq as nEq, EMP.e+GAN.g as pts , EMP.jor as jorn
                FROM (SELECT J.tempCod as i,E.nombreCorto as eq, J.idJor as jor, count(*) as e
                        FROM PARTIDOS P, JORNADAS J, EQUIPOS E
                        WHERE ((P.equipoLocal=RESU.equipo)
                                OR (P.equipoVisitante=RESU.equipo))
                                AND (P.golesLocales=P.golesVisitantes)
                                AND (P.idJor=J.idJor)
                                AND (J.idJor<=RESU.idJor) 
                                AND (J.tempCod=RESU.tempCod)
                                AND E.nombreCorto=RESU.equipo
                        GROUP BY J.tempCod,E.nombreCorto, J.idJor) EMP, 
                        (SELECT J.tempCod as ini, E.nombreCorto as equipo , J.idJor as jor,3*count(*) as g
                        FROM PARTIDOS P, JORNADAS J, EQUIPOS E
                        WHERE (((P.equipoLocal=RESU.equipo) 
                                AND (P.golesLocales>P.golesVisitantes))
                                OR ((P.equipoVisitante=RESU.equipo) 
                                AND (P.golesVisitantes>P.golesLocales)) )
                                AND (P.idJor=J.idJor)
                                AND (J.idJor<=RESU.idJor)
                                AND (J.tempCod=RESU.tempCod)
                                AND E.nombreCorto=RESU.equipo
                        GROUP BY J.tempCod,E.nombreCorto,J.idJor) GAN
                WHERE EMP.i=GAN.ini AND EMP.eq=GAN.equipo AND EMP.jor=GAN.jor) puntos
where RESU.tempCod='3510'
);



SELECT EMP.i as tIni, EMP.eq as nEq, EMP.e+GAN.g as pts , EMP.jor as jorn
                FROM (SELECT J.tempCod as i,E.nombreCorto as eq, J.idJor as jor, count(*) as e
                        FROM PARTIDOS P, JORNADAS J, EQUIPOS E, RESULTADOS RESU
                        WHERE ((P.equipoLocal=RESU.equipo)
                                OR (P.equipoVisitante=RESU.equipo))
                                AND (P.golesLocales=P.golesVisitantes)
                                AND (P.idJor=J.idJor)
                                AND (J.idJor<=RESU.idJor) 
                                AND (J.tempCod=RESU.tempCod)
                                AND E.nombreCorto=RESU.equipo
                        GROUP BY J.tempCod,E.nombreCorto, J.idJor) EMP, 
                        (SELECT J.tempCod as ini, E.nombreCorto as equipo , J.idJor as jor,3*count(*) as g
                        FROM PARTIDOS P, JORNADAS J, EQUIPOS E, RESULTADOS RESU
                        WHERE (((P.equipoLocal=RESU.equipo) 
                                AND (P.golesLocales>P.golesVisitantes))
                                OR ((P.equipoVisitante=RESU.equipo) 
                                AND (P.golesVisitantes>P.golesLocales)) )
                                AND (P.idJor=J.idJor)
                                AND (J.idJor<=RESU.idJor)
                                AND (J.tempCod=RESU.tempCod)
                                AND E.nombreCorto=RESU.equipo
                        GROUP BY J.tempCod,E.nombreCorto,J.idJor) GAN
                WHERE EMP.i=GAN.ini AND EMP.eq=GAN.equipo AND EMP.jor=GAN.jor


SELECT count(*) as e
                        FROM PARTIDOS P, JORNADAS J, EQUIPOS E, RESULTADOS RESU
                        WHERE ((P.equipoLocal=RESU.equipo)
                                OR (P.equipoVisitante=RESU.equipo))
                                AND (P.golesLocales=P.golesVisitantes)
                                AND (P.idJor=J.idJor)
                                AND (J.idJor<=RESU.idJor) 
                                AND (J.tempCod=RESU.tempCod)
                                AND E.nombreCorto=RESU.equipo
                                AND (RESU.tempCod='3510')


select R.puntos
from Resultados R
where R.tempCod='3510' and R.idJor=(Select max(idJor)
                              from JORNADAS J
                              where J.tempCod=R.tempCod);

/*                                                                                       
  ############################################################################################
  Resultados:  puesto
  ##########################################################################################*/

UPDATE Resultados Res
SET puesto = (SELECT RowN 
FROM (
  SELECT 
        ROW_NUMBER() OVER(
            partition by idJor, tempCod
            ORDER BY puntos DESC, golesFavor-golesContra DESC
        ) AS RowN,
        equipos,
        idJor, 
        tempCod 
        FROM Resultados
        order by  tempCod, idJor,RowN  
) Par
where Res.equipos=Par.equipos and Res.idJor=Par.idJor and Res.tempCod=Par.tempCod);











CREATE or REPLACE TRIGGER check_estadio
BEFORE INSERT ESTADIO ON PARTIDOS
FOR EACH ROW
BEGIN 
    SELECT E.estadio into :new.estadio
    FROM PARTIDO P, EQUIPOS E
    WHERE E.nombreCorto = P.equipoLocal
END check_estadio
/




UPDATE Resultados R
  set puntos = (
  select pts 
  from (select 
        E.nombreCorto as equipo,
        R.idJor as idJor,
        R.tempCod as tempCod,
        (3*(Select count(*)
            from partidos P, JORNADAS J
            where 
            (((P.equipoLocal=E.nombreCorto) and (P.golesLocales>P.golesVisitantes))
            or ((P.equipoVisitante=E.nombreCorto) and (P.golesVisitantes>P.golesLocales)) )
                and (J.tempCod=R.tempCod)
                and P.idJor = J.idJor
                and (P.Njornada<=R.Njornada)
        )+(Select count(*)
            from partidos P 
            where 
                ((P.equipoLocal=E.nombreCorto)or(P.equipoVisitante=E.nombreCorto))
                and (P.golesLocales=P.golesVisitantes)
                and (J.tempCod=R.tempCod)
                and P.idJor = J.idJor
                and (P.Njornada<=R.Njornada)))) as pts 
            from equipos E, Resultados R
where  E.nombreCorto=R.equipo  ) PUN

where PUN.equipo=R.equipo and PUN.idJor=R.idJor and PUN.tempCod=R.tempCod
);