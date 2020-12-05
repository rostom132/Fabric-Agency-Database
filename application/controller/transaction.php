<?php
    include_once "../model/supplier.php";
    include_once "../model/category.php";
    include_once "../model/transaction.php";
    function getCategoryFilter() {
        $category_list = Category::getAllCategories();
        return $category_list;
    }

    function getSupplierFilter() {
        $name_list = Supplier::getNamesAllSuppliers();
        return $name_list;
    }
    function getAllTransaction() {
        $trans_list = Transaction::getAllTransaction();
        return $trans_list;
    }
    function getSpecificSupplier($supplier_id) {
        $supplier_info = [];
        $supplier_info = Supplier::getSupplierInfo($supplier_id);
        $supplier_info['phone_numbers'] = Supplier::getSupplierPhoneNumbers($supplier_id);
        return $supplier_info;
    }
    function getFilterTransaction($filterVal) {
        $filterArr = (array)$filterVal;
        foreach ($filterArr as $key=>$value) {
            if ($filterArr[$key] == "-1" || $filterArr[$key] == "") {
                unset($filterArr[$key]);
            }
        }
        $data = array();
        $data["transaction"] = Transaction::getFilterTransaction($filterArr);
        $data["infor"] = Supplier::getAllSuppliersDetail();
        if($filterArr["supplier"] != null) {
            $data["supplier"] = getSpecificSupplier($filterArr["supplier"]);
        }
        if($data["transaction"] == 0) {
            echo(0);
        }
        else {
            echo(json_encode($data));
        }
        
    }
    //Get filter value
    if (isset($_GET["catFilter"]) && isset($_GET["supFilter"])) {
        $data = array();
        $data["category"] = getCategoryFilter();
        $data["supplier"] = getSupplierFilter();
        echo(json_encode($data));
    }
    //Get all transaction
    if (isset($_GET["getAll"])) {
        $data = array();
        $data["transaction"] = getAllTransaction();
        $data["infor"] = Supplier::getAllSuppliersDetail(); 
        echo(json_encode($data));
    }
    //Get transaction with filter
    if(isset($_GET["filterVal"])) {
        getFilterTransaction(json_decode($_GET["filterVal"]));
    }
?>