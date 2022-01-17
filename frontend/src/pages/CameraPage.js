import React from 'react';

import CameraPageTitle from '../components/CameraPageTitle';
import LoggedInName from '../components/LoggedInName';
import CameraUI from '../components/CameraUI';

const CameraPage = () =>
{
    return(
        <div>
            <CameraPageTitle/>
            <LoggedInName />
            <CameraUI />
        </div>
    );
}

export default CameraPage;
