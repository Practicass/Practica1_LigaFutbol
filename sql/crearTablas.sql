CREATE TABLE ESTADIOS (
    nombre VARCHAR(100) PRIMARY KEY,
    fechaInauguracion NUMBER(4),
    capacidad NUMBER(7) CHECK( capacidad>0 )
);

CREATE TABLE EQUIPOS (
    nombreOficial   VARCHAR(100) ,
    nombreCorto     VARCHAR(100) PRIMARY KEY,
    nombreHistorico VARCHAR(100) UNIQUE,
    ciudad          VARCHAR(100),
    fechaFundacion  NUMBER(4),
    fechaLegal      NUMBER(4),
    nomEstadio       VARCHAR(100) ,
    FOREIGN KEY(nomEstadio) REFERENCES ESTADIOS(nombre) ON DELETE CASCADE
);

CREATE TABLE OTROS_NOMBRES (
    nombreCorto VARCHAR(100) PRIMARY KEY,
    otrosNombres VARCHAR(100),
    FOREIGN KEY(nombreCorto) REFERENCES EQUIPOS(nombreCorto) ON DELETE CASCADE
);

CREATE TABLE DIVISIONES (
    denominacion VARCHAR(100) NOT NULL PRIMARY KEY
);



CREATE TABLE TEMPORADAS (
    tempCod NUMBER(5) PRIMARY KEY,
    inicio      NUMBER(4) NOT NULL,
    fin      NUMBER(4) NOT NULL,
    division  VARCHAR(100) NOT NULL,
    FOREIGN KEY (division) REFERENCES DIVISIONES(denominacion) ON DELETE CASCADE
);

CREATE TABLE JORNADAS (
    idJor NUMBER(8) PRIMARY KEY,
    numero NUMBER(3) NOT NULL CHECK( numero > 0),
    tempCod NUMBER(5) NOT NULL,
    FOREIGN KEY (tempCod) REFERENCES TEMPORADAS(tempCod) ON DELETE CASCADE
);


CREATE TABLE PARTIDOS (
    idPar NUMBER(5) PRIMARY KEY,
    idJor NUMBER(8) NOT NULL,
    equipoVisitante VARCHAR(100) NOT NULL,
    equipoLocal VARCHAR(100), 
    estadio VARCHAR(100),
    golesLocales NUMBER(2), 
    golesVisitantes NUMBER(2),
    FOREIGN KEY (equipoVisitante) REFERENCES EQUIPOS(nombreCorto) ON DELETE CASCADE,
    FOREIGN KEY (idJor) REFERENCES JORNADAS(idJor) ON DELETE CASCADE,
    FOREIGN KEY (equipoLocal) REFERENCES EQUIPOS(nombreCorto) ON DELETE CASCADE,
    FOREIGN KEY (estadio) REFERENCES ESTADIOS(nombre) ON DELETE CASCADE,
    CONSTRAINT CK_EQUIPOS CHECK (equipoLocal <> equipoVisitante)
);




