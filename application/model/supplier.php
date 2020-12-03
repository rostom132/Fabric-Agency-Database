<?php
    include_once 'databaseConn.php';

    class Supplier {
        static function getNamesAllSuppliers() {
            $result = $GLOBALS['db_conn']->queryData(
                "SELECT supplierCode as ID, supplierName as Name FROM `supplier` ORDER BY `supplierName` ASC"
            );
            return $GLOBALS['db_conn']->convertToArray($result);
        }
    }
?>