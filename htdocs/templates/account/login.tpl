{extends file="main.tpl"}

{block name="body"}
<h2 id="page-title">{$page_title}</h2>
<form method="post" action="/account/login" id="login-form">
	{if isset($login_errors)}
	<div class="alert alert-error" style="padding-top:.5em;padding-bottom:0">
		<ul id="login-errors">
			{foreach from=$login_errors item=login_error}
			<li>{$login_error}</li>
			{/foreach}
		</ul>
	</div>
	{/if}
	<fieldset id=>
		<label for="username">Username</label>
		<input type="text" placeholder="Email" name="username">
		<label for="password">Password</label>
		<input name="password" type="password" placeholder="Password">
	</fieldset>
	<button type="submit" name="login" class="btn">Login</button>
</form>
{/block}