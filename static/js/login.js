const loginUrl = "./application/controller/login.php";
$("#Login_Btn_Submit").click(function() {
    let user = $("#Login_userName").val();
    let pass = $("#Login_passWord").val();
    $.ajax({
        type: "GET",
        url: loginUrl,
        context: document.body,
        data: { username: user, password: pass },
        success: function(responseText) {
            if (responseText == "Wrong") {
                alert("Wrong password");
            } else {
                window.location.replace(window.location.origin + '/Fabric-Agency-Database/transaction');
            }
        },
        async: true
    })
});