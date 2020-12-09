<?php
    include_once 'databaseConn.php';

    class Category {
        static function getCategoriesBySupplier($supplier_id) {
            $result = $GLOBALS['db_conn']->queryData(
                "call getCategoriesBySupplier('$supplier_id')"
            );
            $result_arr = $GLOBALS['db_conn']->convertToArray($result);
            $GLOBALS["db_conn"]->freeResult($result);
            return $result_arr;
        }

        static function getAllCategories() {
            $result = $GLOBALS['db_conn']->queryData(
                "SELECT * FROM getAllCategories"
            );
            $result_arr = $GLOBALS['db_conn']->convertToArray($result);
            $GLOBALS["db_conn"]->freeResult($result);
            return $result_arr;
        }

        static function getSellingPrice($supplier_id){
            $result = $GLOBALS['db_conn']->queryData(
                "call getSellingPrice('$supplier_id')"
            );
            $result_arr = $GLOBALS['db_conn']->convertToArray($result);
            $GLOBALS["db_conn"]->freeResult($result);
            return $result_arr;
        }
    }
?>