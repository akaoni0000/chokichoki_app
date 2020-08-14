$(function() {
    $(".message_btn").on("click", function(e) {
        var message = $(".chat_form").val();
        if (!$("#message_form_area").find("input").hasClass("hidden_room") || message=="") {
            e.preventDefault();
            $("#button").prop("disabled", true);
        } 
    });
});

// $(function() {
//     var message = $(".chat_form").val();
//         if (!$("#message_form_area").find("input").hasClass("hidden_room") || message=="") {
//             $(".message_btn").prop("disabled", true);
//         }  
// }); 
// height = $(document).height()
// $("#room-1").scrollTop(height);