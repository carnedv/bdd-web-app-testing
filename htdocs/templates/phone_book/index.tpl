{extends file="main.tpl"}

{block name="body"}
<h2 id="page-title">{$page_title}</h2>

<h3>Entries</h3>

<p>
	<a href="#add-entry-modal" data-toggle="modal" class="btn">Add Entry</a>
</p>

<div class="pagination" id="entries-pagination">
	<ul>
		<li><a class="prev" href="javascript:void(0);">Prev</a></li>
		<li><a href="javascript:void(0);">1</a></li>
		<li><a href="javascript:void(0);">2</a></li>
		<li><a href="javascript:void(0);">3</a></li>
		<li><a href="javascript:void(0);">4</a></li>
		<li><a href="javascript:void(0);">5</a></li>
		<li><a class="next" href="javascript:void(0);">Next</a></li>
	</ul>
</div>

<table class="table" id="entries">
	<thead>
		<tr>
			<th>Name</th>
			<th>Address</th>
			<th>Phone Number</th>
			<th>Email</th>
		</tr>
	</thead>
	<tbody>
		{foreach from=$phone_book_entries item='entry'}
		<tr id="entry-{$entry.id}">
			<td>{$entry.name}</td>
			<td>{$entry.address}</td>
			<td>{$entry.phoneNumber}</td>
			<td><a href="mailto:{$entry.email}">{$entry.email}</a></td>
		</tr>
		{/foreach}
	</tbody>
</table>

<div id="add-entry-modal" class="modal hide fade">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3>Add an Entry</h3>
	</div>
	<div class="modal-body">
		<div class="alert alert-error hide" id="save-entry-error">
			<h4>Entry Save Failed</h4>
			Try again please.
		</div>
		<form method="post" action="#" class="form-horizontal">
			<fieldset id="phonebook-entry-form">
				<div class="control-group">
					<label for="name" class="control-label">Name</label>
					<div class="controls">
						<input type="text" name="name">
					</div>
				</div>
				<div class="control-group">
					<label for="address" class="control-label">Address</label>
					<div class="controls">
						<input type="text" name="address">
					</div>
				</div>
				<div class="control-group">
					<label for="city" class="control-label">City</label>
					<div class="controls">
						<input type="text" name="city">
					</div>
				</div>
				<div class="control-group">
					<label for="state" class="control-label">State</label>
					<div class="controls">
						<select name="state"> 
							<option value="" selected="selected">Select a State</option> 
							<option value="AL">Alabama</option> 
							<option value="AK">Alaska</option> 
							<option value="AZ">Arizona</option> 
							<option value="AR">Arkansas</option> 
							<option value="CA">California</option> 
							<option value="CO">Colorado</option> 
							<option value="CT">Connecticut</option> 
							<option value="DE">Delaware</option> 
							<option value="DC">District Of Columbia</option> 
							<option value="FL">Florida</option> 
							<option value="GA">Georgia</option> 
							<option value="HI">Hawaii</option> 
							<option value="ID">Idaho</option> 
							<option value="IL">Illinois</option> 
							<option value="IN">Indiana</option> 
							<option value="IA">Iowa</option> 
							<option value="KS">Kansas</option> 
							<option value="KY">Kentucky</option> 
							<option value="LA">Louisiana</option> 
							<option value="ME">Maine</option> 
							<option value="MD">Maryland</option> 
							<option value="MA">Massachusetts</option> 
							<option value="MI">Michigan</option> 
							<option value="MN">Minnesota</option> 
							<option value="MS">Mississippi</option> 
							<option value="MO">Missouri</option> 
							<option value="MT">Montana</option> 
							<option value="NE">Nebraska</option> 
							<option value="NV">Nevada</option> 
							<option value="NH">New Hampshire</option> 
							<option value="NJ">New Jersey</option> 
							<option value="NM">New Mexico</option> 
							<option value="NY">New York</option> 
							<option value="NC">North Carolina</option> 
							<option value="ND">North Dakota</option> 
							<option value="OH">Ohio</option> 
							<option value="OK">Oklahoma</option> 
							<option value="OR">Oregon</option> 
							<option value="PA">Pennsylvania</option> 
							<option value="RI">Rhode Island</option> 
							<option value="SC">South Carolina</option> 
							<option value="SD">South Dakota</option> 
							<option value="TN">Tennessee</option> 
							<option value="TX">Texas</option> 
							<option value="UT">Utah</option> 
							<option value="VT">Vermont</option> 
							<option value="VA">Virginia</option> 
							<option value="WA">Washington</option> 
							<option value="WV">West Virginia</option> 
							<option value="WI">Wisconsin</option> 
							<option value="WY">Wyoming</option>
						</select>
					</div>
				</div>
				<div class="control-group">
					<label for="name" class="control-label">Zip</label>
					<div class="controls">
						<input type="text" name="zip">
					</div>
				</div>
				<div class="control-group">
					<label for="phone_number" class="control-label">Phone Number</label>
					<div class="controls">
						<input type="text" name="phone_number">
					</div>
				</div>
				<div class="control-group">
					<label for="email" class="control-label">Email</label>
					<div class="controls">
						<input type="email" name="email">
					</div>
				</div>
			</fieldset>
		</form>
	</div>
	<div class="modal-footer">
		<a href="javascript:void(0);" class="btn" data-dismiss="modal" id="close-add-entry-modal">Close</a>
		<a href="javascript:void(0);" class="btn btn-primary" id="save-entry">Save</a>
	</div>
