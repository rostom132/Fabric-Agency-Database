var $mySelect = $('#providers');

function addSelectOptions(selectValues) {
    $.each(selectValues, function(key, value) {
        var $option = $("<option/>", {
            value: key,
            text: value
        });
        $mySelect.append($option);
    });
}


// var selectValues = {
//     "1": "test 1",
//     "2": "test 2"
// };
// addSelectOptions(selectValues);