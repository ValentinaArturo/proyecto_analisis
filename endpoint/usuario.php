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
                $json = file_get_contents("php://input");

                if ($json == false || trim($json) == "") {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Error en datos de entrada",
                    ]);
                    die();
                }
                
                $data = json_decode($json,true);
                                
                if (
                    !isset($data["nombre"]) ||
                    !isset($data["apellido"]) ||
                    !isset($data["fechaNacimiento"]) ||
                    !isset($data["genero"]) ||
                    !isset($data["email"]) ||
                    !isset($data["telefono"]) ||
                    !isset($data["idSucursal"]) ||
                    !isset($data["usuarioModifica"]) ||
                    !isset($data["idUsuario"]) ||
                    !isset($data["idStatusUsuario"]) ||
                    $data["nombre"] == "" ||
                    $data["apellido"] == "" ||
                    $data["fechaNacimiento"] == "" ||
                    $data["genero"] == "" ||
                    $data["email"] == "" ||
                    $data["telefono"] == "" ||
                    $data["idSucursal"] == "" ||
                    $data["usuarioModifica"] == "" ||
                    $data["idUsuario"] == "" ||
                    $data["idStatusUsuario"] == "" ||
                    count($data) !== 10)
                {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrectos",
                    ]);
                    die();
                }
                
                $nombre = $data["nombre"];
                $apellido = $data["apellido"];
                $fechaNacimiento = $data["fechaNacimiento"];
                $idStatusUsuario = $data["idStatusUsuario"];
                $genero = $data["genero"];
                $email = $data["email"];
                $telefono = $data["telefono"];
                $idSucursal = $data["idSucursal"];
                $usuarioModifica = $data["usuarioModifica"];
                $idUsuario = $data["idUsuario"];
                $fechaHoraActual = date('Y-m-d H:i:s');


                $query_put = "UPDATE USUARIO SET 
                Nombre=:nombre,
                Apellido=:apellido,
                FechaNacimiento=:fechaNacimiento,
                IdStatusUsuario=:idStatusUsuario,
                IdGenero=:idGenero,
                CorreoElectronico=:email,
                TelefonoMovil=:telefono,
                IdSucursal=:idSucursal,
                FechaModificacion=:fechaHoraActual,
                UsuarioModificacion=:usuarioModifica
                WHERE IdUsuario=:idUsuario";

                $stmt_validation = $dbhost->prepare($query_put);
                $stmt_validation->bindParam(':nombre', $nombre);
                $stmt_validation->bindParam(':apellido', $apellido);
                $stmt_validation->bindParam(':fechaNacimiento', $fechaNacimiento);
                $stmt_validation->bindParam(':idStatusUsuario', $idStatusUsuario);
                $stmt_validation->bindParam(':idGenero', $genero);
                $stmt_validation->bindParam(':email', $email);
                $stmt_validation->bindParam(':telefono', $telefono);
                $stmt_validation->bindParam(':idSucursal', $idStatusUsuario);
                $stmt_validation->bindParam(':fechaHoraActual', $fechaHoraActual);
                $stmt_validation->bindParam(':usuarioModifica', $usuarioModifica);
                $stmt_validation->bindParam(':idUsuario', $idUsuario);
                $stmt_validation->execute();

                if($stmt_validation->rowCount() > 0 ){

                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Usuario actualizado exitosamente"
                    ));
                    die();
                }else{
                    echo json_encode(array(
                        "status" => 401,
                        "msg" => "Ocurrio un error en el servidor, intenta nuevamente"
                    ));
                    die();
                }

                
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