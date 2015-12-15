--- Name: getFourierTerms
--- Pre-conditions: 
--- Post-conditions:
--- Function: Fill in missing dates 
DROP PROCEDURE getAnomalies;
CREATE PROCEDURE getAnomalies(IN timeseries "ts_model" , OUT anoms "anomalies_model") 
LANGUAGE RLANG AS
BEGIN

library("AnomalyDetection")	
library("zoo")
	
# timeseries
DATE_ID=c(timeseries$TIMESTAMP_ID)
actuals=c(timeseries$TOTAL)

timex<-as.POSIXct(DATE_ID,origin="1900-01-01")
#actuals=coredata(x)
Ts_df<-data.frame(DATE_ID_P=timex,actuals=actuals)

anoms<-AnomalyDetectionTs(Ts_df, max_anoms=0.002, direction='both', plot=FALSE)

tmp1=as.POSIXct(anoms$anoms$timestamp,origin="1900-01-01")
tmp2<-anoms$anoms$anoms

anoms<-data.frame(
TIMESTAMP_ID=tmp1,
ANOMS=tmp2
)

END;

