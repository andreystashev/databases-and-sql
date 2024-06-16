-- создание таблицы, прогрузка csv файла
CREATE TABLE sample 
(
    staf_name     varchar(50),
    staff_age     int4,
    staff_id      varchar(50),
    staff_lang    varchar(50),
    order_pk      numeric,
    order_address varchar(50),
    order_country varchar(50),
    order_company varchar(50),
    order_price   float4,
    order_dt      timestamp,
    order_list    VARCHAR,
    cli_name      varchar(50),
    cli_email     varchar(50),
    cli_phone     varchar(50),
    cli_secret    varchar(50),
    c_token       varchar(64),
    c_pin         int4,
    c_gen         varchar(50),
    c_type        varchar(50)
)

-- заполнение пустых значений staff (name)

UPDATE sample AS t1
SET staf_name = subquery.staf_name
FROM (
    SELECT
        staff_id,
        MAX(staf_name) AS staf_name
    FROM sample
    WHERE staff_id != ''
    GROUP BY staff_id
    HAVING COUNT(*) > 1
) AS subquery
WHERE t1.staff_id = subquery.staff_id;

-- заполнение пустых значений staff (id)
UPDATE sample AS t1
SET staff_id = subquery.staff_id
FROM (
    SELECT
        staf_name,
        MAX(staff_id) AS staff_id
    FROM sample
    WHERE staf_name IS NOT NULL
    GROUP BY staf_name
    HAVING COUNT(*) > 1
) AS subquery
WHERE t1.staf_name = subquery.staf_name

-- заполнение пустых значений staff (age)
UPDATE sample AS t1
SET staff_age = subquery.staff_age
FROM (
    SELECT
        staf_name,
        MAX(staff_age) AS staff_age
    FROM sample
    WHERE staf_name IS NOT NULL
    GROUP BY staf_name
    HAVING COUNT(*) > 1
) AS subquery
WHERE t1.staf_name = subquery.staf_name

-- заполнение пустых значений staff (lang)
UPDATE sample AS t1
SET staff_lang = subquery.staff_lang
FROM (
    SELECT
        staf_name,
        MAX(staff_lang) AS staff_lang
    FROM sample
    WHERE staf_name IS NOT NULL
    GROUP BY staf_name
    HAVING COUNT(*) > 1
) AS subquery
WHERE t1.staf_name = subquery.staf_name

-- скорректировать опечатку в названии столбца
ALTER TABLE sample RENAME COLUMN staf_name TO staff_name;

-- создание таблицы с информацией по сотрудникам
CREATE TABLE staff as
SELECT distinct staff_id, staff_name, staff_age, staff_lang
FROM sample
order by staff_id;

CREATE TABLE IF NOT EXISTS info_staff (
staff_id VARCHAR(10) PRIMARY KEY,
staff_name VARCHAR(50),
staff_age integer,
staff_lang VARCHAR(50))

INSERT INTO info_staff (staff_id, staff_name, staff_age, staff_lang)
SELECT staff_id, staff_name, staff_age, staff_lang
FROM staff;

DROP TABLE IF EXISTS staff;

-- разбиение столбца с именем сотрудников
ALTER TABLE info_staff
    ADD COLUMN first_name VARCHAR(50) NOT NULL DEFAULT '',
    ADD COLUMN last_name VARCHAR(50) NOT NULL DEFAULT '';

UPDATE info_staff
SET first_name = REGEXP_SUBSTR(staff_name, '^\S+')

UPDATE info_staff
set last_name = REGEXP_SUBSTR(staff_name, '\S+$')
    
ALTER TABLE info_staff
    DROP COLUMN staff_name;
    
   
-- заполнение пустых значений order (order_pk)

UPDATE sample AS t1
SET order_pk = subquery.order_pk
FROM (
	SELECT
        order_address,
        MAX(order_pk) AS order_pk
    FROM sample
    WHERE order_address != ''
    GROUP BY order_address
    HAVING COUNT(*) > 1
) AS subquery
WHERE t1.order_address = subquery.order_address

