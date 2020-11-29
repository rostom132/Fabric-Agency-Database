<?php
    session_start();
    $_SESSION['user_id'] = 1;
    include "../view/navbar.html";
    // include "../view/header.html";

    if (isset($_GET['page'])){
        $page = $_GET['page'];
        include "$page.html";
    }
    include "../view/transaction.html";
    // include "../view/category.html";
    // include "addInfoSupplier.html";

?>