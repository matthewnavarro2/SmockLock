import React from 'react';

function LoggedInName()
{

    var _ud = localStorage.getItem('user_data');
    var ud = JSON.parse(_ud);
    var userId = ud.id;
    var firstName = ud.firstName;
    var lastName = ud.lastName;

    const doLogout = event => 
    {
	    event.preventDefault();

        localStorage.removeItem("user_data")
        window.location.href = '/';
    };
    
    const doCam = event =>
    {
      event.preventDefault();
     
      window.location.href = '/cam';
    }

    const doCard = event =>
    {
      event.preventDefault();
     
      window.location.href = '/cards';
    }

  return(
   <div id="loggedInDiv">
   <span id="userName">Logged In As {firstName} {lastName}</span><br />
   <button type="button" id="logoutButton" class="buttons" 
     onClick={doLogout}> Log Out </button>
    <button type="button" id="cameraButton" class="buttons" 
    onClick={doCam}> CAM PAGE </button>
    <button type="button" id="cardButton" class="buttons" 
    onClick={doCard}> CARD PAGE </button>
   </div>
  );
};

export default LoggedInName;
