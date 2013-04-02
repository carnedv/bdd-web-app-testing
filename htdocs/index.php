<?php
require 'vendor/autoload.php';

$smarty = new \Slim\Extras\Views\Smarty();

$app = new \Slim\Slim(array('view' => $smarty));

$faker = Faker\Factory::create();

$page_data = array(
	'app_title' 	=> 'BDD Tests',
	'company_name' 	=> 'RefreshBatonRouge'
);

$app->get('/', function() use ($app, $page_data) {
	$page_data['page_title'] = 'Home';
	$app->render('home/index.tpl', $page_data);
});

$app->get('/account/login', function() use ($app, $page_data) {
	$page_data['page_title'] = 'Login';
	$app->render('account/login.tpl', $page_data);
});

$app->post('/account/login', function() use ($app, $page_data) {
	$page_data['page_title'] = 'Login';

	$login_errors = array();

	$valid_login = array(
		'username' => 'test@test.com',
		'password' => 'test1234'
	);

	$form_post = $app->request()->post();

	if (!preg_match('/^[^\W][a-zA-Z0-9_]+(\.[a-zA-Z0-9_]+)*\@[a-zA-Z0-9_]+(\.[a-zA-Z0-9_]+)*\.[a-zA-Z]{2,4}$/', $form_post['username'])) {
		$login_errors[] = 'Username is not a valid email';
	} else if ($form_post['username'] !== $valid_login['username']) {
		$login_errors[] = 'Username is invalid';
	} else if ($form_post['password'] !== $valid_login['password']) {
		$login_errors[] = 'Password is invalid';
	}

	if (count($login_errors) == 0)
	{
		$app->redirect('/account/login-successful');
	} else {
		$page_data['login_errors'] = $login_errors;
		$app->render('account/login.tpl', $page_data);
	}
});

$app->get('/account/login-successful', function() use ($app, $page_data) {
	$page_data['page_title'] = 'Login Successful';
	$app->render('account/login-successful.tpl', $page_data);
});

$app->get('/phone-book', function() use ($app, $page_data, $faker) {
	$page_data['page_title'] = 'Phone Book';

	$data = array();

	for($i = 0; $i < 10; $i++)
	{
		$data[] = array(
			'id'			=> $faker->randomNumber(1, 1000),
			'name' 			=> $faker->name,
			'address' 		=> $faker->address,
			'phoneNumber' 	=> $faker->phoneNumber,
			'email' 		=> $faker->email
		);
	}

	$page_data['phone_book_entries'] = $data;
	$app->render('phone_book/index.tpl', $page_data);
});

$app->get('/ajax/test-1', function() use ($app, $faker)
{
	$app->contentType('application/json');

	$data = array();

	for($i = 0; $i < 10; $i++)
	{
		$data[] = array(
			'id'			=> $faker->randomNumber(1, 1000),
			'name' 			=> $faker->name,
			'address' 		=> $faker->address,
			'phoneNumber' 	=> $faker->phoneNumber,
			'email' 		=> $faker->email
		);
	}

	echo json_encode($data);
});

$app->post('/ajax/submit-entry', function() use ($app, $faker)
{
	$app->contentType('application/json');

	$post = $app->request()->post();

	$phone_number_regex = '/^(?:(?:\((?=\d{3}\)))?(\d{3})(?:(?<=\(\d{3})\))?[\s.\/-]?)?(\d{3})[\s\.\/-]?(\d{4})\s?(?:(?:(?:(?:e|x|ex|ext)\.?\:?|extension\:?)\s?)(?=\d+)(\d+))?$/';

	if (preg_match($phone_number_regex, $post['phoneNumber'], $matches))
	{
		$post['id'] = $faker->randomNumber(1, 1000);
	} else {
		$app->response()->status(500);
	}

	echo json_encode($post);
});

$app->run();