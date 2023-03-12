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

  /*                                                                                       
  ############################################################################################
  Resultados:  golesFavor golecon 
  ##########################################################################################*/

UPDATE RESULTADOS R set golesFavor = (
    select golesFavorL from 
                            (select 
                                Equi.nombreCorto as equipos,
                                R.idJor as idJor,
                                R.tempCod as tempCod,
                                ((Select sum(Par.golesLocales)
                                  from partidos Par, JORNADAS Jor
                                  where (Par.equipoLocal=Equi.nombreCorto)
                                    and (Jor.tempCod=R.tempCod) and (Jor.idJor = Par.idjor)
                                    and (Par.idJor<=R.idJor)
                                )) as golesFavorL
                            from equipos Equi, Resultados R
                            where  Equi.nombreCorto=R.equipo) Gol
    where Gol.equipos=R.equipo and Gol.idJor=R.idJor and Gol.tempCod=R.tempCod
);





UPDATE RESULTADOS R set golesFavor = (
    select golesFavorV from 
                            (select 
                                Equi.nombreCorto as equipos,
                                R.idJor as idJor,
                                R.tempCod as tempCod,
                                ((Select sum(Par.golesVisitantes)
                                from partidos Par, JORNADAS Jor
                                where 
                                    (Par.equipoVisitante=Equi.nombreCorto)
                                    and (Jor.tempCod=R.tempCod) and (Jor.idJor = Par.idjor)
                                    and (Par.idJor<=R.idJor))) as golesFavorV
                            from equipos Equi, Resultados R
                            where  Equi.nombreCorto=R.equipo) Gol
    where Gol.equipos=R.equipo and Gol.idJor=R.idJor and Gol.tempCod=R.tempCod
);






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




