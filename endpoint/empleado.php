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

                $query_validation ='SELECT * FROM EMPLEADO';
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
                    !isset($data["IdPersona"]) ||
                    !isset($data["IdSucursal"]) ||
                    !isset($data["FechaContratacion"]) ||
                    !isset($data["IdPuesto"]) ||
                    !isset($data["IdStatusEmpleado"]) ||
                    !isset($data["IngresoSueldoBase"]) ||
                    !isset($data["IngresoBonificacionDecreto"]) ||
                    !isset($data["IngresoOtrosIngresos"]) ||
                    !isset($data["UsuarioCreacion"]) ||
                    $data["IdPersona"] == "" ||
                    $data["IdSucursal"] == "" ||
                    $data["FechaContratacion"] == "" ||
                    $data["IdPuesto"] == "" ||
                    $data["IdStatusEmpleado"] == "" ||
                    $data["IngresoSueldoBase"] == "" ||
                    $data["IngresoBonificacionDecreto"] == "" ||
                    $data["IngresoOtrosIngresos"] == "" ||
                    $data["UsuarioCreacion"] == "" ||
                    count($data) !== 9
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdPersona =  $data["IdPersona"];
                $IdSucursal = $data["IdSucursal"];
                $FechaContratacion = $data["FechaContratacion"];
                $IdPuesto = $data["IdPuesto"];
                $IdStatusEmpleado = $data["IdStatusEmpleado"];
                $IngresoSueldoBase = $data["IngresoSueldoBase"];
                $IngresoBonificacionDecreto = $data["IngresoBonificacionDecreto"];
                $IngresoOtrosIngresos = $data["IngresoOtrosIngresos"];
                $DescuentoIggs = $data["IngresoSueldoBase"] * 0.0483;
                $DescuentoISR = ($data["IngresoSueldoBase"] * 0.05) / 12;
                $DecuentoInasistencias = "0.00";
                $UsuarioCreacion = $data["UsuarioCreacion"];
                $fechaHoraActual = date('Y-m-d H:i:s');

                $query_post = "INSERT INTO 
                EMPLEADO(
                    IdPersona, 
                    IdSucursal, 
                    FechaContratacion, 
                    IdPuesto, 
                    IdStatusEmpleado, 
                    IngresoSueldoBase, 
                    IngresoBonificacionDecreto, 
                    IngresoOtrosIngresos, 
                    DescuentoIgss, 
                    DescuentoIsr, 
                    DescuentoInasistencias, 
                    FechaCreacion, 
                    UsuarioCreacion) 
                    VALUES (
                        :idPersona,
                        :idSucursal,
                        :fechaContratacion,
                        :idPuesto,
                        :idStatusEmpleado,
                        :ingresoSueldoBase,
                        :ingresoBono,
                        :ingresoOtro,
                        :descuentoIgss,
                        :descuentoISR,
                        :descuentoInasistencia,
                        :fechaHoraActual,
                        :usuarioCreacion)";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':idPersona', $IdPersona,PDO::PARAM_INT);
                $stmt_post->bindParam(':idSucursal', $IdSucursal,PDO::PARAM_INT);
                $stmt_post->bindParam(':fechaContratacion', $FechaContratacion);
                $stmt_post->bindParam(':idPuesto', $IdPuesto,PDO::PARAM_INT);
                $stmt_post->bindParam(':idStatusEmpleado', $IdStatusEmpleado,PDO::PARAM_INT);
                $stmt_post->bindParam(':ingresoSueldoBase', $IngresoSueldoBase);
                $stmt_post->bindParam(':ingresoBono', $IngresoBonificacionDecreto);
                $stmt_post->bindParam(':ingresoOtro', $IngresoOtrosIngresos);
                $stmt_post->bindParam(':descuentoIgss', $DescuentoIggs);
                $stmt_post->bindParam(':descuentoISR', $DescuentoISR);
                $stmt_post->bindParam(':descuentoInasistencia', $DecuentoInasistencias);
                $stmt_post->bindParam(':usuarioCreacion', $UsuarioCreacion);
                $stmt_post->bindParam(':fechaHoraActual', $fechaHoraActual);
                $stmt_post->execute();

                if($stmt_post->rowCount() > 0 ){

                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Empleado creado exitosamente"
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
                    !isset($data["IdPersona"]) ||
                    !isset($data["IdSucursal"]) ||
                    !isset($data["FechaContratacion"]) ||
                    !isset($data["IdPuesto"]) ||
                    !isset($data["IdStatusEmpleado"]) ||
                    !isset($data["IngresoSueldoBase"]) ||
                    !isset($data["IngresoBonificacionDecreto"]) ||
                    !isset($data["IngresoOtrosIngresos"]) ||
                    !isset($data["DescuentoIgss"]) ||
                    !isset($data["DecuentoISR"]) ||
                    !isset($data["DescuentoInasistencias"]) ||
                    !isset($data["UsuarioModificacion"]) ||
                    !isset($data["IdEmpleado"]) ||
                    $data["IdPersona"] == "" ||
                    $data["IdSucursal"] == "" ||
                    $data["FechaContratacion"] == "" ||
                    $data["IdPuesto"] == "" ||
                    $data["IdStatusEmpleado"] == "" ||
                    $data["IngresoSueldoBase"] == "" ||
                    $data["IngresoBonificacionDecreto"] == "" ||
                    $data["IngresoOtrosIngresos"] == "" ||
                    $data["DescuentoIgss"] == "" ||
                    $data["DecuentoISR"] == "" ||
                    $data["DescuentoInasistencias"] == "" ||
                    $data["UsuarioModificacion"] == "" ||
                    $data["IdEmpleado"] == "" ||
                    count($data) !== 13
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdPersona =  $data["IdPersona"];
                $IdSucursal = $data["IdSucursal"];
                $FechaContratacion = $data["FechaContratacion"];
                $IdPuesto = $data["IdPuesto"];
                $IdStatusEmpleado = $data["IdStatusEmpleado"];
                $IngresoSueldoBase = $data["IngresoSueldoBase"];
                $IngresoBonificacionDecreto = $data["IngresoBonificacionDecreto"];
                $IngresoOtrosIngresos = $data["IngresoOtrosIngresos"];
                $DescuentoIggs = $data["DescuentoIgss"];
                $DescuentoISR = $data["DecuentoISR"];
                $DecuentoInasistencias = $data["DescuentoInasistencias"];
                $UsuarioCreacion = $data["UsuarioModificacion"];
                $fechaHoraActual = date('Y-m-d H:i:s');
                $IdEmpleado = $data["IdEmpleado"];

                $query_post = "UPDATE EMPLEADO SET 
                IdPersona=:idPersona,
                IdSucursal=:idSucursal,
                FechaContratacion=:fechaContratacion,
                IdPuesto=:idPuesto,
                IdStatusEmpleado=:idStatusEmpleado,
                IngresoSueldoBase=:ingresoSueldoBase,
                IngresoBonificacionDecreto=:ingresoBono,
                IngresoOtrosIngresos=:ingresoOtro,
                DescuentoIgss=:descuentoIgss,
                DescuentoIsr=:descuentoISR,
                DescuentoInasistencias=:descuentoInasistencia,
                FechaModificacion=:fechaHoraActual,
                UsuarioModificacion=:usuarioCreacion 
                WHERE IdEmpleado=:idEmpleado";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':idPersona', $IdPersona,PDO::PARAM_INT);
                $stmt_post->bindParam(':idSucursal', $IdSucursal,PDO::PARAM_INT);
                $stmt_post->bindParam(':fechaContratacion', $FechaContratacion);
                $stmt_post->bindParam(':idPuesto', $IdPuesto,PDO::PARAM_INT);
                $stmt_post->bindParam(':idStatusEmpleado', $IdStatusEmpleado,PDO::PARAM_INT);
                $stmt_post->bindParam(':ingresoSueldoBase', $IngresoSueldoBase);
                $stmt_post->bindParam(':ingresoBono', $IngresoBonificacionDecreto);
                $stmt_post->bindParam(':ingresoOtro', $IngresoOtrosIngresos);
                $stmt_post->bindParam(':descuentoIgss', $DescuentoIggs);
                $stmt_post->bindParam(':descuentoISR', $DescuentoISR);
                $stmt_post->bindParam(':descuentoInasistencia', $DecuentoInasistencias);
                $stmt_post->bindParam(':usuarioCreacion', $UsuarioCreacion);
                $stmt_post->bindParam(':fechaHoraActual', $fechaHoraActual);
                $stmt_post->bindParam(':idEmpleado', $IdEmpleado,PDO::PARAM_INT);
                $stmt_post->execute();

                if($stmt_post->rowCount() > 0 ){

                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Empleado actualizado exitosamente"
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
                    !isset($data["IdEmpleado"]) ||
                    $data["IdEmpleado"] == "" ||
                    count($data) !== 1
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $IdEmpleado = $data["IdEmpleado"];

                $query_post = "DELETE FROM EMPLEADO WHERE IdEmpleado=:idEmpleado";
                $stmt_post = $dbhost->prepare($query_post);
                $stmt_post->bindParam(':idEmpleado', $IdEmpleado,PDO::PARAM_INT);
                $stmt_post->execute();

                if($stmt_post->rowCount() > 0 ){

                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Empleado eliminado exitosamente"
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