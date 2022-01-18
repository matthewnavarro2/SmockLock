import React, { useState } from 'react';
import axios from 'axios';

function CameraUI()
{
   var bp = require('./Path.js');
    var storage = require('../tokenStorage.js');
    const jwt = require("jsonwebtoken");
    
    
    let image;
    
    const [message,setMessage] = useState('');
    const [searchResults,setResults] = useState('');
    const [picList,setPicList] = useState('');

    var _ud = localStorage.getItem('user_data');
    var ud = JSON.parse(_ud);
    var userId = ud.id;
    var firstName = ud.firstName;
    var lastName = ud.lastName;
    var picBase64 = '';

    const addPics = async event => 
    {
      event.preventDefault();

      var tok = storage.retrieveToken();
      var obj = {userId:userId,jwtToken:tok, pic:picBase64.value};
      var js = JSON.stringify(obj);
      
      var config = 
      {
          method: 'post',
          url: bp.buildPath('../../../api/addPic'),	
          headers: 
          {
              'Content-Type': 'application/json'
          },
          data: js
      };
  
      axios(config)
          .then(function (response) 
      {
          var res = response.data;
          var retTok = res.jwtToken;
          console.log(res);
  
          if( res.error.length > 0 )
          {
              setMessage( "API Error:" + res.error );
              
          }
          
          setMessage("Successfully added Picture!");
          storage.storeToken( {accessToken:retTok} );
      })
      .catch(function (error) 
      {
          console.log(error);
      });
      
      

    }
    const listPics = async event => 
    {
      event.preventDefault();

      var tok = storage.retrieveToken();
     var obj = {userId:userId,jwtToken:tok};
     var js = JSON.stringify(obj);
      image = new Image();
      var config = 
      {
          method: 'post',
          url: bp.buildPath('../../../api/listPics'),	
          headers: 
          {
              'Content-Type': 'application/json'
          },
          data: js
      };
  
      axios(config)
          .then(function (response) 
      {
          var res = response.data;
          var retTok = res.jwtToken;
          console.log(res);
  
          if( res.error.length > 0 )
          {
              setMessage( "API Error:" + res.error );
              
          }
          let initImg = 'data:image/png;base64,';
          let cameraList = res.result_array;
          for(var i=0; i<cameraList.length; i++ )
          {
            image.src = initImg.concat(cameraList[i].Pic);
            document.body.appendChild(image);
          }
          
          storage.storeToken( {accessToken:retTok} );
      })
      .catch(function (error) 
      {
          console.log(error);
      });
      
      

    }
   return(
        <div id="CameraUIDiv">
        <span id="inner-title">This do be the camera page</span><br />
        <br />
        <input type="text" id="cardText" placeholder="Picture in Base64 Format" 
            ref={(c) => picBase64 = c} />
        <button type="button" id="addPicButton" class="buttons" 
            onClick={addPics}> Add Picture </button><br />
        <span id="cardAddResult">{message}</span>
        <br />
        <button type="button" id="searchPicturesButton" class="buttons" 
            onClick={listPics}> List Pics</button><br />
        <span id="cardSearchResult">{image}</span>
        <p>{image}</p>
        </div>
   );
}

export default CameraUI;