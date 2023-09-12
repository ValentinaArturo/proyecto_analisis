<?php

require '../db/config.php';
require '../auth/Token.php';

header('Content-Type: application/json');

const KEY = 'analisisDeSistemas1234#';
$headers = getallheaders();
$token = null;

$json = file_get_contents('php://input');
date_default_timezone_set('America/Guatemala');

if (isset($headers['Authorization'])) {
    $authorizationHeader = $headers['Authorization'];
    $matches = array();
    if (preg_match('/Bearer (.+)/', $authorizationHeader, $matches)) {
        if (isset($matches[1])) {
            $token = $matches[1];
        }
    }
}

if ($json == false || trim($json) == "") {
    echo json_encode(array(
        "status" => 400,
        "msg" => "Error en datos recibidos"
    ));
    die();
}

$data = json_decode($json);

if (!isset($data->email) || $data->email == "" || count(get_object_vars($data)) !== 1) {
    echo json_encode(array(
        "status" => 400,
        "msg" => "Formato de datos incorrecto"
    ));
    die();
}
$email = $data->email;

if ($token) {

    $options = array(
        PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8'
    );

    $db = 'mysql:host=' . DB_HOSTNAME . ';dbname=' . DB_NAME;
    $dbhost = new PDO($db, DB_USERNAME, DB_PASSWORD, $options);

   if (Token::Verify($token, KEY)) {

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
    }

} else {
    echo json_encode(
        array(
            "status" => 401,
            "msg" => "Error: Token no presente en la cabecera de autorización"
        )
    );
}