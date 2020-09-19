$(function(){
    var width = $(window).width();
    var height = $(window).height();
    var logo_src = $(".logo").attr("src");

    //ハンバーガーメニューの中身とfooterのアイコンを用意
    if (gon.user && width<=425) {
        var unread_number = gon.unread_number_user
        if (unread_number>100) {
            var unread_number = "99+"
        }
        else if (unread_number==0) {
            var unread_number = ""
        }
        modal_html =    `
                            <div class="res_menu">
                                <p class="res_tag color3">
                                    現在のポイント<br>${gon.point}pt
                                </p>
                                <p class="res_tag2">
                                    <a href="/favorites" class="color3">
                                        <span class="glyphicon glyphicon-heart-empty" aria-hidden="true"></span>
                                        お気に入り
                                    </a>
                                </p>
                                <p class="res_tag2">
                                    <a href="/users/1/edit" class="color3">
                                        <span class="glyphicon glyphicon-user" aria-hidden="true"></span>
                                        アカウント設定
                                    </a>
                                </p>
                                <p class="res_tag2">
                                    <a href="/user/logout" data-method="post" class="color3">
                                        <span class="glyphicon glyphicon-log-out" aria-hidden="true" style="margin-right: 5px;"></span>
                                        ログアウト
                                    </a>
                                </p>
                            </div>
                        `
        footer_menu =   `
                            <div class="footer_menu">
                                <div class="footer_menu_option">
                                    <a href="/search/top_hairdresser" data-method="post" class="color2">
                                        <div class="icon_size">
                                            <span class="glyphicon glyphicon-star" aria-hidden="true"></span>
                                        </div>
                                        人気美容師
                                    </a>
                                </div>
                                <div class="footer_menu_option">
                                    <a href="/hairdressers" class="color2">
                                        <div class="icon_size">
                                            <span class="glyphicon glyphicon-th-list" aria-hidden="true"></span>
                                        </div>
                                        美容師一覧
                                    </a>
                                </div>
                                <div class="footer_menu_option">
                                    <a href="/users/reservations" class="color2">
                                        <div class="icon_size">
                                            <span class="glyphicon glyphicon-file" aria-hidden="true"></span>
                                        </div>
                                        予約
                                    </a>
                                </div>
                                <div class="footer_menu_option">
                                    <a href="/user_chat" class="color2">
                                        <div class="icon_size">
                                            <span class="glyphicon glyphicon-user" aria-hidden="true"></span>
                                        </div>
                                        <div class="unread_number_header me">${unread_number}</div>
                                        チャット
                                    </a>
                                </div>
                            </div>
                        `
        $("body").append(footer_menu);
        
    } 
    else if (gon.hairdresser && width<425) {
        var unread_number = gon.unread_number_hairdresser
        if (unread_number>100) {
            var unread_number = "99+"
        }
        else if (unread_number==0) {
            var unread_number = ""
        }
        var notification_reservations_number = gon.notice_reservations_number
        if (notification_reservations_number>100) {
            var notification_reservations_number = "99+"
        }
        else if (notification_reservations_number==0) {
            var notification_reservations_number = ""
        }
        var cancel_number = gon.cancel_number
        if (cancel_number>100) {
            var cancel_number = "99+"
        }
        else if (cancel_number==0) {
            var cancel_number = ""
        }
        modal_html =    `
                            <div class="res_menu">
                                <p class="res_tag color3">
                                    現在の予約件数<br>${gon.reservations_number}件
                                </p>
                                <p class="res_tag2">
                                    <a href="/style_images/1/edit" class="color3">
                                        <span class="glyphicon glyphicon-camera" aria-hidden="true"></span>
                                        ヘアスタイル
                                    </a>
                                </p>
                                <p class="res_tag2">
                                    <a href="/hairdresser_comments" class="color3">
                                        <span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
                                        口コミ
                                    </a>
                                </p>
                                <p class="res_tag2">
                                    <a href="/hairdressers/calendar_index" class="color3">
                                        <span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
                                        予定表
                                    </a>
                                </p>
                                <p class="res_tag2">
                                    <a href="/hairdressers/1" class="color3">
                                        <span class="glyphicon glyphicon-home" aria-hidden="true"></span>
                                        マイページ
                                    </a>
                                </p>
                                <p class="res_tag2">
                                    <a href="/hairdressers/1/edit" class="color3">
                                        <span class="glyphicon glyphicon-user" aria-hidden="true"></span>
                                        アカウント設定
                                    </a>
                                </p>
                                <p class="res_tag2">
                                    <a href="/hairdresser/logout" data-method="post" class="color3">
                                        <span class="glyphicon glyphicon-log-out" aria-hidden="true" style="margin-right: 5px;"></span>
                                        ログアウト
                                    </a>
                                </p>
                            </div>
                        `
        footer_menu =   `
                            <div class="footer_menu">
                                <div class="footer_menu_option2">
                                    <a href="/menus/new" class="color2">
                                        <div class="icon_size">
                                            <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                        </div>
                                        メニュー作成
                                    </a>
                                </div>
                                <div class="footer_menu_option2">
                                    <a href="/menus" class="color2">
                                        <div class="icon_size">
                                            <span class="glyphicon glyphicon-th-list" aria-hidden="true"></span>
                                        </div>
                                        メニュー
                                    </a>
                                </div>
                                <div class="footer_menu_option2">
                                    <a href="/hairdressers/reservations" class="color2">
                                        <div class="icon_size">
                                            <span class="glyphicon glyphicon-file" aria-hidden="true"></span>
                                        </div>
                                        <div class="unread_number_header re res_re">${notification_reservations_number}</div>
                                        予約
                                    </a>
                                </div>
                                <div class="footer_menu_option2">
                                    <a href="/hairdressers/cancel_index" class="color2">
                                        <div class="icon_size">
                                            <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>
                                        </div>
                                        <div class="unread_number_header ca res_ca">${cancel_number}</div>
                                        キャンセル
                                    </a>
                                </div>
                                <div class="footer_menu_option2">
                                    <a href="/hairdresser_chat" class="color2">
                                        <div class="icon_size">
                                            <span class="glyphicon glyphicon-user" aria-hidden="true"></span>
                                        </div>
                                        <div class="unread_number_header me">${unread_number}</div>
                                        チャット
                                    </a>
                                </div>
                            </div>
                        `
        $("body").append(footer_menu);
    }
    else if (gon.admin && width<425) {
        modal_html =    `
                            <div class="res_menu">
                                <p class="res_tag2">
                                    <a rel="nofollow" data-method="post" href="/admins/logout" class="color3">
                                        <span class="glyphicon glyphicon-log-out" aria-hidden="true"></span>
                                        ログアウト
                                    </a>
                                </p>
                            </div>
                        `
        footer_menu =   `
                            <div class="footer_menu">
                                <div class="footer_menu_option">
                                    <a href="/admins/user_index" class="color2">
                                        <div class="icon_size">
                                            <span class="glyphicon glyphicon-align-justify" aria-hidden="true"></span>
                                        </div>
                                        会員
                                    </a>
                                </div>
                                <div class="footer_menu_option">
                                    <a href="/admins/hairdresser_index" class="color2">
                                        <div class="icon_size">
                                            <span class="glyphicon glyphicon-th-list" aria-hidden="true"></span>
                                        </div>
                                        美容師
                                    </a>
                                </div>
                                <div class="footer_menu_option">
                                    <a href="/admins/hairdresser_judge_index" class="color2">
                                        <div class="icon_size">
                                            <span class="glyphicon glyphicon-file" aria-hidden="true"></span>
                                        </div>
                                        承認待ち
                                    </a>
                                </div>
                                <div class="footer_menu_option">
                                    <a href="/admins/user_chart" class="color2">
                                        <div class="icon_size">
                                            <span class="glyphicon glyphicon-stats" aria-hidden="true"></span>
                                        </div>
                                        チャート
                                    </a>
                                </div>
                            </div>
                        `
        $("body").append(footer_menu);
    }
    else {
        modal_html = `
                        <div class="res_menu">
                            <p class="res_tag2">
                                <span id="new_user3" class="color3">
                                    <span class="glyphicon glyphicon-user" aria-hidden="true" style="margin-right: 5px;"></span>
                                    新規登録
                                </span>
                            </p>
                            <p class="res_tag2">
                                <span id="login_user3" class="color3">
                                    <span class="glyphicon glyphicon-log-in" aria-hidden="true" style="margin-right: 5px;"></span>
                                    ログイン
                                </span>
                            </p>
                            <p class="res_tag2">
                                <a href="/about" class="color3">
                                    <span class="glyphicon glyphicon-paperclip" aria-hidden="true"></span>
                                    ABOUT
                                </a>
                            </p>
                            <p class="res_tag2">
                                <a href="/about?faq=true" class="color3">
                                    <span class="glyphicon glyphicon-question-sign" aria-hidden="true"></span>
                                    FAQ
                                </a>
                            </p>
                            <p class="res_tag2">
                                <a rel="nofollow" data-method="post" href="/search/top_hairdresser" class="color3">
                                    <span class="glyphicon glyphicon-star" aria-hidden="true"></span>
                                    人気美容師
                                </a>
                            </p>
                            <p class="res_tag2">
                                <a href="/hairdressers" class="color3">
                                    <span class="glyphicon glyphicon-th-list" aria-hidden="true"></span>
                                    美容師一覧
                                </a>
                            </p>
                        </div>
                    `
    }

    //headerを用意
    if (gon.hairdresser) {
        header_html =   ` 
                            <header class="res_header center" style="">
                                <img src=${logo_src} class="res_logo" style="">
                                <a href="/hairdressers/1">
                                    <div class="link_box"></div> <!--本来ならここにロゴをセットするがロゴ画像の背景を削除できなくてロゴ周辺がリンクになってしまうため工夫するしかなかった-->
                                </a>
                                <div id="res_menu_btn">
                                    <span class="glyphicon glyphicon-align-justify" aria-hidden="true" style="margin-top: 12px; font-size: 25px;"></span>
                                </div>
                                <a class="res_salon" href="/hairdresser_top">サロンの方はこちら</a>
                                <div class="message_noti">
                                </div>
                            </header>
                        `
    }
    else {
        header_html =   ` 
                            <header class="res_header center" style="">
                                <img src=${logo_src} class="res_logo" style="">
                                <a href="/">
                                    <div class="link_box"></div> <!--本来ならここにロゴをセットするがロゴ画像の背景を削除できなくてロゴ周辺がリンクになってしまうため工夫するしかなかった-->
                                </a>
                                <div id="res_menu_btn">
                                    <span class="glyphicon glyphicon-align-justify" aria-hidden="true" style="margin-top: 12px; font-size: 25px;"></span>
                                </div>
                                <a class="res_salon" href="/hairdresser_top">サロンの方はこちら</a>
                                <div class="message_noti">
                                </div>
                            </header>
                        `
    }

    if (width<425) {
        $(".res_header").removeClass("fixed")
        $("body").prepend(header_html);
        var chat_members_height = height - 230 +5 +90
        $("#chat_members").css({
            "height":`${chat_members_height}`
        });
        if (gon.user || gon.hairdresser || gon.admin) {
            $(".res_salon").remove();
        }

        $('.bxslider_cut').bxSlider({
            slideWidth: 300,
            minSlides: 1,
            maxSlides: 1,
            moveSlides: 1,
            nextText: "",
            prevText: "",
            touchEnabled: true,
            infiniteLoop: true,
        });
        $('.bxslider_color').bxSlider({
            slideWidth: 300,
            minSlides: 1,
            maxSlides: 1,
            moveSlides: 1,
            nextText: "",
            prevText: "",
            touchEnabled: true,
            infiniteLoop: true,
        });
        $('.bxslider_parma').bxSlider({
            slideWidth: 300,
            minSlides: 1,
            maxSlides: 1,
            moveSlides: 1,
            nextText: "",
            prevText: "",
            touchEnabled: true,
            infiniteLoop: true,
        });
        $('.bxslider_curly').bxSlider({
            slideWidth: 300,
            minSlides: 1,
            maxSlides: 1,
            moveSlides: 1,
            nextText: "",
            prevText: "",
            touchEnabled: true,
            infiniteLoop: true,
        });
        
        //週間カレンダーをレスポンシブ
        var path = location.pathname
        if (path=="/users/set_week_calendar_reservation" || path=="/hairdressers/set_week_calendar_reservation" || path=="/hairdressers/calendar_index") {
            $(".table_maru_batu").eq(7).addClass("display_none");
            $(".table_maru_batu").eq(8).addClass("display_none");
            $(".table_maru_batu").eq(9).addClass("display_none");
            $(".table_maru_batu").eq(10).addClass("display_none");
            $(".table_maru_batu").eq(11).addClass("display_none");
            $(".table_maru_batu").eq(12).addClass("display_none");
            $(".table_maru_batu").eq(13).addClass("display_none");

            $(".date_top").children("th").eq(7).addClass("display_none");
            $(".date_top").children("th").eq(8).addClass("display_none");
            $(".date_top").children("th").eq(9).addClass("display_none");
            $(".date_top").children("th").eq(10).addClass("display_none");
            $(".date_top").children("th").eq(11).addClass("display_none");
            $(".date_top").children("th").eq(12).addClass("display_none");
            $(".date_top").children("th").eq(13).addClass("display_none");
            
            if ($(".height2").length==2) {
                if ($(".height2").eq(1).width()==33) {
                    $(".height2").eq(1).addClass("display_none");
                }
            }
        }

        //chat画面のレスポンシブ 高さを調整
        if (path=="/user_chat" || path=="/hairdresser_chat" || path=="/chat_room_search") {
            $("#yield").css({
                "min-height":"0",
                "height":"80vh"
            });
        }
        
        //スマホ画面では月間カレンダーは表示させない
        $(".to_month_calendar").addClass("display_none");

        //フラッシュ
        setTimeout(function(){
            $('#flash').fadeOut(); 
        },5000);  
       
        setTimeout(function(){
            $('#flash_red').fadeOut(); 
        },5000);    

    }

    // window.addEventListener( "resize", function () {
    //     var w = $(window).width();
    //     console.log(w);
    //     if (w<425) {
    //         //レスポンシブ用のheaderを用意
    //         if (!$(".res_header").length) {
    //             $("body").prepend(header_html);  
    //         }   
    //     }
    //     else {
    //         $(".res_header").remove();
    //         $(".res_menu").remove();
    //     }
    // });
});

$(function(){
    //ハンバーガーメニューを表示
    $(document).on("click", "#res_menu_btn", function(){ 
        if (!$(this).hasClass("res_active")) {
            $(this).addClass('res_active');
            $("body").prepend(modal_html);
            $(".res_menu").animate({'left':'0px'},500);
            $("#res_menu_btn").css({
                "position":"fixed"
            })
        }
        else {
            $(this).removeClass('res_active');
            $(".res_menu").animate({'left':'100vw'},500);
            setTimeout(function(){
                $(".res_menu").remove();
            },501); 
            $("#res_menu_btn").css({
                "position":""
            })
        }

    });
    
    //ログイン画面を表示
    $(document).on("click", "#new_user3", function(){ 
        $('#user_sign_up_modal').fadeIn();     
    });
    $(document).on("click", "#login_user3", function(){ 
        $('#user_sign_in').fadeIn();   
    });

});
