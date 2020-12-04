<?php
    include_once "../model/supplier.php";
    include_once "../model/category.php";
    session_start();

    function getAllSuppliers() {
        return (json_encode(Supplier::getNamesAllSuppliers()));
    }

    function getCategoriesOfSupplier($supplier_id){
        $categories = Category::getCategoriesBySupplier($supplier_id);
        $price_date = Category::getSellingPrice($supplier_id);

        $group_price = array();
        foreach ( $price_date as $value ) {
            $group_price[$value['code']][] = array('date'=> $value['date'], 'price'=> $value['price']);
        }
        foreach ( $categories as &$value) {
            if (isset($group_price[$value['code']])) {
                $value['date_price'] = $group_price[$value['code']];
            } else {
                $value['date_price'] = [];
            }
        }
        return $categories;
    }

    function getSupplierInfo($supplier_id) {
        $supplier_info = [];
        $supplier_info = Supplier::getSupplierInfo($supplier_id);
        $supplier_info['phone_numbers'] = Supplier::getSupplierPhoneNumbers($supplier_id);
        return $supplier_info;
    }

    function getResponseForCategory($supplier_id) {
        $response = [];
        $response['category'] = getCategoriesOfSupplier($supplier_id);
        $response['supplier'] = getSupplierInfo($supplier_id);
        return json_encode($response);
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
            echo (getResponseForCategory($_GET['get_categories']));
        } else {
            echo ("Please use Admin account to Login!!");
        }
    }
?>