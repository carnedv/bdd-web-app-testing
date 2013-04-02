/* jshint -W024 */
/* jshint expr:true */

var config = require('../config.js')(),
	assert = require('assert'),
	zombie = require('zombie'),
	browser = new zombie(),
	chai = require('chai');

chai.should();

describe('Index Page', function(){
	it('should have correct title when visiting home page', function(done)
	{
		browser.visit(config.appUrl, function(){
			browser.success.should.be.ok;
			browser.text('title').should.equal('BDD Tests - Home');
			done();
		});
	});
});