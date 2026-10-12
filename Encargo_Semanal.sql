-- PRY2204 EFT Semana 9 - ANFP
-- Usuario de trabajo: PRY2204_S9


CREATE TABLE REGION (
    id_region  NUMBER(2)      NOT NULL,
    nombre     VARCHAR2(50)   NOT NULL
);

ALTER TABLE REGION ADD CONSTRAINT REGION_PK PRIMARY KEY (id_region);


CREATE TABLE NACIONALIDAD (
    id_nacion    NUMBER        GENERATED ALWAYS AS IDENTITY (START WITH 210 INCREMENT BY 2),
    descripcion  VARCHAR2(30)  NOT NULL
);

ALTER TABLE NACIONALIDAD ADD CONSTRAINT NACIONALIDAD_PK PRIMARY KEY (id_nacion);


CREATE TABLE ASOCIACION (
    id_asociacion       NUMBER(3)      NOT NULL,
    nombre_asociacion   VARCHAR2(80)   NOT NULL,
    fecha_creacion      DATE           NOT NULL,
    tipo_asociacion     CHAR(1)        NOT NULL
);

ALTER TABLE ASOCIACION ADD CONSTRAINT ASOCIACION_PK PRIMARY KEY (id_asociacion);

ALTER TABLE ASOCIACION ADD CONSTRAINT ASOCIACION_CK_TIPO
    CHECK (tipo_asociacion IN ('P', 'A'));

ALTER TABLE ASOCIACION ADD CONSTRAINT ASOCIACION_CK_FECHA
    CHECK (fecha_creacion >= DATE '1980-12-31');


CREATE TABLE IDIOMA (
    id_idioma       NUMBER(3)     NOT NULL,
    nombre_idioma   VARCHAR2(30)  NOT NULL
);

ALTER TABLE IDIOMA ADD CONSTRAINT IDIOMA_PK PRIMARY KEY (id_idioma);


CREATE TABLE ESCUELA_FUTBOL (
    id_escuela        NUMBER(6)      NOT NULL,
    nombre            VARCHAR2(50)   NOT NULL,
    capacidad         NUMBER(6)      NOT NULL,
    fecha_fundacion   DATE           NOT NULL
);

ALTER TABLE ESCUELA_FUTBOL ADD CONSTRAINT ESCUELA_FUTBOL_PK PRIMARY KEY (id_escuela);


CREATE TABLE COMUNA (
    id_comuna   NUMBER(5)     NOT NULL,
    id_region   NUMBER(2)     NOT NULL,
    nombre      VARCHAR2(40)  NOT NULL
);

ALTER TABLE COMUNA ADD CONSTRAINT COMUNA_PK PRIMARY KEY (id_comuna);

ALTER TABLE COMUNA ADD CONSTRAINT COMUNA_FK_REGION FOREIGN KEY (id_region)
    REFERENCES REGION (id_region);


CREATE SEQUENCE SEQ_CLUB_FUTBOL
    START WITH 703
    INCREMENT BY 4
    NOCACHE;


CREATE TABLE CLUB_FUTBOL (
    id_club       NUMBER(4)      NOT NULL,
    nombre_club   VARCHAR2(50)   NOT NULL,
    patrimonio    NUMBER(12)     NOT NULL,
    direccion     VARCHAR2(80)   NOT NULL,
    tipo_club     VARCHAR2(20)   NOT NULL
);

ALTER TABLE CLUB_FUTBOL ADD CONSTRAINT CLUB_FUTBOL_PK PRIMARY KEY (id_club);

ALTER TABLE CLUB_FUTBOL ADD CONSTRAINT CLUB_FUTBOL_UN_NOMBRE UNIQUE (nombre_club);


CREATE TABLE TRABAJADOR (
    id_inscripcion     NUMBER(9)      NOT NULL,
    rut                NUMBER(8)      NOT NULL,
    dv                 CHAR(1)        NOT NULL,
    nombres            VARCHAR2(50)   NOT NULL,
    apellidos          VARCHAR2(50)   NOT NULL,
    sueldo_base        NUMBER(10)     NOT NULL,
    fecha_nacimiento   DATE           NOT NULL,
    genero             CHAR(1)        NOT NULL,
    estado_civil       VARCHAR2(20)   NOT NULL,
    telefono_movil     VARCHAR2(15),
    email              VARCHAR2(60),
    direccion          VARCHAR2(80)   NOT NULL,
    id_comuna          NUMBER(5)      NOT NULL,
    id_nacion          NUMBER
);

ALTER TABLE TRABAJADOR ADD CONSTRAINT TRABAJADOR_PK PRIMARY KEY (id_inscripcion);

ALTER TABLE TRABAJADOR ADD CONSTRAINT TRABAJADOR_UN_RUT UNIQUE (rut);

ALTER TABLE TRABAJADOR ADD CONSTRAINT TRABAJADOR_CK_GENERO
    CHECK (genero IN ('M', 'F'));

ALTER TABLE TRABAJADOR ADD CONSTRAINT TRABAJADOR_FK_COMUNA FOREIGN KEY (id_comuna)
    REFERENCES COMUNA (id_comuna);

