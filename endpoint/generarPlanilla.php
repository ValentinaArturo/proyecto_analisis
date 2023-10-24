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
            
            case "GET": 

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
                    !isset($data["year"]) ||
                    !isset($data["month"]) ||
                    $data["year"] == "" ||
                    $data["month"] == "" ||
                    count($data) !== 2
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $year =  $data["year"];
                $month = $data["month"];


                $query = "SELECT * FROM PLANILLA_CABECERA WHERE Anio=:year AND Mes=:month ";
                $stmt_post = $dbhost->prepare($query);
                $stmt_post->bindParam(':year', $year,PDO::PARAM_INT);
                $stmt_post->bindParam(':month', $month,PDO::PARAM_INT);
                $stmt_post->execute();

                $results_cabecera = $stmt_post->fetchAll(PDO::FETCH_ASSOC);
                $json_cabecera = json_encode($results_cabecera);

                $query_detalle = "SELECT 
                T1.IdEmpleado,
                T1.Anio, 
                T1.Mes, 
                CONCAT(T3.Nombre,' ',T3.Apellido) as 'Nombre Empleado', 
                T1.FechaContratacion,
                T4.Nombre as 'Puesto',
                T5.Nombre as 'Estado Usuario',
                T1.IngresoSueldoBase,
                T1.IngresoBonificacionDecreto,
                T1.IngresoOtrosIngresos,
                T1.DescuentoIgss,
                T1.DescuentoIsr,
                T1.DescuentoInasistencias,
                T1.SalarioNeto 
                FROM PLANILLA_DETALLE T1 
                LEFT JOIN EMPLEADO T2 ON T1.IdEmpleado = T2.IdEmpleado
                LEFT JOIN PERSONA T3 ON T2.IdPersona = T3.IdPersona
                LEFT JOIN PUESTO T4 ON T1.IdPuesto = T4.IdPuesto
                LEFT JOIN STATUS_USUARIO T5 ON T1.IdStatusEmpleado = T5.IdStatusUsuario
                WHERE T1.Anio=:year AND T1.Mes=:month";
                $stmt_detalle = $dbhost->prepare($query_detalle);
                $stmt_detalle->bindParam(':year', $year,PDO::PARAM_INT);
                $stmt_detalle->bindParam(':month', $month,PDO::PARAM_INT);
                $stmt_detalle->execute();
    
                $results_detalle = $stmt_detalle->fetchAll(PDO::FETCH_ASSOC);
                $json_detalle = json_encode($results_detalle);

                $combined_results = array(
                    'cabecera' => $results_cabecera,
                    'detalle' => $results_detalle
                );

                $json_combined = json_encode($combined_results);

                echo $json_combined;

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
                    !isset($data["year"]) ||
                    !isset($data["month"]) ||
                    $data["year"] == "" ||
                    $data["month"] == "" ||
                    count($data) !== 2
                ) {
                    echo json_encode([
                        "status" => 400,
                        "msg" => "Formato de datos incorrecto",
                    ]);
                    die();
                }

                $year =  $data["year"];
                $month = $data["month"];
                $usuarioCreacion = Token::GetUserID($token);

                $query = "CALL generar_planilla(:year,:month,:usuarioCreacion)";
                $stmt_post = $dbhost->prepare($query);
                $stmt_post->bindParam(':year', $year,PDO::PARAM_INT);
                $stmt_post->bindParam(':month', $month,PDO::PARAM_INT);
                $stmt_post->bindParam(':usuarioCreacion', $usuarioCreacion);
                $stmt_post->execute();

                $customMessage = $stmt_post->fetchColumn();

                if ($customMessage == "No se puede generar planilla, planilla ya generada") {
                    echo json_encode(array(
                        "status" => 401,
                        "msg" => "No se puede generar planilla, planilla ya generada"
                    ));
                } else {
                    echo json_encode(array(
                        "status" => 200,
                        "msg" => "Planilla Generado con exito"
                    ));
                }

                break;
            default:
                echo json_encode(array(
                    "status" => 404,
                    "msg" => "Método no disponible"
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