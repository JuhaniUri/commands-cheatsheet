# 1z0-071

```
CREATE TABLE cruise_orders (
    cruise_order_id  NUMBER,
    order_data       DATE,
    CONSTRAINT pk_co PRIMARY KEY ( cruise_order_id )
);

CREATE TABLE order_returns (
    order_return_id    NUMBER,
    cruise_order_id    NUMBER,
    cruise_order_data  DATE,
    CONSTRAINT pk_or PRIMARY KEY ( order_return_id ),
    CONSTRAINT pk_or_co FOREIGN KEY ( cruise_order_id )
        REFERENCES cruise_orders ( cruise_order_id )
);

SELECT
    *
FROM
    user_constraints;

CREATE TABLE port (
    port_id    NUMBER,
    port_name  VARCHAR(20),
    country    VARCHAR(40),
    capacity   NUMBER,
    CONSTRAINT port_pk PRIMARY KEY ( port_id )
);

CREATE TABLE ships (
    ship_id       NUMBER,
    ship_name     VARCHAR(20),
    home_port_id  NUMBER,
    CONSTRAINT ships_ports_fk FOREIGN KEY ( home_port_id )
        REFERENCES port ( port_id )
);

CREATE TABLE port2 (
    port_id    NUMBER
        CONSTRAINT port2_pk PRIMARY KEY,
    port_name  VARCHAR(20),
    country    VARCHAR(40),
    capacity   NUMBER
);

CREATE TABLE vendors (
    vendor_id    NUMBER,
    vendor_name  VARCHAR2(20),
    status       NUMBER(1) NOT NULL,
    category     VARCHAR2(5)
);

CREATE TABLE positions (
    position_id  NUMBER,
    postion      VARCHAR2(20),
    exempt       CHAR(1),
    CONSTRAINT positions_pk PRIMARY KEY ( position_id )
);

CREATE TABLE ports (
    port_id    NUMBER PRIMARY KEY,
    port_name  VARCHAR2(20)
);

CREATE TABLE cruises (
    cruise_id       NUMBER,
    cruise_type_id  NUMBER,
    cruise_name     VARCHAR(20),
    captain_id      NUMBER NOT NULL,
    start_date      DATE,
    end_date        DATE,
    status          VARCHAR(5) DEFAULT 'DOCK',
    CONSTRAINT cruise_pk PRIMARY KEY ( cruise_id )
);

```

