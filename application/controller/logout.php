<?php
    session_start();
    if (isset($_GET["logout"])) {   
        session_destroy();
        echo("OK");
    }
?>