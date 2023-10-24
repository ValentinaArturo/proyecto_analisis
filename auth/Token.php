<?php

class Token{
    static function SignIn($payload, $key, $expire = null){

        $headers = ['algo'=>'HS256', 'type'=>'JWT', 'expire' => time()+$expire];
        if($expire){
            $headers['expire'] = time()+$expire;
        }
        $headers_encoded = base64_encode(json_encode($headers));

        $payload['time'] = time();
        $payload_encoded = base64_encode(json_encode($payload));

        $signature = hash_hmac('SHA256',$headers_encoded.$payload_encoded,$key);
        $signature_encoded = base64_encode($signature);

        $token = $headers_encoded . '.' . $payload_encoded .'.'. $signature_encoded;

        return $token;
    }

    static function Verify($token, $key){

        $token_parts = explode('.', $token);

        if(!isset($token_parts[0]) || !isset($token_parts[1]) || !isset($token_parts[2]) ){
            echo json_encode(array(
                "status" => 401,
                "msg" => "Token Invalido - Sin Formato"
            ));
            return false;
        }

        $payload = json_decode(base64_decode($token_parts[1]), true);


        $signature = base64_encode(hash_hmac('SHA256',$token_parts[0].$token_parts[1],$key));

        $idUsuario = $payload["id"];
        
        $options = array(
            PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8'
        );
        
        $db = 'mysql:host=' . DB_HOSTNAME . ';dbname=' . DB_NAME;
        $dbhost = new PDO($db, DB_USERNAME, DB_PASSWORD, $options);

        $query_validation = "SELECT JWT FROM USUARIO WHERE IdUsuario=:IdUsuario";
        $stmt_validation = $dbhost->prepare($query_validation);
        $stmt_validation->bindParam(':IdUsuario',$idUsuario);
        $stmt_validation->execute();

        $row = $stmt_validation->fetch(PDO::FETCH_ASSOC);
        $TokenUsuarioDB = $row['JWT'];

        if($TokenUsuarioDB == null){
            echo json_encode(array(
                "status" => 401,
                "msg" => "Token Incorrecto"
            ));
            die();
        }

        if($token == $TokenUsuarioDB){
            return true;
        }else{
            echo json_encode(array(
                "status" => 401,
                "tokenDB" => "Token Incorrecto"
            ));
            die();
        }

        $headers = json_decode(base64_decode($token_parts[0]), true);

        if(isset($headers['expire']) && $headers['expire'] < time()){
            echo json_encode(array(
                "status" => 401,
                "msg" => "Token Expiro"
            ));
            return false;
        }

        return $payload;
    }

    static function GetUserID($token){

        $token_parts = explode('.', $token);

        if(!isset($token_parts[0]) || !isset($token_parts[1]) || !isset($token_parts[2]) ){
            echo json_encode(array(
                "status" => 401,
                "msg" => "Token Invalido - Sin Formato"
            ));
            return false;
        }

        $payload = json_decode(base64_decode($token_parts[1]), true);
        $idUsuario = $payload["id"];
        
        return $idUsuario;
    }

}

?>