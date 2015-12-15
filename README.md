# Streaming-Anomaly-Detection


To run:
Create input and output tables. 
Input table  column fields must follow types defined in table "ILANA"."ts_model"
Output table  column fields must follow types defined in table ILANA."anomalies_model"

The output will contain one row for each anomaly detected shwoing the time-stamp and value of the anomaly. 

Example usage:

CALL getAnomalies("input_ts", "anoms") with OVERVIEW;
