<?php

require '../db/config.php';
require '../auth/Token.php';


header('Content-Type: application/json');

const KEY = 'analisisDeSistemas1234#';
$headers = getallheaders();
$token = null;

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
        
        $query_validation = "SELECT * FROM USUARIO";
        $stmt_validation = $dbhost->prepare($query_validation);
        $stmt_validation->execute();

        $results = $stmt_validation->fetchAll(PDO::FETCH_ASSOC);

        $json = json_encode($results);

        echo $json;

    }

} else {
    echo json_encode(array(
        "status" => 401,
        "msg" => "Error: Token no presente en la cabecera de autorización"
    ));
}


?>