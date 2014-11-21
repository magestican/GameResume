# Slic

## Global Dependencies

Make sure the following are installed:

* [node.js](http://nodejs.org)
* [Git](http://git-scm.com/download/)
* [Chrome Canary](https://www.google.com/intl/en/chrome/browser/canary.html)
* [Ruby](https://www.ruby-lang.org/en/) (should already be installed on OSX)

and then run the following in the terminal:

    $ sudo npm install -g grunt-cli
    $ gem install compass

## Setup

    $ git clone https://github.com/salesforce-ux/slic.git && cd slic
    $ npm install
    $ grunt build

## Static Resources

In order to work around Salesforce "Static Resources", I created a Chrome extension that maps static resoure requests to local versions.

### Request Mapper

The extension and installation instructions are on GitHub:

https://github.com/aputinski/request-mapper

The following RegEx / URL pairs can be used in the options page of the extension

RegEx | URL
--- | ---
`.*\/resource\/.*/slic_assets\/js/modules/ ` | https://localhost/js/modules/
`.*\/resource\/.*/slic_assets\/js/build/ ` | https://localhost/js/build/
`.*\/resource\/.*\/slic_assets\/styles/` | https://localhost/styles/
`.*\/resource\/.*\/slic_assets\/templates/` | https://localhost/templates/

### Building Static Resources

Using Request Mapper will ensure you are always looking at the latest changes and anyone not using the extension will see the static resources that were last uploaded to Salesforce.

The following build script will create file called `slic_assets.zip` that can be uploaded to Salesforce.

    $ ./build.sh

## SSL

In order for the Request Mapper plugin to work with force.com, the local versions must be accessed via SSL.

In the slic directory, run the following commands in the terminal.

When prompted for "common name" enter `secure.slic.dev`

    $ mkdir ssl && cd ssl
    $ openssl genrsa -des3 -out server.key 1024
    $ openssl req -new -key server.key -out server.csr
    $ openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
    $ cp server.key server.tmp
    $ openssl rsa -in server.tmp -out server.key

Once you have created self signed certificate

    $ cd ../
    $ sudo node app.js

This will start a nodejs server on port 443 which can be accessed at [https://localhost]()

Make sure to open [https://localhost]() in Chrome and click the **"Proceed Anyway"** button

## Grunt

Running `grunt watch` will automatically build JS/CSS upon saving and refresh the first tab in Chrome Canary

## Apex and Visualforce Components

They are tracked in a separate repo here [htts://https://git.soma.salesforce.com/dvora/Slic-Production-Org]()
