-- PRY2204 Semana 8 - Taller Mecánico Mikes Ltda.


-- =============================================================================
-- CASO 1: modelo
-- primero las tablas sin FK, después las que dependen de ellas
-- =============================================================================

CREATE TABLE PAIS (
    id_pais   NUMBER(3)      GENERATED ALWAYS AS IDENTITY (START WITH 9 INCREMENT BY 3),
    nom_pais  VARCHAR2(30)   NOT NULL
);

ALTER TABLE PAIS ADD CONSTRAINT PAIS_PK PRIMARY KEY (id_pais);


CREATE TABLE MARCA (
    id_marca     NUMBER(2)      NOT NULL,
    descripcion  VARCHAR2(20)   NOT NULL
);

ALTER TABLE MARCA ADD CONSTRAINT MARCA_PK PRIMARY KEY (id_marca);


CREATE TABLE TIPO_AUTOMOVIL (
    id_tipo      CHAR(3)        NOT NULL,
    descripcion  VARCHAR2(20)   NOT NULL
);

ALTER TABLE TIPO_AUTOMOVIL ADD CONSTRAINT TIPOAUTOMOVIL_PK PRIMARY KEY (id_tipo);


CREATE TABLE SERVICIO (
    id_servicio  NUMBER(3)       NOT NULL,
    descripcion  VARCHAR2(100)   NOT NULL,
    costo        NUMBER(7)       NOT NULL
);

ALTER TABLE SERVICIO ADD CONSTRAINT SERVICIO_PK PRIMARY KEY (id_servicio);


CREATE TABLE CIUDAD (
    id_ciudad    NUMBER(3)      NOT NULL,
    nom_ciudad   VARCHAR2(30)   NOT NULL,
    cod_pais     NUMBER(3)      NOT NULL
);

ALTER TABLE CIUDAD ADD CONSTRAINT CIUDAD_PK PRIMARY KEY (id_ciudad);

ALTER TABLE CIUDAD ADD CONSTRAINT CIUDAD_FK_PAIS FOREIGN KEY (cod_pais)
    REFERENCES PAIS (id_pais);


CREATE TABLE MODELO (
    id_modelo    NUMBER(5)      NOT NULL,
    marca_id     NUMBER(2)      NOT NULL,
    descripcion  VARCHAR2(20)   NOT NULL
);

ALTER TABLE MODELO ADD CONSTRAINT MODELO_PK PRIMARY KEY (id_modelo, marca_id);

ALTER TABLE MODELO ADD CONSTRAINT MODELO_FK_MARCA FOREIGN KEY (marca_id)
    REFERENCES MARCA (id_marca);


CREATE TABLE SUCURSAL (
    id_sucursal   CHAR(3)        NOT NULL,
    nom_sucursal  VARCHAR2(20)   NOT NULL,
    calle         VARCHAR2(20)   NOT NULL,
    num_calle     NUMBER(4)      NOT NULL,
    cod_ciudad    NUMBER(3)      NOT NULL
);

ALTER TABLE SUCURSAL ADD CONSTRAINT SUCURSAL_PK PRIMARY KEY (id_sucursal);

ALTER TABLE SUCURSAL ADD CONSTRAINT SUCURSAL_FK_CIUDAD FOREIGN KEY (cod_ciudad)
    REFERENCES CIUDAD (id_ciudad);


CREATE TABLE CLIENTE (
    rut         NUMBER(8)      NOT NULL,
    dv          CHAR(1)        NOT NULL,
    p_nombre    VARCHAR2(20)   NOT NULL,
    s_nombre    VARCHAR2(20),
    a_paterno   VARCHAR2(20)   NOT NULL,
    a_materno   VARCHAR2(20)   NOT NULL,
    telefono    VARCHAR2(12),
    email       VARCHAR2(40),
    tipo_cli    CHAR(1)        NOT NULL
);

ALTER TABLE CLIENTE ADD CONSTRAINT CLIENTE_PK PRIMARY KEY (rut);


CREATE TABLE ESTANDAR (
    cl_rut                 NUMBER(8)    NOT NULL,
    porcentaje_fidelidad   NUMBER(10)   NOT NULL
);

ALTER TABLE ESTANDAR ADD CONSTRAINT ESTANDAR_PK PRIMARY KEY (cl_rut);

ALTER TABLE ESTANDAR ADD CONSTRAINT ESTANDAR_FK_CLIENTE FOREIGN KEY (cl_rut)
    REFERENCES CLIENTE (rut);


CREATE TABLE PREMIUM (
    cl_rut          NUMBER(8)    NOT NULL,
    pesos_credito   NUMBER(10)   NOT NULL
);

