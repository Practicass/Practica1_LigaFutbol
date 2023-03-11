
/*Equipo que más ligas de primera división ha ganado.*/

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
where   (Select count(*)
        from EQUIPOL EL
        where (EL.estadio=E.nombre))*85/100<(Select count(*)
                                            from EQUIPOL EL
                                            where (EL.estadio=E.nombre) and (golesLocales >= golesVisitantes))





/*Número de goles marcados por el Real Zaragoza en cada temporada de liga en la que haya ganado al
menos a 4 equipos en ambos partidos de la temporada (ida y vuelta).*/

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