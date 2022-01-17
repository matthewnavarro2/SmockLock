import React from 'react';

import CardPageTitle from '../components/CardPageTitle';
import LoggedInName from '../components/LoggedInName';
import CardUI from '../components/CardUI';

const CardPage = () =>
{
    return(
        <div>
            <CardPageTitle />
            <LoggedInName />
            <CardUI />
        </div>
    );
}

export default CardPage;
