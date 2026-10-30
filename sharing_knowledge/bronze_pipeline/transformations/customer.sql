CREATE OR REFRESH STREAMING TABLE bronze_customer
AS SELECT
  *,
  current_timestamp() AS extract_timestamp,
  _metadata.file_modification_time AS file_modification_time
FROM STREAM read_files(
  '/Volumes/workspace/dbsimas/data_file',
  format => 'csv',
  header => true,
  pathGlobFilter => 'customers_*.csv',
  schemaLocation => '/Volumes/workspace/dbsimas/data_schema/bronze_customer',
  schemaEvolutionMode => 'addNewColumns'
);