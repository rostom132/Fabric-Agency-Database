<?php
    session_start();
    if(isset($_SESSION['user']) && $_SESSION['user'] == "admin") {
        include "../view/navbarLogout.html";
    }
    else {
        include "../view/navbarLogin.html";
    }
    if (isset($_GET['page']) && isset($_SESSION['user']) && $_SESSION['user'] == "admin"){
        $page = $_GET['page'];
        include "../view/$page.html";
    }
    else {
        include "../view/login.html";
    }   
?>