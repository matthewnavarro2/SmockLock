var token = require('./createJWT.js');
const bcrypt = require('bcryptjs');
let {PythonShell} = require('python-shell')
var cron = require('node-cron');
const Net = require('net');
// let faceapi = require('./face-api.min.js')
// import { MongoCron } from 'mongodb-cron';
//Install node-cron using npm: $ npm install --save node-cron
//https://www.npmjs.com/package/node-cron

// var $ = require('jquery');

//load user model
// const User = require("./models/user.js");
// //load card model
// const Card = require("./models/card.js");

exports.setApp = function ( app, client )
{
    // ************************************ E KEY API ******************************************************
    //
    // *****************************************************************************************************
    cron.schedule('*/1 * * * *', async () => 
    {
      var date = new Date();
      var temp = new Date();
      
      array = [];
      error = '';
      
      try {
        const db = client.db();
        const eKeyResult = await db.collection('EKey').find({}).toArray();

        for( var i=0; i<eKeyResult.length; i++ )
        {
          var time = new Date(eKeyResult[i].tgo);
          console.log(eKeyResult[i].tgo);

          temp.setTime(time.getTime() - date.getTime());
          
          time.setTime(time.getTime());
          var delTime = {tgo:eKeyResult[i].tgo};
          
          array.push(time);
          
          if ((temp.getTime() < 60000))
          {
            const deleteResult = db.collection('EKey').deleteOne(delTime);
          }
        }
      } 
      catch (e) {
        console.log(e.message);
        error = e.message;
      }
      

      

      console.log(array);
      var ret = {results:delTime, error: error};
      
      res.status(200).json(ret);
     
    });



    app.post('/api/deleteEKey', async (req, res, next) => 
    {
        const {email, jwtToken} = req.body;

        try
        {
          if( token.isExpired(jwtToken))
          {
            var r = {error:'The JWT is no longer valid', jwtToken: ''};
            res.status(200).json(r);
            return;
          }
        }
        catch(e)
        {
          console.log(e.message);
        }

        // Variable Declaration
        var emailObj = {email:email};
        var error = '';

        // Connecting to database and searching for Pictures associated with User.
        try
        {
          const db = client.db();
          const result = await db.collection('EKey').deleteOne(emailObj).toArray();
        }

        // Prints error if failed
        catch(e)
        {
          
          console.log(e.message);
        }
        
        var refreshedToken = null;
        try
        {
          refreshedToken = token.refresh(jwtToken).accessToken;
        }
        catch(e)
        {
          console.log(e.message);
        }
      
        // return
        // return
        var ret = {Email:email, jwtToken: refreshedToken, error: error};
        res.status(200).json(ret);
        console.log(res);


    });

    // API for
    app.post('/api/listEKeys', async (req, res, next) => 
    {
      // incoming: userId, jwtToken
      // outgoing: picture, error

      // Grabbing picture from parameter
      const {userId, jwtToken} = req.body;

      // Checking to see if Token Expired
      try
      {
        if( token.isExpired(jwtToken))
        {
          var r = {error:'The JWT is no longer valid', jwtToken: ''};
          res.status(200).json(r);
          return;
        }
      }
      catch(e)
      {
        console.log(e.message);
      }

      if( results.length > 0 )
      {
        id = results[0].UserId;
        fn = results[0].FirstName;
        ln = results[0].LastName;


        try
        {
          const token = require("./createJWT.js");
           ret = {token: token.createToken( fn, ln, id )};
           // var ret = { results:_ret, error: error, jwtToken: refreshedToken };
        }
        catch(e)
        {
          ret = {error:e.message};
        }
      }
      // Variable Declaration
      var user = {userId:userId};
      var error = '';

      // Connecting to database and searching for Pictures associated with User.
      try
      {
        const db = client.db();
        const result = await db.collection('EKey').find(user).toArray();
        var _resultsarray = [];

        for( var i=0; i<result.length; i++ )
        {
        _resultsarray.push( result[i]);
        }
        
      }

      // Prints error if failed
      catch(e)
      {
        
        console.log(e.message);
      }
      var refreshedToken = null;
      try
      {
        refreshedToken = token.refresh(jwtToken).accessToken;
      }
      catch(e)
      {
        console.log(e.message);
      }
    
      // return
      // return
      var ret = {result_array: _resultsarray, jwtToken: refreshedToken, error: error};
      res.status(200).json(ret);
      console.log(res);
    });



    // API for
    app.post('/api/createEKey', async (req, res, next) => 
    {
      // incoming: pic, email/userid
      // outgoing: error

      // Grabbing picture from parameter must be in base64 format
      const {userId, fn, ln, email, tgo} = req.body;
      var guestId = 0;
      // Variable Declaration
      var resultsArray = [];
      var error = '';
      var expoDate = new Date();
      var timetogo = new Date();
      var time = new Date(tgo);
      // time in milliseconds
      expoDate.setTime(expoDate.getTime() + time.getTime());

     
      console.log(expoDate);
      timetogo.setTime(expoDate.getTime() - timetogo.getTime());
      // const time_remaining = (timetogo) => new Date(expoDate) - new Date();
      // const time_remaining = new Date(expoDate) - new Date();
      // Connecting to database and adding a picture
      try
      {
        const db = client.db();
        
        const eKeyResult = await db.collection('EKey').find().toArray();
        
        // console.log(eKeyResult);
        
        var _ret = [];
        for( var i=0; i<eKeyResult.length; i++ )
        {
          _ret.push( eKeyResult[i].guestId);
        }
        if(Math.max(..._ret) < 0) 
        {
          guestId = 0;
        }
        else
        {
          guestId = Math.max(..._ret) + 1;
        }
        

        var newKey = {guestId:guestId, firstname:fn, lastname:ln, userId:userId, email:email, tgo:timetogo};
      
        const result1 =  await db.collection('EKey').insertOne(newKey);
      }
      
      // Prints error if failed
      catch(e)
      {
        // console.log(eKeyResult);
        // console.log(resultsArray);
        console.log(e.message);
      }
      
      var current = new Date();
      var ret = {currentTime:current, results:newKey, error: error};
      
      res.status(200).json(ret);
    });  

   
    app.post('/api/socketTest', async (req, res, next) => 
    {
      const {macAdd} = req.body;
      const port = 80;
      var host = '';
      var error = '';
      
      try{
        const db = client.db();
        hostResult = await db.collection('Lock').find({MACAddress:macAdd}).toArray();
        host = hostResult[0].IP;
        console.log(hostResult[0]);
        console.log(host);
        
        // Create a new TCP client.
        const Sclient = new Net.Socket();
        // Send a connection request to the server.
        Sclient.connect({ port: port, host: host }, function() {
            // If there is no error, the server has accepted the request and created a new 
            // socket dedicated to us.
            console.log('TCP connection established with the server.');

            // The client can now send data to the server by writing to its socket.
            Sclient.write('Hello, server.');
            
        });

        // The client can also receive data from the server by reading from its socket.
        Sclient.on('data', function(chunk) {
            console.log(`Data received from the server: ${chunk.toString()}.`);
            
            // Request an end to the connection after the data has been received.
            
        });

        Sclient.on('end', function() {
            console.log('Requested an end to the TCP connection');
        }); 
        error = 'success';
      }
      catch(e)
      {
        error = e.message;
      }
      var ret = {error: error};
      
      res.status(200).json(ret);
    });

    // ************************************ LOCK API ******************************************************
    //
    // ****************************************************************************************************
    app.post('/api/updateIP', async (req, res, next) => 
    {
      const {macAdd, ip} = req.body;
      var error = '';
      
      try
      {
        const db = client.db();


        const ipResult = await db.collection('Lock').update({MACAddress: macAdd}, {$set: {IP: ip}});
        error = 'success';
      }
      catch(e)
      {
        error = e.message;
      }
      var ret = {error: error};
      
      res.status(200).json(ret);


    });

    app.post('/api/getLockMA', async (req, res, next) => 
    {
      const {macAdd} = req.body;
      var error = '';
      var result;
      try
      {
        const db = client.db();


        const lockResult = await db.collection('Lock').find({MACAddress: macAdd}).toArray();
        result = lockResult;
        error = 'success';
      }
      catch(e)
      {
        error = e.message;
      }
      var ret = {result: result, error: error};
      
      res.status(200).json(ret);


    });

    app.post('/api/getLockUI', async (req, res, next) => 
    {
      const {userId} = req.body;
      var error = '';
      var result, result2;
      tempUser = Number(userId);
      try
      {
        const db = client.db();


        const lockResult = await db.collection('Lock').find({MasterUserId:tempUser}).toArray();
        const lock2Result = await db.collection('Lock').find({AuthorizedUsers:userId}).toArray();
        result = lockResult;
        result2 = lock2Result;
        error = 'success';
      }
      catch(e)
      {
        error = e.message;
      }
      var ret = {result: result, result2: result2, error: error};
      
      res.status(200).json(ret);


    });


    

    app.post('/api/updateWifiStatus', async (req, res, next) =>
    {
      const {status, macAdd, userId} = req.body;
      var error = '';
      try
      {
        const db = client.db();

        const Result = await db.collection('Lock').update({MACAddress: macAdd}, {$set: {wifiStatus: status}});
        error = 'success';
      }
      catch(e)
      {
        error = e.message;
      }
      var ret = {error: error};
      
      res.status(200).json(ret);

    });

    app.post('/api/checkWifiStatus', async (req, res, next) =>
    {
      var error = '';
      var status;
      const {macAdd, userId} = req.body;
      try
      {
        const db = client.db();
        hostResult = await db.collection('Lock').find({MACAddress:macAdd}).toArray();
        status = hostResult[0].wifiStatus;
      }
      catch(e)
      {
        error = e.message;
      }
    
      var ret = {status: status, error: error};
      res.status(200).json(ret);

    });

    app.post('/api/linkLock', async (req, res, next) =>
    {
      const {macAdd, userId} = req.body;
      var error = '';
      var IP = '';
      var tier = '';
      var auth = [];
      var fp = [];
      var rfid = [];
      var wifiStatus = 0;

      var lockCollection = {MACAddress:macAdd, TierLevel:tier, MasterUserId:Number(userId), IP: IP, wifiStatus: wifiStatus, FingerPrintId:fp, RFID:rfid};

      try
      {
        const db = client.db();
        const macResult = await db.collection('Lock').find({MACAddress:macAdd}).toArray();
        if (macResult[0] == null )
        {
          const tierResult = await db.collection('Lock').insertOne(lockCollection);
        }
        else
        {
          error = 'could not add lock, existing lock already exists with matching MAC Address';
        }
          
      }
      catch(e)
      {
        error = e.message;
      }

      var ret = {lockCollection: lockCollection, error: error};
      
      res.status(200).json(ret);
    });

    // ************************************ AUTHORIZED USERS API ***********************************************
    //
    // *********************************************************************************************************
    app.post('/api/addAuthorizedUser', async (req, res, next) => 
    {
      const {plainCode, userId} = req.body;
      var error =''
      var message = '';
      var MasterUserId;
      
      



      try
      {
        const db = client.db();
        
        
        const code = await bcrypt.hash(plainCode, 10);
        const codeResult = await db.collection('Users').find({code:{$exists:true}}).toArray();
        console.log(code)
        console.log(codeResult.length);
        console.log(codeResult);
        if (codeResult.length == 0)
        {
          
          error = 'Could not add User no user has a matching code';
          

        }
        else
        {
          for (var i = 0; i < codeResult.length; i++)
          {
            let validCode = await bcrypt.compare(plainCode,codeResult[i].code);
            console.log(codeResult[i].code);
            console.log('^adminCode');
            console.log(validCode);
          
            if (validCode)
            {
              const result = db.collection('Users').updateOne(
              { "UserId" : codeResult[i].UserId },
              { $push: { "AuthorizedUsers" : userId } }
              );
    
              const lockresult = db.collection('Lock').updateOne(
              { "MasterUserId" : codeResult[i].UserId },
              { $push: { "AuthorizedUsers" : userId }}
              );
              
              message = 'successfully added Authorized User';
              break;
            }
            else
            {
              error = 'Could not add user because code is invalid.';
            }
          }
        
        }
        

        
      }
      catch(e)
      {
        error = e.message;
        console.log(e.message);
      }

      var ret = { error: error, message: message};
      
      res.status(200).json(ret);

    });

    app.post('/api/adminAddAuthorizedUser', async (req, res, next) => 
    {
      const {userId, guestUserId} = req.body;
      var error =''
      var message = '';

      try
      {
        const db = client.db();

        const lockResult = db.collection('Lock').find({MasterUserId:userId}).toArray();


        const result = db.collection('Users').updateOne(
          { "UserId" : userId },
          { $push: { "AuthorizedUsers" : guestUserId } }
          );

          const lockresult = db.collection('Lock').updateOne(
            { "MasterUserId" : userId },
            { $push: { "AuthorizedUsers" : guestUserId } }
            );
    

        message = 'successfully added Authorized User'
      }
      catch(e)
      {
        error = e.message;
        console.log(e.message);
      }

      var ret = { error: error, message: message};
      
      res.status(200).json(ret);

    });

    // ************************************ TIER API ******************************************************
    //
    // ****************************************************************************************************
    // called by lock
    app.post('/api/tierRequest', async (req, res, next) => 
    {
      const {macAdd} = req.body;
      
      var mac = {MACAddress:macAdd};
      var error = '';
      var tier;

      try
      {
        const db = client.db();
        
        const eKeyResult = await db.collection('Lock').find(mac).toArray();
        
    
        tier = eKeyResult[0].TierLevel;
      }
      
      // Prints error if failed
      catch(e)
      {
        error = e.message;
        console.log(e.message);
      }
      
      var ret = {tier: tier, error: error};
      
      res.status(200).json(ret);
    });

    app.post('/api/sendTier', async (req, res, next) =>
    {
      const {macAdd} = req.body;
      var error = '';
      var sTier = 0;
    
      try
      {
        const db = client.db();
        const result = await db.collection('Lock').find({MACAddress:macAdd}).toArray();   
        sTier = result[0].TierLevel;    
      }
      catch(e)
      {
        error = e.toString();
      }

      console.log(sTier);
    
      var ret = { error: error, sTier:sTier};
      
      res.status(200).json(ret);
    });

    app.post('/api/updateTier', async (req, res, next) =>
    {
      const {macAdd, tier} = req.body;
      


      try
      {
        const db = client.db();
        const result = await db.collection('Lock').update({MACAddress: macAdd}, {$set: {TierLevel: tier}});
        
        error = 'Updated Database'  
      }
      catch(e)
      {
        error = e.toString();
      }

      var ret = { error: error, result:result};
      
      res.status(200).json(ret);
    });
    // ************************************ FINGER API ******************************************************
    //                                      Lock Stuff
    // ******************************************************************************************************
    app.post('/api/compareFinger', async(req, res, next) => 
    {
      const {macAdd, fp} = req.body;
      var error = '';
      var fp1 
      var fpResult = 0;
      let userId = 0;
      var authUsers;
      let length = 0;
      var message = 'No Message'

      try
      {
        const db = client.db();
        
        
        const lockResult = await db.collection('Lock').find({MACAddress:macAdd}).toArray();
        
        
        userId = lockResult[0].MasterUserId;
        const usersResult = await db.collection('Users').find({UserId:userId}).toArray();
        
        const fpArray = lockResult[0].FingerPrintId;
   
        length = fpArray.length;
        for (var j = 0; j < length; j++)
        {

          if (lockResult[0].FingerPrintId[j] == fp)
          {
            authUsers = usersResult[0].AuthorizedUsers;
            const users1Result = await db.collection('Users').find({Fingerprint:fp}).toArray();
            fpResult = users1Result[0].UserId;
           
            message = 'Fingerprint Accepted, User Id:' + fpResult;
            error = '';
            
            break;
          }
          
          else
          {
            error = 'No Match Found'
          }

        }
      }
      
      // Prints error if failed
      catch(e)
      {
        error = e.message;
        console.log(e.message);
      }
      
      var ret = {userId: fpResult, message:message, error: error};
      
      res.status(200).json(ret);
    });

    app.post('/api/enrollFinger', async(req, res, next) => 
    {
      // user is gonna send message with lock saying i wanna enroll fingerprint and this is my userId so lock has userId and macAdd and will generate fp.
      const {macAdd, fp, userId} = req.body;
      var error = '';


      try
      {
        const db = client.db();
        const fpResult = await db.collection('Users').update({UserId: userId}, {$set: {Fingerprint: fp}});

        const rfidResult = db.collection('Lock').updateOne(
          { "MACAddress" : macAdd },
          { $push: { "FingerPrintId" : fp } }
          );

        const checkResult = db.collection('Lock').find(userId);
        if (checkResult == null)
        {
          const rfid1Result = db.collection('Lock').updateOne(
            { "MACAddress" : macAdd },
            { $push: { "AuthorizedUsers" : userId } }
            );
        }
        
        error = 'fingerprint has been added.';
        
      }
      
      // Prints error if failed
      catch(e)
      {
        error = e.message;
        console.log(e.message);
      }
      
      var ret = {fingerprint: fp, error: error};
      
      res.status(200).json(ret);
    });

    app.post('/api/getFingerId', async(req, res, next) => 
    {
      const {macAdd} = req.body;
      var error = '';
      var fingerArray = [];
      var newFingerId = 0;
      let faulty
      let string = '';

      try{
        const db = client.db();
        const lockResult = await db.collection('Lock').find({MACAddress:macAdd}).toArray();
        console.log(lockResult);
        fingerArray = lockResult[0].FingerPrintId;
        console.log(fingerArray);
        
        if (fingerArray.length == 127)
        {
          for (var i = 0; i < fingerArray.length;i++)
          {
            if (fingerArray[i] == 0)
            {
              faulty = i + 1;
              break;
            }
          }
          const result = await db.collection('Lock').updateOne(
            {"FingerPrintId":'0'},
            {$set: {"FingerPrintId.$":String(faulty)}}
            );
          const result1 = await db.collection('Lock').updateOne(
            {"FingerPrintId":0},
            {$set: {"FingerPrintId.$":String(faulty)}}
            );  
        }
        
        
        
        if (Math.max(...fingerArray) < 0)
        {
          error = 'No Finger Array'
        }
        else
        {
          newFingerId = Math.max(...fingerArray) + 1;
        }
        
      }
      catch(e)
      {
        error = e.message;
        console.log(e.message);
      }

      var ret = {newFpUserId: newFingerId, error: error};
      
      res.status(200).json(ret);

    });
    // ************************************ RFID API ******************************************************
    //                                     Lock Stuff
    // ****************************************************************************************************
    app.post('/api/enrollRFID', async(req, res, next) => 
    {
      const {macAdd, rfid, userId} = req.body;
      var error = '';
      

      try
      {
        const db = client.db();
        
        const userResult = await db.collection('Users').update({UserId: userId}, {$set: {RFID: rfid}});;

        const rfidResult = db.collection('Lock').updateOne(
          { "MACAddress" : macAdd },
          { $push: { "RFID" : rfid } }
          );

        const checkResult = db.collection('Lock').find(userId);
        if (checkResult == null)
        {
          const rfid1Result = db.collection('Lock').updateOne(
            { "MACAddress" : macAdd },
            { $push: { "AuthorizedUsers" : userId } }
            );
        }
        
        error = 'rfid has been added.';
        
      }
      
      // Prints error if failed
      catch(e)
      {
        error = e.message;
        console.log(e.message);
      }
      
      var ret = {rfid: rfid, error: error};
      
      res.status(200).json(ret);
    });

    // need to add checks to make sure something happens if nothing is loaded.
    app.post('/api/compareRFID', async(req, res, next) => 
    {
      const {macAdd, rfid} = req.body;
      var error = '';
      var userId;
      var authUsers;
      var message = '';
 
      var rf;
      let length = 0;
      var rfidResult;
      try
      {
        const db = client.db();
        
        
        const lockResult = await db.collection('Lock').find({MACAddress:macAdd}).toArray();
        userId = lockResult[0].MasterUserId;
        const usersResult = await db.collection('Users').find({UserId:userId}).toArray();
        const rfArray = lockResult[0].RFID;
        length = rfArray.length;
        for (var j = 0; j < length; j++)
        {

          if (lockResult[0].RFID[j] == rfid)
          {
  
            
            
            authUsers = usersResult[0].AuthorizedUsers;
            
            const rfResult = await db.collection('Users').find({RFID:rfid}).toArray();
            rfidResult = rfResult[0].UserId;
           
            message = 'RFID Accepted, User Id:' + rfidResult;
            error = '';
            
            break;
          }
          
          else
          {
            error = 'No Match Found'
          }

        }
      }
      
      // Prints error if failed
      catch(e)
      {
        error = e.message;
        console.log(e.message);
      }
      
      var ret = {userId: rfidResult, message:message, error: error};
      
      res.status(200).json(ret);
    });
    // ************************************ ESP32 API ******************************************************
    //
    //
    // *****************************************************************************************************
    app.post('/api/recievefromESP32', async (req, res, next) =>
    {
      //incoming 64bit encoding of pic
      //outgoing 64bit encoding of pic

      //post commands from the esp needed

      const {buffer} = req.body;

      var error = '';

      var newBuffer = {Buffer:buffer};

      console.log(newBuffer);

      try
      {
        const db = client.db();
        const result = db.collection('CameraPics').insertOne(newBuffer);
      }
      catch(e)
      {
        console.log(e.message);
      }

      var ret = {error: error};
      
      res.status(200).json(ret);

    });

    // ************************************ ADD PIC API ******************************************************
    //
    // *******************************************************************************************************

    // API for
    app.post('/api/addPic', async (req, res, next) => 
    {
      // incoming: pic, email/userid
      // outgoing: error

      // Grabbing picture from parameter
      const {name, pic, jwtToken} = req.body;

      // Checking to see if token has expired
      try
      {
        if( token.isExpired(jwtToken))
        {
          var r = {error:'The JWT is no longer valid', jwtToken: ''};
          res.status(200).json(r);
          return;
        }
      }
      catch(e)
      {
        console.log(e.message);
      }
      // Variable Declaration
      var newPic = {Name:name, Pic:pic};
      var error = '';

      // Connecting to database and adding a picture
      try
      {
        const db = client.db();
        const result = await db.collection('UserPics').insertOne(newPic);
        // this script looks at all the pictures in the User Pics once a new picture has been added
        // it then removes the old encoded document and adds a new encoded document
        
        // PythonShell.run("newCreate_encoding.py", null, function(err,results){
        //   console.log(results);
        //   console.log("Python script finished");
        // })
      }
      
      // Prints error if failed
      catch(e)
      {
        console.log(e.message);
      }
      var refreshedToken = null;
      try
      {
        refreshedToken = token.refresh(jwtToken).accessToken;
      }
      catch(e)
      {
        console.log(e.message);
      }
    
      // return
      var ret = {error: error, jwtToken:refreshedToken};
      
      res.status(200).json(ret);
    });
    

    // app.post('/api/detectFace', async (req, res, next) => 
    // {
    //   const {image} = req.body;
    //   let error = '';
    //   let message = '';
    //   faceapi.nets.tinyFaceDetector.loadFromUri('/models');

    //   try
    //   {
    //     const detections = await faceapi.detectAllFaces(image, new faceapi.TinyFaceDetectorOptions())
    //     if (!(detections))
    //     {
    //       error = 'No face detected in picture';
    //     } 
    //     else
    //     {
    //       message = 'face detected'
    //     }
    //     // this script looks at all the pictures in the User Pics once a new picture has been added
    //     // it then removes the old encoded document and adds a new encoded document
        
    //     // PythonShell.run("newCreate_encoding.py", null, function(err,results){
    //     //   console.log(results);
    //     //   console.log("Python script finished");
    //     // })
    //   }
      
    //   // Prints error if failed
    //   catch(e)
    //   {
    //     console.log(e.message);
    //   }
    //   var refreshedToken = null;
    //   try
    //   {
    //     refreshedToken = token.refresh(jwtToken).accessToken;
    //   }
    //   catch(e)
    //   {
    //     console.log(e.message);
    //   }
    
    //   // return
    //   var ret = {message: message, error: error, jwtToken:refreshedToken};
      
    //   res.status(200).json(ret);
    // });

 
    // ************************************ LIST PICS API ******************************************************
    //
    // *********************************************************************************************************
    // API for
    app.post('/api/listPics', async (req, res, next) => 
    {
      // incoming: userId, jwtToken
      // outgoing: picture, error

      // Grabbing picture from parameter
      const {userId, jwtToken} = req.body;

      // Checking to see if Token Expired
      try
      {
        if( token.isExpired(jwtToken))
        {
          var r = {error:'The JWT is no longer valid', jwtToken: ''};
          res.status(200).json(r);
          return;
        }
      }
      catch(e)
      {
        console.log(e.message);
      }


      // Variable Declaration
      var newPic = {UserId:userId};
      var error = '';

      // Connecting to database and searching for Pictures associated with User.
      try
      {
        const db = client.db();
        const result = await db.collection('UserPics').find().toArray();
        var _resultsarray = [];

        for( var i=0; i<result.length; i++ )
        {
        _resultsarray.push( result[i]);
        }
        
      }

      // Prints error if failed
      catch(e)
      {
        
        console.log(e.message);
      }
      var refreshedToken = null;
      try
      {
        refreshedToken = token.refresh(jwtToken).accessToken;
      }
      catch(e)
      {
        console.log(e.message);
      }
    
      // return
      // return
      var ret = {result_array: _resultsarray, jwtToken: refreshedToken, error: error};
      res.status(200).json(ret);
      console.log(res);
    });

    
    app.post('/api/addcard', async (req, res, next) =>
    {
      // incoming: userId, color
      // outgoing: error
        
      const { userId, card, jwtToken } = req.body;

      try
      {
        if( token.isExpired(jwtToken))
        {
          var r = {error:'The JWT is no longer valid', jwtToken: ''};
          res.status(200).json(r);
          return;
        }
      }
      catch(e)
      {
        console.log(e.message);
      }
    
      const newCard = {Card:card,UserId:userId};
      // const newCard = new Card({ Card: card, UserId: userId });
      var error = '';
    
      try
      {
        const db = client.db();
        const result = db.collection('Cards').insertOne(newCard);
        // newCard.save();        
      }
      catch(e)
      {
        error = e.toString();
      }
    
      var refreshedToken = null;
      try
      {
        refreshedToken = token.refresh(jwtToken).accessToken;
      }
      catch(e)
      {
        console.log(e.message);
      }
    
      var ret = { error: error, jwtToken: refreshedToken };
      
      res.status(200).json(ret);
    });

    app.post('/api/getUser', async (req, res, next) => 
    {
      const {userId} = req.body;
      var error = '';
      var result;
      
      try
      {
        const db = client.db();


        const userResult = await db.collection('Users').find({UserId: userId}).toArray();
        result = userResult;
        error = 'success';
      }
      catch(e)
      {
        error = e.message;
      }
      var ret = {result: result, error: error};
      
      res.status(200).json(ret);


    });
    
    app.post('/api/login', async (req, res, next) => 
    {
      // incoming: login, password
      // outgoing: id, firstName, lastName, error
    
     var error = '';
    
      const { login, password } = req.body;
    
      const db = client.db();
      const results = await db.collection('Users').find({Login:login}).toArray(); 
      // const verified = results[0].IsVerified; 
	  // console.log(password);
      // console.log(results[0].Password);
	  const validPassword = await bcrypt.compare(password,results[0].Password);
      // const results = await User.find({ Login: login, Password: password});
      // console.log(results);

      var id = -1;
      var fn = '';
      var ln = '';

	

      var ret;
    
      if( results.length > 0 )
      {
        id = results[0].UserId;
        fn = results[0].FirstName;
        ln = results[0].LastName;


        try
        {
          const token = require("./createJWT.js");
           ret = {token: token.createToken( fn, ln, id )};
           // var ret = { results:_ret, error: error, jwtToken: refreshedToken };
        }
        catch(e)
        {
          ret = {error:e.message};
        }
      }
      else
      {
          ret = {error:"Login/Password incorrect"};
      }
      // // check if verified
      // if ( verified == false){
      //     res.status(400).json({ error: "Check your email for code to verify your account!" });
      // }
      if(validPassword){
	      res.status(200).json(ret);
	  } else{
	    res.status(400).json({ error: "Invalid Password" });
	  }
    });
    
    app.post('/api/register', async (req, res, next) => 
    {

      // incoming: email, firstname, lastname, login, password
      // outgoing: status, error


      // connect to db
      const db = client.db();

      // req.body to pull the info from the webpage. 
      const { email, firstname, lastname, login, password: plainTextPassword, plainCode } = req.body

      if (!(plainCode))
      {
        plainCode = '';
      }
      // set userId to the unique username and email combo 
      const userId_array = await db.collection('Users').find().toArray();
        
      var arraylength = userId_array.length
	  
      // check if a user already has this id, 
      const id_check = await db.collection('Users').find({UserId:arraylength + 1}).toArray();
      // if the array bigger than 0 we need to fix our id. 
      if (id_check.length > 0)
      {
        console.log("TAKEN"); 
        arraylength = Math.floor(arraylength + 35 + (Math.random() * (500 - 1) + 1) + (Math.random() * (500 - 1) + 1)) ;
        console.log(arraylength); 
      }


      // bcrypt to encrypt password  
      const password = await bcrypt.hash(plainTextPassword, 10);
      const code = await bcrypt.hash(plainCode, 10);
      // // lets make an empty friends array.
      // let friends_array = [];
      // let defaultValue = 0;
        
      // // create key to verify.
      // let key = Math.floor(Math.random() * (9999 - 1000) + 1000);
        
      // console.log(key); 
      // let verify = false;

      // create a new user 
      const fullname = firstname + ' ' + lastname;
      var auth = [];
      var fingerprint = '';
      var rfid = '';
      const newUser = {Email:email, UserId: arraylength + 1, FirstName:firstname, LastName:lastname, FullName:fullname,
         Login:login, Password:password, Fingerprint:fingerprint, RFID:rfid, AuthorizedUsers:auth, code:code}; // add userid UserId:userId

      
      // check if email is taken,
      const email_check = await db.collection('Users').find({Email:email}).toArray();

      //console.log(email_check); 
      if(Array.isArray(email_check) && email_check.length)
      {
        // console.log('User Not created')
        return res.json({ status:'Email already taken!'})
      }

      // check if username is taken,
      const username_check = await db.collection('Users').find({Login:login}).toArray();
      if( Array.isArray(username_check) && username_check.length)
      {
        // console.log('User Not created')
        return res.json({ status:'UserName already taken!'})
      }

      // // SEND CONFIRM EMAIL:
      // const msg = {
      //   to: "" + email + "",
      //   from: "akbobsmith79@gmail.com",
      //   subject: "Here is your email buddy",
      //   text: "Enter this key: "+ key + "" 
      // };
      
      // sgMail.send(msg).then(() => {
      // console.log('Message sent')
      // }).catch((error) => {
      // console.log(error.response.body)
      // // console.log(error.response.body.errors[0].message)
      // }) 
    
      try{
        const new_user = await db.collection('Users').insertOne(newUser);
        console.log('User created')

      } 
      catch(e){
        // console.log(error)
        return res.json({ status:'error'})
      }

      res.json({status: 'All Good'});

    });

    app.post('/api/searchcards', async (req, res, next) => 
    {
      // incoming: userId, search
      // outgoing: results[], error
    
      var error = '';
    
      const { userId, search, jwtToken } = req.body;

      try
      {
        if( token.isExpired(jwtToken))
        {
          var r = {error:'The JWT is no longer valid', jwtToken: ''};
          res.status(200).json(r);
          return;
        }
      }
      catch(e)
      {
        console.log(e.message);
      }
      
      var _search = search.trim();
      
      const db = client.db();
      const results = await db.collection('Cards').find({"Card":{$regex:_search+'.*', $options:'r'}}).toArray();
      // const results = await Card.find({ "Card": { $regex: _search + '.*', $options: 'r' } });
            
      var _ret = [];
      for( var i=0; i<results.length; i++ )
      {
        _ret.push( results[i].Card );
      }
      
      var refreshedToken = null;
      try
      {
        refreshedToken = token.refresh(jwtToken).accessToken;
      }
      catch(e)
      {
        console.log(e.message);
      }
    
      var ret = { results:_ret, error: error, jwtToken: refreshedToken };
      
      res.status(200).json(ret);
    });
    
    app.post('/api/searchusers', async (req, res, next) => 
    {
      var error = '';
      const { search, jwtToken } = req.body;

      var _search = search.trim();

      const db = client.db();
      const results = await db.collection('Users').find({"FullName":{$regex:_search+'.', $options:'r'}}).toArray();

      var _resultsarray = [];

      for( var i=0; i<results.length; i++ )
      {
        _resultsarray.push( results[i]);
      }

      var refreshedToken = null;
      try
      {
        refreshedToken = token.refresh(jwtToken).accessToken;
      }
      catch(e)
      {
        console.log(e.message);
      }

      var ret = { results_array : _resultsarray, error: error, jwtToken: refreshedToken }; // fullName:_fullNameArray, email:_emailArray, userId:_userIdArray,

      res.status(200).json(ret);
    });
}

