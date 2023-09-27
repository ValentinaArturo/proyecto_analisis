<?php

require '../db/config.php';
require '../auth/Token.php';


header('Content-Type: application/json');

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, PUT, OPTIONS, PATCH, DELETE');
header('Access-Control-Allow-Credentials: true');
header("Access-Control-Allow-Headers: Authorization, Content-Type");


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
            case 'GET':

                $query_validation = "SELECT * FROM USUARIO";
                $stmt_validation = $dbhost->prepare($query_validation);
                $stmt_validation->execute();
        
                $results = $stmt_validation->fetchAll(PDO::FETCH_ASSOC);
        
                $json = json_encode($results);
        
                echo $json;

                break;
                
            case 'POST':
                echo json_encode(array(
                    "status" => 404,
                    "msg" => "Método no disponible"
                ));
                break;
            case 'PUT':
                // $json = file_get_contents("php://input");

                // if ($json == false || trim($json) == "") {
                //     echo json_encode([
                //         "status" => 400,
                //         "msg" => "Error en datos recibidos",
                //     ]);
                //     die();
                // }

                // $data = json_decode($json,true);

                // if (
                //     !isset($data["nombre"]) ||
                //     !isset($data["apellido"]) ||
                //     !isset($data["fechaNacimiento"]) ||
                //     !isset($data["genero"]) ||
                //     !isset($data["email"]) ||
                //     !isset($data["telefono"]) ||
                //     !isset($data["password"]) ||
                //     !isset($data["IdSucursal"]) ||
                //     $data["nombre"] == "" ||
                //     $data["apellido"] == "" ||
                //     $data["fechaNacimiento"] == "" ||
                //     $data["genero"] == "" ||
                //     $data["email"] == "" ||
                //     $data["telefono"] == "" ||
                //     $data["password"] == "" ||
                //     $data["IdSucursal"] == "" ||
                //     count($data) !== 8
                // ) {
                //     echo json_encode([
                //         "status" => 400,
                //         "msg" => "Formato de datos incorrecto",
                //     ]);
                //     die();
                // }

                echo json_encode(array(
                    "status" => 404,
                    "msg" => "Método no disponible"
                ));
                break;
                
                break;
            case 'DELETE':
                echo json_encode(array(
                    "status" => 404,
                    "msg" => "Método no disponible"
                ));
                break;
            default:
                echo json_encode(array(
                    "status" => 404,
                    "msg" => "Método no permitido"
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