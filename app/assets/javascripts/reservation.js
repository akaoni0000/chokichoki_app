//css
$(function() {
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
        else if ($(this).find("p").hasClass("simbol_remove")) {
            $(this).css({
                "background-color": "#EEEEEE"
            })
        } 
        else if ($(this).find("p").hasClass("simbol_exist_reservation")) {
            $(this).css({
                "background-color": "#99CCFF"
            })
        } 
    });

    //偶数番目 奇数番目でcssをわける
    $(".times").each(function(){
        $('.times tr:odd').children("th").addClass("small_time");
        $('.times tr:even').children("th").addClass("big_time");
    });

    //偶数番目 奇数番目でcssをわける
    $(".simbols").each(function(){
        $('.simbols tr:odd').children("td").addClass("border_bottom2");
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
});

//マル、バツをクリックした時 発動
$(function() {
    $(".function").click(function(){
        //すでに予約を作成してあるマル(時刻)をクリックした時
        if ($(this).children().hasClass("exist_reservation")) {
            $(this).html("<p class='glyphicon glyphicon-remove simbol_remove remove_exist_reservation' aria-hidden='true'></p>");
            var reservation_time = $(this).attr('href');
            var reservation_time_num = $(this).attr('id');
            $("#hairdresser_reservation_form").append(`<input type="hidden" name="start_time_remove[]" value="${reservation_time}" class="${reservation_time_num}" readonly>`);
        }
        //すでに予約を作成してあるバツ(時刻)をクリックした時
        else if ($(this).children().hasClass("remove_exist_reservation")) {
            $(this).html("<p style='color: red;' class='simbol_round exist_reservation'>◎</p>");
            var reservation_time = $(this).attr('href');
            var reservation_time_num = $(this).attr('id');
            $("#hairdresser_reservation_form").find(`.${reservation_time_num}`).remove();
        }

        //予約を作成してないバツ(時刻)をクリックした時
        else if ($(this).children().hasClass("not_reservation")) {
            $(this).html("<p style='color: red;' class='simbol_round remove_not_reservation'>◎</p>");
            var reservation_time = $(this).attr('href');
            var reservation_time_num = $(this).attr('id');
            $("#hairdresser_reservation_form").append(`<input type="hidden" name="start_time[]" value="${reservation_time}" class="${reservation_time_num}" readonly>`);
        }
        //予約を作成してないマル(時刻)をクリックした時
        else if ($(this).children().hasClass("remove_not_reservation")) {
            $(this).html("<p class='glyphicon glyphicon-remove simbol_remove not_reservation' aria-hidden='true'></p>");
            var reservation_time = $(this).attr('href');
            var reservation_time_num = $(this).attr('id');
            $("#hairdresser_reservation_form").find(`.${reservation_time_num}`).remove();
        }
    })
});

//次の月、前の月、次の週、前の週のlinkをクリックした時、発動
$(function() {
    $(".link_last_next").on("click", function(e) {
        var a = $("#hairdresser_reservation_form").children().length;
        if ( a >= 6 ) {
            if(confirm('変更は破棄されます。よろしいですか？')){
                //OKの時の処理
            }else{
                //キャンセルの時の処理
                e.preventDefault();
                $(this).hover(function(){
                    $(this).css('color','#CC9933');
                }, function(){
                    $(this).css('color','#DEB887');
                })
            }
        } 
        var win_height = $(window).scrollTop();
        var href = $(this).attr("href");  
        $(this).attr('href', `${href}&win_height=${win_height}`);
    });

    //変更を保存するをクリック
    $(".change_form").on("click", function(e) {
        var win_height = $(window).scrollTop();
        $("#hairdresser_reservation_form").append(`<input type="hidden" name="win_height" value=${win_height}></input>`)
    });

    if (gon.win_height) {
        $(window).scrollTop(gon.win_height);
    }

    if (gon.scroll) {
        $(window).scrollTop(500);
    }
});

//会員ログインしないで予約をすることを防ぐ
$(function() { //このfunctionのifはページをロードした瞬間に働くのでフロントでgon.userを足しても大丈夫
    if (!gon.user) {
        $(".user_reservation").on("click", function(e) {
            e.preventDefault();
            var reservation_id = $(this).attr("id"); 
            $('#user_sign_in').fadeIn();
            $(".user_login_error").text("ログインする必要があります");
            $("#user_login_form").append(`<input type="hidden" name="reservation_id" value=${reservation_id}></input>`)
        });
    }
});