-- заполнение пустых значений order (address)
UPDATE sample AS t1
SET order_address = subquery.order_address
FROM (
    SELECT
        order_pk,
        MAX(order_address) AS order_address
    FROM sample
    WHERE order_pk is not null 
    GROUP BY order_pk
    HAVING COUNT(*) > 1
) AS subquery
WHERE t1.order_pk = subquery.order_pk

-- заполнение пустых значений order (country)
UPDATE sample AS t1
SET order_country = subquery.order_country
FROM (
    SELECT
        order_address,
        MAX(order_country) AS order_country
    FROM sample
    WHERE order_address IS NOT NULL
    GROUP BY order_address
    HAVING COUNT(*) > 1
) AS subquery
WHERE t1.order_address = subquery.order_address

-- заполнение пустых значений order (company)
UPDATE sample AS t1
SET order_company = subquery.order_company
FROM (
    SELECT
        order_country,
        MAX(order_company) AS order_company
    FROM sample
    WHERE order_country IS NOT NULL
    GROUP BY order_country
    HAVING COUNT(*) > 1
) AS subquery
WHERE t1.order_country = subquery.order_country

-- заполнение пустых значений order (price)
UPDATE sample AS t1
SET order_price = subquery.order_price
FROM (
    SELECT
        order_address,
        MAX(order_price) AS order_price
    FROM sample
    WHERE order_address IS NOT NULL
    GROUP BY order_address
    HAVING COUNT(*) > 1
) AS subquery
WHERE t1.order_address = subquery.order_address

-- заполнение пустых значений order (dt)
UPDATE sample AS t1
SET order_dt = subquery.order_dt
FROM (
    SELECT
        order_address,
        MAX(order_dt) AS order_dt
    FROM sample
    WHERE order_address IS NOT NULL
    GROUP BY order_address
    HAVING COUNT(*) > 1
) AS subquery
WHERE t1.order_address = subquery.order_address

-- заполнение пустых значений order (list)
UPDATE sample AS t1
SET order_list = subquery.order_list
FROM (
    SELECT
        order_address,
        MAX(order_list) AS order_list
    FROM sample
    WHERE order_address IS NOT NULL
    GROUP BY order_address
    HAVING COUNT(*) > 1
) AS subquery
WHERE t1.order_address = subquery.order_address

-- заполнение пустых значений clients (email)
UPDATE sample AS t1
SET cli_email = subquery.cli_email
FROM (
    SELECT
        cli_name,
        MAX(cli_email) AS cli_email
    FROM sample
    WHERE cli_name IS NOT NULL
    GROUP BY cli_name
    HAVING COUNT(*) > 1
) AS subquery
WHERE t1.cli_name = subquery.cli_name

-- заполнение пустых значений clients (name)
UPDATE sample AS t1
SET cli_name = subquery.cli_name
FROM (
    SELECT
        cli_email,
        MAX(cli_name) AS cli_name
    FROM sample
    WHERE cli_email IS NOT NULL
    GROUP BY cli_email
    HAVING COUNT(*) > 1
) AS subquery
WHERE t1.cli_email = subquery.cli_email

-- заполнение пустых значений clients (phone)
UPDATE sample AS t1
SET cli_phone = subquery.cli_phone
FROM (
    SELECT
        cli_name,
        MAX(cli_phone) AS cli_phone
    FROM sample
    WHERE cli_name IS NOT NULL
    GROUP BY cli_name
    HAVING COUNT(*) > 1
) AS subquery
WHERE t1.cli_name = subquery.cli_name

-- заполнение пустых значений  (secret)
UPDATE sample AS t1
SET cli_secret = subquery.cli_secret
FROM (
    SELECT
        cli_name,
        MAX(cli_secret) AS cli_secret
    FROM sample
    WHERE cli_name IS NOT NULL
    GROUP BY cli_name
    HAVING COUNT(*) > 1
) AS subquery
WHERE t1.cli_name = subquery.cli_name

