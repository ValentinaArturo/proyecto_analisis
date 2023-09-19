<?php

header("Content-Type: application/json");
$json = file_get_contents("php://input");
date_default_timezone_set("America/Guatemala");

if ($json == false || trim($json) == "") {
    echo json_encode([
        "status" => 400,
        "msg" => "Error en datos recibidos",
    ]);
    die();
}

$data = json_decode($json);

if (
    !isset($data->nombre) ||
    !isset($data->apellido) ||
    !isset($data->fechaNacimiento) ||
    !isset($data->genero) ||
    !isset($data->email) ||
    !isset($data->telefono) ||
    !isset($data->password) ||
    $data->nombre == "" ||
    $data->apellido == "" ||
    $data->fechaNacimiento == "" ||
    $data->genero == "" ||
    $data->email == "" ||
    $data->telefono == "" ||
    $data->password == "" ||
    count(get_object_vars($data)) !== 7
) {
    echo json_encode([
        "status" => 400,
        "msg" => "Formato de datos incorrecto",
    ]);
    die();
}

$nombre = $data->nombre;
$apellido = $data->apellido;
$fechaNacimiento = $data->fechaNacimiento;
$genero = $data->genero;
$email = $data->email;
$telefono = $data->telefono;
$password = $data->password;

require "../db/config.php";

$options = [
    PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8",
];

$db = "mysql:host=" . DB_HOSTNAME . ";dbname=" . DB_NAME;
$dbhost = new PDO($db, DB_USERNAME, DB_PASSWORD, $options);

function generarIdUsuario($nombre, $apellido) {
    $nombre = strtolower(str_replace(' ', '', $nombre));
    $apellido = strtolower(str_replace(' ', '', $apellido));
    $nombreCorto = substr($nombre, 0, 3);
    $apellidoCorto = substr($apellido, 0, 3);
    $marcaTiempo = time();
    $marcaTiempoStr = str_pad($marcaTiempo, 10, '0', STR_PAD_LEFT);
    $idUsuario = $nombreCorto . $apellidoCorto . $marcaTiempoStr;
    
    return $idUsuario;
}

$idUsuario = generarIdUsuario($nombre,$apellido);
$fechaHoraActual = date('Y-m-d H:i:s');
$usuarioCreacion = "system";

$query_insert =
    "INSERT INTO USUARIO(
    IdUsuario,
    Nombre,
    Apellido,
    FechaNacimiento,
    IdStatusUsuario,
    Password,
    IdGenero,
    UltimaFechaIngreso,
    IntentosDeAcceso,
    SesionActual,
    UltimaFechaCambioPassword,
    CorreoElectronico,
    RequiereCambiarPassword,
    Fotografia,
    TelefonoMovil,
    IdSucursal,
    FechaCreacion,
    UsuarioCreacion,
    FechaModificacion,
    UsuarioModificacion,
    JWT)
    VALUES(
        :idUsuario,
        :Nombre,
        :Apellido,
        :FechaNacimiento,
        1,
        :Password,
        :genero,
        NULL,
        0,
        NULL,
        NULL,
        :email,
        1,
        NULL,
        :telefono,
        1,
        :fechaActual,
        :usuarioCreacion,
        NULL,
        NULL,
        NULL)";

$stmt_validation = $dbhost->prepare($query_insert);
$stmt_validation->bindParam(':idUsuario', $idUsuario);
$stmt_validation->bindParam(':Nombre', $nombre);
$stmt_validation->bindParam(':Apellido', $apellido);
$stmt_validation->bindParam(':FechaNacimiento', $fechaNacimiento);
$stmt_validation->bindParam(':Password', $password);
$stmt_validation->bindParam(':genero', $genero);
$stmt_validation->bindParam(':email', $email);
$stmt_validation->bindParam(':telefono', $telefono);
$stmt_validation->bindParam(':fechaActual', $fechaHoraActual);
$stmt_validation->bindParam(':usuarioCreacion', $usuarioCreacion );
$stmt_validation->execute();

if($stmt_validation->rowCount() > 0 ){

    echo json_encode(array(
        "status" => 200,
        "msg" => "Usuario registrado exitosamente"
    ));

    die();
    
}else{

    echo json_encode(array(
        "status" => 401,
        "msg" => "Ocurrio un error, intenta nuevamente"
    ));
    
    die();
}

?>