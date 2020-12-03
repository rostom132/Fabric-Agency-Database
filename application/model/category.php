<?php
    include_once 'databaseConn.php';

    class Category {
        static function getCategoriesBySupplier($supplier_id) {
            $result = $GLOBALS['db_conn']->queryData(
                "SELECT `categoryCode` as code,`categoryName` as name,`color`,`quantity` FROM category WHERE `r_supplierCode` = '$supplier_id'"
            );
            return $GLOBALS['db_conn']->convertToArray($result);
        }
    }
?>