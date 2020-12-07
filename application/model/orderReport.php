<?php
	include_once "databaseConn.php";

	class orderReport {
		static function getCustomersName() {
			$result = $GLOBALS["db_conn"]->queryData(
				"SELECT * FROM getCustomersName"
			);
			return $GLOBALS["db_conn"]->convertToArray($result);
		}

		static function getAllOrders() {
			$result = $GLOBALS["db_conn"]->queryData(
				"SELECT * FROM getAllOrders"
			);
			return $GLOBALS["db_conn"]->convertToArray($result);
		}

		static function getOrderByName($filterName) {
			$result = $GLOBALS["db_conn"]->queryData(
				"call getOrderByName('$filterName')"
			);
			return $GLOBALS["db_conn"]->convertToArray($result);
		}

		static function getOrderInfo($orderCode) {
			$result = $GLOBALS["db_conn"]->queryData(
				"call getOrderInfo('$orderCode')"
			);
			return $GLOBALS["db_conn"]->convertToArray($result);
		}

		static function getOrderList($orderCode) {
			$result = $GLOBALS["db_conn"]->queryData(
				"call getOrderList('$orderCode')"
			);
			return $GLOBALS["db_conn"]->convertToArray($result);
		}

		static function getCustomerPhone($customerCode) {
			$result = $GLOBALS["db_conn"]->queryData(
				"call getCustomerPhone('$customerCode')"
			);
			return $GLOBALS["db_conn"]->convertToArray($result);
		}
	}
?>