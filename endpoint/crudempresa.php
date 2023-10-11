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
                $query_validation = "SELECT * FROM EMPRESA";
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
                    !isset($data["direccion"]) ||
                    !isset($data["nit"]) ||
                    !isset($data["passwordCantidadMayusculas"]) ||
                    !isset($data["passwordCantidadMinusculas"]) ||
                    !isset($data["passwordCantidadCaracteresEspeciales"]) ||
                    !isset($data["passwordCantidadCaducidadDias"]) ||
                    !isset($data["passwordLargo"]) ||
                    !isset($data["passwordIntentosAntesDeBloquear"]) ||
                    !isset($data["passwordCantidadNumeros"]) ||
                    !isset($data["passwordCantidadPreguntasValidar"]) ||
                    !isset($data["usuarioCreacion"]) ||
                    $data["nombre"] == "" ||
                    $data["direccion"] == "" ||
                    $data["nit"] == "" ||
                    $data["passwordCantidadMayusculas"] == "" ||
                    $data["passwordCantidadMinusculas"] == "" ||
                    $data["passwordCantidadCaracteresEspeciales"] == "" ||
                    $data["passwordCantidadCaducidadDias"] == "" ||
                    $data["passwordLargo"] == "" ||
                    $data["passwordIntentosAntesDeBloquear"] == "" ||
                    $data["passwordCantidadNumeros"] == "" ||
                    $data["passwordCantidadPreguntasValidar"] == "" ||
                    $data["usuarioCreacion"] == "" ||
                    count($data) !== 12
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $Nombre = $data["nombre"];
                $Direccion = $data["direccion"];
                $Nit = $data["nit"];
                $PasswordCantidadMayusculas = $data["passwordCantidadMayusculas"];
                $PasswordCantidadMinusculas = $data["passwordCantidadMinusculas"];
                $PasswordCantidadCaracteresEspeciales = $data["passwordCantidadCaracteresEspeciales"];
                $PasswordCantidadCaducidadDias = $data["passwordCantidadCaducidadDias"];
                $PasswordLargo = $data["passwordLargo"];
                $PasswordIntentosAntesDeBloquear = $data["passwordIntentosAntesDeBloquear"];
                $PasswordCantidadNumeros = $data["passwordCantidadNumeros"];
                $PasswordCantidadPreguntasValidar = $data["passwordCantidadPreguntasValidar"];
                $UsuarioCreacion = $data["usuarioCreacion"];

                $query_validation = "Select Nombre From EMPRESA Where Nombre=:Nombre";
                $stmt_validation = $dbhost->prepare($query_validation);
                $stmt_validation->bindParam(':Nombre', $Nombre);
                $stmt_validation->execute();

                if ($stmt_validation->rowCount() == 0) {
                    $query_post = "INSERT INTO EMPRESA(Nombre,Direccion,Nit,PasswordCantidadMayusculas,PasswordCantidadMinusculas,PasswordCantidadCaracteresEspeciales,
                    PasswordCantidadCaducidadDias,PasswordLargo,PasswordIntentosAntesDeBloquear,PasswordCantidadNumeros,PasswordCantidadPreguntasValidar,FechaCreacion,
                    UsuarioCreacion,FechaModificacion,UsuarioModificacion) 
                    VALUES (:Nombre,:Direccion,:Nit,:PasswordCantidadMayusculas,:PasswordCantidadMinusculas,:PasswordCantidadCaracteresEspeciales,
                    :PasswordCantidadCaducidadDias,:PasswordLargo,:PasswordIntentosAntesDeBloquear,:PasswordCantidadNumeros,:PasswordCantidadPreguntasValidar,:fechaHoraActual,
                    :UsuarioCreacion,NULL,NULL)";

                    $stmt_post = $dbhost->prepare($query_post);
                    $stmt_post->bindParam(':Nombre', $Nombre);
                    $stmt_post->bindParam(':Direccion', $Direccion);
                    $stmt_post->bindParam(':Nit', $Nit);
                    $stmt_post->bindParam(':PasswordCantidadMayusculas', $PasswordCantidadMayusculas);
                    $stmt_post->bindParam(':PasswordCantidadMinusculas', $PasswordCantidadMinusculas);
                    $stmt_post->bindParam(':PasswordCantidadCaracteresEspeciales', $PasswordCantidadCaracteresEspeciales);
                    $stmt_post->bindParam(':PasswordCantidadCaducidadDias', $PasswordCantidadCaducidadDias);
                    $stmt_post->bindParam(':PasswordLargo', $PasswordLargo);
                    $stmt_post->bindParam(':PasswordIntentosAntesDeBloquear', $PasswordIntentosAntesDeBloquear);
                    $stmt_post->bindParam(':PasswordCantidadNumeros', $PasswordCantidadNumeros);
                    $stmt_post->bindParam(':PasswordCantidadPreguntasValidar', $PasswordCantidadPreguntasValidar);
                    $stmt_post->bindParam(':fechaHoraActual', $fechaHoraActual);
                    $stmt_post->bindParam(':UsuarioCreacion', $UsuarioCreacion);

                    $stmt_post->execute();
                    if ($stmt_post->rowCount() > 0) {
                        echo json_encode(
                            array(
                                "status" => 200,
                                "msg" => "Empresa agregada exitosamente"
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
                            "msg" => "¡El nombre de la empresa está en uso, valide!"
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
                    !isset($data["idEmpresa"]) ||
                    !isset($data["nombre"]) ||
                    !isset($data["direccion"]) ||
                    !isset($data["nit"]) ||
                    !isset($data["passwordCantidadMayusculas"]) ||
                    !isset($data["passwordCantidadMinusculas"]) ||
                    !isset($data["passwordCantidadCaracteresEspeciales"]) ||
                    !isset($data["passwordCantidadCaducidadDias"]) ||
                    !isset($data["passwordLargo"]) ||
                    !isset($data["passwordIntentosAntesDeBloquear"]) ||
                    !isset($data["passwordCantidadNumeros"]) ||
                    !isset($data["passwordCantidadPreguntasValidar"]) ||
                    !isset($data["usuarioModificacion"]) ||
                    $data["idEmpresa"] == "" ||
                    $data["nombre"] == "" ||
                    $data["direccion"] == "" ||
                    $data["nit"] == "" ||
                    $data["passwordCantidadMayusculas"] == "" ||
                    $data["passwordCantidadMinusculas"] == "" ||
                    $data["passwordCantidadCaracteresEspeciales"] == "" ||
                    $data["passwordCantidadCaducidadDias"] == "" ||
                    $data["passwordLargo"] == "" ||
                    $data["passwordIntentosAntesDeBloquear"] == "" ||
                    $data["passwordCantidadNumeros"] == "" ||
                    $data["passwordCantidadPreguntasValidar"] == "" ||
                    $data["usuarioModificacion"] == "" ||
                    count($data) !== 13
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdEmpresa = $data["idEmpresa"];
                $Nombre = $data["nombre"];
                $Direccion = $data["direccion"];
                $Nit = $data["nit"];
                $PasswordCantidadMayusculas = $data["passwordCantidadMayusculas"];
                $PasswordCantidadMinusculas = $data["passwordCantidadMinusculas"];
                $PasswordCantidadCaracteresEspeciales = $data["passwordCantidadCaracteresEspeciales"];
                $PasswordCantidadCaducidadDias = $data["passwordCantidadCaducidadDias"];
                $PasswordLargo = $data["passwordLargo"];
                $PasswordIntentosAntesDeBloquear = $data["passwordIntentosAntesDeBloquear"];
                $PasswordCantidadNumeros = $data["passwordCantidadNumeros"];
                $PasswordCantidadPreguntasValidar = $data["passwordCantidadPreguntasValidar"];
                $UsuarioModificacion = $data["usuarioModificacion"];

                $query_validation = "Select Nombre From EMPRESA Where Nombre=:Nombre";
                $stmt_validation = $dbhost->prepare($query_validation);
                $stmt_validation->bindParam(':Nombre', $Nombre);
                $stmt_validation->execute();

                if ($stmt_validation->rowCount() == 0) {
                    $query_post = "UPDATE EMPRESA SET Nombre=:Nombre, Direccion=:Direccion, Nit=:Nit, PasswordCantidadMayusculas=:PasswordCantidadMayusculas,
                    PasswordCantidadMinusculas=:PasswordCantidadMinusculas, PasswordCantidadCaracteresEspeciales=:PasswordCantidadCaracteresEspeciales,
                    PasswordCantidadCaducidadDias=:PasswordCantidadCaducidadDias, PasswordLargo=:PasswordLargo,
                    PasswordIntentosAntesDeBloquear=:PasswordIntentosAntesDeBloquear, PasswordCantidadNumeros=:PasswordCantidadNumeros,
                    PasswordCantidadPreguntasValidar=:PasswordCantidadPreguntasValidar,
                    FechaModificacion=:FechaHoraActual, UsuarioModificacion=:UsuarioModificacion
                    WHERE IdEmpresa=:idEmpresa";

                    $stmt_post = $dbhost->prepare($query_post);
                    $stmt_post->bindParam(':idEmpresa', $IdEmpresa);
                    $stmt_post->bindParam(':Nombre', $Nombre);
                    $stmt_post->bindParam(':Direccion', $Direccion);
                    $stmt_post->bindParam(':Nit', $Nit);
                    $stmt_post->bindParam(':PasswordCantidadMayusculas', $PasswordCantidadMayusculas);
                    $stmt_post->bindParam(':PasswordCantidadMinusculas', $PasswordCantidadMinusculas);
                    $stmt_post->bindParam(':PasswordCantidadCaracteresEspeciales', $PasswordCantidadCaracteresEspeciales);
                    $stmt_post->bindParam(':PasswordCantidadCaducidadDias', $PasswordCantidadCaducidadDias);
                    $stmt_post->bindParam(':PasswordLargo', $PasswordLargo);
                    $stmt_post->bindParam(':PasswordIntentosAntesDeBloquear', $PasswordIntentosAntesDeBloquear);
                    $stmt_post->bindParam(':PasswordCantidadNumeros', $PasswordCantidadNumeros);
                    $stmt_post->bindParam(':PasswordCantidadPreguntasValidar', $PasswordCantidadPreguntasValidar);
                    $stmt_post->bindParam(':FechaHoraActual', $fechaHoraActual);
                    $stmt_post->bindParam(':UsuarioModificacion', $UsuarioModificacion);
                    $stmt_post->execute();

                    if ($stmt_post->rowCount() > 0) {
                        echo json_encode(
                            array(
                                "status" => 200,
                                "msg" => "Empresa actualizada exitosamente"
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
                            "msg" => "¡El nombre de la empresa está en uso, valide!"
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
                    !isset($data["idEmpresa"]) ||
                    $data["idEmpresa"] == "" ||
                    count($data) !== 1
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdEmpresa = $data["idEmpresa"];
                $query_delete = "DELETE FROM EMPRESA WHERE IdEmpresa=:idEmpresa";
                $stmt_post = $dbhost->prepare($query_delete);
                $stmt_post->bindParam(':idEmpresa', $IdEmpresa, PDO::PARAM_INT);
                $stmt_post->execute();

                if ($stmt_post->rowCount() > 0) {
                    echo json_encode(
                        array(
                            "status" => 200,
                            "msg" => "Empresa eliminada exitosamente"
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