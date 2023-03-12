/*Trigger que revisa que el año de inicio sea menor que el de fin*/
CREATE OR REPLACE TRIGGER check_annos
BEFORE INSERT ON TEMPORADAS
FOR EACH ROW
BEGIN
  IF :new.inicio > :new.fin THEN 
  raise_application_error(-2127, 'La fecha de inicio debe 
    de ser menor o igual a la de fin');
  END IF;
  END check_annos;


/*Trigger que evita que se introduzcan dos veces el mismo equipo en un partido de la misma jornada*/
CREATE OR REPLACE TRIGGER check_jornada
BEFORE INSERT ON TEMPORADAS
FOR EACH ROW
DECLARE
  jor NUMBER;
BEGIN  
  SELECT count(*) INTO jor FROM PARTIDOS WHERE
      ((equipoLocal = :new.equipoLocal)OR (equipoVisitante = :new.equipoVisitante)OR(equipoLocal = :new.equipoVisitante)OR(equipoVisitante= :new.equipoLocal))
      AND (idJor = :new.idJor)
      
      IF (jor>0) THEN
      raise_application_error(-20004, 'Un equipo no puede jugar más de una vez en una jornada');
      END IF;
END check_jornada;