ALTER TABLE TRABAJADOR ADD CONSTRAINT TRABAJADOR_FK_NACION FOREIGN KEY (id_nacion)
    REFERENCES NACIONALIDAD (id_nacion);


CREATE TABLE JUGADOR (
    id_inscripcion      NUMBER(9)      NOT NULL,
    puesto              VARCHAR2(30)   NOT NULL,
    monto_premios       NUMBER(12)     NOT NULL,
    id_escuela          NUMBER(6),
    anio_fin_amateur    NUMBER(4),
    id_asociacion       NUMBER(3)      NOT NULL
);

ALTER TABLE JUGADOR ADD CONSTRAINT JUGADOR_PK PRIMARY KEY (id_inscripcion);

ALTER TABLE JUGADOR ADD CONSTRAINT JUGADOR_FK_TRABAJADOR FOREIGN KEY (id_inscripcion)
    REFERENCES TRABAJADOR (id_inscripcion);

ALTER TABLE JUGADOR ADD CONSTRAINT JUGADOR_FK_ESCUELA FOREIGN KEY (id_escuela)
    REFERENCES ESCUELA_FUTBOL (id_escuela);

ALTER TABLE JUGADOR ADD CONSTRAINT JUGADOR_FK_ASOCIACION FOREIGN KEY (id_asociacion)
    REFERENCES ASOCIACION (id_asociacion);


CREATE TABLE PERSONAL_PLANTA (
    id_inscripcion     NUMBER(9)    NOT NULL,
    horas_trabajadas   NUMBER(5),
    valor_hora_extra   NUMBER(8)
);

ALTER TABLE PERSONAL_PLANTA ADD CONSTRAINT PERSONAL_PLANTA_PK PRIMARY KEY (id_inscripcion);

ALTER TABLE PERSONAL_PLANTA ADD CONSTRAINT PERSONAL_PLANTA_FK_TRABAJADOR FOREIGN KEY (id_inscripcion)
    REFERENCES TRABAJADOR (id_inscripcion);


CREATE TABLE JUGADOR_IDIOMA (
    id_inscripcion   NUMBER(9)      NOT NULL,
    id_idioma        NUMBER(3)      NOT NULL,
    nivel            VARCHAR2(20)   NOT NULL
);

ALTER TABLE JUGADOR_IDIOMA ADD CONSTRAINT JUGADOR_IDIOMA_PK PRIMARY KEY (id_inscripcion, id_idioma);

ALTER TABLE JUGADOR_IDIOMA ADD CONSTRAINT JUGADOR_IDIOMA_FK_JUGADOR FOREIGN KEY (id_inscripcion)
    REFERENCES JUGADOR (id_inscripcion);

ALTER TABLE JUGADOR_IDIOMA ADD CONSTRAINT JUGADOR_IDIOMA_FK_IDIOMA FOREIGN KEY (id_idioma)
    REFERENCES IDIOMA (id_idioma);


CREATE TABLE HISTORIAL_CLUB (
    id_inscripcion   NUMBER(9)   NOT NULL,
    id_club          NUMBER(4)   NOT NULL,
    fecha_inicio     DATE        NOT NULL,
    fecha_fin        DATE
);

ALTER TABLE HISTORIAL_CLUB ADD CONSTRAINT HISTORIAL_CLUB_PK
    PRIMARY KEY (id_inscripcion, id_club, fecha_inicio);

ALTER TABLE HISTORIAL_CLUB ADD CONSTRAINT HISTORIAL_CLUB_FK_JUGADOR FOREIGN KEY (id_inscripcion)
    REFERENCES JUGADOR (id_inscripcion);

ALTER TABLE HISTORIAL_CLUB ADD CONSTRAINT HISTORIAL_CLUB_FK_CLUB FOREIGN KEY (id_club)
    REFERENCES CLUB_FUTBOL (id_club);

ALTER TABLE HISTORIAL_CLUB ADD CONSTRAINT HISTORIAL_CLUB_CK_PERIODO
    CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio);


-- =============================================================================
-- Poblado: solo REGION, COMUNA, ASOCIACION, NACIONALIDAD, CLUB_FUTBOL
-- =============================================================================

INSERT INTO REGION (id_region, nombre) VALUES (1, 'Tarapaca');
INSERT INTO REGION (id_region, nombre) VALUES (2, 'Antofagasta');
INSERT INTO REGION (id_region, nombre) VALUES (3, 'Atacama');
INSERT INTO REGION (id_region, nombre) VALUES (4, 'Coquimbo');
INSERT INTO REGION (id_region, nombre) VALUES (5, 'Valparaiso');
INSERT INTO REGION (id_region, nombre) VALUES (8, 'Biobio');
INSERT INTO REGION (id_region, nombre) VALUES (13, 'Metropolitana');
INSERT INTO REGION (id_region, nombre) VALUES (15, 'Arica y Parinacota');
INSERT INTO REGION (id_region, nombre) VALUES (16, 'Nuble');


