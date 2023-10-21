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
                $query_validation = "SELECT * FROM DOCUMENTO_PERSONA;";
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
                    !isset($data["idTipoDocumento"]) ||
                    !isset($data["idPersona"]) ||
                    !isset($data["noDocumento"]) ||
                    !isset($data["usuarioCreacion"]) ||
                    $data["idTipoDocumento"] == "" ||
                    $data["idPersona"] == "" ||
                    $data["noDocumento"] == "" ||
                    $data["usuarioCreacion"] == "" ||
                    count($data) !== 4
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdTipoDocumento = $data["idTipoDocumento"];
                $IdPersona = $data["idPersona"];
                $NoDocumento = $data["noDocumento"];
                $UsuarioCreacion = $data["usuarioCreacion"];

                $query_validation = "Select NoDocumento From DOCUMENTO_PERSONA Where NoDocumento=:NoDocumento";
                $stmt_validation = $dbhost->prepare($query_validation);
                $stmt_validation->bindParam(':NoDocumento', $NoDocumento);
                $stmt_validation->execute();

                if ($stmt_validation->rowCount() == 0) {
                    $query_post = "INSERT INTO DOCUMENTO_PERSONA(IdTipoDocumento, IdPersona, NoDocumento,
                    FechaCreacion, UsuarioCreacion,FechaModificacion,UsuarioModificacion) 
                    VALUES (:IdTipoDocumento,:IdPersona,:NoDocumento,:FechaHoraActual,:UsuarioCreacion,NULL,NULL)";
                    $stmt_post = $dbhost->prepare($query_post);
                    $stmt_post->bindParam(':IdTipoDocumento', $IdTipoDocumento);
                    $stmt_post->bindParam(':IdPersona', $IdPersona);
                    $stmt_post->bindParam(':NoDocumento', $NoDocumento);
                    $stmt_post->bindParam(':FechaHoraActual', $fechaHoraActual);
                    $stmt_post->bindParam(':UsuarioCreacion', $UsuarioCreacion);
                    $stmt_post->execute();

                    if ($stmt_post->rowCount() > 0) {
                        echo json_encode(
                            array(
                                "status" => 200,
                                "msg" => "Documento persona agregado exitosamente"
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
                            "msg" => "¡El Documento está en uso, valide!"
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
                    !isset($data["idPersona"]) ||
                    !isset($data["noDocumento"]) ||
                    !isset($data["usuarioModificacion"]) ||
                    $data["idTipoDocumento"] == "" ||
                    $data["idPersona"] == "" ||
                    $data["noDocumento"] == "" ||
                    $data["usuarioModificacion"] == "" ||
                    count($data) !== 4
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdTipoDocumento = $data["idTipoDocumento"];
                $IdPersona = $data["idPersona"];
                $NoDocumento = $data["noDocumento"];
                $UsuarioModificacion = $data["usuarioModificacion"];

                $query_validation = "Select NoDocumento From DOCUMENTO_PERSONA Where NoDocumento=:NoDocumento";
                $stmt_validation = $dbhost->prepare($query_validation);
                $stmt_validation->bindParam(':NoDocumento', $NoDocumento);
                $stmt_validation->execute();

                if ($stmt_validation->rowCount() == 0) {
                    $query_post = "UPDATE DOCUMENTO_PERSONA SET IdTipoDocumento=:IdTipoDocumento,
                    IdPersona=:IdPersona, noDocumento=:noDocumento,
                    FechaModificacion=:FechaHoraActual,
                    UsuarioModificacion=:UsuarioModificacion
                    WHERE IdTipoDocumento=:idTipoDocumento And IdPersona=:idPersona And NoDocumento=:noDocumento";
                    $stmt_post = $dbhost->prepare($query_post);
                    $stmt_post->bindParam(':IdTipoDocumento', $IdTipoDocumento);
                    $stmt_post->bindParam(':IdPersona', $IdPersona);
                    $stmt_post->bindParam(':NoDocumento', $NoDocumento);
                    $stmt_post->bindParam(':FechaHoraActual', $fechaHoraActual);
                    $stmt_post->bindParam(':UsuarioModificacion', $UsuarioModificacion);
                    $stmt_post->execute();

                    if ($stmt_post->rowCount() > 0) {
                        echo json_encode(
                            array(
                                "status" => 200,
                                "msg" => "Documento persona actualizado exitosamente"
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
                            "msg" => "¡El Documento está en uso, valide!"
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
                    !isset($data["idPersona"]) ||
                    !isset($data["noDocumento"]) ||
                    $data["idTipoDocumento"] == "" ||
                    $data["idPersona"] == "" ||
                    $data["noDocumento"] == "" ||
                    count($data) !== 3
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdTipoDocumento = $data["idTipoDocumento"];
                $IdPersona = $data["idPersona"];
                $NoDocumento = $data["noDocumento"];

                $query_delete = "DELETE FROM DOCUMENTO_PERSONA WHERE IdTipoDocumento=:idTipoDocumento And
                IdPersona=:idPersona And NoDocumento=:noDocumento";

                $stmt_post = $dbhost->prepare($query_delete);
                $stmt_post->bindParam(':idTipoDocumento', $IdTipoDocumento, PDO::PARAM_INT);
                $stmt_post->bindParam(':idPersona', $IdPersona, PDO::PARAM_INT);
                $stmt_post->bindParam(':noDocumento', $NoDocumento, PDO::PARAM_INT);
                $stmt_post->execute();

                if ($stmt_post->rowCount() > 0) {
                    echo json_encode(
                        array(
                            "status" => 200,
                            "msg" => "Documento persona eliminado exitosamente"
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