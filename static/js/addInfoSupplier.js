const submit_data_url = "application/controllers/registerSupplier.php";

let schedule_id = 1;
const MAX_PHONE_NUMBERS = 4;
const SUBMIT_PREFIX = "#registerSupplier-";

$("#schedule_add_btn").click(function() {
    var $free_time_length = $(SUBMIT_PREFIX + "schedule_container").children().length;
    if ($free_time_length === MAX_PHONE_NUMBERS) {
        alert("You can only add maximum of 4 phone numbers");
        return;
    }
    var $schedule_container = $("#registerSupplier-schedule_container");
    $schedule_container.append(`
    <div id="schedule_row_` + schedule_id + `"` + `class="group-row">
            <input id="registerSupplier-date_` + schedule_id + `"` + ` class="form__select date_select input_field" placeholder="Phone Number" required>
            </input>
        <button id="schedule_delete_icon_` + schedule_id + `"` + ` class="schedule_icon delete_icon"><i class="fa fa-trash" aria-hidden="true"></i></button>
    </div>
    `);
    schedule_id += 1;
})

function appendDeleteButton($id) {
    $("#schedule_row_" + $id).append(`<button id="schedule_delete_icon_` + $id + `"` + `class="schedule_icon delete_icon"><i class="fa fa-trash" aria-hidden="true"></i></button>`);
}

function removeDeleteButton($id) {
    $("#schedule_row_" + $id).children().last().remove();
}

function getDataOfSupplier() {
    var data = {};
    data['name'] = document.getElementById('input_name').value;
    data['address'] = document.getElementById('input_address').value;
    data['tax'] = document.getElementById('input_tax').value;
    data['bank_account'] = document.getElementById('input_account').value;
    data['phone_numbers'] = new Array();
    $('#registerSupplier-schedule_container').children().each(function() {
        data['phone_numbers'].push($(this).children('input').val());
    });

    return data;
}

$("#registerSupplier-schedule_container").on("click", ".delete_icon", function() {
    $(this).parent().remove();
})

$("#registerSupplier-submit-btn").on("click", function supply() {
    var inputInfoSupplier = getDataOfSupplier();
    var insertNewData = true;
    $.ajax({
        type: "GET",
        url: "application/controller/addInfoSupplier.php?name=" + inputInfoSupplier['name'],
        success: function(data) {
            if (data == "exist") {
                if (!confirm('This name is already exist! Do you want to insert it again?')) {
                    insertNewData = false;
                }
            }
        },
        async: false,
    });
    if (insertNewData) {
        $.ajax({
            type: "POST",
            url: "application/controller/addInfoSupplier.php",
            data: { inputSupplier: inputInfoSupplier },
            success: function(data) {
                alert(data);
                if (data == "success") {
                    window.location.replace(window.location.origin + "/Fabric-Agency-Database/category")
                }
            }
        });
    }
})