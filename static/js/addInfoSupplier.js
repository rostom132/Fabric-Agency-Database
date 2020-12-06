const submit_data_url = "application/controllers/registerSupplier.php";

let schedule_id = 1;
const MAX_PHONE_NUMBERS = 4;
const SUBMIT_PREFIX = "#registerSupplier-";

$("#schedule_add_btn").click(function() {
    var $free_time_length = $(SUBMIT_PREFIX + "schedule_container").children().length;
    console.log($free_time_length);
    if ($free_time_length === MAX_PHONE_NUMBERS) {
        alert("You can only add maximum of 4 phone numbers");
        return;
    }
    var $schedule_container = $("#registerSupplier-schedule_container");
    $schedule_container.append(`
    <div id="schedule_row_` + schedule_id + `"` + `class="group-row">
            <input id="registerSupplier-date_` + schedule_id + `"` + ` class="form__select date_select" placeholder="Phone Number" required>
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


$("#registerSupplier-schedule_container").on("click", ".delete_icon", function() {
    var $current_id = $(this).attr("id").split("_")[3];
    console.log($current_id + " " + typeof $current_id);
    $(this).parent().remove();
})