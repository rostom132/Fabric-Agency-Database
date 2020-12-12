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

        static function checkNameExist($name) {
            $result = $GLOBALS['db_conn']->queryData(
                "SELECT getNumberOfSuppliers('$name') AS numberOfSuppliers;"
            );
            $result_arr = $GLOBALS['db_conn']->convertToArray($result);
            $GLOBALS["db_conn"]->freeResult($result);
            if ($result_arr[0]['numberOfSuppliers'] > 0) return true;
            return false;
        }

        /**
         * insert info for supplier
         * @param array $input_data array of supplier info (name, address, bank_account, tax) 
         * 
         * @return integer id of new supplier if success
         * @return flase if fail
         */ 
        static function inputNewSupplier($input_data) {  
            $supplierName = (isset($input_data["name"]) && $input_data["name"] != null) ? $input_data["name"] : "";
            $address = (isset($input_data["address"]) && $input_data["address"] != null) ? $input_data["address"] : "";
            $bankAccount = (isset($input_data["tax"]) && $input_data["tax"] != null) ? $input_data["tax"] : "";
            $taxCode = (isset($input_data["bank_account"]) && $input_data["bank_account"] != null) ? $input_data["bank_account"] : "";
            $result = $GLOBALS['db_conn']->queryData(
                "call add_supplier('$supplierName', '$address', '$bankAccount', '$taxCode', @id)"
            );
            $result = $GLOBALS['db_conn']->queryData(
                "SELECT @id"
            );
            if($result) {
                return $GLOBALS['db_conn']->convertToArray($result)[0]["@id"];
            }
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
            $phone_numbers_string = '["' . implode('","', $phone_numbers) . '"]';
            $result = $GLOBALS['db_conn']->queryData(
               "call insertPhones('$supplier_id', '$phone_numbers_string')"
            );
            if ($result) return true;
            return false;
        }
    }
?>