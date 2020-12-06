<?php
    session_start();
    include_once "../model/supplier.php";
    include_once "./common/validation.php";

    function addNewSupplier($input_supplier) {      
        $phone_numbers['phone'] = isset($input_supplier['phone_numbers'])? $input_supplier['phone_numbers'] : [];
        unset($input_supplier['phone_numbers']);

        $validation = Validate::validateData('supplier',$input_supplier);
        if ($validation != 'success') return $validation;
        
        $validation = Validate::validateData('supplier_phonenumber',$phone_numbers);
        if ($validation != 'success') return $validation;

        $status_id_supplier = Supplier::inputNewSupplier($input_supplier);
        if (!$status_id_supplier) return 'fail';

        $phone_numbers['ID'] = $status_id_supplier;

        $status_phone = Supplier::inputPhoneNumberSupplier($phone_numbers['ID'],$phone_numbers['phone']);
        return $status_phone ? 'success' : 'fail';
    }

    if (isset($_POST['inputSupplier']) && isset($_SESSION['user']) && $_SESSION['user'] == 'admin') {
        echo(addNewSupplier($_POST['inputSupplier']));
    }

?>