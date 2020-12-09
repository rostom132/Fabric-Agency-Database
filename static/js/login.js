const loginUrl = "./application/controller/login.php";
$("#Login_Btn_Submit").click(function() {
    login();
});
$(document).on('keypress',function(e) {
    if(e.which == 13) {
        login();
    }
});
function login() {
    let user = $("#Login_userName").val();
    let pass = $("#Login_passWord").val();
    $.ajax({
        type: "GET",
        url: loginUrl,
        context: document.body,
        data: { username: user, password: pass },
        success: function(responseText) {
            if(responseText == "Wrong") {
                alert("Wrong password");
            }
            else {
                window.location.replace(window.location.origin + window.location.pathname + 'transaction');
            }
        },
        async: true
        })
}