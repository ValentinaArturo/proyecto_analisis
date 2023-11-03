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
                $query_validation = "SELECT * FROM CUENTA_BANCARIA_EMPLEADO";
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
                    !isset($data["idEmpleado"]) ||
                    !isset($data["idBanco"]) ||
                    !isset($data["numeroDeCuenta"]) ||
                    !isset($data["activa"]) ||
                    !isset($data["usuarioCreacion"]) ||
                    $data["idEmpleado"] == "" ||
                    $data["idBanco"] == "" ||
                    $data["numeroDeCuenta"] == "" ||
                    $data["activa"] == "" ||
                    $data["usuarioCreacion"] == "" ||
                    count($data) !== 5
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdEmpleado = $data["idEmpleado"];
                $IdBanco = $data["idBanco"];
                $NumeroDeCuenta = $data["numeroDeCuenta"];
                $Activa = $data["activa"];
                $UsuarioCreacion = $data["usuarioCreacion"];

                $query_validation = "Select NumeroDeCuenta From CUENTA_BANCARIA_EMPLEADO Where NumeroDeCuenta=:NumeroDeCuenta";
                $stmt_validation = $dbhost->prepare($query_validation);
                $stmt_validation->bindParam(':NumeroDeCuenta', $NumeroDeCuenta);
                $stmt_validation->execute();

                if ($stmt_validation->rowCount() == 0) {
                    $query_post = "INSERT INTO CUENTA_BANCARIA_EMPLEADO(IdEmpleado,IdBanco,NumeroDeCuenta,Activa,
                    FechaCreacion,UsuarioCreacion,FechaModificacion,UsuarioModificacion) 
                    VALUES (:IdEmpleado,:IdBanco,:NumeroDeCuenta,:Activa,:FechaHoraActual,:UsuarioCreacion,NULL,NULL)";
                    $stmt_post = $dbhost->prepare($query_post);

                    $stmt_post->bindParam(':IdEmpleado', $IdEmpleado);
                    $stmt_post->bindParam(':IdBanco', $IdBanco);
                    $stmt_post->bindParam(':NumeroDeCuenta', $NumeroDeCuenta);
                    $stmt_post->bindParam(':Activa', $Activa);
                    $stmt_post->bindParam(':FechaHoraActual', $fechaHoraActual);
                    $stmt_post->bindParam(':UsuarioCreacion', $UsuarioCreacion);
                    $stmt_post->execute();

                    if ($stmt_post->rowCount() > 0) {
                        echo json_encode(
                            array(
                                "status" => 200,
                                "msg" => "Cuenta bancaria de empleado agregada exitosamente"
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
                            "msg" => "¡Cuenta bancaria de empleado está en uso, valide!"
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
                    !isset($data["idCuentaBancaria"]) ||
                    !isset($data["idEmpleado"]) ||
                    !isset($data["idBanco"]) ||
                    !isset($data["numeroDeCuenta"]) ||
                    !isset($data["activa"]) ||
                    !isset($data["usuarioModificacion"]) ||
                    $data["idCuentaBancaria"] == "" ||
                    $data["idEmpleado"] == "" ||
                    $data["idBanco"] == "" ||
                    $data["numeroDeCuenta"] == "" ||
                    $data["activa"] == "" ||
                    $data["usuarioModificacion"] == "" ||
                    count($data) !== 6
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdCuentaBancaria = $data["idCuentaBancaria"];
                $IdEmpleado = $data["idEmpleado"];
                $IdBanco = $data["idBanco"];
                $NumeroDeCuenta = $data["numeroDeCuenta"];
                $Activa = $data["activa"];
                $UsuarioModificacion = $data["usuarioModificacion"];

                $query_validation = "Select numeroDeCuenta From CUENTA_BANCARIA_EMPLEADO Where NumeroDeCuenta=:NumeroDeCuenta";
                $stmt_validation = $dbhost->prepare($query_validation);
                $stmt_validation->bindParam(':NumeroDeCuenta', $NumeroDeCuenta);
                $stmt_validation->execute();

                if ($stmt_validation->rowCount() == 0) {
                    $query_post = "UPDATE CUENTA_BANCARIA_EMPLEADO SET IdEmpleado=:IdEmpleado, IdBanco=:IdBanco, NumeroDeCuenta=:NumeroDeCuenta,
                    Activa=:Activa, FechaModificacion=:FechaHoraActual, UsuarioModificacion=:UsuarioModificacion
                    WHERE IdCuentaBancaria=:idCuentaBancaria";
                    $stmt_post = $dbhost->prepare($query_post);
                    $stmt_post->bindParam(':IdCuentaBancaria', $IdCuentaBancaria);
                    $stmt_post->bindParam(':IdEmpleado', $IdEmpleado);
                    $stmt_post->bindParam(':IdBanco', $IdBanco);
                    $stmt_post->bindParam(':NumeroDeCuenta', $NumeroDeCuenta);
                    $stmt_post->bindParam(':Activa', $Activa);
                    $stmt_post->bindParam(':FechaHoraActual', $fechaHoraActual);
                    $stmt_post->bindParam(':UsuarioModificacion', $UsuarioModificacion);
                    $stmt_post->execute();

                    if ($stmt_post->rowCount() > 0) {
                        echo json_encode(
                            array(
                                "status" => 200,
                                "msg" => "Registro actualizado exitosamente"
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
                            "msg" => "¡Cuenta bancaria de empleado está en uso, valide!"
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
                    !isset($data["idCuentaBancaria"]) ||
                    $data["idCuentaBancaria"] == "" ||
                    count($data) !== 1
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdCuentaBancaria = $data["idCuentaBancaria"];

                $query_delete = "DELETE FROM CUENTA_BANCARIA_EMPLEADO WHERE IdCuentaBancaria=:IdCuentaBancaria";
                $stmt_post = $dbhost->prepare($query_delete);
                $stmt_post->bindParam(':IdCuentaBancaria', $IdCuentaBancaria, PDO::PARAM_INT);
                $stmt_post->execute();

                if ($stmt_post->rowCount() > 0) {
                    echo json_encode(
                        array(
                            "status" => 200,
                            "msg" => "Registro eliminado exitosamente"
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