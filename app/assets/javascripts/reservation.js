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
    //console.log($(".td_color").children());
    $('.td_color').each(function(){
        if ($(this).find("p").hasClass("simbol_round")) {
            $(this).css({
                "background-color": "white"
            })
            $(this).addClass("hover_color");
        } 
        else if ($(this).find("p").hasClass("simbol_triangle")) {
            $(this).css({
                "background-color": "#CCCCCC"
            })
        } 
        else if ($(this).find("span").hasClass("simbol_remove")) {
            $(this).css({
                "background-color": "#EEEEEE"
            })
        } 
    });
    
    //マルをhoverしたとき
    $(".hover_color").hover(function(){
        $(this).css({
            "background-color": "red"
        })
    })
    $('.hover_color').hover(function(){
        $(this).css('background','pink');
        },function(){
        $(this).css('background','white');
    });

    // $('html').animate({
    //     'scrollTop': position - 300
    //   }, 1500);
    
    //$(window).scrollTop(300);
});


$(function() {
    //次の週をクリックした時点でのスクロール位置を取得してコントローラに送る
    $(".next_week").on("click", function(e) {
        //e.preventDefault();
        var win_height = $(window).scrollTop();
        var href = $(this).attr("href");        
        $(this).attr('href', `${href}&win_height=${win_height}`);
    });

    //前の週をクリックした時点でのスクロール位置を取得してコントローラに送る
    $(".last_week").on("click", function(e) {
        //e.preventDefault();
        var win_height = $(window).scrollTop();
        var href = $(this).attr("href");        
        $(this).attr('href', `${href}&win_height=${win_height}`);
    });

    if (gon.win_height) {
        $(window).scrollTop(gon.win_height);
    }
});