-- создание таблицы с информацией по клиентам
CREATE TABLE info_cli as 
SELECT distinct
cli_name, 
cli_email,
cli_phone,
cli_secret
FROM sample;

ALTER TABLE info_cli
ADD cli_id serial primary key;

-- заполнение пустых значений cargo (pin)
UPDATE sample AS t1
SET c_pin = subquery.c_pin
FROM (
    select distinct
        c_pin,
        c_token
    FROM sample
    WHERE c_token != '' and c_pin IS NOT null
) AS subquery
WHERE t1.c_token = subquery.c_token

-- заполнение пустых значений cargo (gen)
UPDATE sample AS t1
SET c_gen = subquery.c_gen
FROM (
    select distinct
        c_token,
        c_gen
    FROM sample
    WHERE c_gen != '' and c_token != ''
) AS subquery
WHERE t1.c_token = subquery.c_token

-- заполнение пустых значений cargo (type)
UPDATE sample AS t1
SET c_type = subquery.c_type
FROM (
    select distinct
        c_token,
        c_type
    FROM sample
    WHERE c_type != '' and c_token != ''
) AS subquery
WHERE t1.c_token = subquery.c_token

-- заполнение пустых значений cargo (token)
UPDATE sample AS t1
SET c_token = subquery.c_token
FROM (
    select distinct
        c_token,
        c_gen,
        c_pin
    FROM sample
    WHERE c_gen != '' and c_token != ''
) AS subquery
WHERE t1.c_pin = subquery.c_pin and t1.c_gen = subquery.c_gen

UPDATE sample AS t1
SET c_token = subquery.c_token
FROM (
    select distinct
        c_token,
        c_type,
        c_pin
    FROM sample
    WHERE c_type != '' and c_token != ''
) AS subquery
WHERE t1.c_pin = subquery.c_pin and t1.c_type = subquery.c_type



-- создание таблицы с информацией по заказам и грузам с разбивкой массива
CREATE TABLE orders_list as
SELECT distinct order_pk, order_address, unnest(string_to_array(order_list, ',')) as order_list
FROM sample
order by order_pk

ALTER TABLE orders_list ADD order_id integer NULL;

ALTER TABLE orders_list ADD FOREIGN KEY (order_id) REFERENCES info_orders (order_id);

UPDATE orders_list AS t1
SET order_id = subquery.order_id
FROM (
    select distinct
        order_address,
        order_pk,
        order_id
    FROM info_orders
    ) AS subquery
WHERE t1.order_pk = subquery.order_pk

ALTER TABLE orders_list DROP COLUMN order_address;

ALTER TABLE orders_list DROP COLUMN order_pk;


-- создание таблицы с информацией по заказу и сотруднику
CREATE TABLE staff_orders as 
SELECT distinct
order_address, 
staff_id
FROM sample

ALTER TABLE staff_orders ADD order_id integer NULL;

ALTER TABLE staff_orders ADD FOREIGN KEY (order_id) REFERENCES info_orders (order_id);

UPDATE staff_orders AS t1
SET order_id = subquery.order_id
FROM (
    select distinct
        order_address,
        order_id
    FROM info_orders
    ) AS subquery
WHERE t1.order_address = subquery.order_address

ALTER TABLE staff_orders DROP COLUMN order_address;

-- создание таблицы с информацией по грузу
CREATE TABLE info_cargo as
SELECT distinct c_pin, c_token,  c_gen, c_type
FROM sample
order by c_pin;

ALTER TABLE info_cargo
ADD c_id serial primary key;

-- создание таблицы с информацией по заказам
CREATE TABLE info_orders as
SELECT distinct order_pk, order_address, order_country, order_company, order_price, order_dt
FROM sample
order by order_pk;


