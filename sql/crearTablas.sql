SET ECHO ON

 CREATE TABLE ESTADIOS (
    nombre VARCHAR(100) PRIMARY KEY,
    fechaInauguracion NUMBER(4),
    capacidad NUMBER(6) CHECK( capacidad>0 )
);

CREATE TABLE EQUIPOS (
    nombreOficial   VARCHAR(100),
    nombreCorto     VARCHAR(100) PRIMARY KEY,
    nombreHistorico VARCHAR(100) UNIQUE,
    ciudad          VARCHAR(100),
    fechaFundacion  NUMBER(4) NOT NULL,
    fechaLegal      NUMBER(4),
    nomEstadio       VARCHAR(100) NOT NULL,
    FOREIGN KEY(nomEstadio) REFERENCES ESTADIOS(nombre) ON DELETE CASCADE
);

CREATE TABLE OTROS_NOMBRES (
    nombreCorto VARCHAR(100) PRIMARY KEY,
    otrosNombres VARCHAR(100) NOT NULL,
    FOREIGN KEY(nombreCorto) REFERENCES EQUIPOS(nombreCorto) ON DELETE CASCADE
);

CREATE TABLE DIVISIONES (
    denominacion VARCHAR(100) NOT NULL PRIMARY KEY
);



CREATE TABLE TEMPORADAS (
    tempCod NUMBER(5) PRIMARY KEY DEFAULT newid(),
    inicio      NUMBER(4) NOT NULL,
    fin      NUMBER(4) NOT NULL,
    division  VARCHAR(100) NOT NULL,
    FOREIGN KEY (division) REFERENCES DIVISIONES(denominacion) ON DELETE CASCADE,
    CONSTRAINT CK_TEMPORADAS CHECK ( inicio = fin - 1)
);

CREATE TABLE JORNADAS (
    idJor NUMBER(5) PRIMARY KEY,
    numero NUMBER(3) NOT NULL CHECK( numero > 0),
    tempCod VARCHAR(100) NOT NULL,
    FOREIGN KEY (tempCod) REFERENCES TEMPORADAS(tempCod) ON DELETE CASCADE
);



CREATE TABLE PARTIDOS (
    idPar NUMBER(5) PRIMARY KEY DEFAULT newid(),
    idJor VARCHAR(100) NOT NULL,
    equipoVisitante VARCHAR(100) NOT NULL,
    FOREIGN KEY (equipoVisitante) REFERENCES EQUIPOV(equipoV) ON DELETE CASCADE,
    FOREIGN KEY (idJor) REFERENCES JORNADAS(idJor) ON DELETE CASCADE
);


CREATE TABLE EQUIPOV(
    equipoV VARCHAR(100) PRIMARY KEY,
    equipoL VARCHAR(100),
    FOREIGN KEY (equipoV) REFERENCES EQUIPOS(nombreCorto) ON DELETE CASCADE,
    FOREIGN KEY (equipoL) REFERENCES EQUIPOL(equipoL) ON DELETE CASCADE,
    CONSTRAINT CK_EQUIPOS CHECK (equipoL <> equipoV)
);


CREATE TABLE EQUIPOL(
    equipoL VARCHAR(100) PRIMARY KEY, 
    estadio VARCHAR(100),
    golesLocales NUMBER(2), 
    golesVisitantes NUMBER(2),
    FOREIGN KEY (equipoL) REFERENCES EQUIPOS(nombreCorto) ON DELETE CASCADE,
    FOREIGN KEY (estadio) REFERENCES ESTADIOS(nombre) ON DELETE CASCADE
);



/* CREATE TABLE PARTIDOS (
    IdPar VARCHAR(100) NOT NULL PRIMARY KEY,
    golesLocales NUMBER(3) NOT NULL,
    golesVisitantes NUMBER(3) NOT NULL,
    equipoLocal VARCHAR(100) NOT NULL,
    equipoVisitante VARCHAR(100) NOT NULL,
    Jornada VARCHAR(100) NOT NULL,
    estadio VARCHAR(100) NOT NULL,
    FOREIGN KEY (equipoLocal) REFERENCES EQUIPOS(nombreCorto) ON DELETE CASCADE,
    FOREIGN KEY (equipoVisitante) REFERENCES EQUIPOS(nombreCorto) ON DELETE CASCADE,
    FOREIGN KEY (Jornada) REFERENCES JORNADAS(idJornada) ON DELETE CASCADE,
    FOREIGN KEY (estadio) REFERENCES ESTADIOS(nombre) ON DELETE CASCADE,
    CONSTRAINT CK_EQUIPOS CHECK (equipoLocal <> equipoVisitante)
);*/

/*
CREATE TABLE TEMPORADAS (
    idTemporada   VARCHAR(100) NOT NULL PRIMARY KEY,
    inicio      NUMBER(4) NOT NULL,
    fin      NUMBER(4) NOT NULL,
    suDiv  VARCHAR(100) NOT NULL,
    FOREIGN KEY (suDiv) REFERENCES DIVISIONES(denominacion) ON DELETE CASCADE,
    CONSTRAINT CK_TEMPORADAS CHECK ( inicio = fin - 1)
);
*/