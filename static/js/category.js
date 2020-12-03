function addSelectOptions(selectValues) {
    $.each(selectValues, function(key, value) {
        var $option = $("<option>", {
            value: value['ID'],
            text: value['Name']
        });
        $('#supplier').append(new Option(value['Name'], value['ID'],));
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
function newRowForCategoryTable(data) {

}
function generateBodyCategoryTable() {

}

function generateCategoryTable() {
    var tablePosition = document.getElementById('table_category');
    var tbl = document.createElement('table');
    tbl.style.width = '100%';
    tbl.setAttribute('border', '1');
    tbl.insertAdjacentHTML('afterbegin',generateHeaderCategoryTable());
    tablePosition.appendChild(tbl);
}

$('#supplier').on('change', function() {
    var supplierId = $(this).val();
    $.ajax({
        type: "GET",
        url: "application/controller/category.php?get_categories=" + supplierId,
        success: function(data) {
            console.log(data);
            // addSelectOptions(JSON.parse(data));
        }
    });
});

$(document).ready(function(){
    $.ajax({
        type: "GET",
        url: "application/controller/category.php?get_suppliers=true",
        success: function(data) {
            addSelectOptions(JSON.parse(data));
        }
    });
    generateCategoryTable();
})

// var selectValues = {
//     "1": "test 1",
//     "2": "test 2"
// };
// addSelectOptions(selectValues);