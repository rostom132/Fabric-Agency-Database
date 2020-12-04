<?php
    include_once 'databaseConn.php';

    class Supplier {
        static function getNamesAllSuppliers() {
            $result = $GLOBALS['db_conn']->queryData(
                "SELECT supplierCode as ID, supplierName as Name FROM `supplier` ORDER BY `supplierName` ASC"
            );
            return $GLOBALS['db_conn']->convertToArray($result);
        }

        static function getSupplierInfo($supplier_id) {
            $result = $GLOBALS['db_conn']->queryData(
                "SELECT supplierName as name, taxCode as tax, address, bankAccount as bank  FROM supplier WHERE supplierCode = '$supplier_id'"
            );
            return $GLOBALS['db_conn']->convertToArray($result)[0];
        }

        static function getSupplierPhoneNumbers($supplier_id) {
            $result = $GLOBALS['db_conn']->queryData(
                "SELECT `phoneNumber` FROM supplier_phonenumber WHERE supplierCode = '$supplier_id'"
            );
            return $GLOBALS['db_conn']->convertToArray($result);
        }
    }
?>