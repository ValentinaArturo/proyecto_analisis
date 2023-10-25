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
$contador = null;

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
                $query_validation = "SELECT * FROM TIPO_DOCUMENTO";
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
                    !isset($data["usuarioCreacion"]) ||
                    $data["nombre"] == "" ||
                    $data["usuarioCreacion"] == "" ||
                    count($data) !== 2
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $Nombre = $data["nombre"];
                $UsuarioCreacion = $data["usuarioCreacion"];

                $query_validation = "Select Nombre From TIPO_DOCUMENTO Where Nombre=:Nombre";
                $stmt_validation = $dbhost->prepare($query_validation);
                $stmt_validation->bindParam(':Nombre', $Nombre);
                $stmt_validation->execute();

                if ($stmt_validation->rowCount() == 0) {
                    $query_post = "INSERT INTO TIPO_DOCUMENTO(Nombre,FechaCreacion,UsuarioCreacion,FechaModificacion,UsuarioModificacion) 
                    VALUES (:Nombre,:FechaHoraActual,:UsuarioCreacion,NULL,NULL)";
                    $stmt_post = $dbhost->prepare($query_post);
                    $stmt_post->bindParam(':Nombre', $Nombre);
                    $stmt_post->bindParam(':FechaHoraActual', $fechaHoraActual);
                    $stmt_post->bindParam(':UsuarioCreacion', $UsuarioCreacion);
                    $stmt_post->execute();

                    if ($stmt_post->rowCount() > 0) {
                        echo json_encode(
                            array(
                                "status" => 200,
                                "msg" => "Tipo documento agregado exitosamente"
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
                            "msg" => "¡El nombre del Tipo documento está en uso, valide!"
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
                    !isset($data["idTipoDocumento"]) ||
                    !isset($data["nombre"]) ||
                    !isset($data["usuarioModificacion"]) ||
                    $data["idTipoDocumento"] == "" ||
                    $data["nombre"] == "" ||
                    $data["usuarioModificacion"] == "" ||
                    count($data) !== 3
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdTipoDocumento = $data["idTipoDocumento"];
                $Nombre = $data["nombre"];
                $UsuarioModificacion = $data["usuarioModificacion"];

                $query_validation = "Select Nombre From TIPO_DOCUMENTO Where Nombre=:Nombre";
                $stmt_validation = $dbhost->prepare($query_validation);
                $stmt_validation->bindParam(':Nombre', $Nombre);
                $stmt_validation->execute();

                if ($stmt_validation->rowCount() == 0) {
                    $query_post = "UPDATE TIPO_DOCUMENTO SET Nombre=:Nombre,
                    FechaModificacion=:FechaHoraActual,
                    UsuarioModificacion=:UsuarioModificacion
                    WHERE IdTipoDocumento=:idTipoDocumento";
                    $stmt_post = $dbhost->prepare($query_post);
                    $stmt_post->bindParam(':idTipoDocumento', $IdTipoDocumento);
                    $stmt_post->bindParam(':Nombre', $Nombre);
                    $stmt_post->bindParam(':FechaHoraActual', $fechaHoraActual);
                    $stmt_post->bindParam(':UsuarioModificacion', $UsuarioModificacion);
                    $stmt_post->execute();

                    if ($stmt_post->rowCount() > 0) {
                        echo json_encode(
                            array(
                                "status" => 200,
                                "msg" => "Tipo documento actualizado exitosamente"
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
                            "msg" => "¡El nombre del Tipo documento está en uso, valide!"
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
                    !isset($data["idTipoDocumento"]) ||
                    $data["idTipoDocumento"] == "" ||
                    count($data) !== 1
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdTipoDocumento = $data["idTipoDocumento"];
                $query_delete = "DELETE FROM TIPO_DOCUMENTO WHERE IdTipoDocumento=:idTipoDocumento";
                $stmt_post = $dbhost->prepare($query_delete);
                $stmt_post->bindParam(':idTipoDocumento', $IdTipoDocumento, PDO::PARAM_INT);
                $stmt_post->execute();

                if ($stmt_post->rowCount() > 0) {
                    echo json_encode(
                        array(
                            "status" => 200,
                            "msg" => "Tipo documento eliminado exitosamente"
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