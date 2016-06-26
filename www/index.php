<?php

require_once 'init.php';

$salt = substr(preg_replace('/[+=]/', '', base64_encode(openssl_random_pseudo_bytes(16))), 0, 16);
$cryptpass = crypt($password, '$6$rounds=500000$' . $salt . '$');

// UID/GID - do not use 65500 - 65600
