use ecommerce;
desc ecommerce_sales;
select * from ecommerce_sales;

alter table ecommerce_sales modify order_id varchar(30);

alter table ecommerce_sales modify customer_id varchar(20);

alter table ecommerce_sales modify ship_mode varchar(20);

update ecommerce_sales set ship_mode = 'unknown' where trim(ship_mode) = '';

update ecommerce_sales set ship_mode = upper(ship_mode);
 
set sql_safe_updates = 0;

select upper(ship_mode)from ecommerce_sales;

alter table ecommerce_sales modify customer_name varchar(30);

update ecommerce_sales set customer_name = 'unknown' where trim(customer_name) = '';

update ecommerce_sales set customer_name = upper(customer_name); 

alter table ecommerce_sales modify gender varchar(10);

update ecommerce_sales set gender = 'unknown' where trim(gender) = '';

update ecommerce_sales set gender = upper(gender); 

select * from ecommerce_sales where customer_id is null;

alter table ecommerce_sales modify customer_type varchar(20);
  
update ecommerce_sales set customer_type = 'unknown' where trim(customer_type) = '';

update ecommerce_sales set customer_type = upper(customer_type); 

alter table ecommerce_sales modify segment varchar(20);

update ecommerce_sales set segment = 'unknown' where trim(segment) = ''; 

update ecommerce_sales set segment = upper(segment);  

alter table ecommerce_sales modify country varchar(20);

update ecommerce_sales set country = 'russia' where trim(country) = '';

update ecommerce_sales set country = upper(country);  

alter table ecommerce_sales modify city varchar(15);

update ecommerce_sales set city = 'ahmadabad' where trim(city) = '';

update ecommerce_sales set city = upper(city);  

alter table ecommerce_sales modify state varchar(20);

update ecommerce_sales set state = 'gujarat' where trim(state) = '';

update ecommerce_sales set state = upper(state);  

alter table ecommerce_sales modify region varchar(10);

update ecommerce_sales set region = 'unknown' where trim(region) = '';

update ecommerce_sales set region = upper(region); 

alter table ecommerce_sales modify product_id varchar(20);

alter table ecommerce_sales modify category varchar(30);

update ecommerce_sales set category = 'unknown' where trim(category) =''; 

update ecommerce_sales set category = upper(category);  

alter table ecommerce_sales modify sub_category varchar(20);

update ecommerce_sales set sub_category = 'unknown' where trim(sub_category) ='';

update ecommerce_sales set sub_category = upper(sub_category);  

alter table ecommerce_sales modify product_name varchar(20);

update ecommerce_sales set product_name = 'unknown' where trim(product_name) ='';

update ecommerce_sales set product_name = upper(product_name); 

alter table ecommerce_sales modify brand varchar(15);

update ecommerce_sales set brand = 'unknown' where trim(brand) = '';

update ecommerce_sales set brand = upper(brand); 

alter table ecommerce_sales modify payment_method varchar(20);

update ecommerce_sales set payment_method = 'unknown' where trim(payment_method) ='';

update ecommerce_sales set payment_method = upper(payment_method); 

alter table ecommerce_sales modify order_status varchar(20);

update ecommerce_sales set order_status = 'unknown' where trim(order_status) ='';

update ecommerce_sales set order_status = upper(order_status); 

alter table ecommerce_sales modify return_flag varchar(10);

update ecommerce_sales set return_flag = 'N/A' where trim(return_flag) ='';

update ecommerce_sales set return_flag = 'Yes' where return_flag = "Y";

update ecommerce_sales set return_flag = upper(return_flag);

alter table ecommerce_sales modify coupon_used varchar(10);

update ecommerce_sales set coupon_used = 'N/A' where trim(coupon_used) ='';

update ecommerce_sales set coupon_used = "Yes" where coupon_used = "Y";

update ecommerce_sales set coupon_used = upper(coupon_used);
 
alter table ecommerce_sales modify customer_satisfaction varchar(30);

update ecommerce_sales set customer_satisfaction = 'unknown' where trim(customer_satisfaction) ='';

update ecommerce_sales set customer_satisfaction = upper(customer_satisfaction);

alter table ecommerce_sales drop column notes;

select * from ecommerce_sales;

desc ecommerce_sales;

alter table ecommerce_sales modify age int;

update ecommerce_sales set age = 40 where age = "forty";

set sql_safe_updates = 0;

select avg(age) from ecommerce_sales;

update ecommerce_sales set age = 23 where trim(age) ='';

update ecommerce_sales set postal_code = 508255 where postal_code = "N/A";

update ecommerce_sales set postal_code = 500001 where trim(postal_code) ='';

alter table ecommerce_sales modify postal_code int;

select avg(quantity) from ecommerce_sales;

update ecommerce_sales set quantity = 3 where trim(quantity) ='';

alter table ecommerce_sales modify quantity int;

