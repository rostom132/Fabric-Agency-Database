const dateArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

let table = $("#order-detail");

function getDateFormat(dateObj) {
    var dd = String(dateObj.getDate()).padStart(2, '0');
    var mm = dateArr[parseInt(String(dateObj.getMonth() + 1).padStart(2, '0'), 10) - 1];
    var yyyy = dateObj.getFullYear();
    return mm + " " + dd + ", " + yyyy;
}

function getURL(orderId, customerId) {
    return "application/controller/orderReport.php?orderId=" + orderId + "&customerId=" + customerId;
}

function getOrderDetail(url) {
    $.ajax({
        type: "GET",
        url: url,
        success: function(response) {
            var data = JSON.parse(response);
            renderHeader(data);
            renderInformation(data);
            renderEmployee(data);
            renderItemList(data);
            renderCustomerPhone(data);
        },
        async: false
    });
}

function renderHeader(orderInfo) {
    var cur_date = new Date();
    cur_date = getDateFormat(cur_date);
    $(
        `
		<tr class="top">
			<td colspan="12">
				<table>
					<tr>
						<td class="title">
							TKT Fabric
						</td>

						<td>
							Order Invoice #: ${orderInfo.OrderID}
							<br> Created: ${cur_date}
						</td>
					</tr>
				</table>
			</td>
		</tr>
		`
    ).appendTo(table);
}

function renderInformation(orderInfo) {
    $(
        `
		<tr class="information">
			<td colspan="12">
				<table>
					<tr>
						<td>
							TKT Fabric, Inc.<br> 268 Lý Thường Kiệt, District 10, Ho Chi Minh City<br> 0969935447
						</td>

						<td id="customer_phone_number">
							${orderInfo.customerName}<br>${orderInfo.customerAddress}<br>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		`
    ).appendTo(table);
}

function renderEmployee(orderInfo) {
    $(
        `
		<tr class="heading">
			<td colspan="2">
				Employee ID
			</td>
			<td colspan="2">
				Employee Name
			</td>
			<td colspan="2">
				Address
			</td>
			<td colspan="2">
				Phone Number
			</td>
			<td colspan="2">
				Date
			</td>
		</tr>

		<tr class="details">
			<td colspan="2">
				${orderInfo.employeeCode}
			</td>
			<td colspan="2">
				${orderInfo.employeeName}
			</td>
			<td colspan="2">
				${orderInfo.employeeAddress}
			</td>
			<td colspan="2">
				${orderInfo.phoneNumber}
			</td>
			<td colspan="2">
				${orderInfo.date}` + " " + `${orderInfo.time}
			</td>
        </tr>
		`
    ).appendTo(table);
}

function renderItemList(orderInfo) {
    $(
        `
		<tr class="heading">
			<td colspan="2">
				Category ID
			</td>
			<td colspan="2">
				Category Name
			</td>
			<td colspan="2">
				Color
			</td>
			<td colspan="2">
				Bolt ID
			</td>
			<td colspan="2">
				Length
			</td>
		</tr>
		`
    ).appendTo(table);
    $.each(orderInfo.orderList, function(index, value) {
        $(
            `
			<tr class="item">
				<td colspan="2">
					${value.categoryCode}
				</td>
				<td colspan="2">
					${value.categoryName}
				</td>
				<td colspan="2">
					${value.color}
				</td>
				<td colspan="2">
					${value.boltCode}
				</td>
				<td colspan="2">
					${value.length}
				</td>
			</tr>
			`
        ).appendTo(table);
    });
    $(
        `
		<tr class="total">
			<td colspan="5"></td>
			<td colspan="5">
				Total: ${orderInfo.totalPrice}
			</td>
		</tr> -->
		`
    ).appendTo(table);
}

function renderCustomerPhone(orderInfo) {
    $.each(orderInfo.customerPhone, function(index, value) {
        $("#customer_phone_number").append(value.phoneNumber + "<br>");
    });
}

function generatePDF(orderId) {
    var content = $("#order-detail")[0];
    const pdf = new jsPDF({
        orientation: "landscape",
        unit: "in",
    });
    pdf.addHTML(content, function() {
        pdf.save('oderInvoice' + orderId + '.pdf');
    });
}

$(function() {
    let parameter = window.location.href.split("&");
    let orderId = parameter[0].split("=")[1];
    let customerId = parameter[1].split("=")[1];
    var url = getURL(orderId, customerId);
    getOrderDetail(url);
    $("#print-btn").click(() => generatePDF(orderId));
})