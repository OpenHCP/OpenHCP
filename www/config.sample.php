<?php

/**
 * OpenHCP - Open Hosting Control Panel
 *
 * @author Michał Pena <cyb0org@gmail.com>
 * @copyright (C) 2016, Michał Pena
 * @license https://opensource.org/licenses/ISC ISC License
 */
/** @var string $dbhost_ro MySQL host only for read - fast */
define('dbhost_ro', 'localhost');

/** @var string $dbuser_ro MySQL user */
define('dbuser_ro', '');

/** @var string $dbpass_ro MySQL user password */
define('dbpass_ro', '');

/** @var string $dbname_ro MySQL database name */
define('dbname_ro', '');

/** @var string $dbhost_rw MySQL host only for write - slow */
define('dbhost_rw', 'localhost');

/** @var string $dbuser_rw MySQL user */
define('dbuser_rw', '');

/** @var string $dbpass_rw MySQL user password */
define('dbpass_rw', '');

/** @var string $dbname_rw MySQL database name */
define('dbname_rw', '');

/** @var string $source_dir directory where classes lies */
define('source_dir', '../core/');
