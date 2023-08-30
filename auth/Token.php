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

        $signature = base64_encode(hash_hmac('SHA256',$token_parts[0].$token_parts[1],$key));
        if($signature != $token_parts[2]){
            echo json_encode(array(
                "status" => 401,
                "msg" => "Token Invalido"
            ));
            return false;
        }

        $headers = json_decode(base64_decode($token_parts[0]), true);
        $payload = json_decode(base64_decode($token_parts[1]), true);

        if(isset($headers['expire']) && $headers['expire'] < time()){
            echo json_encode(array(
                "status" => 401,
                "msg" => "Token Expiro"
            ));
            return false;
        }

        return $payload;
    }

}

?>