const getCustomersName_url = "application/controller/orderReport.php?getAllNames=true";
const getAllOrdrers_url = "application/controller/orderReport.php?getAllOrders=true";
const getOrderByName_url = "application/controller/orderReport.php";

function addSelectOptions(selectValues) {
    $.each(selectValues, function(key, value) {
        $('#order').append(new Option(value['Name'], value['Name'], ));
    });
    $('#order').selectpicker("val", "");
    $('#order').selectpicker('refresh');
}

function renderRecord(dataObj) {
    var table = $("#orderReport");
    table.find("tr").slice(1).remove();
    $.each(dataObj, function(index, value) {
        $(
            `
				<tr>
				<td id="${value.orderCode}">${value.orderCode}</td>
				<td>${value.totalPrice}</td>
				<td id="${value.customerCode}">${value.customerCode}</td>
				<td>${value.Name}</td>
				<td><a href="orderDetail?order=${value.orderCode}&customer=${value.customerCode}" target="_blank">View details</a></td>
				</tr>
			`
        ).appendTo(table);
    });
}

function getCustomersName() {
    $.ajax({
        type: "GET",
        url: getCustomersName_url,
        cache: false,
        success: function(response) {
            var data = JSON.parse(response);
            addSelectOptions(data);
        },
        async: false
    });
}

function getAllOrders() {
    $.ajax({
        type: "GET",
        url: getAllOrdrers_url,
        cache: false,
        success: function(response) {
            var data = JSON.parse(response);
            renderRecord(data);
        }
    })
}

function getOrderByName(customerName) {
    $.ajax({
        type: "POST",
        url: getOrderByName_url,
        data: { obj: customerName },
        success: function(response) {
            var data = JSON.parse(response);
            renderRecord(data);
        }
    })
}

function applyFilter() {
    $("#order").change(function() {
        var filter_name = $(this).val();
        if (filter_name !== "") {
            getOrderByName(filter_name);
        } else getAllOrders();
    });
}

$(function() {
    getCustomersName();
    getAllOrders();
    applyFilter();
})