INSERT INTO COMUNA (id_comuna, id_region, nombre) VALUES (101, 13, 'Santiago');
INSERT INTO COMUNA (id_comuna, id_region, nombre) VALUES (102, 5, 'Valparaiso');
INSERT INTO COMUNA (id_comuna, id_region, nombre) VALUES (103, 8, 'Concepcion');
INSERT INTO COMUNA (id_comuna, id_region, nombre) VALUES (104, 2, 'Antofagasta');
INSERT INTO COMUNA (id_comuna, id_region, nombre) VALUES (105, 16, 'Chillan');


INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
    VALUES (25, 'Asociacion de Futbol de Santiago', TO_DATE('15-05-2001','DD-MM-YYYY'), 'P');
INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
    VALUES (26, 'Asociacion Nacional de Futbol Amateur', TO_DATE('10-03-1998','DD-MM-YYYY'), 'A');
INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
    VALUES (27, 'Asociacion de Futbol de Valparaiso', TO_DATE('21-07-1987','DD-MM-YYYY'), 'P');
INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
    VALUES (28, 'Asociacion de Futbol de Concepcion', TO_DATE('30-11-1995','DD-MM-YYYY'), 'A');
INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
    VALUES (29, 'Asociacion de Futbol de Antofagasta', TO_DATE('25-06-2003','DD-MM-YYYY'), 'P');
INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
    VALUES (30, 'Asociacion de Futbol de Temuco', TO_DATE('01-12-2010','DD-MM-YYYY'), 'A');
INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
    VALUES (31, 'Asociacion de Futbol de Rancagua', TO_DATE('08-09-1999','DD-MM-YYYY'), 'P');
INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
    VALUES (32, 'Asociacion de Futbol de Puerto Montt', TO_DATE('20-04-2005','DD-MM-YYYY'), 'A');
INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
    VALUES (33, 'Asociacion de Futbol de La Serena', TO_DATE('14-08-2012','DD-MM-YYYY'), 'P');
INSERT INTO ASOCIACION (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
    VALUES (34, 'Asociacion de Futbol de Chillan', TO_DATE('01-12-2018','DD-MM-YYYY'), 'A');


INSERT INTO NACIONALIDAD (descripcion) VALUES ('Chilena');
INSERT INTO NACIONALIDAD (descripcion) VALUES ('Argentina');
INSERT INTO NACIONALIDAD (descripcion) VALUES ('Peruana');
INSERT INTO NACIONALIDAD (descripcion) VALUES ('Boliviana');
INSERT INTO NACIONALIDAD (descripcion) VALUES ('Brasilena');


INSERT INTO CLUB_FUTBOL (id_club, nombre_club, patrimonio, direccion, tipo_club)
    VALUES (SEQ_CLUB_FUTBOL.NEXTVAL, 'Colo-Colo', 500000000, 'Av. Marathon 5300', 'Profesional');
INSERT INTO CLUB_FUTBOL (id_club, nombre_club, patrimonio, direccion, tipo_club)
    VALUES (SEQ_CLUB_FUTBOL.NEXTVAL, 'Universidad de Chile', 450000000, 'Av. El Parron 931', 'Profesional');
INSERT INTO CLUB_FUTBOL (id_club, nombre_club, patrimonio, direccion, tipo_club)
    VALUES (SEQ_CLUB_FUTBOL.NEXTVAL, 'Deportes Antofagasta', 180000000, 'Avenida Angamos 1606', 'Profesional');
INSERT INTO CLUB_FUTBOL (id_club, nombre_club, patrimonio, direccion, tipo_club)
    VALUES (SEQ_CLUB_FUTBOL.NEXTVAL, 'Huachipato', 220000000, 'Avenida Desiderio Garcia 909', 'Profesional');
INSERT INTO CLUB_FUTBOL (id_club, nombre_club, patrimonio, direccion, tipo_club)
    VALUES (SEQ_CLUB_FUTBOL.NEXTVAL, 'Nublense', 170000000, 'Avenida Pedro Aguirre Cerda 1003', 'Profesional');

COMMIT;


-- INFORME 1: asociaciones profesionales creadas despues del 2000
SELECT id_asociacion      AS "ID",
       nombre_asociacion  AS "ASOCIACION",
       fecha_creacion     AS "CREADA",
       tipo_asociacion    AS "TIPO"
  FROM ASOCIACION
 WHERE tipo_asociacion = 'P'
   AND EXTRACT(YEAR FROM fecha_creacion) > 2000
 ORDER BY fecha_creacion DESC;


-- INFORME 2: patrimonio en pesos y dolares (976)
SELECT id_club                              AS "CLUB",
       nombre_club                          AS "NOMBRE CLUB",
       patrimonio                           AS "PATRIMONIO EN PESOS",
       ROUND(patrimonio / 955, 2)           AS "PATRIMONIO EN DOLARES"
  FROM CLUB_FUTBOL
 WHERE LOWER(nombre_club) LIKE '%a%'
   AND patrimonio > 200000000
   AND UPPER(tipo_club) = 'PROFESIONAL'
 ORDER BY id_club DESC;

