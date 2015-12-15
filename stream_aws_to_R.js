// File - compare 3 different anomalous methods on Nikolay Leptov labelled anomaly dataset
// twitters R package "anomaly"
// NodeJS package "Anomaly"
// ?? Egads - forecasting approach
// Constructs an ensemble of these methods... 

// http://docs.aws.amazon.com/AWSJavaScriptSDK/guide/node-examples.html

// load aws-sdk
var AWS=require('aws-sdk');

// update region
AWS.config.update({region: 'ap-northeast-1'});

// construct a service
var s3 = new AWS.S3({region: 'ap-southeast-1'});
// s3.getObject({Bucket: 'anomaly-detection-s3', Key: 'test/sample_input'});

// list buckets  ## works
s3.listBuckets(function(err, data) {
  if (err) { console.log("Error:", err); }
  else {
    for (var index in data.Buckets) {
      var bucket = data.Buckets[index];
      console.log("Bucket: ", bucket.Name, ' : ', bucket.CreationDate);
    }
  }
});


// streaming works
var params = {Bucket: 'anomaly-detection-s3', Key: 'test/sample_input'};
var file = require('fs').createWriteStream('tmp_output.csv');
s3.getObject(params).createReadStream().pipe(file);

// https://www.npmjs.com/package/awssum-amazon-s3
// maybe we can just stream a "chunk", or stream into node environment saving on I/O to disk processing// Hagen?

// call to R... 
// https://www.npmjs.com/package/rstats
// need node-gyp installed: https://www.npmjs.com/package/node-gyp
// need RInside, RJSONIO
//ubuntu issues with nodejs https://www.jsilky.com/2014/10/17/nodejs-on-ubuntu-debian-this-failure-might-be-due-to-the-use-of-legacy-binary-node/


var rstats  = require('rstats');
var R  = new rstats.session();
//R.parseEvalQ("cat('\n Hello World \n')");
R.parseEvalQ("tmp=read.csv('./tmp_output.csv')"); // Read in file from anomaly-detection.csv
R.parseEvalQ("library('AnomalyDetection')");
R.parseEvalQ("anoms_flat<-AnomalyDetectionTs(tmp, max_anoms=0.002, direction='both',plot=FALSE)");
var anoms=R.get("anoms_flat[['anoms']]");

// inspect 

var util=require('util')
console.log(util.inspect(anoms))

// create a bucket 
// uplaod to bucket

//var s3 = new AWS.S3({params: {Bucket: 'anom_output_bucket', Key: 'myKey'}});
//s3.createBucket(function(err) {
//  if (err) { console.log("Error:", err); }
//  else {
//    s3.upload({Body: 'Hello!'}, function() {
//      console.log("Successfully uploaded data to anom_output_bucket/myKey");
//    });
//  }
//});

// - save as a file and upload... 
// call back function - asynchronous function has a call back function as last parameter
// call back function function(err,data) - if function is successful returns data, else error object

var s3 = new AWS.S3({region: 'ap-southeast-1'});
var fs = require('fs');

//var body = fs.createReadStream('bigfile').pipe(zlib.createGzip());
debugger;
var params = {Bucket: 'anom-output-bucket', Key: 'myKey', Body: anoms};
s3.upload(params, function(err, data) {
  console.log(err, data);
});

var fs = require('fs');
var zlib = require('zlib');



var body = fs.createReadStream('anoms_results');
var s3obj = new AWS.S3({params: {Bucket: 'myBucket', Key: 'myKey'}});
s3obj.upload({Body: body}).
  on('httpUploadProgress', function(evt) { console.log(evt); }).
  send(function(err, data) { console.log(err, data) });









