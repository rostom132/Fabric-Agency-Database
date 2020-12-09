<?php
    session_start();
    if(isset($_SESSION['user']) && $_SESSION['user'] == "admin") {
        if (!isset($_GET['page'])) {
            header("Location: http://localhost/Fabric-Agency-Database/transaction");
        }
        else {
            $page = $_GET['page'];
            include "../view/navbarLogout.html";   
            include "../view/$page.html";
        }
    }
    else {
        include "../view/navbarLogin.html";
        include "../view/login.html";
    }
?>