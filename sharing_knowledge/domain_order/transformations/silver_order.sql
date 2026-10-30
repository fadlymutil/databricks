CREATE TEMPORARY VIEW bronze_orders_clean
AS SELECT *
FROM STREAM bronze_order
WHERE _rescued_data IS NULL;

CREATE OR REFRESH STREAMING TABLE silver_order
CLUSTER BY (order_id)
TBLPROPERTIES (delta.enableRowTracking = true);

CREATE FLOW silver_orders_flow
AS AUTO CDC INTO silver_order
FROM STREAM bronze_orders_clean
KEYS (order_id)
SEQUENCE BY file_modification_time
STORED AS SCD TYPE 1;