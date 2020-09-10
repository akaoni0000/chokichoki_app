//ページ読み込み時に発動
$(document).ready(function(){
	//フォームの画像選択は画像しか選べ内容する
    $("input").attr('accept', "image/*");
    
    if (gon.display_none == "remove_display_none") {
        $(".display_th").removeClass();
	}
	
    if (gon.faq) {
		var id = $(".faq_scroll").attr('href');      //id属性には#が入っている     
        var position = $(id).offset().top;  //topからの距離を取得
        $('html').animate({
            'scrollTop': position - 300
        }, 1500);
	}
 
    // パスの取得
    var path = location.pathname

    //今いるページのリンクを白くする
    $('a').each(function(){
		var href = $(this).attr('href');
		if (href == path) {
			$(this).css({
			"color": "#FAF0E6"
			})
		}
	});
	
    if (path == "/hairdressers" || path == "/strong_search") {
		$(".link_index").addClass("color3");
	}
	
	if (path == "/chat_room_search") {
		$(".link_chat").addClass("color3");
    }
    
    if (path == "/admins/hairdresser_chart") {
        $(".link_chart").addClass("color3");
    }

    if (path == "/admins/sell_chart") {
        $(".link_chart").addClass("color3");
    }


    // var path = location.pathname
    // if (path = "/hairdresser_top") {
    //     $('#flash').css({
    //         "color": "red"
    //     });
    // }

    // $("#name_hidden").hide();
})