ALTER TABLE PREMIUM ADD CONSTRAINT PREMIUM_PK PRIMARY KEY (cl_rut);

ALTER TABLE PREMIUM ADD CONSTRAINT PREMIUM_FK_CLIENTE FOREIGN KEY (cl_rut)
    REFERENCES CLIENTE (rut);


CREATE TABLE AUTOMOVIL (
    patente       CHAR(8)        NOT NULL,
    anio          NUMBER(4)      NOT NULL,
    cant_puertas  NUMBER(1)      NOT NULL,
    km            NUMBER(6),
    color         VARCHAR2(30)   NOT NULL,
    tipo_auto     CHAR(3)        NOT NULL,
    cod_modelo    NUMBER(5)      NOT NULL,
    marca_id      NUMBER(2)      NOT NULL,
    cl_rut        NUMBER(8)      NOT NULL
);

ALTER TABLE AUTOMOVIL ADD CONSTRAINT AUTOMOVIL_PK PRIMARY KEY (patente);

ALTER TABLE AUTOMOVIL ADD CONSTRAINT AUTOMOVIL_FK_CLIENTE FOREIGN KEY (cl_rut)
    REFERENCES CLIENTE (rut);

ALTER TABLE AUTOMOVIL ADD CONSTRAINT AUTOMOVIL_FK_MODELO FOREIGN KEY (cod_modelo, marca_id)
    REFERENCES MODELO (id_modelo, marca_id);

ALTER TABLE AUTOMOVIL ADD CONSTRAINT AUTOMOVIL_FK_TIPO FOREIGN KEY (tipo_auto)
    REFERENCES TIPO_AUTOMOVIL (id_tipo);


CREATE TABLE MECANICO (
    id_mecanico      NUMBER(5)      GENERATED ALWAYS AS IDENTITY (START WITH 460 INCREMENT BY 7),
    p_nombre         VARCHAR2(20)   NOT NULL,
    s_nombre         VARCHAR2(20),
    a_paterno        VARCHAR2(20)   NOT NULL,
    a_materno        VARCHAR2(20)   NOT NULL,
    bono_jefatura    NUMBER(10),
    sueldo           NUMBER(10)     NOT NULL,
    monto_impuestos  NUMBER(10)     NOT NULL,
    cod_supervisor   NUMBER(5)
);

ALTER TABLE MECANICO ADD CONSTRAINT MECANICO_PK PRIMARY KEY (id_mecanico);

-- el jefe es otro mecánico de la misma tabla
ALTER TABLE MECANICO ADD CONSTRAINT MECANICO_FK_MECANICO FOREIGN KEY (cod_supervisor)
    REFERENCES MECANICO (id_mecanico);


CREATE TABLE MANTENCION (
    num_mantencion  NUMBER(4)      NOT NULL,
    cod_sucursal    CHAR(3)        NOT NULL,
    fecha_ingreso   DATE           NOT NULL,
    fecha_salida    DATE,
    patente_auto    CHAR(8),
    cod_mecanico    NUMBER(5)      NOT NULL,
    costo_total     NUMBER(7),
    estado          VARCHAR2(15)
);

ALTER TABLE MANTENCION ADD CONSTRAINT MANTENCION_PK PRIMARY KEY (num_mantencion);

ALTER TABLE MANTENCION ADD CONSTRAINT MANT_FK_AUTOMOVIL FOREIGN KEY (patente_auto)
    REFERENCES AUTOMOVIL (patente);

ALTER TABLE MANTENCION ADD CONSTRAINT MANT_FK_MECANICO FOREIGN KEY (cod_mecanico)
    REFERENCES MECANICO (id_mecanico);

ALTER TABLE MANTENCION ADD CONSTRAINT MANT_FK_SUCURSAL FOREIGN KEY (cod_sucursal)
    REFERENCES SUCURSAL (id_sucursal);


CREATE TABLE DETALLE_SERVICIO (
    mantencion_num  NUMBER(4)      NOT NULL,
    cod_servicio    NUMBER(3)      NOT NULL,
    descuento       NUMBER(4,3),
    cantidad        NUMBER(3)      NOT NULL
);

ALTER TABLE DETALLE_SERVICIO ADD CONSTRAINT DETALLE_PK PRIMARY KEY (mantencion_num, cod_servicio);

ALTER TABLE DETALLE_SERVICIO ADD CONSTRAINT DET_SERV_FK_MANTENCION FOREIGN KEY (mantencion_num)
    REFERENCES MANTENCION (num_mantencion);

