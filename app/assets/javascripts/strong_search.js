//検索するときの順番を変更
$(function() {
    if (gon.turn == 2) {
        $('.search_day').after($('.search_time'),$('.search_menu'));
        $(".search_none").removeClass("display_none");
    } 
    else if (gon.turn == 3) {
        $('.search_area').after($('.search_none'),$('.search_area_name'),$('.search_area_current_place'),$('.search_menu'),$(".search_day"),$(".search_time"));
        $("#name").addClass("check");
        $("#name").children("input").prop('checked', true);
        $(".search_area_name").removeClass("display_none");
    } 
    else if (gon.turn == 4) {
        $('.search_area').after($('.search_none'),$('.search_area_name'),$('.search_area_current_place'),$('.search_menu'),$(".search_day"),$(".search_time"));
        $("#current").addClass("check");
        $("#current").children("input").prop('checked', true);
        $(".search_area_current_place").removeClass("display_none");
    }
    else if (gon.turn == 5) {
        $('.search_reputation').after($('.search_menu'),$('.search_day'),$('.search_time'),$('.search_area'),$(".search_none"),$(".search_area_name"),$(".search_area_current_place"));
        $(".search_none").removeClass("display_none");
    }
    else if (gon.turn == 6) {
        $(".search_sex").after($('.search_menu'),$('.search_day'),$('.search_time'),$('.search_area'),$(".search_none"),$(".search_area_name"),$(".search_area_current_place"),$('.search_reputation'));
        $(".search_none").removeClass("display_none");
    }
    else {
        $(".search_none").removeClass("display_none");
    }
});

//検索フォーム画面のメニュー選択のcheck_boxを操作
$(function() {
    $(".point").click(function(){
        if (!$(this).hasClass("check")) {
        $(this).addClass("check");
        $(this).children("input").prop('checked', true);
        } else if ($(this).hasClass("check")) {
        $(this).removeClass("check");
        $(this).children("input").prop('checked', false);
        }
    });
});

//検索フォーム画面の日付のselectを操作
$(function() {
    $("#day").change(function(){
        var select_day = $(this).val();
        if (select_day == "指定しない") {
        $("#start_time").attr('disabled', true);
        $("#finish_time").attr('disabled', true);
        } else {
        $("#start_time").attr('disabled', false);
        $("#finish_time").attr('disabled', false);
        }
    });

    $("#start_time").change(function(){
        $("#finish_time").children("option").attr("disabled", false)
        start_number = $(this).prop("selectedIndex");  //selectボックスで何番目のoptionが選択されているかを取得
        $("#finish_time").children("option").slice(0, start_number).attr("disabled", true)
    });

    $("#finish_time").change(function(){
        $("#start_time").children("option").attr("disabled", false)
        finish_number = $(this).prop("selectedIndex");  //selectボックスで何番目のoptionが選択されているかを取得
        $("#start_time").children("option").slice(finish_number+1, ).attr("disabled", true)
    });
});

//検索フォーム画面のエリアのcheck_boxを操作
$(function() {
    $("#name").click(function(){
        if (!$(this).hasClass("check")) {
        $(this).addClass("check");
        $(this).children("input").prop('checked', true);
        $("#current").removeClass("check");
        $("#current").children("input").prop('checked', false);
        $(".search_area_name").removeClass("display_none");
        $(".search_area_current_place").addClass("display_none");
        $(".search_none").addClass("display_none");
        } else if ($(this).hasClass("check")) {
        $(this).removeClass("check");
        $(this).children("input").prop('checked', false);
        $(".search_area_name").addClass("display_none");
        $(".search_none").removeClass("display_none");
        }
    });

    $("#current").click(function(){
        if (!$(this).hasClass("check")) {
        $(this).addClass("check");
        $(this).children("input").prop('checked', true);
        $("#name").removeClass("check");
        $("#name").children("input").prop('checked', false);
        $(".search_area_current_place").removeClass("display_none");
        $(".search_area_name").addClass("display_none");
        $(".search_none").addClass("display_none");
        } else if ($(this).hasClass("check")) {
        $(this).removeClass("check");
        $(this).children("input").prop('checked', false);
        $(".search_area_current_place").addClass("display_none");
        $(".search_none").removeClass("display_none");
        }
    });
});


//検索フォーム画面の評価選択のselectを操作
$(function() {
    $("#start_rate").change(function(){
        $("#finish_rate").children("option").attr("disabled", false)
        start_rate = $(this).prop("selectedIndex");  //selectボックスで何番目のoptionが選択されているかを取得
        $("#finish_rate").children("option").slice(0, start_rate).attr("disabled", true)
    });

    $("#finish_rate").change(function(){
        $("#start_rate").children("option").attr("disabled", false)
        finish_rate = $(this).prop("selectedIndex");  //selectボックスで何番目のoptionが選択されているかを取得
        $("#start_rate").children("option").slice(finish_rate+1, ).attr("disabled", true)
    });
});

//性別選択の操作
$(function() {
    $(".man").click(function(){
        if ($(this).hasClass("check")) {
        $(this).removeClass("check");
        $(this).children("input").prop('checked', false);
        } else {
        $(this).addClass("check");
        $(this).children("input").prop('checked', true);
        $(".woman").removeClass("check");
        }
    });

    $(".woman").click(function(){
        if ($(this).hasClass("check")) {
        $(this).removeClass("check");
        $(this).children("input").prop('checked', false);
        } else {
        $(this).addClass("check");
        $(this).children("input").prop('checked', true);
        $(".man").removeClass("check");
        }
    });
});