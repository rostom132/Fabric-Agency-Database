const dateArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

let getOrderInfo_url = "application/controller/orderReport.php?orderInfo=";
let getItemList_url = "application/controller/orderReport.php?orderList=";
let getCustomerPhone_url = "application/controller/orderReport.php?customerCode=";
let orderInfo = [];
let orderList = [];
let table = $("#order-detail");

function getDateFormat(dateObj) {
    var dd = String(dateObj.getDate()).padStart(2, '0');
    var mm = dateArr[parseInt(String(dateObj.getMonth() + 1).padStart(2, '0'), 10) - 1];
    var yyyy = dateObj.getFullYear();
    return mm + " " + dd + ", " + yyyy;
}

function getOrderInfo() {
    $.ajax({
        type: "GET",
        url: getOrderInfo_url,
        success: function(response) {
            orderInfo = JSON.parse(response)[0];
            console.log(orderInfo);
        },
        async: false
    });
}

function getItemList() {
    $.ajax({
        type: "GET",
        url: getItemList_url,
        success: function(response) {
            orderList = JSON.parse(response);
            console.log(orderList);
        },
        async: false
    });
}

function getCustomerPhone() {
    $.ajax({
        type: "GET",
        url: getCustomerPhone_url,
        success: function(response) {
            var data = JSON.parse(response);
            console.log(data);
            $.each(data, function(index, value) {
                console.log(value);
                $("#customer_phone_number").append(value.phoneNumber + "<br>");
            });
        },
        async: false
    })
}

function renderHeader() {
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

function renderInformation() {
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

function renderEmployee() {
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

function renderItemList() {
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
    $.each(orderList, function(index, value) {
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

function generatePDF() {
    var content = $("#order-detail")[0];
    const pdf = new jsPDF({
        orientation: "landscape",
        unit: "in",
    });
    pdf.addHTML(content, function() {
        pdf.save('web.pdf');
    });
}

$("#print-btn").click(() => generatePDF());

$(function() {
    let parameter = window.location.href.split("&");
    let orderCode = parameter[0].split("=")[1];
    let customerCode = parameter[1].split("=")[1];
    getOrderInfo_url += orderCode;
    getItemList_url += orderCode;
    getCustomerPhone_url += customerCode;
    getOrderInfo();
    getItemList();
    renderHeader();
    renderInformation();
    renderEmployee();
    renderItemList();
    getCustomerPhone();
})