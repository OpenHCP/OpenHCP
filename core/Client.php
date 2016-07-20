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

	/** @var object $pdo_ro PDO object */
	private $pdo_ro = false;

	/** @var object $pdo_rw PDO object */
	private $pdo_rw = false;

	/** @var array $json JSON string with received data */
	private $json = [];

	public function __construct($json) {
		if (!\OpenHCP\OpenHCP::sessionStarted()) {
			\OpenHCP\OpenHCP::sendData(401);
		}

		$db = DB::getInstance();
		$this->pdo_ro = $db->mysqlConnect('ro');
		$this->pdo_rw = $db->mysqlConnect('rw');

		$this->json = $json;
	}

	public function getClients() {
		if (\OpenHCP\OpenHCP::checkAcl(["admin"])) {
			$sql = 'SELECT * FROM client';
			$prepared = $this->pdo_ro->prepare($sql);
			$prepared->execute();
			$clients = $prepared->fetchAll(\PDO::FETCH_ASSOC);
			if (count($clients) > 0) {
				\OpenHCP\OpenHCP::continueSession();
				for ($i = 0, $j = sizeof($clients); $i < $j; $i++) {
					$clients_data[$i]['id'] = $clients[$i]['id'];
					$clients_data[$i]['name'] = $clients[$i]['name'];
					$clients_data[$i]['gid'] = $clients[$i]['gid'];
					$clients_data[$i]['active'] = $clients[$i]['active'];
				}
				$data = ["status" => true, "info" => "", "data" => $clients_data];
				\OpenHCP\OpenHCP::sendData(200, $data);
			}
		}
		$data = ["status" => false, "info" => "Unathorized request."];
		\OpenHCP\OpenHCP::sendData(401, $data);
	}

	public function getClient() {
		if (\OpenHCP\OpenHCP::checkAcl(["client"])) {
			\OpenHCP\OpenHCP::continueSession();
			$sql = 'SELECT * FROM client WHERE ';
			$sql .= 'id = :id';
			$prepared = $this->pdo_ro->prepare($sql);
			$prepared->bindParam(':id', $_SESSION['user']['data']['id']);
			$prepared->execute();
			$client = $prepared->fetchAll(\PDO::FETCH_ASSOC);
			if (count($client) > 0) {
				$client_data['id'] = $client[0]['id'];
				$client_data['name'] = $client[0]['name'];
				$client_data['gid'] = $client[0]['gid'];
				$client_data['active'] = $client[0]['active'];
				$data = ["status" => true, "info" => "", "data" => $client_data];
				\OpenHCP\OpenHCP::sendData(200, $data);
			}
		} elseif (\OpenHCP\OpenHCP::checkAcl(["admin"])) {
			\OpenHCP\OpenHCP::continueSession();
			$sql = 'SELECT * FROM client WHERE ';
			if (strlen(trim($this->json['name'])) > 0) {
				$sql .= 'name = :name';
				$prepared = $this->pdo_ro->prepare($sql);
				$prepared->bindParam(':name', $this->json['name']);
			} elseif ($this->json['id'] > 0) {
				$sql .= 'id = :id';
				$prepared = $this->pdo_ro->prepare($sql);
				$prepared->bindParam(':id', $this->json['id']);
			} else {
				$sql .= 'id = :id';
				$prepared = $this->pdo_ro->prepare($sql);
				$prepared->bindParam(':id', $_SESSION['user']['data']['id']);
			}
			$prepared->execute();
			$client = $prepared->fetchAll(\PDO::FETCH_ASSOC);
			if (count($client) > 0) {
				$client_data['id'] = $client[0]['id'];
				$client_data['name'] = $client[0]['name'];
				$client_data['gid'] = $client[0]['gid'];
				$client_data['active'] = $client[0]['active'];
				$data = ["status" => true, "info" => "", "data" => $client_data];
				\OpenHCP\OpenHCP::sendData(200, $data);
			}
		}
		$data = ["status" => false, "info" => "Unathorized request."];
		\OpenHCP\OpenHCP::sendData(401, $data);
	}

}
