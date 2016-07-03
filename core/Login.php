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

	/** @var array $json JSON string with received data */
	private $json = [];

	public function __construct($json) {
		$this->json = $json;
	}

	public function login() {
		if (preg_match('/^[a-z]+[a-z0-9]+[a-z]+$/', $this->json['user'])) {
			/**
			 * client name
			 * "/^[a-z]+[a-z0-9]+[a-z]+$/"
			 */
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
	}

	private function login_client() {
		$sql = 'SELECT * FROM client WHERE name = :name AND active = 1';
		$pass = '$6$rounds=500000$cg7dVrrKU5DvROA0$/5ZZ/Dx/ZDRKB2MrNyPkge.BY8o3JJpC0dgbUlmwxDl/vojdMi72idsRQ1RDNd.W.gZ/zKK2qPsvKOVxXCMyU/';
		list(,,, $salt) = explode('$', $pass);
		$check_pass = crypt($this->json['password'], '$6$rounds=500000$' . $salt . '$');
		if (hash_equals($pass, $check_pass)) {
			$this->login_ok();
			return true;
		} else {
			$this->login_bad();
			return false;
		}
	}

	private function login_ok() {
		\OpenHCP\OpenHCP::startSession();
		\OpenHCP\OpenHCP::sendData(200, true);
	}

	private function login_bad() {
		\OpenHCP\OpenHCP::sendData(401);
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
