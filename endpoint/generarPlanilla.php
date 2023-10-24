<?php

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, PUT, OPTIONS, PATCH, DELETE');
header('Access-Control-Allow-Credentials: true');
header("Access-Control-Allow-Headers: Authorization, Content-Type");

header("Content-Type: application/json");
date_default_timezone_set("America/Guatemala");


require '../db/config.php';
require '../auth/Token.php';

const KEY = 'analisisDeSistemas1234#';
$headers = getallheaders();
$token = null;

$method = $_SERVER['REQUEST_METHOD'];


if (isset($headers['Authorization'])) {
    $authorizationHeader = $headers['Authorization'];
    $matches = array();
    if (preg_match('/Bearer (.+)/', $authorizationHeader, $matches)) {
        if (isset($matches[1])) {
            $token = $matches[1];
        }
    }
}

if ($token) {

    $options = array(
        PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8'
    );
    
    $db = 'mysql:host=' . DB_HOSTNAME . ';dbname=' . DB_NAME;
    $dbhost = new PDO($db, DB_USERNAME, DB_PASSWORD, $options);
    
    if(Token::Verify($token,KEY)){


        switch ($method) {                
            case 'POST':

                $json = file_get_contents("php://input");
                $fechaHoraActual = date('Y-m-d H:i:s');

                if ($json == false || trim($json) == "") {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Error en datos recibidos",
                    ]);
                    die();
                }

                $data = json_decode($json,true);

                if (
                    !isset($data["year"]) ||
                    !isset($data["month"]) ||
                    $data["year"] == "" ||
                    $data["month"] == "" ||
                    count($data) !== 2
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $year =  $data["year"];
                $month = $data["month"];
                $usuarioCreacion = Token::GetUserID($token);

                $query = "CALL generar_planilla(:year,:month,:usuarioCreacion)";
                $stmt_post = $dbhost->prepare($query);
                $stmt_post->bindParam(':year', $year,PDO::PARAM_INT);
                $stmt_post->bindParam(':month', $month,PDO::PARAM_INT);
                $stmt_post->bindParam(':usuarioCreacion', $usuarioCreacion);
                $stmt_post->execute();

                $customMessage = $stmt_post->fetchColumn();

                if ($customMessage == "No se puede generar planilla, planilla ya generada") {
                    echo json_encode(array(
                        "status" => 401,
                        "msg" => "No se puede generar planilla, planilla ya generada"
                    ));
                } else {
                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Planilla Generado con exito"
                    ));
                }

                break;
            default:
                echo json_encode(array(
                    "status" => 404,
                    "msg" => "Método no disponible"
                ));
                break;
        }

        
   

    }

} else {
    echo json_encode(array(
        "status" => 401,
        "msg" => "Error: Token no presente en la cabecera de autorización"
    ));
}


?>