#!/bin/bash

if [ -z $1 ] || [ $# != 1 ] ; then
  echo "Please use: ./$0 [Project name]"
  exit -1
fi

meteor create $1

path="./$1"
## MKDIR CLIENT AND SERVER DIRECTORY
rm -rf $path/client/*
rm -rf $path/server/*
touch $path/server/main.js
touch $path/client/main.jsx
touch $path/client/main.html

## MKDIR PUBLIC DIRECTORY
mkdir $path/public
mkdir $path/public/images
mkdir $path/public/favicons
touch $path/public/robots.txt

## MKDIR IMPORTS DIRECTORY
mkdir $path/imports
#api
mkdir $path/imports/api
# Startup
mkdir $path/imports/startup
mkdir $path/imports/startup/server
mkdir $path/imports/startup/client
touch $path/imports/startup/client/routes.js
# ui
mkdir $path/imports/ui
mkdir $path/imports/ui/components
mkdir $path/imports/ui/containers
touch $path/imports/ui/containers/App.jsx
mkdir $path/imports/ui/layouts
touch $path/imports/ui/layouts/Header.jsx
touch $path/imports/ui/layouts/Footer.jsx
mkdir $path/imports/ui/pages
touch $path/imports/ui/pages/NotFoundPage.jsx
touch $path/imports/ui/pages/HomePage.jsx

## client Main.html
echo "<head>
  <title>$1</title>
</head>

<body>
  <div id="render-application"></div>
</body>" >> $path/client/main.html

## Client main.jsx
echo "import React from 'react'
import { Meteor } from 'meteor/meteor'
import { render } from 'react-dom'

import { renderRoutes } from '../imports/startup/client/routes.jsx'

Meteor.startup(() => {
	render(renderRoutes(), document.getElementById('render-application'));
});" >> $path/client/main.jsx

## Main App container
echo "import React, { Component } from 'react';

class App extends Component {
  render() {
    return (
      <div className="container">
        {this.props.children}
      </div>
    );
  }
}

export default App;
" >> $path/imports/ui/containers/App.jsx

## NotfoundPage App container
echo "import React, { Component } from 'react'

class NotFoundPage extends Component {

  render() {
    return (
      <div>
        <div className="container">
          <h1>404 Not Found</h1>
        </div>
      </div>
    );
  }
}

export default NotFoundPage;
" >> $path/imports/ui/pages/NotFoundPage.jsx

## Main App container
echo "import React, { Component } from 'react'

class HomePage extends Component {

  render() {
    return (
      <div>
        // Home Page Components
      </div>
    );
  }
}

export default HomePage;
" >> $path/imports/ui/pages/HomePage.jsx

## Server main.jsx
echo "import { Meteor } from 'meteor/meteor';

// Data
//import '../imports/api/datas/server/publications.js';
//import '../imports/api/datas/methods.js';

Meteor.startup(() => {
  // code to run on server at startup
}); " >> $path/server/main.js

## Routes file
echo "import React from 'react'
import { Router, Route, browserHistory, IndexRoute } from 'react-router'

// Import all pages for the Router
import App from '../../ui/components/App.jsx'
import HomePage from '../../ui/pages/HomePage.jsx'
import NotFoundPage from '../../ui/pages/NotFoundPage.jsx'

export const renderRoutes = () => (
	<Router history={browserHistory}>
    <Route path="/" component={App}>
      <IndexRoute component={HomePage}/>
    </Route>
    <Route path="*" component={NotFoundPage}/>
	</Router>
);" >> $path/imports/startup/client/routes.js

echo "INSTRUCTIONS:
 $ cd $1
 $ meteor npm install
 $ meteor npm install --save react react-dom react-router
 $ meteor
"

exit 0