</div>
{/block}

{block name="javascript"}
<script type="text/javascript">
var page = 1;
var lastPage = 5;

var addedEntry = null;

var setPageNav = function()
{
	$('.pagination li').removeClass('disabled active');
	$('.pagination li a:contains("' + page + '")').parent().addClass('active');

	if (page == 1)
	{
		$('.pagination a.prev').parent().addClass('disabled');
	}

	if (page == lastPage)
	{
		$('.pagination a.next').parent().addClass('disabled');
	}
};

var updateEntries = function()
{
	$.get('/ajax/test-1', null).success(function(res) {
		$('table#entries tbody').children().remove();
		res.forEach(function(row, index)
		{
			var $tr = $('<tr id="entry-' + row.id + '"></tr>');
			$tr.append('<td>' + row.name + '</td>');
			$tr.append('<td>' + row.address + '</td>');
			$tr.append('<td>' + row.phoneNumber + '</td>');
			$tr.append('<td><a href="mailto:' + row.email + '">' + row.email + '</a></td>');
			$('table#entries tbody').append($tr);
		});
	}).error(function (err) {
		alert('There was an error getting your phonebook entries.')
	});
}

$(function() {

	setPageNav();

	$('.pagination a').not('.prev').not('.next').on('click', function(e) {
		e.preventDefault();
		var newPage = parseInt($(this).text());
		if (page !== newPage)
		{
			page = newPage;
			setPageNav();
			updateEntries();
		}
	});

	$('.pagination a.prev').on('click', function(e) {
		e.preventDefault();
		if (page > 1) {
			page--;
			setPageNav();
			updateEntries();
		} else {
			return;
		}
	});

	$('.pagination a.next').on('click', function(e) {
		e.preventDefault();
		if (page < lastPage) 
		{
			page++;
			setPageNav();
			updateEntries();
		} else {
			return;
		}
	});

	$('#add-entry-modal').on('show', function() {
		$('#add-entry-modal div#save-entry-error').hide();
		$('#add-entry-modal input, #add-entry-modal select').val('');
	});

	$('a#save-entry').on('click', function(e) {
		e.preventDefault();
		
		$('#add-entry-modal div#save-entry-error').hide();

		var toSave = {
			name: $('input[name="name"]').val(),
			address: $('input[name="address"]').val(),
			city: $('input[name="city"]').val(),
			state: $('select[name="state"]').val(),
			zip: $('input[name="zip"]').val(),
			phoneNumber: $('input[name="phone_number"]').val(),
			emailAddress: $('input[name="email"]').val()
		};

		$.post('/ajax/submit-entry', toSave).success(function(resp) {

			addedEntry = resp;

			var $tr = $('<tr id="entry-' + resp.id + '"></tr>');
				
			$tr.append('<td>' + resp.name + '</td>');
			$tr.append('<td>' + resp.address + ' ' + resp.city + ', ' + resp.state + ' ' + resp.zip +  '</td>');
			$tr.append('<td>' + resp.phoneNumber + '</td>');
			$tr.append('<td><a href="mailto:' + resp.emailAddress + '">' + resp.emailAddress + '</a></td>');
			
			$('table#entries tbody tr').last().remove();
			$('table#entries tbody').prepend($tr);

			$('#add-entry-modal').modal('hide');
			$('#add-entry-modal input, #add-entry-modal select').val('');
		}).error(function(err)
		{
			$('#add-entry-modal div#save-entry-error').show();
		});
	});
});
</script>
{/block}