<?php

namespace OpenHCP;

/**
 * OpenHCP - Open Hosting Control Panel
 *
 * @author Michał Pena <cyb0org@gmail.com>
 * @copyright (C) 2016, Michał Pena
 * @license https://opensource.org/licenses/ISC ISC License
 */

/**
 * OpenHCP
 * 
 * main class
 */
class OpenHCP {

	/** @var array $URI array of elements from URI */
	public $URI = [];

	/** @var string $URI_long string with elements from URI */
	public $URI_long = '';

	/** @var array $json JSON array with received parametars */
	private $json = [];

	/** @var array $routing array with allowed routing */
	public $routing = [
	    'login' => [
		'class' => 'Login',
		'method' => 'login',
		'proto' => 'POST'
	    ],
	    'clients' => [
		'class' => 'Client',
		'method' => 'getClients',
		'proto' => 'GET'
	    ],
	    'client' => [
		'class' => 'Client',
		'method' => 'getClient',
		'proto' => 'GET'
	    ]
	];

	/**
	 * default class constructor
	 */
	public function __construct() {
		$this->loadJSON();
		if (isset($_COOKIE['OPENHCP_SESSION'])) {
			self::startSession();
		}
		ini_set('always_populate_raw_post_data', -1);
		$this->parseUrl();
		$this->router();
	}

	private function loadJSON() {
		$body = file_get_contents('php://input');
		$json = json_decode($body, true, 8);
		if (json_last_error() === JSON_ERROR_NONE) {
			$this->json = $json;
			return true;
		} else {
			exit(json_last_error_msg());
		}
	}

	/**
	 * parseUrl
	 * 
	 * parse URL and put parts into array
	 */
	private function parseUrl() {
		// TODO: [a-z\/]
		$this->URI_long = substr($_SERVER["PHP_SELF"], strlen($_SERVER["SCRIPT_NAME"]) + 1, strlen($_SERVER["PHP_SELF"]) - strlen($_SERVER["SCRIPT_NAME"]));
		$this->URI = explode('/', $this->URI_long);
	}

	/**
	 * router
	 * 
	 * calls method of class using URI data
	 */
	private function router() {
		if ($this->URI[0] != '' && isset($this->routing[$this->URI_long]) && $this->routing[$this->URI_long]['proto'] == $_SERVER["REQUEST_METHOD"]) {
			$class_name = '\\OpenHCP\\' . $this->routing[$this->URI_long]['class'];
			$class_method = $this->routing[$this->URI_long]['method'];
			if (class_exists($class_name)) {
				$route = new $class_name($this->json);
				$route->$class_method();
				exit();
			}
		}
		self::sendData(400, ["status" => false, "info" => "Bad request."]);
	}

	public static function sessionStarted() {
		if (session_status() === PHP_SESSION_ACTIVE) {
			return true;
		} else {
			return false;
		}
	}

	public static function startSession() {
		if (!self::sessionStarted()) {
			ini_set('session.cookie_path', dirname($_SERVER['SCRIPT_NAME']));
			ini_set('session.cookie_secure', true);
			ini_set('session.cookie_httponly', true);
			session_name('OPENHCP_SESSION');
			session_start();
		}
	}

	public static function continueSession() {
		if (isset($_COOKIE['OPENHCP_SESSION'])) {
			self::startSession();
			if ($_SESSION['loggedin'] !== true) {
				self::sendData(401, ["status" => false, "info" => "Session expired."]);
			}
		}
	}

	public static function sendData($code = 200, $data = []) {
		$codes = [
		    200 => '200 OK',
		    400 => '400 Bad Request',
		    401 => '401 Unauthorized',
		    403 => '403 Forbidden',
		    404 => '404 Not Found',
		    405 => '405 Method Not Allowed',
		    429 => '429 Too Many Requests'
		];

		if (!isset($codes[$code])) {
			exit;
		}
		header($_SERVER['SERVER_PROTOCOL'] . ' ' . $codes[$code]);
		header('Pragma: no-cache');
		header('Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0');
		header('X-XSS-Protection: 1; mode=block');
		header('X-Frame-Options: sameorigin');
		header('X-Content-Type-Options: nosniff');

		if (count($data) > 0) {
			header('Content-Type: application/json; charset=utf8');
			echo json_encode($data);
		}

		exit;
	}

	public static function checkAcl($allowed = []) {
		foreach ($allowed as $type) {
			if ($type == $_SESSION['user']['type']) {
				return true;
			}
		}
		return false;
	}

}
