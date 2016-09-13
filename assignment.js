/**
 * Assignment Fetcher
 * 
 * @author Jared Allard <jaredallard@outlook.com>
 * @license MIT
 * @version 1.0.0
 **/

'use strict';

const http = require('http');
const url  = require('url')

let HOST, 
    PORT;
    
// Check for docker container link.
let backend_string = process.env.BACKEND_1_PORT;
let backend_url    = url.parse(db_string);

if(backend_string) {
  console.log('I: Found Backend on', backend_string);
  HOST = db_url.hostname;
  PORT = db_url.port;
}

http.get({
   host: HOST || '172.17.0.1',
   port: PORT || 8080,
   path: '/v1/assignments/by-id/'+process.env.ASSIGNMENTID
}, response => {
   // Continuously update stream with data
   var body = '';
   response.on('data', function(d) {
       body += d;
   });

   response.on('end', function() {
     let o = JSON.parse(body);

     if(o.success === false) {
       process.exit(1);
     }

     process.stdout.write(o.data.info.repo);
   });
});