ALTER TABLE info_orders
ADD order_id serial primary key;


-- создание внешнего ключа со staff
ALTER TABLE staff_orders ADD CONSTRAINT staff_orders_fk FOREIGN KEY (staff_id) REFERENCES info_staff(staff_id);


-- создание таблицы с информ заказ-адрес-получатель-пин
CREATE TABLE orders_cli as
SELECT distinct order_pk, order_address, cli_name, c_pin 
FROM sample
order by order_pk;

ALTER TABLE orders_cli ADD cli_id integer NULL;

ALTER TABLE orders_cli ADD FOREIGN KEY (cli_id) REFERENCES info_cli (cli_id);

update orders_cli
set cli_id =(
select cli_id 
from info_cli 
where info_cli.cli_name = orders_cli.cli_name);

ALTER TABLE orders_cli DROP COLUMN cli_name;

ALTER TABLE orders_cli ADD order_id integer NULL;

ALTER TABLE orders_cli ADD FOREIGN KEY (order_id) REFERENCES info_orders (order_id);

UPDATE orders_cli AS t1
SET order_id = subquery.order_id
FROM (
    select distinct
        order_address,
        order_pk,
        order_id
    FROM info_orders
    ) AS subquery
WHERE t1.order_pk = subquery.order_pk

ALTER TABLE orders_cli DROP COLUMN order_pk;

ALTER TABLE orders_cli ADD CONSTRAINT orders_cli_fk FOREIGN KEY (cli_id) REFERENCES info_cli(cli_id);

-- создание таблицы с информ секретное слово-токен-пин-клиент
CREATE TABLE secret_key as SELECT distinct cli_name, cli_secret, c_token, c_pin 
FROM sample
order by cli_name;

ALTER TABLE secret_key ADD cli_id integer NULL;

ALTER TABLE secret_key ADD FOREIGN KEY (cli_id) REFERENCES info_cli (cli_id);

update secret_key
set cli_id =(
select cli_id 
from info_cli 
where info_cli.cli_name = secret_key.cli_name);

ALTER TABLE secret_key DROP COLUMN cli_name;

-- создание таблицы с информ заказ-груз

CREATE TABLE orders_cargo as SELECT distinct order_pk, order_address, c_token, c_pin 
FROM sample
order by order_pk;

ALTER TABLE orders_cargo ADD order_id integer NULL;

ALTER TABLE orders_cargo ADD FOREIGN KEY (order_id) REFERENCES info_orders (order_id);

UPDATE orders_cargo AS t1
SET order_id = subquery.order_id
FROM (
    select distinct
        order_address,
        order_pk,
        order_id
    FROM info_orders
    ) AS subquery
WHERE t1.order_pk = subquery.order_pk

ALTER TABLE orders_cargo DROP COLUMN order_pk;
ALTER TABLE orders_cargo DROP COLUMN order_address;

ALTER TABLE orders_cargo ADD c_id integer NULL;

ALTER TABLE orders_cargo ADD FOREIGN KEY (c_id) REFERENCES info_cargo (c_id);


UPDATE orders_cargo AS t1
SET c_id = subquery.c_id
FROM (
    select distinct
        c_pin,
        c_token,
        c_id
    FROM info_cargo
    ) AS subquery
WHERE t1.c_token = subquery.c_token

ALTER TABLE orders_cargo DROP COLUMN c_pin;

-- разбиение столбца с именем клиентов
ALTER TABLE info_cli
    ADD COLUMN first_name VARCHAR(50) NOT NULL DEFAULT '',
    ADD COLUMN last_name VARCHAR(50) NOT NULL DEFAULT '';

UPDATE info_cli
SET first_name = REGEXP_SUBSTR(cli_name, '^\S+')

UPDATE info_cli
set last_name = REGEXP_SUBSTR(cli_name, '\S+$')
    
ALTER TABLE info_cli
    DROP COLUMN cli_name;
