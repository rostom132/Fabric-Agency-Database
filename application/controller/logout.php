<?php
    session_start();
    if (isset($_SESSION["user"]) && isset($_GET["logout"])) {   
        session_destroy();
        echo("OK");
    }
?>