<?php
    session_start();
    $_SESSION['user_id'] = 1;
    $_SESSION['user'] = 'manager';
    include "../view/navbar.html";
    // include "../view/header.html";

    if (isset($_GET['page'])){
        $page = $_GET['page'];
        include "$page.html";
    }
    // include "../view/transaction.html";
    // include "../view/category.html";
    // include "../view/addInfoSupplier.html";
    // include "../view/orderReport.html";
?>