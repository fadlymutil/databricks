
CREATE OR REFRESH MATERIALIZED VIEW gold_customer_order
(
    -- 1. LOG (default): average transaction value within a reasonable range.
    --    Violations are counted in the event log; rows are still written.
    CONSTRAINT qa_reasonable_quantity
        EXPECT (order_quantity BETWEEN 1 AND 2),

    -- 2. DROP ROW: gross revenue must be non-negative.
    --    Violating rows are excluded from the target; pipeline continues.
    CONSTRAINT qa_valid_amount
        EXPECT (order_amount >= 0) ON VIOLATION DROP ROW,

    -- 3. FAIL UPDATE: product must be populated.
    --    Any violation aborts the whole pipeline update with the constraint name.
    CONSTRAINT qa_valid_customer
        EXPECT (customer_id IS NOT NULL) ON VIOLATION FAIL UPDATE
)
AS SELECT
  order_id,
  customer_id,
  TRY_CAST(total_amount AS DOUBLE)   AS order_amount,
  TRY_CAST(quantity AS INT)    AS order_quantity,
  TRY_CAST(unit_price AS DOUBLE)    AS order_unit_price,
  TRY_CAST(discount_amount AS DOUBLE)    AS order_discount_amount,
  file_modification_time       AS source_timestamp

FROM silver_order;