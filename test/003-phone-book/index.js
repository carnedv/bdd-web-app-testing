/* jshint -W024 */
/* jshint expr:true */

var config = require('../config.js')(),
	assert = require('assert'),
	zombie = require('zombie'),
	browser = new zombie(),
	chai = require('chai'),
	cheerio = require('cheerio');

chai.Assertion.includeStack = true;
chai.should();

var $;

beforeEach(function(done)
{
	browser.visit(config.appUrl + 'phone-book', function() {
		browser.success.should.be.ok;
		$ = cheerio.load(browser.html());
		done();
	});
});

describe('Phone book page navigation', function() {
	it('should have a table of entries and pagination links', function(done)
	{
		browser.query('table#entries').should.be.ok;
		browser.query('div#entries-pagination').should.be.ok;
		done();
	});
	it('should have a disabled previous page link (we are on the first page)', function(done)
	{
		$('div#entries-pagination li').first().attr('class').should.contain('disabled');
		done();
	});
	it('should have a first page link that is active (we are on the first page)', function(done)
	{
		$('div#entries-pagination li').eq(1).attr('class').should.contain('active');
		done();
	});
	it('should change the entries if we click on the second page link', function(done)
	{
		var originalFirstItemId = $('table#entries tbody tr').first().attr('id');
		var secondPageLink = browser.querySelector('div#entries-pagination a:eq(2)');

		secondPageLink.should.be.ok;

		browser.fire('click', secondPageLink, function() {
			$ = cheerio.load(browser.html());
			$('table#entries tbody tr').first().attr('id').should.not.equal(originalFirstItemId);
			done();
		});
	});
	it('should have a disabled next button when we click the last page link (we are on the last page)', function(done)
	{
		var lastPageNumber = browser.window.lastPage;
		var lastPageLink = browser.querySelector('div#entries-pagination a:contains("' + lastPageNumber + '")');

		lastPageLink.should.be.ok;

		browser.fire('click', lastPageLink, function() {
			$ = cheerio.load(browser.html());
			$('div#entries-pagination li').last().attr('class').should.contain('disabled');
			done();
		});
	});
	it('should not allow an invalid phone book entry to be created and show an error message', function(done)
	{
		var originalFirstItemId = $('table#entries tbody tr').first().attr('id');

		browser.clickLink('Add Entry', function()
		{
			browser.
				fill('name', 'Test User').
				fill('address', '1234 Easy Street').
				fill('city', 'Baton Rouge').
				select('state', 'LA').
				fill('zip', '70808').
				fill('phone_number', 'bad phone number').
				fill('email', 'test@test.com').
				clickLink('#save-entry', function()
				{
					browser.evaluate('$("#save-entry-error").is(":visible");').should.equal(true);
					$('table#entries tbody tr').first().attr('id').should.equal(originalFirstItemId);
					done();
				});
		});
	});
	it('should allow a valid phone book entry to be created, close the form modal and add the new entry to the entries table', function(done)
	{
		var originalFirstItemId = $('table#entries tbody tr').first().attr('id');

		browser.clickLink('Add Entry', function()
		{
			browser.
				fill('name', 'Test User').
				fill('address', '1234 Easy Street').
				fill('city', 'Baton Rouge').
				select('state', 'LA').
				fill('zip', '70808').
				fill('phone_number', '225-555-1234').
				fill('email', 'test@test.com').
				clickLink('#save-entry', function()
				{
					$ = cheerio.load(browser.html());
					browser.evaluate('$("#save-entry-error").is(":visible");').should.equal(false);
					browser.evaluate('$("#save-entry-modal").is(":visible");').should.equal(false);
					$('table#entries tbody tr').first().attr('id').should.not.equal(originalFirstItemId);
					done();
				});
		});
	});
});