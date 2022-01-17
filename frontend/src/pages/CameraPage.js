import React from 'react';

import PageTitle from '../components/PageTitle';
import LoggedInName from '../components/LoggedInName';
import CameraUI from '../components/CameraUI';

const CameraPage = () =>
{
    return(
        <div>
            <LoggedInName />
            <CameraUI />
        </div>
    );
}

export default CameraPage;
