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

                $query_validation ='SELECT * FROM PERSONA';
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
                    !isset($data["Apellido"]) ||
                    !isset($data["FechaNacimiento"]) ||
                    !isset($data["IdGenero"]) ||
                    !isset($data["Direccion"]) ||
                    !isset($data["Telefono"]) ||
                    !isset($data["CorreoElectronico"]) ||
                    !isset($data["IdEstadoCivil"]) ||
                    !isset($data["UsuarioCreacion"]) ||
                    $data["Nombre"] == "" ||
                    $data["Apellido"] == "" ||
                    $data["FechaNacimiento"] == "" ||
                    $data["IdGenero"] == "" ||
                    $data["Direccion"] == "" ||
                    $data["Telefono"] == "" ||
                    $data["CorreoElectronico"] == "" ||
                    $data["IdEstadoCivil"] == "" ||
                    $data["UsuarioCreacion"] == "" ||
                    count($data) !== 9
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $nombre = $data["Nombre"];
                $apellido = $data["Apellido"];
                $fechaNacimiento = $data["FechaNacimiento"];
                $IdGenero = $data["IdGenero"];
                $Direccion = $data["Direccion"];
                $Telefono = $data["Telefono"];
                $CorreoElectronico = $data["CorreoElectronico"];
                $IdEstadoCivil = $data["IdEstadoCivil"];
                $UsuarioCreacion = $data["UsuarioCreacion"];
                $fechaHoraActual = date('Y-m-d H:i:s');

                $query_post = "INSERT INTO PERSONA(
                    Nombre, 
                    Apellido, 
                    FechaNacimiento, 
                    IdGenero, 
                    Direccion, 
                    Telefono, 
                    CorreoElectronico,
                    IdEstadoCivil, 
                    FechaCreacion,
                    UsuarioCreacion) VALUES (
                        :nombre,
                        :apellido,
                        :fechaNacimiento,
                        :idGenero,
                        :Direccion,
                        :Telefono,
                        :CorreoElectronico,
                        :IdEstadoCivil,
                        :fechaHora,
                        :UsuarioCreacion)";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':nombre', $nombre);
                $stmt_post->bindParam(':apellido', $apellido);
                $stmt_post->bindParam(':fechaNacimiento', $fechaNacimiento);
                $stmt_post->bindParam(':idGenero', $IdGenero);
                $stmt_post->bindParam(':Direccion', $Direccion);
                $stmt_post->bindParam(':Telefono', $Telefono);
                $stmt_post->bindParam(':CorreoElectronico', $CorreoElectronico);
                $stmt_post->bindParam(':IdEstadoCivil', $IdEstadoCivil);
                $stmt_post->bindParam(':fechaHora', $fechaHoraActual);
                $stmt_post->bindParam(':UsuarioCreacion', $UsuarioCreacion);
                $stmt_post->execute();

                if($stmt_post->rowCount() > 0 ){

                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Persona creada exitosamente"
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
                    !isset($data["Apellido"]) ||
                    !isset($data["FechaNacimiento"]) ||
                    !isset($data["IdGenero"]) ||
                    !isset($data["Direccion"]) ||
                    !isset($data["Telefono"]) ||
                    !isset($data["CorreoElectronico"]) ||
                    !isset($data["IdEstadoCivil"]) ||
                    !isset($data["UsuarioModificacion"]) ||
                    !isset($data["IdPersona"]) ||
                    $data["Nombre"] == "" ||
                    $data["Apellido"] == "" ||
                    $data["FechaNacimiento"] == "" ||
                    $data["IdGenero"] == "" ||
                    $data["Direccion"] == "" ||
                    $data["Telefono"] == "" ||
                    $data["CorreoElectronico"] == "" ||
                    $data["IdEstadoCivil"] == "" ||
                    $data["UsuarioModificacion"] == "" ||
                    $data["IdPersona"] == "" ||
                    count($data) !== 10
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $nombre = $data["Nombre"];
                $apellido = $data["Apellido"];
                $fechaNacimiento = $data["FechaNacimiento"];
                $IdGenero = $data["IdGenero"];
                $Direccion = $data["Direccion"];
                $Telefono = $data["Telefono"];
                $CorreoElectronico = $data["CorreoElectronico"];
                $IdEstadoCivil = $data["IdEstadoCivil"];
                $UsuarioModificacion = $data["UsuarioModificacion"];
                $IdPersona = $data["IdPersona"];
                $fechaHoraActual = date('Y-m-d H:i:s');

                $query_post = "UPDATE PERSONA SET 
                Nombre=:nombre,
                Apellido=:apellido,
                FechaNacimiento=:fechaNacimiento,
                IdGenero=:idGenero,
                Direccion=:Direccion,
                Telefono=:Telefono,
                CorreoElectronico=:CorreoElectronico,
                IdEstadoCivil=:IdEstadoCivil,
                FechaModificacion=:fechaHora,
                UsuarioModificacion=:UsuarioModificacion 
                WHERE IdPersona=:idPersona";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':nombre', $nombre);
                $stmt_post->bindParam(':apellido', $apellido);
                $stmt_post->bindParam(':fechaNacimiento', $fechaNacimiento);
                $stmt_post->bindParam(':idGenero', $IdGenero);
                $stmt_post->bindParam(':Direccion', $Direccion);
                $stmt_post->bindParam(':Telefono', $Telefono);
                $stmt_post->bindParam(':CorreoElectronico', $CorreoElectronico);
                $stmt_post->bindParam(':IdEstadoCivil', $IdEstadoCivil);
                $stmt_post->bindParam(':fechaHora', $fechaHoraActual);
                $stmt_post->bindParam(':UsuarioModificacion', $UsuarioModificacion);
                $stmt_post->bindParam(':idPersona', $IdPersona);
                $stmt_post->execute();

                if($stmt_post->rowCount() > 0 ){

                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Persona actualizada exitosamente"
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