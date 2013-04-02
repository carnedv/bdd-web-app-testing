/* jshint -W024 */
/* jshint expr:true */

var config = require('../config.js')(),
	assert = require('assert'),
	zombie = require('zombie'),
	browser = new zombie(),
	chai = require('chai');

chai.should();

beforeEach(function(done)
{
	browser.visit(config.appUrl + 'account/login', function ()
	{
		browser.success.should.be.ok;
		done();
	});
});

describe('Login Page', function() {
	it ('should have a form with username and password fields and a login button', function (done)
	{
		browser.query('form#login-form input[name="username"]').should.be.ok;
		browser.query('form#login-form input[name="password"]').should.be.ok;
		browser.query('form#login-form button[name="login"]').should.be.ok;
		done();
	});
	it ('should return to the login page with an error message if a username that is not a valid email is submitted', function (done)
	{
		browser.fill('username', 'test').fill('password', 'test1234').pressButton('login', function () {
			browser.text('h2#page-title').should.equal('Login');
			browser.query('#login-errors').should.be.ok;
			done();
		});
	});
	it ('should return to the login page with an error message if a username that is not in the system is submitted', function (done)
	{
		browser.fill('username', 'test2@test.com').fill('password', 'test1234').pressButton('login', function () {
			browser.text('h2#page-title').should.equal('Login');
			browser.query('#login-errors').should.be.ok;
			done();
		});
	});
	it ('should return to the login page with an error message if an invalid password is submitted', function (done)
	{
		browser.fill('username', 'test@test.com').fill('password', 'badpassword').pressButton('login', function () {
			browser.text('h2#page-title').should.equal('Login');
			browser.query('#login-errors').should.be.ok;
			done();
		});
	});
	it ('should forward to the login successful page if a valid username and password are entered', function (done)
	{
		browser.fill('username', 'test@test.com').fill('password', 'test1234').pressButton('login', function () {
			browser.text('h2#page-title').should.equal('Login Successful');
			done();
		});
	});
});