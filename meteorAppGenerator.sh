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
touch $path/imports/ui/components/App.jsx
mkdir $path/imports/ui/layouts
touch $path/imports/ui/layouts/header.jsx
touch $path/imports/ui/layouts/footer.jsx
mkdir $path/imports/ui/pages
touch $path/imports/ui/pages/notFoundPage.jsx

echo "Directory Initialization ... [OK]"

echo "<head>
  <title>$1</title>
</head>

<body>
  <div id="render-application"></div>
</body>" >> $path/client/main.html

echo "import React from 'react'
import { Meteor } from 'meteor/meteor'
import { render } from 'react-dom'

import { renderRoutes } from '../imports/startup/client/routes.jsx'

Meteor.startup(() => {
	render(renderRoutes(), document.getElementById('render-application'));
});" >> $path/client/main.jsx

echo "import React, { Component } from 'react';

export default class App extends Component {
  render() {
    return (
      <div className="container">

      </div>
    );
  }
}" >> $path/imports/ui/components/App.jsx

echo "import { Meteor } from 'meteor/meteor';

// Data
//import '../imports/api/datas/server/publications.js';
//import '../imports/api/datas/methods.js';

Meteor.startup(() => {
  // code to run on server at startup
}); " >> $path/server/main.js

echo "import React from 'react'
import { Router, Route, browserHistory, IndexRoute } from 'react-router'

// Import all pages for the Router

export const renderRoutes = () => (
	<Router history={browserHistory}>
    	<Route path="*" component={NotFoundPage}/>
	</Router>
);" >> $path/imports/startup/client/routes.js

exit 0
