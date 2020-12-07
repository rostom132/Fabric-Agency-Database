<?php
	include "../model/orderReport.php";
	session_start();
	function getCustomersName() {
		return orderReport::getCustomersName();
	}	

	function getAllOrders() {
		return orderReport::getAllOrders();
	}

	function getOrderByName($filterName) {
		return orderReport::getOrderByName($filterName);
	}

	function getOrderInfo($orderCode) {
		return orderReport::getOrderInfo($orderCode);
	}

	function getOrderList($orderCode) {
		return orderReport::getOrderList($orderCode);
	}

	function getCustomerPhone($customerCode) {
		return orderReport::getCustomerPhone($customerCode);
	}

	if(isset($_GET["getAllNames"]) && $_SESSION["user"] === "admin") {
		echo(json_encode(getCustomersName()));
	}

	if(isset($_GET["getAllOrders"]) && $_SESSION["user"] === "admin") {
		echo(json_encode(getAllOrders()));
	}

	if(isset($_POST["obj"]) && $_SESSION["user"] === "admin") {
		echo(json_encode(getOrderByName($_POST["obj"])));
	}

	if(isset($_GET["orderInfo"]) && $_SESSION["user"] === "admin") {
		echo(json_encode(getOrderInfo($_GET["orderInfo"])));
	}

	if(isset($_GET["orderList"]) && $_SESSION["user"] === "admin") {
		echo(json_encode(getOrderList($_GET["orderList"])));
	}

	if(isset($_GET["customerCode"]) && $_SESSION["user"] === "admin") {
		echo(json_encode(getCustomerPhone($_GET["customerCode"])));
	}
?>