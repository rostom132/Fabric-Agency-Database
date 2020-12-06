<?php
    session_start();
    function verifyAccount($username,$password) {
        $hash_password = md5($password);
        $xml = simplexml_load_file("../../secret/manager.xml") or die ("Error: Cannot create object");
        foreach($xml->account as $account) {
            if($account->username == $username) {
                if($account->password == $hash_password) {
                    return true;
                }
            }
        }
        return false;
    }
    if(isset($_GET["username"]) && isset($_GET["password"])) { 
        if(verifyAccount($_GET["username"], $_GET["password"])) {
            $_SESSION["user"] = "admin";
            echo "OK";
        }
        else {
            session_destroy();
            echo "Wrong";
        }
    }
?>