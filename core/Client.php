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
 * Client
 * 
 * 
 */
class Client {

	/** @var array $json JSON string with received data */
	private $json = [];

	public function __construct($json) {
		if (!\OpenHCP\OpenHCP::sessionStarted()) {
			\OpenHCP\OpenHCP::sendData(401);
		}

		$this->json = $json;
	}

	public function getClients() {
		\OpenHCP\OpenHCP::sendData(200, ["id" => 1, "name" => "openhcp", "active" => 1]);
	}

}
