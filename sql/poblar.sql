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
    FROM  (select Equi.nombreCorto as eq,
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
                         WHERE G.eq=RESU.equipo and G.Jor=RESU.idJor and G.temp=RESU.tempCod and RESU.idJor = '1972011');

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