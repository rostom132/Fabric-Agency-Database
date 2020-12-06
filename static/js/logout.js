const logoutUrl = "./application/controller/logout.php";

$("#logout").click(function() {
    $.ajax({
        type: "GET",
        url: logoutUrl,
        context: document.body,
        data: { logout: true },
        success: function(responseText) {
            console.log(responseText);
            if(responseText == "OK") {
                window.location.replace(window.location.origin + "/Fabric-Agency-Database/");
            }
            else {
                alert("Error");
            }
        },
        async: true
        })
});