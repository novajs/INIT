/**
 * FETCH ALL THE THINGS.
 **/

'use strict';

const http = require('http');

http.get({
   host: '172.17.0.1',
   port: 8000,
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
