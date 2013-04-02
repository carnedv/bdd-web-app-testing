# BDD Web App Testing

This repo includes a sample website built on PHP Slim and Smarty along with a Mocha test suite for testing the website's functionality.

To get the website up and running:

* Clone the repo.
* Setup an Apache virtual host to point to the htdocs folder.
* Set the htdocs/templates/_compiled and htdocs/templates/_cache folders to be writable by the webserver (Smarty needs this).
* Navigate to the url you configured in the Apache virtual host.

To run the Mocha tests:

* Install Mocha with ***npm install mocha -g***
* Ensure you have ***make*** installed (Mac and Linux already have it, if you are on Windows  get [GNU Make](http://gnuwin32.sourceforge.net/packages/make.htm))
* Set the url to the test website to match the one you have configured in ***test/config.js***
* Run ***make test*** from the repo's root.