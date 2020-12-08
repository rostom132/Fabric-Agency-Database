<?php
    include_once 'databaseConn.php';

    class Supplier {
        static function getNamesAllSuppliers() {
            $result = $GLOBALS['db_conn']->queryData(
                "SELECT * FROM getSuppliersName"
            );
            return $GLOBALS['db_conn']->convertToArray($result);
        }
        static function getAllSuppliersDetail() {
            $result = $GLOBALS['db_conn']->queryData(
                "SELECT * from getSupplierInfos"
            );
            return $GLOBALS['db_conn']->convertToArray($result);
        }
        static function getSupplierInfo($supplier_id) {
            $result = $GLOBALS['db_conn']->queryData(
                "call getSupplierInfo('$supplier_id');"
            );
            $result_arr = $GLOBALS['db_conn']->convertToArray($result)[0];
            $GLOBALS["db_conn"]->freeResult($result);
            return $result_arr;
        }

        static function getSupplierPhoneNumbers($supplier_id) {
            $result = $GLOBALS['db_conn']->queryData(
                "call getSupplierPhoneNumber('$supplier_id');"
            );
            $result_arr = $GLOBALS['db_conn']->convertToArray($result);
            $GLOBALS["db_conn"]->freeResult($result);
            return $result_arr;
        }

        /**
         * insert info for supplier
         * @param array $input_data array of supplier info (name, address, bank_account, tax) 
         * 
         * @return integer id of new supplier if success
         * @return flase if fail
         */ 
        static function inputNewSupplier($input_data) {
            $columns = array_keys($input_data);
            foreach ( $columns as &$value) {
                $value = $GLOBALS['db_conn'] -> convertToColumnName('supplier', $value);
            }
            $values = array_values($input_data);

            $result = $GLOBALS['db_conn']->queryData(
                "INSERT INTO `supplier` (`" .implode("`, `",$columns) ."`" .") 
                VALUES ('" . implode("', '", $values) . "' )"
            );
            if ($result) return ($GLOBALS['db_conn'] -> getNewInsertedId());
            return false;
        }

        /**
         * insert phone numbers for supplier
         * @param string $supplier_id id of the supplier (ID)
         * @param array $phone_numbers array of phone numbers (phone) 
         * 
         * @return integer id
         */ 
        static function inputPhoneNumberSupplier($supplier_id, $phone_numbers) {
            $sql = '';
            foreach ($phone_numbers AS $val) {
                if ($sql !=  '') $sql.= ',';
                $sql .= "('$supplier_id', '$val')";
            }

            $result = $GLOBALS['db_conn']->queryData(
                "INSERT INTO `supplier_phonenumber` (`" .$GLOBALS['db_conn'] -> convertToColumnName('supplier_phonenumber', 'ID') ."`,`" .$GLOBALS['db_conn'] -> convertToColumnName('supplier_phonenumber', 'phone') . "`) 
                VALUES" .$sql
            );
            if ($result) return true;
            return false;
        }
    }
?>