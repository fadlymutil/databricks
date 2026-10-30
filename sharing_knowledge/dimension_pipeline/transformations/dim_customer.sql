CREATE TEMPORARY VIEW bronze_customers_clean
AS SELECT *
FROM STREAM bronze_customer
WHERE _rescued_data IS NULL;

CREATE OR REFRESH STREAMING TABLE dim_customer
CLUSTER BY (customer_id)
TBLPROPERTIES (delta.enableRowTracking = true);

CREATE FLOW dim_customer_flow
AS AUTO CDC INTO dim_customer
FROM STREAM bronze_customers_clean
KEYS (customer_id)
SEQUENCE BY file_modification_time
STORED AS SCD TYPE 1;