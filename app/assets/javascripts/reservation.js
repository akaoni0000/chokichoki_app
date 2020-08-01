$(function() {
    $(".function").click(function(){
        //すでに予約を作成してあるマル(時刻)をクリックした時
        if ($(this).find("div").size()) {
            $(this).html("<span class='glyphicon glyphicon-remove' aria-hidden='true'></span><a></a>");
            var reservation_time = $(this).attr('href');
            $("#hairdresser_reservation_form").append(`<input type="hidden" name="start_time_remove[]" value=${reservation_time} class="${reservation_time}"></input>`);
        }
        //すでに予約を作成してあるバツ(時刻)をクリックした時
        else if ($(this).find("a").size()) {
            $(this).html("<p style='color: red;'>◎</p><div></div>");
            var reservation_time = $(this).attr('href');
            $("#hairdresser_reservation_form").find(`.${reservation_time}`).remove();
        }

        //予約を作成してないバツ(時刻)をクリックした時
        else if (!$(this).find("p").size()) {
            $(this).html("<p style='color: red;'>◎</p>");
            var reservation_time = $(this).attr('href');
            $("#hairdresser_reservation_form").append(`<input type="hidden" name="start_time[]" value=${reservation_time} class="${reservation_time}"></input>`);
        }
        //予約を作成してないマル(時刻)をクリックした時
        else {
            $(this).html("<span class='glyphicon glyphicon-remove' aria-hidden='true'></span>");
            var reservation_time = $(this).attr('href');
            $("#hairdresser_reservation_form").find(`.${reservation_time}`).remove();
        }
    })
});


$(function() {
    if (gon.thead_fix == true) {
        var win = $(window);
    //     $(".container").click(function(){
    //     console.log(win.scrollTop());
    // })
        $(window).scroll(function (){
            var height = $(".week_reservation_table").offset().top;
            if (win.scrollTop()>=height) {
                $("thead").css({
                    //"position": "absolute",
                    "position": "fixed",
                    "top": "0px",
                    "left": "107px",
                    "z-index": 99,
                    "background-color": "rgba(247, 247, 247, 1.0)",
                    "border": "solid 1px  #BFB9B0; border-collapse: collapse"
                })
                $(".attr87").css({
                    "border-left": "solid 1px #BFB9B0",
                    "border-bottom": "solid 1px #BFB9B0",
                    "border-right": "solid 1px #BFB9B0"
                })
                $(".attr87").attr({"href": 81});
                $(".attr87").attr({'width': 81});
                $(".attr43").attr({'width': 43});
                $(".attr42").attr({'width': 42});
                // $("tbody").css({
                    
                    
                // })
            } 
            else if (win.scrollTop()<416) {
                $("thead").css("position", "");
                $("thead").css("background-color", "");
            }
        });
    }
    
});


// $('html').animate({
//     'scrollTop': position - 300
//   }, 1500);