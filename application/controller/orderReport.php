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

	if(isset($_GET["getAllNames"]) && $_SESSION["user"] === "manager") {
		echo(json_encode(getCustomersName()));
	}

	if(isset($_GET["getAllOrders"]) && $_SESSION["user"] === "manager") {
		echo(json_encode(getAllOrders()));
	}

	if(isset($_POST["obj"]) && $_SESSION["user"] === "manager") {
		echo(json_encode(getOrderByName($_POST["obj"])));
	}
?>