ALTER TABLE DETALLE_SERVICIO ADD CONSTRAINT DET_SERV_FK_SERVICIO FOREIGN KEY (cod_servicio)
    REFERENCES SERVICIO (id_servicio);


-- =============================================================================
-- CASO 2: reglas nuevas con ALTER TABLE
-- =============================================================================

ALTER TABLE MANTENCION DROP COLUMN costo_total;

-- la mantención se identifica por número + sucursal, hay que tocar también DETALLE
ALTER TABLE DETALLE_SERVICIO DROP CONSTRAINT DET_SERV_FK_MANTENCION;
ALTER TABLE DETALLE_SERVICIO DROP CONSTRAINT DETALLE_PK;
ALTER TABLE MANTENCION DROP CONSTRAINT MANTENCION_PK;

ALTER TABLE MANTENCION ADD CONSTRAINT MANTENCION_PK PRIMARY KEY (num_mantencion, cod_sucursal);

ALTER TABLE DETALLE_SERVICIO ADD (cod_sucursal CHAR(3) NOT NULL);

ALTER TABLE DETALLE_SERVICIO ADD CONSTRAINT DETALLE_PK
    PRIMARY KEY (mantencion_num, cod_sucursal, cod_servicio);

ALTER TABLE DETALLE_SERVICIO ADD CONSTRAINT DET_SERV_FK_MANTENCION
    FOREIGN KEY (mantencion_num, cod_sucursal)
    REFERENCES MANTENCION (num_mantencion, cod_sucursal);

-- UNIQUE deja pasar varios nulos, el email queda opcional y sin repetirse
ALTER TABLE CLIENTE ADD CONSTRAINT CLIENTE_UN_EMAIL UNIQUE (email);

ALTER TABLE CLIENTE ADD CONSTRAINT CLIENTE_CK_DV
    CHECK (dv IN ('0','1','2','3','4','5','6','7','8','9','K'));

ALTER TABLE MECANICO ADD CONSTRAINT MECANICO_CK_SUELDO
    CHECK (sueldo >= 510000);

ALTER TABLE MANTENCION ADD CONSTRAINT MANTENCION_CK_ESTADO
    CHECK (estado IN ('Reserva','Ingresado','Entregado','Anulado'));


-- =============================================================================
-- CASO 3: poblamiento
-- =============================================================================

CREATE SEQUENCE SEQ_SERVICIO
    START WITH 400
    INCREMENT BY 2;

CREATE SEQUENCE SEQ_CIUDAD
    START WITH 165
    INCREMENT BY 5;


-- el id no va en el insert, lo pone la identidad
INSERT INTO PAIS (nom_pais) VALUES ('Chile');
INSERT INTO PAIS (nom_pais) VALUES ('Peru');
INSERT INTO PAIS (nom_pais) VALUES ('Colombia');


INSERT INTO CIUDAD (id_ciudad, nom_ciudad, cod_pais)
    VALUES (SEQ_CIUDAD.NEXTVAL, 'Santiago', 9);
INSERT INTO CIUDAD (id_ciudad, nom_ciudad, cod_pais)
    VALUES (SEQ_CIUDAD.NEXTVAL, 'Lima', 12);
INSERT INTO CIUDAD (id_ciudad, nom_ciudad, cod_pais)
    VALUES (SEQ_CIUDAD.NEXTVAL, 'Bogota', 15);


INSERT INTO SUCURSAL (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad)
    VALUES ('01', 'Providencia', 'Av. A. Varas', 234, 165);
INSERT INTO SUCURSAL (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad)
    VALUES ('02', 'Las 4 esquinas', 'Av. Latina', 669, 170);
INSERT INTO SUCURSAL (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad)
    VALUES ('03', 'El Cafetero', 'Av. El Faro', 900, 175);


INSERT INTO SERVICIO (id_servicio, descripcion, costo)
    VALUES (SEQ_SERVICIO.NEXTVAL, 'Cambio Luces', 45000);
INSERT INTO SERVICIO (id_servicio, descripcion, costo)
    VALUES (SEQ_SERVICIO.NEXTVAL, 'Desabolladura', 67000);
INSERT INTO SERVICIO (id_servicio, descripcion, costo)
    VALUES (SEQ_SERVICIO.NEXTVAL, 'Revision Frenos', 30000);
INSERT INTO SERVICIO (id_servicio, descripcion, costo)
    VALUES (SEQ_SERVICIO.NEXTVAL, 'Cambio Puerta Trasera', 50000);


