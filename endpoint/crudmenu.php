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
                $query_validation = "SELECT * FROM MENU";
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
                    !isset($data["idModulo"]) ||
                    !isset($data["nombre"]) ||
                    !isset($data["ordenMenu"]) ||
                    !isset($data["usuarioCreacion"]) ||
                    $data["idModulo"] == "" ||
                    $data["nombre"] == "" ||
                    $data["ordenMenu"] == "" ||
                    $data["usuarioCreacion"] == "" ||
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
                $UsuarioCreacion = $data["usuarioCreacion"];

                $query_validation1 = "Select Nombre From MODULO Where IdModulo=:IdModulo";
                $stmt_validation1 = $dbhost->prepare($query_validation1);
                $stmt_validation1->bindParam(':IdModulo', $IdModulo);
                $stmt_validation1->execute();

                if ($stmt_validation1->rowCount() !== 0) {
                    $query_validation = "Select Nombre From MENU Where Nombre=:Nombre";
                    $stmt_validation = $dbhost->prepare($query_validation);
                    $stmt_validation->bindParam(':Nombre', $Nombre);
                    $stmt_validation->execute();

                    if ($stmt_validation->rowCount() == 0) {
                        $query_post = "INSERT INTO MENU(IdModulo,Nombre,OrdenMenu,FechaCreacion,UsuarioCreacion,FechaModificacion,UsuarioModificacion) 
                            VALUES (:IdModulo,:Nombre,:OrdenMenu,:FechaHoraActual,:UsuarioCreacion,NULL,NULL)";
                        $stmt_post = $dbhost->prepare($query_post);
                        $stmt_post->bindParam(':IdModulo', $IdModulo);
                        $stmt_post->bindParam(':Nombre', $Nombre);
                        $stmt_post->bindParam(':OrdenMenu', $OrdenMenu);
                        $stmt_post->bindParam(':FechaHoraActual', $fechaHoraActual);
                        $stmt_post->bindParam(':UsuarioCreacion', $UsuarioCreacion);
                        $stmt_post->execute();

                        if ($stmt_post->rowCount() > 0) {
                            echo json_encode(
                                array(
                                    "status" => 200,
                                    "msg" => "Menú agregado exitosamente"
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
                                "msg" => "¡El nombre del menú está en uso, valide!"
                            )
                        );
                        break;
                    }

                } else {
                    echo json_encode(
                        array(
                            "status" => 401,
                            "msg" => "¡El Id del módulo no existe, valide!"
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
                    !isset($data["idMenu"]) ||
                    !isset($data["idModulo"]) ||
                    !isset($data["nombre"]) ||
                    !isset($data["ordenMenu"]) ||
                    !isset($data["usuarioModificacion"]) ||
                    $data["idMenu"] == "" ||
                    $data["idModulo"] == "" ||
                    $data["nombre"] == "" ||
                    $data["ordenMenu"] == "" ||
                    $data["usuarioModificacion"] == "" ||
                    count($data) !== 5
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdMenu = $data["idMenu"];
                $IdModulo = $data["idModulo"];
                $Nombre = $data["nombre"];
                $OrdenMenu = $data["ordenMenu"];
                $UsuarioModificacion = $data["usuarioModificacion"];

                $query_validation1 = "Select Nombre From MODULO Where IdModulo=:IdModulo";
                $stmt_validation1 = $dbhost->prepare($query_validation1);
                $stmt_validation1->bindParam(':IdModulo', $IdModulo);
                $stmt_validation1->execute();

                if ($stmt_validation1->rowCount() !== 0) {
                    $query_validation = "Select Nombre From MENU Where Nombre=:Nombre";
                    $stmt_validation = $dbhost->prepare($query_validation);
                    $stmt_validation->bindParam(':Nombre', $Nombre);
                    $stmt_validation->execute();

                    if ($stmt_validation->rowCount() == 0) {
                        $query_post = "UPDATE MENU SET Nombre=:Nombre, IdModulo=:IdModulo, OrdenMenu=:OrdenMenu,
                        FechaModificacion=:FechaHoraActual,
                        UsuarioModificacion=:UsuarioModificacion
                        WHERE IdMenu=:IdMenu";
                        $stmt_post = $dbhost->prepare($query_post);
                        $stmt_post->bindParam(':IdMenu', $IdMenu);
                        $stmt_post->bindParam(':IdModulo', $IdModulo);
                        $stmt_post->bindParam(':Nombre', $Nombre);
                        $stmt_post->bindParam(':OrdenMenu', $OrdenMenu);
                        $stmt_post->bindParam(':FechaHoraActual', $fechaHoraActual);
                        $stmt_post->bindParam(':UsuarioModificacion', $UsuarioModificacion);
                        $stmt_post->execute();

                        if ($stmt_post->rowCount() > 0) {
                            echo json_encode(
                                array(
                                    "status" => 200,
                                    "msg" => "Menú actualizado exitosamente"
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
                                "msg" => "¡El nombre del menú está en uso, valide!"
                            )
                        );
                        break;
                    }
                } else {
                    echo json_encode(
                        array(
                            "status" => 401,
                            "msg" => "¡El Id del módulo no existe, valide!"
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
                    !isset($data["idMenu"]) ||
                    $data["idMenu"] == "" ||
                    count($data) !== 1
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdMenu = $data["idMenu"];
                $query_delete = "DELETE FROM MENU WHERE IdMenu=:idMenu";
                $stmt_post = $dbhost->prepare($query_delete);
                $stmt_post->bindParam(':idMenu', $IdMenu, PDO::PARAM_INT);
                $stmt_post->execute();

                if ($stmt_post->rowCount() > 0) {
                    echo json_encode(
                        array(
                            "status" => 200,
                            "msg" => "Menú eliminado exitosamente"
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