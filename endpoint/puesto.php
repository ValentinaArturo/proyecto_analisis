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

                $query_validation ='SELECT * FROM PUESTO';
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
                    !isset($data["IdDepartamento"]) ||
                    !isset($data["UsuarioCreacion"]) ||
                    $data["Nombre"] == "" ||
                    $data["IdDepartamento"] == "" ||
                    $data["UsuarioCreacion"] == "" ||
                    count($data) !== 3
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdEmpresa = $data["IdDepartamento"];
                $nombre = $data["Nombre"];
                $IdUsuarioCreacion = $data["UsuarioCreacion"];
                $fechaHoraActual = date('Y-m-d H:i:s');

                $query_post = "INSERT INTO PUESTO(
                    Nombre, 
                    IdDepartamento, 
                    FechaCreacion, 
                    UsuarioCreacion) VALUES (
                        :nombre,
                        :idEmpresa,
                        :fechaHoraActual,
                        :usuarioCreacion)";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':nombre', $nombre);
                $stmt_post->bindParam(':idEmpresa', $IdEmpresa);
                $stmt_post->bindParam(':usuarioCreacion', $IdUsuarioCreacion);
                $stmt_post->bindParam(':fechaHoraActual', $fechaHoraActual);
                $stmt_post->execute();

                if($stmt_post->rowCount() > 0 ){

                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Puesto creado exitosamente"
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
                    !isset($data["Nombre"]) ||
                    !isset($data["IdDepartamento"]) ||
                    !isset($data["UsuarioModificacion"]) ||
                    !isset($data["IdPuesto"]) ||
                    $data["Nombre"] == "" ||
                    $data["IdDepartamento"] == "" ||
                    $data["UsuarioModificacion"] == "" ||
                    $data["IdPuesto"] == "" ||
                    count($data) !== 4
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdEmpresa = $data["IdDepartamento"];
                $nombre = $data["Nombre"];
                $IdUsuarioCreacion = $data["UsuarioModificacion"];
                $IdDepartametno = $data["IdPuesto"];
                $fechaHoraActual = date('Y-m-d H:i:s');

                $query_post = "UPDATE PUESTO SET 
                Nombre=:nombre,
                IdDepartamento=:idEmpresa,
                FechaModificacion=:fechaHoraActual,
                UsuarioModificacion=:usuarioCreacion 
                WHERE IdPuesto=:IdDepartamento";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':nombre', $nombre);
                $stmt_post->bindParam(':idEmpresa', $IdEmpresa);
                $stmt_post->bindParam(':usuarioCreacion', $IdUsuarioCreacion);
                $stmt_post->bindParam(':fechaHoraActual', $fechaHoraActual);
                $stmt_post->bindParam(':IdDepartamento', $IdDepartametno);
                $stmt_post->execute();

                if($stmt_post->rowCount() > 0 ){

                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Puesto actualizado exitosamente"
                    ));
                    
                }else{
                    
                    echo json_encode(array(
                        "status" => 401,
                        "msg" => "Ocurrio un error, intenta nuevamente"
                    ));
                }

                break;
            case 'DELETE':
                echo json_encode(array(
                    "status" => 401,
                    "msg" => "METODO NO DISPONIBLE"
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