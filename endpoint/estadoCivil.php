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

                $query_validation ='SELECT * FROM ESTADO_CIVIL';
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
                    !isset($data["Nombre"]) ||
                    !isset($data["IdUsuarioCreacion"]) ||
                    $data["Nombre"] == "" ||
                    $data["IdUsuarioCreacion"] == "" ||
                    count($data) !== 2
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdUsuarioCreacion = $data["IdUsuarioCreacion"];
                $nombre = $data["Nombre"];
                $fechaHoraActual = date('Y-m-d H:i:s');

                $query_post = " INSERT INTO ESTADO_CIVIL(
                Nombre,
                FechaCreacion, 
                UsuarioCreacion
                ) 
                VALUES (
                :nombre,
                :fechaHoraActual,
                :usuarioCreacion) ";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':nombre', $nombre);
                $stmt_post->bindParam(':fechaHoraActual', $fechaHoraActual);
                $stmt_post->bindParam(':usuarioCreacion', $IdUsuarioCreacion);
                $stmt_post->execute();

                if($stmt_post->rowCount() > 0 ){

                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Estado civil creado exitosamente"
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
                    !isset($data["IdEstadoCivil"]) ||
                    !isset($data["IdUsuarioModificacion"]) ||
                    !isset($data["Nombre"]) ||
                    $data["Nombre"] == "" ||
                    $data["IdEstadoCivil"] == "" ||
                    $data["IdUsuarioModificacion"] == "" ||
                    count($data) !== 3
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdUsuarioCreacion = $data["IdUsuarioModificacion"];
                $nombre = $data["Nombre"];
                $IdStatusUsuario =  $data['IdEstadoCivil'];
                $fechaHoraActual = date('Y-m-d H:i:s');

                $query_post = "UPDATE `ESTADO_CIVIL` SET 
                Nombre = :nombre,
                FechaModificacion = :fechaHoraActual ,
                UsuarioModificacion = :IdUsuarioCreacion
                WHERE IdEstadoCivil = :IdStatusUsuario";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':nombre', $nombre);
                $stmt_post->bindParam(':fechaHoraActual', $fechaHoraActual);
                $stmt_post->bindParam(':IdUsuarioCreacion', $IdUsuarioCreacion);
                $stmt_post->bindParam(':IdStatusUsuario', $IdStatusUsuario);
                $stmt_post->execute();

                if($stmt_post->rowCount() > 0 ){

                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Estado actualizado exitosamente"
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
                    !isset($data["IdEstadoCivil"]) ||
                    $data["IdEstadoCivil"] == "" ||
                    count($data) !== 1
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdUsuarioCreacion = $data["IdEstadoCivil"];


                $query_post = "DELETE FROM ESTADO_CIVIL WHERE IdEstadoCivil=:idEstadoCivil ";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':idEstadoCivil', $IdUsuarioCreacion, PDO::PARAM_INT);
                $stmt_post->execute();

                if($stmt_post->rowCount() > 0 ){

                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Estado civil eliminado exitosamente"
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