<?php

require '../db/config.php';
require '../auth/Token.php';


header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, PUT, OPTIONS, PATCH, DELETE');
header('Access-Control-Allow-Credentials: true');
header("Access-Control-Allow-Headers: Authorization, Content-Type");

date_default_timezone_set("America/Guatemala");

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

                $query_validation = "SELECT * FROM INASISTENCIA";
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
                    !isset($data["IdEmpleado"]) ||
                    !isset($data["FechaInicial"]) ||
                    !isset($data["FechaFinal"]) ||
                    !isset($data["MotivoInasistencia"]) ||
                    !isset($data["FechaProcesado"]) ||
                    $data["IdEmpleado"] == "" ||
                    $data["FechaInicial"] == "" ||
                    $data["FechaFinal"] == "" ||
                    $data["MotivoInasistencia"] == "" ||
                    $data["FechaProcesado"] == "" ||
                    count($data) !== 5
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdEmpleado = $data["IdEmpleado"];
                $FechaInicial = $data["FechaInicial"];
                $FechaFinal = $data["FechaFinal"];
                $MotivoInasistencia = $data["MotivoInasistencia"];
                $FechaProcesado = $data["FechaProcesado"];
                $fechaHoraActual = date('Y-m-d H:i:s');

                $usuarioCreacion = Token::GetUserID($token);

                $query_post = "INSERT INTO INASISTENCIA(
                IdEmpleado, 
                FechaInicial, 
                FechaFinal, 
                MotivoInasistencia, 
                FechaProcesado, 
                FechaCreacion, 
                UsuarioCreacion) 
                VALUES 
                (
                :idEmpleado,
                :fechaInicial,
                :fechaFinal,
                :motivoInasistencia,
                :fechaProcesada,
                :fechaHoraActual,
                :usuarioCreacion
                )";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':idEmpleado', $IdEmpleado);
                $stmt_post->bindParam(':fechaInicial', $FechaInicial);
                $stmt_post->bindParam(':fechaFinal', $FechaFinal);
                $stmt_post->bindParam(':motivoInasistencia', $MotivoInasistencia);
                $stmt_post->bindParam(':fechaProcesada', $fechaHoraActual);
                $stmt_post->bindParam(':fechaHoraActual', $fechaHoraActual);
                $stmt_post->bindParam(':usuarioCreacion', $usuarioCreacion);
                $stmt_post->execute();

                if($stmt_post->rowCount() > 0 ){
                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Inasistencia agregada exitosamente"
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
                    !isset($data["IdEmpleado"]) ||
                    !isset($data["FechaInicial"]) ||
                    !isset($data["FechaFinal"]) ||
                    !isset($data["MotivoInasistencia"]) ||
                    !isset($data["FechaProcesado"]) ||
                    !isset($data["IdInasistencia"]) ||
                    $data["IdEmpleado"] == "" ||
                    $data["FechaInicial"] == "" ||
                    $data["FechaFinal"] == "" ||
                    $data["MotivoInasistencia"] == "" ||
                    $data["FechaProcesado"] == "" ||
                    $data["IdInasistencia"] == "" ||
                    count($data) !== 6
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdEmpleado = $data["IdEmpleado"];
                $FechaInicial = $data["FechaInicial"];
                $FechaFinal = $data["FechaFinal"];
                $MotivoInasistencia = $data["MotivoInasistencia"];
                $FechaProcesado = $data["FechaProcesado"];
                $IdInasistencia = $data["IdInasistencia"];
                $fechaHoraActual = date('Y-m-d H:i:s');

                $usuarioCreacion = Token::GetUserID($token);

                $query_post = "UPDATE INASISTENCIA SET 
                IdEmpleado=:idEmpleado,
                FechaInicial=:fechaInicial,
                FechaFinal=:fechaFinal,
                MotivoInasistencia=:motivoInasistencia,
                FechaProcesado=:fechaProcesada,
                FechaModificacion=:fechaHoraActual,
                UsuarioModificacion=:usuarioCreacion
                WHERE IdInasistencia =:idInasistencia ";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':idEmpleado', $IdEmpleado);
                $stmt_post->bindParam(':fechaInicial', $FechaInicial);
                $stmt_post->bindParam(':fechaFinal', $FechaFinal);
                $stmt_post->bindParam(':motivoInasistencia', $MotivoInasistencia);
                $stmt_post->bindParam(':fechaProcesada', $fechaHoraActual);
                $stmt_post->bindParam(':fechaHoraActual', $fechaHoraActual);
                $stmt_post->bindParam(':usuarioCreacion', $usuarioCreacion);
                $stmt_post->bindParam(':idInasistencia', $IdInasistencia,PDO::PARAM_INT);
                $stmt_post->execute();

                if($stmt_post->rowCount() > 0 ){
                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Inasistencia actualizada exitosamente"
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
                    !isset($data["idInasistencia"]) ||
                    $data["idInasistencia"] == "" ||
                    count($data) !== 1
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $idInasistencia = $data["idInasistencia"];

                $query_delete = "DELETE FROM INASISTENCIA WHERE IdInasistencia=:idInasistencia";
                $stmt_post = $dbhost->prepare($query_delete);
                $stmt_post->bindParam(':idInasistencia', $idInasistencia,PDO::PARAM_INT);
                $stmt_post->execute();

                if($stmt_post->rowCount() > 0 ){
                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Inasistencia eliminada exitosamente"
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