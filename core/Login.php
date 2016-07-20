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
 * Login
 * 
 * 
 */
class Login {

	/** @var object $pdo_ro PDO object */
	private $pdo_ro = false;

	/** @var object $pdo_rw PDO object */
	private $pdo_rw = false;

	/** @var array $json JSON string with received data */
	private $json = [];
	private $login_type = '';

	public function __construct($json) {
		$db = DB::getInstance();
		$this->pdo_ro = $db->mysqlConnect('ro');
		$this->pdo_rw = $db->mysqlConnect('rw');
		$this->json = $json;
	}

	public function login() {
		if (preg_match('/^[a-z]+[a-z0-9]+[a-z]+$/', $this->json['user'])) {
			/**
			 * client name
			 * "/^[a-z]+[a-z0-9]+[a-z]+$/"
			 */
			$this->login_type = 'client';
			$this->login_client();
		}
		/**
		 * domain (not IDN - FIXME)
		 * "^[a-z0-9.-]+$"
		 */
		/**
		 * mail domain (not IDN - FIXME)
		 * "^[a-z0-9.-]+$"
		 */
		/**
		 * mail user
		 * "^[a-z.-+@]+$"
		 */
		/**
		 * reseller
		 * 
		 */
		/**
		 * admin
		 * 
		 */
	}

	private function login_client() {
		$sql = 'SELECT * FROM client WHERE name = :name AND active = 1';
		$prepared = $this->pdo_ro->prepare($sql);
		$prepared->bindParam(':name', $this->json['user']);
		$prepared->execute();
		$client = $prepared->fetchAll(\PDO::FETCH_ASSOC);
		if (count($client) > 0) {
			list(, $type, $options, $salt) = explode('$', $client[0]['password']);
			$check_pass = crypt($this->json['password'], '$' . $type . '$' . $options . '$' . $salt . '$');
			if (hash_equals($client[0]['password'], $check_pass)) {
				$client_data['id'] = $client[0]['id'];
				$client_data['name'] = $client[0]['name'];
				$client_data['gid'] = $client[0]['gid'];
				$client_data['active'] = $client[0]['active'];
				self::login_ok($client_data, $this->login_type);
				return true;
			} else {
				self::login_bad();
				return false;
			}
		} else {
			return false;
		}
	}

	private static function login_ok($client_data = [], $login_type = 'nobody') {
		\OpenHCP\OpenHCP::startSession();
		$_SESSION['loggedin'] = true;
		$_SESSION['user']['type'] = $login_type;
		$_SESSION['user']['data'] = $client_data;
		$data = ["status" => true, "info" => "Hello, Dave."];
		\OpenHCP\OpenHCP::sendData(200, $data);
	}

	private static function login_bad() {
		$data = ["status" => false, "info" => "Bad user and/or password"];
		\OpenHCP\OpenHCP::sendData(401, $data);
	}

	public static function generatePasswordHash($password) {
		$salt = substr(preg_replace('/[+=]/', '', base64_encode(openssl_random_pseudo_bytes(16))), 0, 16);
		return crypt($password, '$6$rounds=500000$' . $salt . '$');
	}

	public static function generatePassword($size = 16) {
		if ($size > 0 && $size < 128) {
			return substr(preg_replace('/[+=]/', '', base64_encode(openssl_random_pseudo_bytes($size))), 0, $size);
		} else {
			return false;
		}
	}

}
