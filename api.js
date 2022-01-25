var token = require('./createJWT.js');
const bcrypt = require('bcryptjs');
let {PythonShell} = require('python-shell')
// var $ = require('jquery');

//load user model
// const User = require("./models/user.js");
// //load card model
// const Card = require("./models/card.js");

exports.setApp = function ( app, client )
{
    // const {spawn} = require('child_process');

    // // API test for python script of create_encoding.py
    // app.post('/api/pythonScript', (req, res) => {
 
    //   const {userId, image, jwtToken} = req.body;
    //   var dataToSend;

    //   // the create_encoding uses a folder of images. So we can do this all at once. So grab all the images people have associated with them. And it will be one encoding document.
    //   // creating_encoding assume we are in base64 format
    //   const python = spawn('python', ['create_encoding.py', image]);
    //   // collect data from script
    //   python.stdout.on('data', function (data) {
    //    console.log('Pipe data from python script ...');
    //    dataToSend = data.toString();
    //   });

      

    //   // in close event we are sure that stream from child process is closed
    //   python.on('close', (code) => {
    //     console.log(`child process close all stdio with code ${code}`);

    //   newImage = {UserId:userId, Encoding:dataToSend, jwtToken:jwtToken}

    //   // Connecting to database and searching for Pictures associated with User.
    //   try
    //   {
    //     const db = client.db();
    //     const result = db.collection('Pics').insertOne(newImage);

    //     for( var i=0; i<resultEncodings.length; i++ )
    //     {
    //     _resultsarray.push( resultEncodings[i]);
    //     }

    //     // looking for recent image from the lock itself
    //     const resultImages = await db.collection('Pics').find().toArray();
    //     // were only checking the most recent image added to database.
    //     var arraylength = resultImages.length;
    //     espImage = resultImages[arraylength].Pic;

    //   }

    //   // Prints error if failed
    //   catch(e)
    //   {
        
    //     console.log(e.message);
    //   }

    //   for (var i = 0;i < _resultsarray.length; i++)
    //   {
    //     // spawn new child process to call the python script
    //     const python = spawn('python', ['esp.py', _resultsarray[i].EncodedImages, espImage]);

    //     // collect data from script
    //     python.stdout.on('data', function (data) {
    //       console.log('Pipe data from python script ...');
    //       dataToSend = data.toString();
    //     });
 
       
 
    //    // in close event we are sure that stream from child process is closed
    //    python.on('close', (code) => {
    //     console.log(`child process close all stdio with code ${code}`);
 
    //    });
    //   }

      

    // });

    // API for
    app.post('/api/cameraAddPic', async (req, res, next) => 
    {
      // incoming: pic, email/userid
      // outgoing: error

      // Grabbing picture from parameter must be in base64 format
      const {/*userId, */pic} = req.body;

      
      // Variable Declaration
      var newPic = {/*userId,*/ Pic:pic};
      var error = '';

      // Connecting to database and adding a picture
      try
      {
        const db = client.db();
        const result = db.collection('CameraPics').insertOne(newPic);

        // // looking for encoded images associated with the lock
        // const db = client.db();
        // const resultEncodings = await db.collection('Encodings').find({"LockID":lockId}).toArray();
        // var _resultsarray = [];

        // for( var i=0; i<resultEncodings.length; i++ )
        // {
        // _resultsarray.push( resultEncodings[i]);
        // }

        // // looking for recent image from the lock itself
        // const resultImages = await db.collection('Pics').find().toArray();
        // // were only checking the most recent image added to database.
        // var arraylength = resultImages.length;
        // espImage = resultImages[arraylength].Pic;
        
      }
      
      // Prints error if failed
      catch(e)
      {
        console.log(e.message);
      }
      
      // for (var i = 0;i < _resultsarray.length; i++)
      // {
      //   // spawn new child process to call the python script
      //   const python = spawn('python', ['esp.py', _resultsarray[i].EncodedImages, espImage]);


      // }

      /* collect data from script
      python.stdout.on('data', function (data) {
       console.log('Pipe data from python script ...');
       dataToSend = data.toString();
      });

      */

      // // in close event we are sure that stream from child process is closed
      // python.on('close', (code) => {
      // console.log(`child process close all stdio with code ${code}`);

      // });
      // return
      var ret = {error: error};
      
      res.status(200).json(ret);
    });  

    app.post('/api/recievefromESP32', async (req, res, next) =>
    {
      //incoming 64bit encoding of pic
      //outgoing 64bit encoding of pic

      const {picEncoding, bufferlen} = req.body;

      //encode
      var encodedStringBtoA = btoa(picEncoding);


      try
      {
        const db = client.db();
        const result = db.collection('CameraPics').insertOne(encodedStringBtoA);
      }
      catch(e)
      {
        console.log(e.message);
      }

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
      
      // return
      var ret = {error: error};
      
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
        const result = await db.collection('Pics').find({"UserId":userId}).toArray();
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
      
      // return
      var ret = {result_array: _resultsarray, jwtToken: jwtToken, error: error};
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
      const newUser = {Email:email, UserId: arraylength + 1, FirstName:firstname, LastName:lastname, FullName:fullname,
         Login:login, Password:password }; // add userid UserId:userId

      
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

