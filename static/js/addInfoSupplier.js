const textField = ["topic", "salary_per_lesson", "no_students", "address", "phone_number", "description"];
const selectField = ["district", "ward", "street", "schedule_container"];
const radioField = ["no_lesson_per_week", "time_per_lesson", "gender_of_tutor"];
const magicField = ["subject"];

const get_subject_url = "application/controllers/registerClass.php?get_subject_db=true";
const submit_data_url = "application/controllers/registerClass.php";

let schedule_id = 1;
let editMode = 0;
const START_TIME_MAX = "20:00:00";

const SUBMIT_PREFIX = "#registerClass-";
const DATE_PREFIX = "#registerClass-date_";

var magicSelect;

$("#schedule_add_btn").click(function() {
    var $free_time_length = $(SUBMIT_PREFIX + "schedule_container").children().length;
    console.log($free_time_length);
    if ($free_time_length === 4) {
        alert("You can only add maximum of 4 phone numbers");
        return;
    }
    var $schedule_container = $("#registerClass-schedule_container");
    $schedule_container.append(`
    <div id="schedule_row_` + schedule_id + `"` + `class="group-row">
            <input id="registerClass-date_` + schedule_id + `"` + ` class="form__select date_select" placeholder="Phone Number" required>
            </input>
        <button id="schedule_delete_icon_` + schedule_id + `"` + ` class="schedule_icon delete_icon"><i class="fa fa-trash" aria-hidden="true"></i></button>
    </div>
    `);
    schedule_id += 1;
})


// function checkNotEmpty($id) {
//     var $check_date = $(DATE_PREFIX + $id).find("option:selected").val();
//     if ($check_date !== "") {
//         return 0;
//     } else return -1;
// }

function appendDeleteButton($id) {
    $("#schedule_row_" + $id).append(`<button id="schedule_delete_icon_` + $id + `"` + `class="schedule_icon delete_icon"><i class="fa fa-trash" aria-hidden="true"></i></button>`);
}

function removeDeleteButton($id) {
    $("#schedule_row_" + $id).children().last().remove();
}


$("#registerClass-schedule_container").on("click", ".delete_icon", function() {
    var $current_id = $(this).attr("id").split("_")[3];
    console.log($current_id + " " + typeof $current_id);
    if (editMode === 1) {
        // Reset state
        var $add_bnt = $("#schedule_add_btn");
        $add_bnt.prop("disabled", false);
        $add_bnt.removeClass("disable");
        // changeFieldState($current_id, true);
        editMode = 0;
    }
    $(this).parent().remove();
})

// function changeFieldState($schedule_row_id, status) {
//     $(DATE_PREFIX + $schedule_row_id).prop("disabled", status);
// }