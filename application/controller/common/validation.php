<?php
    include_once "../../secret/config.php";

    class Validate {
        
        static function createResponse(&$response , $error) {
            if ($response == '') {
                $response .= "ERROR when validate " . $error;
            } else {
                $response .= ", " . $error;
            }
            return;
        } 

        static function validateData ($table, $data) {
            $response = '';
            switch($table) {
                case 'supplier_phonenumber':
                    if (empty($data['phone'])) return "Please input atleast 1 phone number";
                    foreach($data['phone'] as $value) {
                        if (!preg_match(Config::getRegex()['supplier_phonenumber']['phone'], $value)) {
                            Validate::createResponse($response, "Phone Number");
                            return $response;
                        }
                    }
                    break;
                default:
                    foreach($data as $key=>$value) {
                        if (!preg_match(Config::getRegex()[$table][$key], $value)) {
                            
                            Validate::createResponse($response, $key);
                            return $response;
                        }
                    }
            }
            return 'success';
        }

    }

?>