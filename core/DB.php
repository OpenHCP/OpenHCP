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
 * DB
 * 
 * DB singleton class
 */
final class DB {

	/** @var object $singleton singleton instance of DB object */
	private static $singleton = false;

	/** @var object $pdo_ro PDO object */
	private $pdo_ro = false;

	/** @var object $pdo_rw PDO object */
	private $pdo_rw = false;

	private function __construct() {
		if (defined('dbuser_ro')) {
			$this->pdo_ro = $this->mysqlConnect('ro');
		}
		if (defined('dbuser_rw')) {
			$this->pdo_rw = $this->mysqlConnect('rw');
		}
	}

	/**
	 * getInstance
	 * 
	 * get singleton instance of DB class
	 * 
	 * @return object singleton instance of DB class
	 */
	public static function getInstance() {
		if (self::$singleton === false) {
			self::$singleton = new \LMS\DB();
		}
		return self::$singleton;
	}

	/**
	 * mysqlConnect
	 *
	 * connects to MySQL server
	 *
	 * @return object PDO object
	 */
	public function mysqlConnect($mode) {
		if ($mode == 'ro') {
			if ($this->pdo_ro !== false) {
				return $this->pdo_ro;
			}
			$dbname = dbname_ro;
			$dbhost = dbhost_ro;
			$dbuser = dbuser_ro;
			$dbpass = dbpass_ro;
		} elseif ($mode == 'rw') {
			if ($this->pdo_rw !== false) {
				return $this->pdo_rw;
			}
			$dbname = dbname_rw;
			$dbhost = dbhost_rw;
			$dbuser = dbuser_rw;
			$dbpass = dbpass_rw;
		} else {
			return false;
		}

		$dsn = 'mysql:dbname=' . $dbname . ';host=' . $dbhost . ';charset=utf8';
		try {
			$pdo = new \PDO($dsn, $dbuser, $dbpass, array(\PDO::ATTR_PERSISTENT => false));
			return $pdo;
		} catch (PDOException $e) {
			echo 'Connection failed: ' . $e->getMessage();
			return $e;
		}
	}

}
