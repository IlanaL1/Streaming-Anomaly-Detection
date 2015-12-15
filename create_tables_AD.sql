
--input model
DROP TABLE "ts_model";
CREATE COLUMN TABLE "ts_model"(
TIMESTAMP_ID TIMESTAMP, 
TOTAL DOUBLE
);	

-- Table AD1 entered manually. Contains anomaly detection data. 
SELECT * FROM AD1;

DROP TABLE "input_ts";
CREATE TABLE "input_ts" as (SELECT "timestamp" as TIMESTAMP_ID, "count" as TOTAL FROM AD1 ORDER BY "timestamp");

SELECT * FROM "input_ts";

-- output model
DROP TABLE "anomalies_model";
CREATE COLUMN TABLE "anomalies_model"(
TIMESTAMP_ID TIMESTAMP, 
ANOMS DOUBLE
);

-- Create output table for actual values
DROP TABLE "anoms";
CREATE COLUMN TABLE "anoms" LIKE "anomalies_model" WITH NO DATA;



