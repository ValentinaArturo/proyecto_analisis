<?php

header('Content-Type: application/json');
$json = file_get_contents('php://input');
date_default_timezone_set('America/Guatemala');


if ($json === false || trim($json) === "") {
    echo json_encode(array(
        "status" => 400,
        "msg" => "Error en datos recibidos"
    ));
    die();
}

$data = json_decode($json);

if (!isset($data->email) || !isset($data->password) || count(get_object_vars($data)) !== 2) {
    echo json_encode(array(
        "status" => 400,
        "msg" => "Formato de datos incorrecto"
    ));
    die();
}

$email = $data->email;
$password = $data->password;

require '../auth/Token.php';
require '../db/config.php';

//Secret Key
const KEY = 'analisisDeSistemas1234#';


//Configuracion PDO

$options = array(
    PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8'
);

$db = 'mysql:host=' . DB_HOSTNAME . ';dbname=' . DB_NAME;
$dbhost = new PDO($db, DB_USERNAME, DB_PASSWORD, $options);

$query_validation = "SELECT 
T1.IdUsuario,T1.IdStatusUsuario, 
T2.Nombre,
T1.Apellido, 
T1.Nombre as NombreUsuario, 
T1.RequiereCambiarPassword, 
T1.UltimaFechaCambioPassword,
T4.PasswordCantidadCaducidadDias
FROM Nomina.USUARIO AS T1
LEFT JOIN STATUS_USUARIO AS T2 ON T1.IdStatusUsuario = T2.IdStatusUsuario
LEFT JOIN SUCURSAL T3 ON T1.IdSucursal = T3.IdSucursal
LEFT JOIN EMPRESA T4 ON T3.IdEmpresa = T4.IdEmpresa
WHERE CorreoElectronico =:email AND Password =:password ";
$stmt_validation = $dbhost->prepare($query_validation);
$stmt_validation->bindParam(':email', $email);
$stmt_validation->bindParam(':password', $password);
$stmt_validation->execute();


if ($stmt_validation->rowCount() == 0 ){

    $query_username = "SELECT T1.IdUsuario,T1.IntentosDeAcceso, T3.PasswordIntentosAntesDeBloquear, T1.IdStatusUsuario, T4.Nombre 
    FROM USUARIO T1
    LEFT JOIN SUCURSAL T2 ON T1.IdSucursal = T2.IdSucursal
    LEFT JOIN EMPRESA T3 ON T2.IdEmpresa = T3.IdEmpresa
    LEFT JOIN STATUS_USUARIO T4 ON T1.IdStatusUsuario = T4.IdStatusUsuario
    WHERE T1.CorreoElectronico =:email";
    $stmt_username = $dbhost->prepare($query_username);
    $stmt_username->bindParam(':email', $email);
    $stmt_username->execute();

    $row = $stmt_username->fetch(PDO::FETCH_ASSOC);
    $IntentosDeAcceso = (int)$row['IntentosDeAcceso'];
    $PasswordIntentosAntesDeBloquear = (int)$row['PasswordIntentosAntesDeBloquear'];
    $IdStatusUsuario = $row['IdStatusUsuario'];
    $IdUsuario = $row['IdUsuario'];
    $message_error = $row['Nombre'];

    if ($stmt_username->rowCount() == 0 ){
        echo json_encode(array(
            "status" => 401,
            "msg" => "Credenciales Invalidas"
        ));
    }else{
        switch ($IdStatusUsuario) {
            case '1':

                if($IntentosDeAcceso >= $PasswordIntentosAntesDeBloquear){
                    
                   $query_block = "UPDATE USUARIO SET IdStatusUsuario = 2 WHERE idUsuario =:idUser";
                   $stmt_block = $dbhost->prepare($query_block);
                   $stmt_block->bindParam(':idUser', $IdUsuario);
                   $stmt_block->execute();

                   echo json_encode(array(
                        "status" => 401,
                        "msg" => "Credenciales Invalidas"
                    ));
                    die();

                }else{
                    $newIntento = $IntentosDeAcceso + 1;
                    
                    $query_intento = "UPDATE USUARIO SET IntentosDeAcceso =:newIntento
                     WHERE idUsuario =:idUser";
                    $stmt_intento = $dbhost->prepare($query_intento);
                    $stmt_intento->bindParam(':newIntento', $newIntento,PDO::PARAM_INT);
                    $stmt_intento->bindParam(':idUser', $IdUsuario);
                    $stmt_intento->execute();

                    echo json_encode(array(
                        "status" => 401,
                        "msg" => "Credenciales Invalidas"
                    ));
                    die();
                }
                
                break;
            default:
                echo json_encode(array(
                    "status" => 401,
                    "msg" => $message_error
                ));
                die();
                break;
        }
    }
}else{

    $row = $stmt_validation->fetch(PDO::FETCH_ASSOC);
    $idUsuario = $row['IdUsuario'];
    $IdStatusUsuario = $row['IdStatusUsuario'];
    $message_error = $row['Nombre'];
    $RequiereCambiarPassword = $row['RequiereCambiarPassword'];
    $UltimaFechaCambioPassword = $row['UltimaFechaCambioPassword'];
    $fecha_formateada = new DateTime($UltimaFechaCambioPassword);
    $fechaActual = new DateTime();
    $PasswordCantidadCaducidadDias = (int) $row['PasswordCantidadCaducidadDias'];

    switch ($IdStatusUsuario) {
        case '1':

            $token = Token::SignIn(['id'=>$idUsuario],KEY,60*8);
            $fechaHoraActual = date('Y-m-d H:i:s');

            $query_login = "UPDATE USUARIO SET IntentosDeAcceso = 0, JWT =:token, UltimaFechaIngreso=:fecha_ingreso
            WHERE idUsuario =:idUser";
            $stmt_login = $dbhost->prepare($query_login);
            $stmt_login->bindParam(':idUser', $idUsuario);
            $stmt_login->bindParam(':token', $token);
            $stmt_login->bindParam(':fecha_ingreso', $fechaHoraActual);
            $stmt_login->execute();

            if($RequiereCambiarPassword == '1'){

                $intervalo = $fechaActual->diff($fecha_formateada);
                $diferenciaEnDias = $intervalo->days;

                if ($diferenciaEnDias >= $PasswordCantidadCaducidadDias) {
                    echo json_encode(array(
                        "status" => 33,
                        "msg" => "Cambia tu contraseña por favor",
                        "token"=> $token,
                        "data"=>$row
                    ));
                    die();
                } else {
                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Bienvenido",
                        "token"=> $token,
                        "data"=>$row
                    ));
                    die();
                }
            }else{
                echo json_encode(array(
                    "status" => 200,
                    "msg" => "Bienvenido",
                    "token"=>$token,
                    "data"=>$row
                ));
                die();
            }

            break;


        
        default:
            echo json_encode(array(
                "status" => 401,
                "msg" => $message_error
            ));
            die();
            break;
    }
}



?>