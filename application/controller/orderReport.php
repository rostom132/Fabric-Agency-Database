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

	function getOrderInfo($orderId) {
		return orderReport::getOrderInfo($orderId);
	}

	function getOrderList($orderId) {
		return orderReport::getOrderList($orderId);
	}

	function getCustomerPhone($customerId) {
		return orderReport::getCustomerPhone($customerId);
	}

	function getOrderDetail($orderId, $customerId) {
		$data = [];
		$data = getOrderInfo($orderId);
		$data["orderList"] = getOrderList($orderId);
		$data["customerPhone"] = getCustomerPhone($customerId);
		return $data;
	}

	if(isset($_GET["getAllNames"]) && $_GET["getAllNames"] === "true") {
		if(isset($_SESSION["user"]) && $_SESSION["user"] === "admin"){
			echo(json_encode(getCustomersName()));
		} else {
            echo ("Please use Admin account to Login!!");
        }
	}

	if(isset($_GET["getAllOrders"]) && $_GET["getAllOrders"] === "true") {
		if(isset($_SESSION["user"]) && $_SESSION["user"] === "admin"){
			echo(json_encode(getAllOrders()));
		} else {
            echo ("Please use Admin account to Login!!");
        }
	}

	if(isset($_POST["obj"])) {
		if(isset($_SESSION["user"])){
			echo(json_encode(getOrderByName($_POST["obj"])));
		} else {
            echo ("Please use Admin account to Login!!");
        }
	}

	if(isset($_GET["orderId"]) && isset($_GET["customerId"])) {
		if(isset($_SESSION["user"]) && $_SESSION["user"] === "admin"){
			echo(json_encode(getOrderDetail($_GET["orderId"], $_GET["customerId"])));
		}
	}
?>