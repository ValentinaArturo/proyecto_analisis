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

                $query_validation ='SELECT * FROM FLUJO_STATUS_EMPLEADO';
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
                    !isset($data["IdStatusActual"]) ||
                    !isset($data["IdStatusNuevo"]) ||
                    !isset($data["NombreEvento"]) ||
                    !isset($data["UsuarioCreacion"]) ||
                    $data["IdStatusActual"] == "" ||
                    $data["IdStatusNuevo"] == "" ||
                    $data["NombreEvento"] == "" ||
                    $data["UsuarioCreacion"] == "" ||
                    count($data) !== 4
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdStatusActual =  $data["IdStatusActual"];
                $IdStatusNuevo = $data["IdStatusNuevo"];
                $NombreEvento = $data["NombreEvento"];
                $UsuarioCreacion = $data["UsuarioCreacion"];
                $fechaHoraActual = date('Y-m-d H:i:s');

                $query_post = "INSERT INTO 
                FLUJO_STATUS_EMPLEADO(
                    IdStatusActual,
                    IdStatusNuevo,
                    NombreEvento, 
                    FechaCreacion, 
                    UsuarioCreacion) 
                    VALUES (
                        :idStatusActual,
                        :idStatusNuevo,
                        :nombreEvento,
                        :fechaHoraActual,
                        :usuarioCreacion)";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':idStatusActual', $IdStatusActual, PDO::PARAM_INT);
                $stmt_post->bindParam(':idStatusNuevo', $IdStatusNuevo, PDO::PARAM_INT);
                $stmt_post->bindParam(':nombreEvento', $NombreEvento);
                $stmt_post->bindParam(':fechaHoraActual', $fechaHoraActual);
                $stmt_post->bindParam(':usuarioCreacion', $UsuarioCreacion);
                $stmt_post->execute();

                if($stmt_post->rowCount() > 0 ){

                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Flujo creado exitosamente"
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
                    !isset($data["IdStatusActual"]) ||
                    !isset($data["IdStatusNuevo"]) ||
                    !isset($data["NombreEvento"]) ||
                    !isset($data["UsuarioModificacion"]) ||
                    $data["IdStatusActual"] == "" ||
                    $data["IdStatusNuevo"] == "" ||
                    $data["NombreEvento"] == "" ||
                    $data["UsuarioModificacion"] == "" ||
                    count($data) !== 4
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdStatusActual =  $data["IdStatusActual"];
                $IdStatusNuevo = $data["IdStatusNuevo"];
                $NombreEvento = $data["NombreEvento"];
                $UsuarioCreacion = $data["UsuarioModificacion"];
                $fechaHoraActual = date('Y-m-d H:i:s');

                $query_post = "UPDATE 
                FLUJO_STATUS_EMPLEADO
                SET 
                    IdStatusActual=:idStatusActual,
                    IdStatusNuevo=:idStatusNuevo,
                    NombreEvento=:nombreEvento,
                    FechaModificacion=:fechaHoraActual,
                    UsuarioModificacion=:usuarioCreacion
                 WHERE IdStatusActual=:idStatusActual AND IdStatusNuevo=:idStatusNuevo";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':idStatusActual', $IdStatusActual, PDO::PARAM_INT);
                $stmt_post->bindParam(':idStatusNuevo', $IdStatusNuevo, PDO::PARAM_INT);
                $stmt_post->bindParam(':nombreEvento', $NombreEvento);
                $stmt_post->bindParam(':fechaHoraActual', $fechaHoraActual);
                $stmt_post->bindParam(':usuarioCreacion', $UsuarioCreacion);
                $stmt_post->execute();

                if($stmt_post->rowCount() > 0 ){

                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Flujo actualizado exitosamente"
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