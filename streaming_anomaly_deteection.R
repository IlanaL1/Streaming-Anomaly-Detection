
require(devtools)
require(stream)
require(ff)
require(RMOA)
require(AnomalyDetection)

#Input anomaly detection for rainfall
Input<-read.csv("daily-rainfall-in-melbourne-aust.csv",sep=",",header=TRUE)
Input<-Input[-c(nrow(Input),nrow(Input)-1),]

colnames(Input)<-c("DATE_ID","TOTAL")
DATE_ID<-as.Date(Input[,1],format="%Y-%m-%d")
actuals<-as.numeric(Input[,2])
DATE_ID_P<-as.POSIXct(DATE_ID)
Ts_df<-data.frame(DATE_ID_P=DATE_ID_P,actuals=actuals)

# Test batch
s1<-Sys.time()
anoms_flat<-AnomalyDetectionTs(Ts_df, max_anoms=0.002, direction='both', plot=TRUE)
s2<-Sys.time()
time_batch<-s2-s1 #0.17seconds
write.csv(anoms_flat[["anoms"]], file="daily_rainfall_anoms_flat.csv")

# Iris trial 
require(ff)
irisff <- as.ffdf(factorise(iris))
x <- datastream_ffdf(data=irisff)
x$get_points(10)
x
x$get_points(10)
x

# Aomaly time-series detection with streaming
#test
myffdf <- as.ffdf(Ts_df)
mydatastream <- datastream_ffdf(data = myffdf) 
tmp<-mydatastream$get_points(100)
#% of anomolies should be 0.002*100/nrow(myffdf)
max_anoms_chunks<-0.002*100/nrow(myffdf)
anoms<-AnomalyDetectionTs(tmp, max_anoms=max_anoms_chunks, direction='both', plot=TRUE)

# Test accuracy and system.time()
myffdf <- as.ffdf(Ts_df)
mydatastream <- datastream_ffdf(data = myffdf) 
chunk_size<-200
max_anoms_chunks<-0.002*chunk_size/nrow(myffdf)
current_chunk<-mydatastream$get_points(chunk_size)
anoms_stream<-data.frame()
s1<-Sys.time()
while(!is.null(current_chunk)){
  anoms<-AnomalyDetectionTs(current_chunk, max_anoms=max_anoms_chunks, direction='both', plot=TRUE)
  anoms_stream<-rbind(anoms_stream,anoms$anoms)
  current_chunk<-mydatastream$get_points(chunk_size)
}
s2<-Sys.time()
time_stream<-s2-s1 #.951 seconds
write.csv(anoms_stream[["anoms"]], file="daily_rainfall_anoms_stream.csv")

time_stream-time_batch
#Time difference of 0.776355 secs