-- van en este orden para que el supervisor ya exista cuando lo referencian
INSERT INTO MECANICO (p_nombre, s_nombre, a_paterno, a_materno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
    VALUES ('Jorge', 'Pablo', 'Soto', 'Sierpe', 540000, 2759000, 223580, NULL);
INSERT INTO MECANICO (p_nombre, s_nombre, a_paterno, a_materno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
    VALUES ('Pedro', 'Jose', 'Manriquez', 'Corral', NULL, 759000, 23980, NULL);
INSERT INTO MECANICO (p_nombre, s_nombre, a_paterno, a_materno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
    VALUES ('Sandra', 'Josefa', 'Letelier', 'S.', 0, 659000, 22358, 460);
INSERT INTO MECANICO (p_nombre, s_nombre, a_paterno, a_materno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
    VALUES ('Felipe', 'M.', 'Vidal', 'A.', NULL, 759000, 23580, 460);
INSERT INTO MECANICO (p_nombre, s_nombre, a_paterno, a_materno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
    VALUES ('Jose', 'Miguel', 'Troncoso', 'B.', NULL, 659000, 44580, 474);
INSERT INTO MECANICO (p_nombre, s_nombre, a_paterno, a_materno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
    VALUES ('Juan', 'Pablo', 'Sanchez', 'R.', NULL, 859000, 22380, 474);
INSERT INTO MECANICO (p_nombre, s_nombre, a_paterno, a_materno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
    VALUES ('Carlos', 'Felipe', 'Soto', 'J.', 0, 597000, 23580, 474);
INSERT INTO MECANICO (p_nombre, s_nombre, a_paterno, a_materno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
    VALUES ('Alberto', 'P.', 'Cerda', 'Ramirez', NULL, 559000, 22380, 460);
INSERT INTO MECANICO (p_nombre, s_nombre, a_paterno, a_materno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
    VALUES ('Alejandra', 'Gabriela', 'Infanti', 'R.', NULL, 659000, 22380, 460);
INSERT INTO MECANICO (p_nombre, s_nombre, a_paterno, a_materno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
    VALUES ('Roberto', 'Patricio', 'Gutierrez', 'Sosa', NULL, 859000, 22380, 460);


INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
    VALUES (101, '01', TO_DATE('12-04-2023','DD-MM-YYYY'), NULL, NULL, 481, 'Reserva');
INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
    VALUES (102, '02', TO_DATE('21-02-2023','DD-MM-YYYY'), TO_DATE('21-02-2023','DD-MM-YYYY'), NULL, 502, 'Entregado');
INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
    VALUES (103, '02', TO_DATE('09-10-2023','DD-MM-YYYY'), NULL, NULL, 502, 'Anulado');
INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
    VALUES (104, '03', TO_DATE('11-08-2023','DD-MM-YYYY'), TO_DATE('18-08-2023','DD-MM-YYYY'), NULL, 509, 'Entregado');
INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
    VALUES (105, '03', TO_DATE('03-12-2023','DD-MM-YYYY'), NULL, NULL, 509, 'Ingresado');

COMMIT;


-- =============================================================================
-- CASO 4: informes
-- =============================================================================

-- INFORME 1
-- bono nulo e impuesto bajo 40000; Jose (44580) queda fuera
SELECT id_mecanico                              AS "ID MECANICO",
       p_nombre || ' ' || a_paterno             AS "NOMBRE MECANICO",
       sueldo                                   AS "SALARIO",
       monto_impuestos                          AS "IMPUESTO ACTUAL",
       monto_impuestos * 0.8                    AS "IMPUESTO REBAJADO",
       sueldo - (monto_impuestos * 0.8)         AS "SUELDO CON REBAJA IMPUESTOS"
  FROM MECANICO
 WHERE bono_jefatura IS NULL
   AND monto_impuestos < 40000
 ORDER BY monto_impuestos DESC,
          a_paterno ASC;


-- INFORME 2
-- sueldo entre 600 mil y 900 mil, o sin supervisor
SELECT id_mecanico                                          AS "IDENTIFICADOR",
       p_nombre || ' ' || s_nombre || ' ' || a_paterno      AS "MECANICO",
       sueldo                                               AS "SALARIO ACTUAL",
       sueldo * 0.05                                        AS "AJUSTE",
       sueldo * 1.05                                        AS "SUELDO_REAJUSTADO"
  FROM MECANICO
 WHERE sueldo BETWEEN 600000 AND 900000
    OR cod_supervisor IS NULL
 ORDER BY sueldo ASC,
          p_nombre || ' ' || s_nombre || ' ' || a_paterno DESC;
