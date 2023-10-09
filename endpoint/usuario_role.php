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
            case 'GET':

                $query_validation = "SELECT * FROM USUARIO_ROLE";
                $stmt_validation = $dbhost->prepare($query_validation);
                $stmt_validation->execute();
        
                $results = $stmt_validation->fetchAll(PDO::FETCH_ASSOC);
        
                $json = json_encode($results);
        
                echo $json;

                break;
                
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
                    !isset($data["IdUsuario"]) ||
                    !isset($data["IdRole"]) ||
                    !isset($data["IdUsuarioCreacion"]) ||
                    $data["IdUsuario"] == "" ||
                    $data["IdRole"] == "" ||
                    $data["IdUsuarioCreacion"] == "" ||
                    count($data) !== 3
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdUsuario = $data["IdUsuario"];
                $IdRole = (int)$data["IdRole"];
                $IdUsuarioCreacion = $data["IdUsuarioCreacion"];
                $fechaHoraActual = date('Y-m-d H:i:s');

                $query_post = "INSERT INTO USUARIO_ROLE(IdUsuario,IdRole,FechaCreacion,UsuarioCreacion,FechaModificacion,UsuarioModificacion)
                VALUES(:IdUsuario,:IdRole,:FechaHoraActual,:IdUsuarioCreacion,NULL,NULL)";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':IdUsuario', $IdUsuario);
                $stmt_post->bindParam(':IdRole', $IdRole,PDO::PARAM_INT);
                $stmt_post->bindParam(':FechaHoraActual', $fechaHoraActual);
                $stmt_post->bindParam(':IdUsuarioCreacion', $IdUsuarioCreacion);
                $stmt_post->execute();

                if($stmt_post->rowCount() > 0 ){

                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Rol asignado exitosamente"
                    ));
                    
                }else{
                    
                    echo json_encode(array(
                        "status" => 401,
                        "msg" => "Ocurrio un error, intenta nuevamente"
                    ));
                }

                break;
            case 'PUT':
                
                $json = file_get_contents("php://input");

                if ($json == false || trim($json) == "") {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Error en datos recibidos",
                    ]);
                    die();
                }

                $data = json_decode($json,true);

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
                    !isset($data["IdUsuario"]) ||
                    !isset($data["IdRole"]) ||
                    !isset($data["IdUsuarioModificacion"]) ||
                    $data["IdUsuario"] == "" ||
                    $data["IdRole"] == "" ||
                    $data["IdUsuarioModificacion"] == "" ||
                    count($data) !== 3
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdUsuario = $data["IdUsuario"];
                $IdRole = (int)$data["IdRole"];
                $IdUsuarioModificacion = $data["IdUsuarioModificacion"];


                $query_post = "UPDATE USUARIO_ROLE SET IdRole=:IdRole, FechaModificacion=:FechaHoraActual, UsuarioModificacion=:IdUsuarioModificacion
                WHERE IdUsuario=:IdUsuario";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':IdUsuario', $IdUsuario);
                $stmt_post->bindParam(':IdRole', $IdRole,PDO::PARAM_INT);
                $stmt_post->bindParam(':FechaHoraActual', $fechaHoraActual);
                $stmt_post->bindParam(':IdUsuarioModificacion', $IdUsuarioModificacion);
                $stmt_post->execute();


                if($stmt_post->rowCount() > 0 ){

                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Rol actualizado exitosamente"
                    ));
                    
                }else{
                    
                    echo json_encode(array(
                        "status" => 401,
                        "msg" => "Ocurrio un error, intenta nuevamente"
                    ));
                }

                break;
            case 'DELETE':
                $json = file_get_contents("php://input");

                if ($json == false || trim($json) == "") {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Error en datos recibidos",
                    ]);
                    die();
                }

                $data = json_decode($json,true);
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
                    !isset($data["IdUsuario"]) ||
                    !isset($data["IdRole"]) ||
                    $data["IdUsuario"] == "" ||
                    $data["IdRole"] == "" ||
                    count($data) !== 2
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdUsuario = $data["IdUsuario"];
                $IdRole = (int)$data["IdRole"];

                $query_post = "DELETE FROM USUARIO_ROLE WHERE IdUsuario=:IdUsuario AND IdRole=:IdRole";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':IdUsuario', $IdUsuario);
                $stmt_post->bindParam(':IdRole', $IdRole,PDO::PARAM_INT);
                $stmt_post->execute();


                if($stmt_post->rowCount() > 0 ){

                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Rol elimando exitosamente"
                    ));
                    
                }else{
                    
                    echo json_encode(array(
                        "status" => 401,
                        "msg" => "Ocurrio un error, intenta nuevamente"
                    ));
                }
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