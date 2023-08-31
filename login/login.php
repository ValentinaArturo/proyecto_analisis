<?php

header('Content-Type: application/json');
$json = file_get_contents('php://input');


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

$query_validation = "SELECT idUsuario FROM Nomina.USUARIO WHERE CorreoElectronico =:email AND Password =:password ";
$stmt_validation = $dbhost->prepare($query_validation);
$stmt_validation->bindParam(':email', $email);
$stmt_validation->bindParam(':password', $password);
$stmt_validation->execute();


if ($stmt_validation->rowCount() == 0 ){
    echo json_encode(array(
        "status" => 400,
        "msg" => "Credenciales Invalidas"
    ));
}else{

    $row = $stmt_validation->fetch(PDO::FETCH_ASSOC);
    $idUsuario = $row['idUsuario'];
    $token = Token::SignIn(['id'=>$idUsuario],KEY,60*8);

    echo json_encode(array(
        "status" => 200,
        "msg" => "Bienvenido",
        "token"=>$token,
        "idUsuario"=> $idUsuario
    ));

}

$token = Token::SignIn(['id'=>'luisca'],KEY,3);


?>