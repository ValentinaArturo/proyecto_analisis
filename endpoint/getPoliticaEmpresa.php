<?php

require '../db/config.php';

header('Content-Type: application/json');


if(!isset($_GET["empresa"])){
    echo json_encode([
        "status" => 400,
        "msg" => "Error en datos recibidos",
    ]);
    die();
}

$idEmpresa = $_GET["empresa"];


if($idEmpresa == null){
    echo json_encode([
        "status" => 400,
        "msg" => "Error en datos recibidos",
    ]);
    die();
}

$options = array(
    PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8'
);

$db = 'mysql:host=' . DB_HOSTNAME . ';dbname=' . DB_NAME;
$dbhost = new PDO($db, DB_USERNAME, DB_PASSWORD, $options);

$query_validation = "SELECT PasswordCantidadMayusculas, PasswordCantidadMinusculas, 
PasswordCantidadCaracteresEspeciales, PasswordLargo,PasswordCantidadNumeros FROM EMPRESA WHERE IdEmpresa =:idEmpresa";
$stmt_validation = $dbhost->prepare($query_validation);
$stmt_validation->bindParam(':idEmpresa', $idEmpresa);
$stmt_validation->execute();

$results = $stmt_validation->fetchAll(PDO::FETCH_ASSOC);

$json = json_encode($results);

echo $json;


?>