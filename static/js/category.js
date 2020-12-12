function addSelectOptions(selectValues) {
    $.each(selectValues, function(key, value) {
        $("#supplier").append("<option data-subtext='ID=" + value['ID'] + "'value='" + value['ID'] + "'>" + value['Name'] + "</option>");
    });
    $('#supplier').val('default').selectpicker('deselectAll');
    $('#supplier').selectpicker('refresh');
}

function generateHeaderCategoryTable() {
    var header = "<thead>%data</thead>";
    var first_row = "<tr>";
    first_row += "<th style='width: 25%;' rowspan='2'>Category Name</th>";
    first_row += "<th style='width: 25%;' rowspan='2'>Category Color</th>";
    first_row += "<th style='width: 16%;' rowspan='2'>Category Quantity</th>";
    first_row += "<th style='width: 34%;' colspan='2'>Selling Price</th>";
    first_row += "</tr>";
    var second_row = "<tr>";
    second_row += "<th>Date</th>";
    second_row += "<th>Price</th>";
    second_row += "</tr>";
    var data = first_row + second_row;
    header = header.replace("%data", data);
    return header;
}

function newRowForCategoryTable(row_info) {
    var row = '';
    row += "<tr>";
    var rowspan = row_info['date_price'].length > 0 ? row_info['date_price'].length : 1;
    row += "<td rowspan='" + rowspan + "'>" + row_info['name'] + "</td>";
    row += "<td rowspan='" + rowspan + "'>" + row_info['color'] + "</td>";
    row += "<td rowspan='" + rowspan + "'>" + row_info['quantity'] + "</td>";
    if (row_info['date_price'].length > 0) {
        row += "<td>" + row_info['date_price'][0]['date'] + "</td>";
        row += "<td>" + row_info['date_price'][0]['price'] + "</td>";
        row += "</tr>";
        row_info['date_price'].splice(0, 1);
        for (var date_price of row_info['date_price']) {
            row += "<tr>";
            row += "<td>" + date_price['date'] + "</td>";
            row += "<td>" + date_price['price'] + "</td>";
            row += "</tr>";
        }
    }
    return row;
}

function generateBodyCategoryTable(data) {
    var bodyOfTable = '';
    bodyOfTable += "<tbody>";
    for (var row_info of data) {
        bodyOfTable += newRowForCategoryTable(row_info);
    }
    bodyOfTable += "</tbody>";
    return bodyOfTable;
}

function generateCategoryTable(data) {
    var tablePosition = document.getElementById('table_category');
    tablePosition.innerHTML = '';
    var tbl = document.createElement('table');
    tbl.style.width = '100%';
    tbl.setAttribute('border', '1');
    tbl.insertAdjacentHTML('afterbegin', generateHeaderCategoryTable());
    tbl.insertAdjacentHTML('beforeend', generateBodyCategoryTable(data));
    tablePosition.appendChild(tbl);
}

function generateBodySupplierTable(data) {
    var body = "<tbody>%rows</tbody>";
    var numbers_of_phone = data['phone_numbers'].length;
    var rowspan = Object.keys(data).length + numbers_of_phone;
    var row = "<tr>";
    row += "<td style='width: 25%;' rowspan='" + rowspan + "'>Supplier</td>";
    row += "<td style='width: 20%;'>Name</td>";
    row += "<td style='width: 55%;'>" + data['name'] + "</td>";
    row += "</tr>";
    if (numbers_of_phone > 0) {
        row += "<tr>";
        row += "<td rowspan='" + numbers_of_phone + "'>Phone Numbers</td>";
        row += "<td>" + data['phone_numbers'][0]['phoneNumber'] + "</td>";
        row += "</tr>";
        data['phone_numbers'].splice(0, 1);
        for (var phoneNumber of data['phone_numbers']) {
            row += "<tr>";
            row += "<td>" + phoneNumber['phoneNumber'] + "</td>";
            row += "</tr>";
        }
    }
    row += "<tr>";
    row += "<td>Tax Code</td>";
    row += "<td>" + data['tax'] + "</td>";
    row += "</tr>";
    row += "<tr>";
    row += "<td>Address</td>";
    row += "<td>" + data['address'] + "</td>";
    row += "</tr>";
    row += "<tr>";
    row += "<td>Bank Account</td>";
    row += "<td>" + data['bank'] + "</td>";
    row += "</tr>";
    body = body.replace("%rows", row);
    return body;
}

function generatateSupplierTable(data) {
    var tablePosition = document.getElementById('table_supplier');
    tablePosition.innerHTML = '';
    var tbl = document.createElement('table');
    tbl.style.width = '100%';
    tbl.setAttribute('border', '1');
    tbl.insertAdjacentHTML('afterbegin', generateBodySupplierTable(data));
    tablePosition.appendChild(tbl);
}

$('#supplier').on('change', function() {
    var supplierId = $(this).val();
    $.ajax({
        type: "GET",
        url: "application/controller/category.php?get_categories=" + supplierId,
        success: function(data) {
            var response = JSON.parse(data);
            generatateSupplierTable(response['supplier']);
            generateCategoryTable(response['category']);
        }
    });
});

$(document).ready(function() {
    $.ajax({
        type: "GET",
        url: "application/controller/category.php?get_suppliers=true",
        success: function(data) {
            addSelectOptions(JSON.parse(data));
        }
    });
})