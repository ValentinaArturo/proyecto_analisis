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

                $query_validation ='SELECT * FROM OPCION';
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
                    !isset($data["IdMenu"]) ||
                    !isset($data["Nombre"]) ||
                    !isset($data["OrdenMenu"]) ||
                    !isset($data["Pagina"]) ||
                    !isset($data["UsuarioCreacion"]) ||
                    $data["IdMenu"] == "" ||
                    $data["Nombre"] == "" ||
                    $data["OrdenMenu"] == "" ||
                    $data["Pagina"] == "" ||
                    $data["UsuarioCreacion"] == "" ||
                    count($data) !== 5
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdMenu = $data["IdMenu"];
                $Nombre = $data["Nombre"];
                $OrdenMenu = $data["OrdenMenu"];
                $Pagina = $data["Pagina"];
                $UsuarioCreacion = $data["UsuarioCreacion"];
                $fechaHoraActual = date('Y-m-d H:i:s');

                $query_post = "INSERT INTO 
                OPCION(
                    IdMenu, 
                    Nombre, 
                    OrdenMenu, 
                    Pagina,
                    FechaCreacion, 
                    UsuarioCreacion, 
                    FechaModificacion, 
                    UsuarioModificacion) 
                    VALUES (
                        :idMenu,
                        :Nombre,
                        :OrdenMenu,
                        :Pagina,
                        :fechaHoraActual,
                        :UsuarioCreacion,
                        NULL,
                        NULL)";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':idMenu', $IdMenu);
                $stmt_post->bindParam(':Nombre', $Nombre);
                $stmt_post->bindParam(':OrdenMenu', $OrdenMenu);
                $stmt_post->bindParam(':Pagina', $Pagina);
                $stmt_post->bindParam(':UsuarioCreacion', $UsuarioCreacion);
                $stmt_post->bindParam(':fechaHoraActual', $fechaHoraActual);
                $stmt_post->execute();

                if($stmt_post->rowCount() > 0 ){

                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Opcion creada exitosamente"
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
                    !isset($data["IdMenu"]) ||
                    !isset($data["Nombre"]) ||
                    !isset($data["OrdenMenu"]) ||
                    !isset($data["Pagina"]) ||
                    !isset($data["UsuarioModificacion"]) ||
                    !isset($data["IdOpcion"]) ||
                    $data["IdMenu"] == "" ||
                    $data["Nombre"] == "" ||
                    $data["OrdenMenu"] == "" ||
                    $data["Pagina"] == "" ||
                    $data["UsuarioModificacion"] == "" ||
                    $data["IdOpcion"] == "" ||
                    count($data) !== 6
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdMenu = $data["IdMenu"];
                $Nombre = $data["Nombre"];
                $OrdenMenu = $data["OrdenMenu"];
                $Pagina = $data["Pagina"];
                $UsuarioCreacion = $data["UsuarioModificacion"];
                $IdOpcion = $data["IdOpcion"];
                $fechaHoraActual = date('Y-m-d H:i:s');

                $query_post = "UPDATE OPCION
                SET 
                IdMenu=:idMenu,
                Nombre=:Nombre,
                OrdenMenu=:OrdenMenu,
                Pagina=:Pagina,
                FechaModificacion=:fechaHoraActual,
                UsuarioModificacion=:UsuarioModificacion
                WHERE IdOpcion=:idOpcion";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':idMenu', $IdMenu);
                $stmt_post->bindParam(':Nombre', $Nombre);
                $stmt_post->bindParam(':OrdenMenu', $OrdenMenu);
                $stmt_post->bindParam(':Pagina', $Pagina);
                $stmt_post->bindParam(':UsuarioModificacion', $UsuarioCreacion);
                $stmt_post->bindParam(':fechaHoraActual', $fechaHoraActual);
                $stmt_post->bindParam(':idOpcion', $IdOpcion);
                $stmt_post->execute();

                if($stmt_post->rowCount() > 0 ){

                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Opcion actualizada exitosamente"
                    ));
                    
                }else{
                    
                    echo json_encode(array(
                        "status" => 401,
                        "msg" => "Ocurrio un error, intenta nuevamente"
                    ));
                }

                break;
                
            default:
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
                !isset($data["IdOpcion"]) ||
                $data["IdOpcion"] == "" ||
                count($data) !== 1
            ) {
                echo json_encode([
                    "status" => 400,
                    "msg" => "Formato de datos incorrecto",
                ]);
                die();
            }

            $IdOpcion = $data["IdOpcion"];

            $query_post = "DELETE FROM OPCION
            WHERE IdOpcion=:idOpcion";
            $stmt_post = $dbhost->prepare($query_post);
            $stmt_post->bindParam(':idOpcion', $IdOpcion);
            $stmt_post->execute();

            if($stmt_post->rowCount() > 0 ){

                echo json_encode(array(
                    "status" => 200,
                    "msg" => "Opcion eliminada exitosamente"
                ));
                
            }else{
                
                echo json_encode(array(
                    "status" => 401,
                    "msg" => "Ocurrio un error, intenta nuevamente"
                ));
            }

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