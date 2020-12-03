<?php
    include_once "../model/supplier.php";
    include_once "../model/category.php";
    session_start();

    function getAllSuppliers() {
        return (json_encode(Supplier::getNamesAllSuppliers()));
    }

    function getCategoriesOfSupplier($supplier_id){
        return (json_encode(Category::getCategoriesBySupplier($supplier_id)));
    }

    if (isset($_GET['get_suppliers']) and $_GET['get_suppliers'] == 'true') {
        if ( isset($_SESSION['user']) and $_SESSION['user'] == "admin") {
            echo (getAllSuppliers());
        } else {
            echo ("Please use Admin account to Login!!");
        }
    }

    if (isset($_GET['get_categories'])) {
        if ( isset($_SESSION['user']) and $_SESSION['user'] == "admin") {
            echo (getCategoriesOfSupplier($_GET['get_categories']));
        } else {
            echo ("Please use Admin account to Login!!");
        }
    }
?>