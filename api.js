var token = require('./createJWT.js');
const bcrypt = require('bcryptjs');
let {PythonShell} = require('python-shell')
var cron = require('node-cron');
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
        var email = {email:email};
        var error = '';

        // Connecting to database and searching for Pictures associated with User.
        try
        {
          const db = client.db();
          const result = await db.collection('EKey').deleteOne(email).toArray();
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

    // since we know what lock is associated with which userId, we need to search for approved users 
    // ...
    // ...
    // ...
    // ...
    // ...
    // ...
    // ...
    // end


    app.post('/api/updateIP', async (req, res, next) => 
    {
      const {macAdd, ip} = req.body;

      
      try
      {
        const db = client.db();


        const ipResult = await db.collection('Lock').Update({MACAddress: macAdd}, {$set: {IP: ip}});
        error = 'success';
      }
      catch(e)
      {
        error = e.message;
      }
      var ret = {error: error};
      
      res.status(200).json(ret);


    });


    app.post('/api/updateTier', async (req, res, next) =>
    {

    });
    // 
    app.post('/api/linkLock', async (req, res, next) =>
    {
      const {macAdd, userId} = req.body;

      var IP = '';
      var tier = '';
      var auth = [];
      var lockCollection = {MACAddress:macAdd, TierLevel:tier, MasterUserId:userId, IP: IP};

      try
      {
        const db = client.db();


        // lets search for the authorized users, and add it as a field in the lock collection. ( we can do this by search the userId passed and finding his collection and uploading their authorized users array
        // since their authorized users array will contain everyone.) make separate api for this.
        // ...
        // ...
        // const authResult = await db.collection('Users').find({UserId:userId});
        // auth = authResult.AuthorizedUsers;
        // ...
        // ...
        // ...
        // ...
        // end


        const tierResult = await db.collection('Lock').insertOne(lockCollection);
      }
      catch(e)
      {
        error = e.message;
      }

      var ret = {lockCollection: lockCollection, error: error};
      
      res.status(200).json(ret);
    });


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
        
        const eKeyResult = await db.collection('Lock').find(mac);
        
    
        tier = eKeyResult.TierLevel;
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

    // Start
    // the bottom stuff all will be added to users collection so make do with those variabbles
    // its also possible that when comparing fingers we have multiple fingers so make sure to do an array and check both.
    // now we dont need to make enroll fingers have multiple fingers to send we can do one at time.
    app.post('/api/compareFinger', async(req, res, next) => 
    {

    });

    app.post('/api/enrollFinger', async(req, res, next) => 
    {

    });

    app.post('/api/enrollRFID', async(req, res, next) => 
    {

    });

    app.post('/api/compareRFID', async(req, res, next) => 
    {
      
    });
    // 
    //
    // 
    // End
    
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

    app.post('/api/sendTier', async (req, res, next) =>
    {
      var error = '';
      var sTier = 0;
    
      try
      {
        const db = client.db();
        const result = await db.collection('DBSecurity').find().toArray();   
        sTier = result[0].sTier;    
      }
      catch(e)
      {
        error = e.toString();
      }

      console.log(sTier);
    
      var ret = { error: error, sTier:sTier};
      
      res.status(200).json(ret);
    });

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
      const { email, firstname, lastname, login, password: plainTextPassword  } = req.body

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
      const password = await bcrypt.hash(plainTextPassword, 10)
      
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
      const newUser = {Email:email, UserId: arraylength + 1, FirstName:firstname, LastName:lastname, FullName:fullname,
         Login:login, Password:password, AuthorizedUsers:auth}; // add userid UserId:userId

      
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

