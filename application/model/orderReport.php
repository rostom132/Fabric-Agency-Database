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
	}
?>