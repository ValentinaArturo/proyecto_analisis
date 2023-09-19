<?php

require '../db/config.php';

header('Content-Type: application/json');

$options = array(
    PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8'
);

$db = 'mysql:host=' . DB_HOSTNAME . ';dbname=' . DB_NAME;
$dbhost = new PDO($db, DB_USERNAME, DB_PASSWORD, $options);

$query_validation = "SELECT IdGenero,Nombre as 'Genero' FROM GENERO";
$stmt_validation = $dbhost->prepare($query_validation);
$stmt_validation->execute();

$results = $stmt_validation->fetchAll(PDO::FETCH_ASSOC);

$json = json_encode($results);

echo $json;


?>