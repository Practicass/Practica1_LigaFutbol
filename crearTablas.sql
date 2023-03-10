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
    miEstadio       VARCHAR(100) NOT NULL,
    FOREIGN KEY(miEstadio) REFERENCES ESTADIOS(nombre)
);

CREATE TABLE OTROS_NOMBRES (
    Equipo VARCHAR(100) PRIMARY KEY,
    otrosNombres VARCHAR(100) NOT NULL,
    FOREIGN KEY(otrosNombres) REFERENCES EQUIPOS(nombreCorto)
);

CREATE TABLE DIVISIONES (
    denominacion VARCHAR(100) NOT NULL PRIMARY KEY
);

CREATE TABLE TEMPORADAS (
    idTemporada   VARCHAR(100) NOT NULL PRIMARY KEY,
    inicio      NUMBER(4) NOT NULL,
    fin      NUMBER(4) NOT NULL,
    suDiv  VARCHAR(100) NOT NULL,
    FOREIGN KEY (suDiv) REFERENCES DIVISIONES(denominacion),
    CONSTRAINT CK_TEMPORADAS CHECK ( inicio = fin - 1)
);

CREATE TABLE JORNADAS (
    idJornada VARCHAR(100) NOT NULL PRIMARY KEY,
    numJor NUMBER(3) NOT NULL CHECK( numJor > 0),
    suTemp VARCHAR(100) NOT NULL,
    FOREIGN KEY (suTemp) REFERENCES TEMPORADAS(idTemporada)
);


CREATE TABLE PARTIDOS (
    IdPar VARCHAR(100) NOT NULL PRIMARY KEY,
    golesLocales NUMBER(3) NOT NULL,
    golesVisitantes NUMBER(3) NOT NULL,
    equipoLocal VARCHAR(100) NOT NULL,
    equipoVisitante VARCHAR(100) NOT NULL,
    Jornada VARCHAR(100) NOT NULL,
    estadio VARCHAR(100) NOT NULL,
    FOREIGN KEY (equipoLocal) REFERENCES EQUIPOS(nombreCorto),
    FOREIGN KEY (equipoVisitante) REFERENCES EQUIPOS(nombreCorto),
    FOREIGN KEY (Jornada) REFERENCES JORNADAS(idJornada),
    FOREIGN KEY (estadio) REFERENCES ESTADIOS(nombre),
    CONSTRAINT CK_EQUIPOS CHECK (equipoLocal <> equipoVisitante)
);




