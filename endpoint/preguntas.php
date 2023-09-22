<?php

header('Content-Type: application/json');
$json = file_get_contents('php://input');
date_default_timezone_set('America/Guatemala');


if ($json == false || trim($json) == "") {
    echo json_encode(
        array(
            "status" => 400,
            "msg" => "Error en datos recibidos"
        )
    );
    die();
}

$data = json_decode($json);

if (!isset($data->email) || $data->email == "" || count(get_object_vars($data)) !== 1) {
    echo json_encode(
        array(
            "status" => 400,
            "msg" => "Formato de datos incorrecto"
        )
    );
    die();
}
$email = $data->email;

require '../auth/Token.php';
require '../db/config.php';

//Secret Key
const KEY = 'analisisDeSistemas1234#';

//Configuracion PDO
$options = array(
    PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8'
);

$db = 'mysql:host=' . DB_HOSTNAME . ';dbname=' . DB_NAME;
$dbhost = new PDO($db, DB_USERNAME, DB_PASSWORD, $options);

$query_validation =
    "SELECT Pregunta From USUARIO_PREGUNTA A 
        Inner Join USUARIO B On B.IdUsuario = A.IdUSUARIO
        Where B.CorreoElectronico = :email
        Order By OrdenPregunta";
$stmt_validation = $dbhost->prepare($query_validation);
$stmt_validation->bindParam(':email', $email);
$stmt_validation->execute();
$results = $stmt_validation->fetchAll(PDO::FETCH_ASSOC);
$json = $results;

if ($stmt_validation->rowCount() == 0) {
    echo json_encode(
        array(
            "status" => 401,
            "msg" => "El usuario no tiene preguntas parametrizadas"
        )
    );
} else {
    echo json_encode(
        array(
            "status" => 200,
            "data" => $json
        )
    );
    die();
}

?>