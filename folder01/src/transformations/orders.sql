CREATE OR REFRESH STREAMING TABLE bronze_orders
AS SELECT
  *,
  current_timestamp() AS extract_timestamp,
  _metadata.file_modification_time AS file_modification_time
FROM STREAM read_files(
  '/Volumes/labuser16159962_1791254849/vintage_audio/data',
  format => 'csv',
  header => true,
  pathGlobFilter => 'orders_*.csv',
  schemaLocation => '/Volumes/labuser16159962_1791254849/dbsimas/schemas/bronze_orders/',
  schemaEvolutionMode => 'addNewColumns'
);