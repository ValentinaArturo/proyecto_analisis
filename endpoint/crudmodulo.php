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

    if (Token::Verify($token, KEY)) {
        switch ($method) {
            case 'GET':
                $query_validation = "SELECT * FROM MODULO";
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

                $data = json_decode($json, true);

                if (
                    !isset($data["nombre"]) ||
                    !isset($data["ordenMenu"]) ||
                    !isset($data["usuarioCreacion"]) ||
                    $data["nombre"] == "" ||
                    $data["ordenMenu"] == "" ||
                    $data["usuarioCreacion"] == "" ||
                    count($data) !== 3
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $Nombre = $data["nombre"];
                $OrdenMenu = $data["ordenMenu"];
                $UsuarioCreacion = $data["usuarioCreacion"];

                $query_validation = "Select Nombre From MODULO Where Nombre=:Nombre";
                $stmt_validation = $dbhost->prepare($query_validation);
                $stmt_validation->bindParam(':Nombre', $Nombre);
                $stmt_validation->execute();

                if ($stmt_validation->rowCount() == 0) {
                    $query_post = "INSERT INTO MODULO(Nombre,OrdenMenu,FechaCreacion,UsuarioCreacion,FechaModificacion,UsuarioModificacion) 
                    VALUES (:Nombre,:OrdenMenu,:FechaHoraActual,:UsuarioCreacion,NULL,NULL)";
                    $stmt_post = $dbhost->prepare($query_post);
                    $stmt_post->bindParam(':Nombre', $Nombre);
                    $stmt_post->bindParam(':OrdenMenu', $OrdenMenu);
                    $stmt_post->bindParam(':FechaHoraActual', $fechaHoraActual);
                    $stmt_post->bindParam(':UsuarioCreacion', $UsuarioCreacion);
                    $stmt_post->execute();

                    if ($stmt_post->rowCount() > 0) {
                        echo json_encode(
                            array(
                                "status" => 200,
                                "msg" => "Módulo agregado exitosamente"
                            )
                        );

                    } else {

                        echo json_encode(
                            array(
                                "status" => 401,
                                "msg" => "Ocurrio un error, intenta nuevamente"
                            )
                        );
                    }
                    break;
                } else {
                    echo json_encode(
                        array(
                            "status" => 401,
                            "msg" => "¡El nombre del modulo está en uso, valide!"
                        )
                    );
                    break;
                }

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

                $data = json_decode($json, true);

                if (
                    !isset($data["idModulo"]) ||
                    !isset($data["nombre"]) ||
                    !isset($data["ordenMenu"]) ||
                    !isset($data["usuarioModificacion"]) ||
                    $data["idModulo"] == "" ||
                    $data["nombre"] == "" ||
                    $data["ordenMenu"] == "" ||
                    $data["usuarioModificacion"] == "" ||
                    count($data) !== 4
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdModulo = $data["idModulo"];
                $Nombre = $data["nombre"];
                $OrdenMenu = $data["ordenMenu"];
                $UsuarioModificacion = $data["usuarioModificacion"];

                $query_validation = "Select Nombre From MODULO Where Nombre=:Nombre";
                $stmt_validation = $dbhost->prepare($query_validation);
                $stmt_validation->bindParam(':Nombre', $Nombre);
                $stmt_validation->execute();

                if ($stmt_validation->rowCount() == 0) {
                    $query_post = "UPDATE MODULO SET Nombre=:Nombre, OrdenMenu=:OrdenMenu,
                    FechaModificacion=:FechaHoraActual,UsuarioModificacion=:UsuarioModificacion
                    WHERE IdModulo=:idModulo";
                    $stmt_post = $dbhost->prepare($query_post);
                    $stmt_post->bindParam(':idModulo', $IdModulo);
                    $stmt_post->bindParam(':Nombre', $Nombre);
                    $stmt_post->bindParam(':OrdenMenu', $OrdenMenu);
                    $stmt_post->bindParam(':FechaHoraActual', $fechaHoraActual);
                    $stmt_post->bindParam(':UsuarioModificacion', $UsuarioModificacion);
                    $stmt_post->execute();

                    if ($stmt_post->rowCount() > 0) {
                        echo json_encode(
                            array(
                                "status" => 200,
                                "msg" => "Módulo actualizado exitosamente"
                            )
                        );

                    } else {
                        echo json_encode(
                            array(
                                "status" => 401,
                                "msg" => "Ocurrio un error, intenta nuevamente"
                            )
                        );
                    }
                    break;
                }else {
                    echo json_encode(
                        array(
                            "status" => 401,
                            "msg" => "¡El nombre del modulo está en uso, valide!"
                        )
                    );
                    break;
                }

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
                $data = json_decode($json, true);
                if (
                    !isset($data["idModulo"]) ||
                    $data["idModulo"] == "" ||
                    count($data) !== 1
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdModulo = $data["idModulo"];
                $query_delete = "DELETE FROM MODULO WHERE IdModulo=:idModulo";
                $stmt_post = $dbhost->prepare($query_delete);
                $stmt_post->bindParam(':idModulo', $IdModulo, PDO::PARAM_INT);
                $stmt_post->execute();

                if ($stmt_post->rowCount() > 0) {
                    echo json_encode(
                        array(
                            "status" => 200,
                            "msg" => "Módulo eliminado exitosamente"
                        )
                    );
                } else {

                    echo json_encode(
                        array(
                            "status" => 401,
                            "msg" => "Ocurrio un error, intenta nuevamente"
                        )
                    );
                }
                break;
            default:
                echo json_encode(
                    array(
                        "status" => 404,
                        "msg" => "Método no permitido"
                    )
                );
                break;
        }
    }

} else {
    echo json_encode(
        array(
            "status" => 401,
            "msg" => "Error: Token no presente en la cabecera de autorización"
        )
    );
}
?>