alter table ecommerce_sales modify discount_pct decimal(3,2);

update ecommerce_sales set sales = REGEXP_REPLACE(trim(sales),'[^0-9.]', '');

set sql_safe_updates = 0;

alter table ecommerce_sales modify sales decimal(15,2);

select * from ecommerce_sales;

update ecommerce_sales set unit_price = REGEXP_REPLACE(trim(unit_price),'[^0-9.]', '');

alter table ecommerce_sales modify unit_price decimal(12,2);

select avg(cost) from ecommerce_sales;

update ecommerce_sales set cost = 136012.32590333308 where trim(cost) ='';

alter table ecommerce_sales modify cost decimal(15,2);

select avg(profit) from ecommerce_sales;

update ecommerce_sales set  profit = 54177.38588533328 where trim(profit) ='';

alter table ecommerce_sales modify profit decimal(15,2);

select avg(rating) from ecommerce_sales;

update ecommerce_sales set rating = 3 where trim(rating) ='';

alter table ecommerce_sales modify rating int; 

select avg(delivery_days) from ecommerce_sales;

update ecommerce_sales set delivery_days = 3 where trim(delivery_days) ='';

alter table ecommerce_sales modify delivery_days int;

update ecommerce_sales
set discount_pct =
    cast(
        replace(trim(discount_pct),
'%', '')
       as decimal(5,2)
   ) / 100
where discount_pct like '%\%%';

alter table ecommerce_sales modify discount_pct decimal(5,2); 

desc ecommerce_sales;

select * from ecommerce_sales;

select order_date,ship_date from ecommerce_sales limit 20;

update ecommerce_sales set order_date = nullif(trim(order_date), ''),ship_date = nullif(trim(ship_date), '');

select distinct order_date from ecommerce_sales where order_date is not null limit 100;

select * from ecommerce_sales;

SELECT 
    order_date,
    CASE
        WHEN TRIM(order_date) REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
            THEN STR_TO_DATE(TRIM(order_date), '%m/%d/%Y')

        WHEN TRIM(order_date) REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
            THEN STR_TO_DATE(TRIM(order_date), '%d-%m-%Y')

        WHEN TRIM(order_date) REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN STR_TO_DATE(TRIM(order_date), '%Y-%m-%d')

        ELSE NULL
    END AS converted_date
FROM ecommerce_sales
LIMIT 100;


UPDATE ecommerce_sales
SET order_date =
CASE
    WHEN order_date IS NULL OR TRIM(order_date) = ''
        THEN NULL

    WHEN TRIM(order_date) REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
        THEN DATE_FORMAT(
            STR_TO_DATE(TRIM(order_date), '%m/%d/%Y'),
            '%Y-%m-%d'
        )

    WHEN TRIM(order_date) REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
        THEN DATE_FORMAT(
            STR_TO_DATE(TRIM(order_date), '%d-%m-%Y'),
            '%Y-%m-%d'
        )

    WHEN TRIM(order_date) REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN DATE_FORMAT(
            STR_TO_DATE(TRIM(order_date), '%Y-%m-%d'),
            '%Y-%m-%d'
        )

    ELSE NULL
END;


SELECT 
   ship_date,
    CASE
        WHEN TRIM(ship_date) REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
            THEN STR_TO_DATE(TRIM(ship_date), '%m/%d/%Y')

        WHEN TRIM(ship_date) REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
            THEN STR_TO_DATE(TRIM(ship_date), '%d-%m-%Y')

        WHEN TRIM(ship_date) REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN STR_TO_DATE(TRIM(ship_date), '%Y-%m-%d')

        ELSE NULL
    END AS converted_date
FROM ecommerce_sales
LIMIT 100;


UPDATE ecommerce_sales
SET ship_date =
CASE
    WHEN ship_date IS NULL OR TRIM(ship_date) = ''
        THEN NULL

    WHEN TRIM(ship_date) REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
        THEN DATE_FORMAT(
            STR_TO_DATE(TRIM(ship_date), '%m/%d/%Y'),
            '%Y-%m-%d'
        )

    WHEN TRIM(ship_date) REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
        THEN DATE_FORMAT(
            STR_TO_DATE(TRIM(ship_date), '%d-%m-%Y'),
            '%Y-%m-%d'
        )

    WHEN TRIM(ship_date) REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN DATE_FORMAT(
            STR_TO_DATE(TRIM(ship_date), '%Y-%m-%d'),
            '%Y-%m-%d'
        )

    ELSE NULL
END;


select * from ecommerce_sales;

alter table ecommerce_sales modify order_date date,
modify ship_date date;

SELECT COUNT(*) AS both_null
FROM ecommerce_sales
WHERE order_date IS NULL
  AND ship_date IS NULL;
  
update ecommerce_sales
set order_date = '2025-01-01',
    ship_date = '2025-01-01'
where order_date is NULL
 and ship_date is NULL;    
