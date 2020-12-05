<?php
    include_once 'databaseConn.php';
    
    Class Transaction {
        static function getAllTransaction() {
            $result = $GLOBALS['db_conn']->queryData(
                "SELECT * FROM getalltransaction"
            );
            return $GLOBALS['db_conn']->convertToArray($result);
        }
        static function getFilterTransaction($input_array) {
            $sql = "SELECT category.categoryName, relationprovide_provideinformation.date as Date, relationprovide_provideinformation.purchasePrice, relationprovide_provideinformation.quantity as Quantity, supplier.supplierName, supplier.supplierCode FROM category, relationprovide_provideinformation, supplier WHERE category.categoryCode = relationprovide_provideinformation.categoryCode AND category.r_supplierCode = supplier.supplierCode ";
            foreach ($input_array AS $col=>$val) {
                $sql .= " AND ";
                if($col == "start") {
                    $sql .= "relationprovide_provideinformation.date >= '$val'";
                }
                if($col == "end") {
                    $sql .= "relationprovide_provideinformation.date <= '$val'";
                }
                if($col == "category") {
                    $sql .= "category.categoryName LIKE '$val'";
                }
                if($col == "supplier") {
                    $sql .= "supplier.supplierCode = '$val'";
                }
            }
            $sql.= " ORDER BY relationprovide_provideinformation.date DESC";
            $result = $GLOBALS['db_conn']->queryData(
                $sql
            );
            if($result->num_rows != 0) {
                return $GLOBALS['db_conn']->convertToArray($result);
            }
            else {
                return 0;
            }
        }
    }
?>