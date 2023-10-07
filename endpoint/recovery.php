<?php

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, PUT, OPTIONS, PATCH, DELETE');
header('Access-Control-Allow-Credentials: true');
header("Access-Control-Allow-Headers: Authorization, Content-Type");

header('Content-Type: application/json');
$json = file_get_contents('php://input');
date_default_timezone_set('America/Guatemala');


if(!isset($_GET["service"])){
    echo json_encode([
        "status" => 400,
        "msg" => "Especifique el servicio",
    ]);
    die();
}

$service = $_GET["service"];


if($service == null){
    echo json_encode([
        "status" => 400,
        "msg" => "Error en datos recibidos",
    ]);
    die();
}elseif($service == "changePassword"){
    
    if ($json == false || trim($json) == "") {
        echo json_encode([
            "status" => 400,
            "msg" => "Error en datos recibidos ChangePassword",
        ]);
        die();
    }
    
    $data = json_decode($json);
    
    if (
        !isset($data->newPassword) ||
        !isset($data->oldPassword) ||
        !isset($data->email) ||
        $data->newPassword == "" ||
        $data->oldPassword == "" ||
        $data->email == "" ||
        count(get_object_vars($data)) !== 3
    ) {
        echo json_encode([
            "status" => 400,
            "msg" => "Formato de datos incorrecto",
        ]);
        die();
    }

    require "../db/config.php";

    $options = [
        PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8",
    ];

    $db = "mysql:host=" . DB_HOSTNAME . ";dbname=" . DB_NAME;
    $dbhost = new PDO($db, DB_USERNAME, DB_PASSWORD, $options);

    $newPassword = $data->newPassword;
    $oldPassword = $data->oldPassword;
    $email = $data->email;

    $query_validation = "SELECT IdUsuario FROM USUARIO WHERE CorreoElectronico=:email AND password=:oldPassword";
    $stmt_validation = $dbhost->prepare($query_validation);
    $stmt_validation->bindParam(':email', $email);
    $stmt_validation->bindParam(':oldPassword', $oldPassword);
    $stmt_validation->execute();

    if ($stmt_validation->rowCount() > 0 ){

        $row = $stmt_validation->fetch(PDO::FETCH_ASSOC);
        $IdUsuario = $row['IdUsuario'];
        $fechaHoraActual = date('Y-m-d H:i:s');

        $query_update = "UPDATE USUARIO SET Password=:newPassword,UltimaFechaCambioPassword=:fechaHoraActual WHERE IdUsuario=:idUsuario";
        $stmt_update = $dbhost->prepare($query_update);
        $stmt_update->bindParam(':idUsuario', $IdUsuario);
        $stmt_update->bindParam(':newPassword', $newPassword);
        $stmt_update->bindParam(':fechaHoraActual', $fechaHoraActual);
        $stmt_update->execute();

        echo json_encode([
            "status" => 200,
            "msg" => "Contraseña restablecida exitosamente",
        ]);
        die();
        
    }else{
        echo json_encode([
            "status" => 401,
            "msg" => "Credenciales incorrectas, intente nuevamente",
        ]);
        die();
    }



}elseif($service == "unlockUser"){
    
    if ($json == false || trim($json) == "") {
        echo json_encode([
            "status" => 400,
            "msg" => "Error en datos recibidos",
        ]);
        die();
    }
    
    $data = json_decode($json,true);
    
    if (
        !isset($data["respuestas"]) ||
        !isset($data["newPassword"]) ||
        !isset($data["email"]) ||
        $data["newPassword"] == "" ||
        $data["email"] == "" 
    ) {
        echo json_encode([
            "status" => 400,
            "msg" => "Formato de datos incorrecto",
        ]);
        die();
    }

    $email = $data["email"];
    $newPassword = $data["newPassword"];

    require '../db/config.php';

    $options = array(
        PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8'
    );
    
    $db = 'mysql:host=' . DB_HOSTNAME . ';dbname=' . DB_NAME;
    $dbhost = new PDO($db, DB_USERNAME, DB_PASSWORD, $options);

    $query_question = "SELECT IdPregunta,Respuesta as respuesta FROM USUARIO_PREGUNTA T1
    LEFT JOIN USUARIO T2 ON T1.IdUsuario = T2.IdUsuario
    WHERE T2.CorreoElectronico = :email ";
    $stmt_question = $dbhost->prepare($query_question);
    $stmt_question->bindParam(':email', $email);
    $stmt_question->execute();

    $respuestas_ingresadas = $data["respuestas"];
    $respuestas_correctas = $stmt_question->fetchAll(PDO::FETCH_ASSOC);


    $preguntasConfundidas = [];

    if(count($respuestas_correctas) !== count($respuestas_ingresadas)){
        echo json_encode([
            "status" => 400,
            "msg" => "Preguntas de seguridad incorrectas",
        ]);
        die();
    }

    for ($i = 0; $i < count($respuestas_ingresadas); $i++) {
        
        if ($respuestas_ingresadas[$i]['IdPregunta'] !== $respuestas_correctas[$i]['IdPregunta']){
            echo json_encode([
                "status" => 400,
                "msg" => "Preguntas de seguridad incorrectas",
            ]);
            die();
        }

        if ($respuestas_ingresadas[$i]['respuesta'] !== $respuestas_correctas[$i]['respuesta']){
            echo json_encode([
                "status" => 400,
                "msg" => "Preguntas de seguridad incorrectas",
            ]);
            die();
        }        
    }


    $query_usuario = "SELECT IdUsuario FROM USUARIO WHERE CorreoElectronico=:email";
    $stmt_usuario = $dbhost->prepare($query_usuario);
    $stmt_usuario->bindParam(':email', $email);
    $stmt_usuario->execute();

    $info_usuario = $stmt_usuario->fetch(PDO::FETCH_ASSOC);

    $IdUsuario = $info_usuario['IdUsuario'];

    $fechaHoraActual = date('Y-m-d H:i:s');

    $query_update = "UPDATE USUARIO SET Password=:newPassword,UltimaFechaCambioPassword=:fechaHoraActual, IdStatusUsuario = 1 WHERE IdUsuario=:idUsuario";
    $stmt_update = $dbhost->prepare($query_update);
    $stmt_update->bindParam(':idUsuario', $IdUsuario);
    $stmt_update->bindParam(':newPassword', $newPassword);
    $stmt_update->bindParam(':fechaHoraActual', $fechaHoraActual);
    $stmt_update->execute();

    echo json_encode([
        "status" => 200,
        "msg" => "Contraseña restablecida exitosamente",
    ]);
    die();
}else{
    echo json_encode([
        "status" => 400,
        "msg" => "Servicio incorrecto",
    ]);
    die();
}