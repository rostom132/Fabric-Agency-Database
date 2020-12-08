<?php
	include_once "databaseConn.php";

	class orderReport {
		static function getCustomersName() {
			$result = $GLOBALS["db_conn"]->queryData(
				"SELECT * FROM getCustomersName"
			);
			$result_arr = $GLOBALS['db_conn']->convertToArray($result);
            $GLOBALS["db_conn"]->freeResult($result);
            return $result_arr;
		}

		static function getAllOrders() {
			$result = $GLOBALS["db_conn"]->queryData(
				"SELECT * FROM getAllOrders"
			);
			$result_arr = $GLOBALS['db_conn']->convertToArray($result);
            $GLOBALS["db_conn"]->freeResult($result);
            return $result_arr;
		}

		static function getOrderByName($filterName) {
			$result = $GLOBALS["db_conn"]->queryData(
				"call getOrderByName('$filterName')"
			);
			$result_arr = $GLOBALS['db_conn']->convertToArray($result);
            $GLOBALS["db_conn"]->freeResult($result);
            return $result_arr;
		}

		static function getOrderInfo($orderCode) {
			$result = $GLOBALS["db_conn"]->queryData(
				"call getOrderInfo('$orderCode')"
			);
			$result_arr = $GLOBALS['db_conn']->convertToArray($result)[0];
            $GLOBALS["db_conn"]->freeResult($result);
            return $result_arr;
		}

		static function getOrderList($orderCode) {
			$result = $GLOBALS["db_conn"]->queryData(
				"call getOrderList('$orderCode')"
			);
			$result_arr = $GLOBALS['db_conn']->convertToArray($result);
            $GLOBALS["db_conn"]->freeResult($result);
            return $result_arr;
		}

		static function getCustomerPhone($customerCode) {
			$result = $GLOBALS["db_conn"]->queryData(
				"call getCustomerPhone('$customerCode')"
			);
			$result_arr = $GLOBALS['db_conn']->convertToArray($result);
            $GLOBALS["db_conn"]->freeResult($result);
            return $result_arr;
		}
	}
?>