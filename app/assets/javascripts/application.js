// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets1sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require js.cookie
//= require jquery.jposta
//= require bootstrap-sprockets
//= require activestorage
//= require jquery.raty
//= require gmaps/google
// require turbolinks
//= require_tree .

//turbolinksがあるとjsが発動しないことがあるので消した

//フラッシュ 5秒たつと消える
$(function() {
    if ($("body").find("div").attr("id")=="flash") { //緑のフラッシュ
        setTimeout(function(){
            $('#flash').fadeOut(); 
        },5000);  
    }
    if ($("body").find("div").attr("id")=="flash_red") { //赤のフラッシュ
        setTimeout(function(){
            $('#flash_red').fadeOut(); 
        },5000);  
    }
    //位置を調整
    if ($("p").hasClass("propaganda")) {
        $('#flash').css({
            "margin-top": "-54px"
        });
    }

    //スマホの時
    var width = $(window).width();
    if ($("p").hasClass("propaganda") && width<=425) {
        $('#flash').css({
            "margin-top": "0px"
        });
    }
});

//二重ログイン防止 userとhairdresserの同時ログインはできない
$(function(){
    if (gon.double == true) {
        alert("二重ログインは禁止されています。ログイン情報をリセットしました。")
        $("#flash").addClass("display_none");
    }
});

//メール再送信の連打防止
$(function(){
    $(document).on("click", "#resend", function() { 
        $(".resend")[0].click(); 
        $(".resend").prop('disabled',true);//ボタンを無効化する
    });
});

//bxslider内でのリンク
$(function(){
    $(document).on("click", ".link_re", function() { 
        $(this)[0].click(); 
    });
    $(document).on("click", ".link_hairdresser_show_modal", function() { 
        $(this)[0].click(); 
    });
});

// //idをつける
// $(function(){
//     $("#star").children("input").attr("id", "star_form");
// });


//kaminari のviewを調整 ページが2のとき1の色が見えづらくなっているのが嫌だった
$(function(){
    if (gon.kaminari) {
        $("a").attr('style', '');
    }
});

//userのページを消す
$(function(){
    $("body").click(function(){
        $(".user_options").remove();
    });
});

//モーダル系
$(function() {
    //userの新規会員登録を押した時モーダル出現
    $('#new_user, #new_user2, #new_user3').click(function() {
        $('#user_sign_up_modal').fadeIn();     
    });

    //userログインを押した時モーダル出現
    $('#login_user, #login_user2').click(function() {
        $('#user_sign_in').fadeIn();      
    });
    
    //userのメールアドレスで登録をクリック
    $("#link_user_sign_up").click(function(){
        $('.back_dark').eq(0).hide();
        $(".back_dark").eq(1).show();
    });
    
    //userのログインの方はこちらをクリック
    $(".link_user_sign_in").click(function(){
        $('.back_dark').eq(0).hide();
        $('.back_dark').eq(1).hide();
        $('.back_dark').eq(3).hide();

        $(".back_dark").eq(2).show();
    });
    
    //userの登録の方はこちらをクリック
    $(".link_user_sign_up").click(function(){
        $('.back_dark').eq(2).hide();
        $('.back_dark').eq(3).hide();

        $(".back_dark").eq(0).show();
    });

    //userのパスワードを忘れた方はこちらをクリック
    $("#link_user_password_reset").click(function(){
        $('.back_dark').eq(2).hide();

        $(".back_dark").eq(3).show();
    });
    
    //エラー表示をなくす
    $("#link_user_sign_up, .link_user_sign_in, .link_user_sign_up, #link_user_password_reset").click(function(){
        $('.error').html(""); //エラー文を削除
        $(".form-control").css({ //エラー文によって枠が赤くなったところを戻す
            "border": "1px solid #ccc"
        });
    });
    
    //美容師の新規登録を押すとモーダル出現
    $('#new_hairdresser, #new_hairdresser2').click(function() {
        $('#hairdresser_sign_up').fadeIn();     
    });

    //美容師ログインを押すとモーダル出現
    $('#login_hairdresser, #login_hairdresser2').click(function() {
        $('#hairdresser_sign_in').fadeIn();      
    });

    //hairdressersのログインの方はこちらをクリック
    $(".link_hairdresser_sign_in").click(function(){
        $('.back_dark').eq(4).hide();
        $('.back_dark').eq(6).hide();

        $(".back_dark").eq(5).show();
    });
    
    //hairdresserの登録の方はこちらをクリック
    $(".link_hairdresser_sign_up").click(function(){
        $('.back_dark').eq(5).hide();
        $('.back_dark').eq(6).hide();

        $(".back_dark").eq(4).show();
    });
    
    //hairdresserのパスワードを忘れた方はこちらをクリック
    $(".link_hairdresser_password_reset").click(function(){
        $('.back_dark').eq(5).hide();

        $(".back_dark").eq(6).show();
    });
    
    //エラー表示をなくす
    $(".link_hairdresser_sign_up, .link_hairdresser_sign_in, .link_hairdresser_password_reset").click(function(){
        $('.error').html(""); //エラー文を削除
        $(".form-control").css({ //エラー文によって枠が赤くなったところを戻す
            "border": "1px solid #ccc"
        });
    });

    //ご希望ありをクリックする
    $(document).on("click", ".user_hope", function () { 
        $(this).next("div").fadeIn(); 
    });
    
    //バツアイコンでモーダルを閉じる
    $(document).on("click", ".glyphicon-remove", function(){ 
        $('.back_dark').fadeOut();
        setTimeout(function(){
            $('.error').html(""); 
            $("input").css({
                "border-width":"0px"
            });
            $(".form-control").css({
                "border": "1px solid #ccc"
            })
            $(".number_form").css({
                "border": "1px solid #ccc"
            })
        },1000);
        $('body').removeClass("no_scroll");
    });

    //FAQ
    $('.question').click(function() {
        if($(this).next().hasClass('open')) { 
            $(this).next().removeClass("open");
            $(this).next().slideUp(); 
        } 
        else {
            $(this).next().addClass('open'); 
            $(this).next().slideDown(); 
        }
    });

  　//ナビゲーション スクロール
    // $('.scroll-btn').click(function(){
    //     var id = $(this).attr('href');      //id属性には#が入っている     
    //     var position = $(id).offset().top;  //topからの距離を取得
    //     $('html').animate({
    //     'scrollTop': position - 300
    //     }, 1500);
    // });
});



//スクロールでアニメーション
$(function(){
  $(window).scroll(function (){
      $('.fadein').each(function(){            //fadeinクラスすべて順番に
          var position = $(this).offset().top; //上からfadeinクラスまでの距離
          var scroll = $(window).scrollTop();     //上からスクロールした距離
          var windowHeight = $(window).height();  //画面の高さ
          if (scroll > position - windowHeight + 190){  //図を書くと理解できる
            $(this).addClass('active');
          }
      });
  });
});



//gonを使った時
$(function(){
    //user_topの時だけヘッダーを固定
    var width = $(window).width();
    if (gon.fix == "header" && 426<=width) {
        $("header").addClass("fixed");
        $(".logo").css({
            "top": "-45px"
        })
    }

    //hairdresser_topの時だけヘッダーをなくす
    if (gon.display_none) {
        $("header").addClass("display_none")
    }

    //背景色を変更
    if (gon.body == "white"){
        $("body").css({
            "background-color":"white"
        });
        $("#yield").css({
            "background-color":"white"
        });
    }

    //出現させる
    if (gon.display_none == "remove_display_none") {
        $(".display_th").removeClass();
	}
    
    //FAQまでスクロールさせる ナビゲーション
    if (gon.faq) {
		var id = $(".faq_scroll").attr('href');      //id属性には#が入っている     
        var position = $(id).offset().top;  //topからの距離を取得
        $('html').animate({
            'scrollTop': position - 300
        }, 1500);
	}
})

//郵便番号入力で住所自動入力
// $(function() {
//     $(window).ready(function() {
//         alert("fdada")
//         $("#hairdresser_post_number").jpostal({
//             postcode: ["#hairdresser_post_number"],
//             address: {
//                 "#hairdresser_address": "%3%4%5"
//             }
//         });
//     });
// });
$(function () {
	$('#hairdresser_post_number').jpostal({
		postcode : [
			'#hairdresser_post_number'
		],
		address : {
			'#hairdresser_address' : '%3%4%5'
		}
	});
});

//画像プレビュー表示
$(function () {
    //宣材写真
    $(document).on("change", "#hairdresser_img", function () { 
        var input = $(this)
        var reader = new FileReader();   //filereaderを起動
        reader.readAsDataURL(this.files[0]);  //最初の写真を読み込む
        reader.onload = function (e) {        //読み込み終わったら発火
        $('#prev_img').attr('src', e.target.result);
        $(".img_save").empty();
        input.appendTo(".img_save");
        $(".hairdresser_label").append('<input id="hairdresser_img" class="hidden" type="file" name="hairdresser[hairdresser_image]">');
        }
    });
    
    //宣材写真を削除した時
    $(".img_delete").click(function(){
        $("#prev_img").remove();
        $(".hairdresser_label").append('<img src="/assets/no_image-1d7230a86ae81ad3d79bc59c93ae5633d4560e4cfe469a82eb1a0fae86d27bee.png" alt="" id="prev_img" style="width: 150px; height: 150px; border-radius: 20px;"></img>');
        $(".img_save").empty();
    });

    //免許証
    $(document).on("change", "#confirm_img", function () { 
        var input = $(this)
        var reader = new FileReader();
        reader.readAsDataURL(this.files[0]);
        reader.onload = function (e) {
        $('#prev_img2').attr('src', e.target.result);
        $(".img_save2").empty();
        input.appendTo(".img_save2");
        $(".confirm_label").append('<input id="confirm_img" class="hidden" type="file" name="hairdresser[confirm_image]">');
        $(".confirm_label").removeClass("exist_img")
        $(".confirm_label").addClass("exist_img")
        }
    });

    //免許証を削除した時
    $(".img_delete2").click(function(){
        $("#prev_img2").remove();
        $(".confirm_label").append('<img src="/assets/no_image-1d7230a86ae81ad3d79bc59c93ae5633d4560e4cfe469a82eb1a0fae86d27bee.png" alt="" id="prev_img2" style="width: 150px; height: 150px; border-radius: 20px;"></img>');
        $(".img_save2").empty();
        $(".confirm_label").removeClass("exist_img");
    });
});

//userの予約確定するかどうかページ
$(function() {
    $(".point_check").click(function(){
        if ($(this).children(".checkbox").hasClass("check")) {
            $(this).children(".checkbox").removeClass("check");
            $(this).children(".checkbox").prop('checked', false); 
        } else {
            $('.checkbox').prop('checked', false);  
            $('.checkbox').removeClass('check'); 
            $(this).children(".checkbox").addClass("check");
            $(this).children(".checkbox").prop('checked', true);
        }
    });

    $(".card_check").click(function(){
        console.log(2);
        if ($(this).children(".checkbox").hasClass("check")) {
            $(this).children(".checkbox").removeClass("check");
            $(this).children(".checkbox").prop('checked', false);
        } else {
            $('.checkbox').prop('checked', false);  
            $('.checkbox').removeClass('check'); 
            $(this).children(".checkbox").addClass("check");
            $(this).children(".checkbox").prop('checked', true);  
        }
    });

    $(".registered_card_check").click(function(){
        console.log(3);
        if ($(this).children(".checkbox").hasClass("check")) {
            $(this).children(".checkbox").removeClass("check");
            $(this).children(".checkbox").prop('checked', false);
        } else {
            $('.checkbox').prop('checked', false);  
            $('.checkbox').removeClass('check'); 
            $(this).children(".checkbox").addClass("check");
            $(this).children(".checkbox").prop('checked', true);  
        }
    });
});

//menu投稿画面
$(function(){
    $(document).on("change", "#menu_img", function () { 
        var input = $(this)
        var reader = new FileReader();   //filereaderを起動
        reader.readAsDataURL(this.files[0]);  //最初の写真を読み込む
        reader.onload = function (e) {        //読み込み終わったら発火
        $('#prev_menu_img').attr('src', e.target.result);
        $(".menu_img_save").empty();
        input.appendTo(".menu_img_save");
        $(".label_menu_img").append('<input id="menu_img" class="hidden" type="file" accept= "image/*" name="menu[menu_image]" >');
        }
    });

    //titile
    $(".menu_name").keyup(function(){
        var menu_name = $(this).val();
        $(".title").html(menu_name);
    })

    $(".menu_explanation").keyup(function(){
        var menu_explanation = $(this).val();
        $(".explain").html(menu_explanation);
    })

    //menu施術時間
    $("#menu_time").change(function(){
        var time = $(this).val();
        $(".menu_time").html(time+"分");
    });

    //メニューカテゴリー $(this).children(".checkbox").prop('checked', true);
    $(".category1").click(function(){
        if ($(this).hasClass("check")) {
            $(this).removeClass("check");
            $(this).children("input").prop('checked', false);
            $(".cut_category").html("");
        } else {
            $(this).addClass("check");
            $(this).children("input").prop('checked', true);
            $(".cut_category").html("カット");
        }
    });

    $(".category2").click(function(){
        if ($(this).hasClass("check")) {
            $(this).removeClass("check");
            $(this).children("input").prop('checked', false);
            $(".color_category").html("");
        } else {
            $(this).addClass("check");
            $(this).children("input").prop('checked', true);
            $(".color_category").html("カラー");
        }
    });

    $(".category3").click(function(){
        if ($(this).hasClass("check")) {
            $(this).removeClass("check");
            $(this).children("input").prop('checked', false);
            $(".curly_category").html("");
        } else {
            $(this).addClass("check");
            $(this).children("input").prop('checked', true);
            $(".curly_category").html("縮毛矯正");
        }
    });

    $(".category4").click(function(){
        if ($(this).hasClass("check")) {
            $(this).removeClass("check");
            $(this).children("input").prop('checked', false);
            $(".perm_category").html("");
        } else {
            $(this).addClass("check");
            $(this).children("input").prop('checked', true);
            $(".perm_category").html("パーマ");
        }
    });
});


//userのマイページ
$(function() {
    $(document).on("click", ".cancel_fail", function () {  
        console.log(1);
        alert("予約日から24時間以内なのでこのサイトからキャンセルできません。直接、担当美容師にお問い合わせください");
    });
});

$(function() {
    $('.form_close_modal').click(function() { 
        $('.card_modal').fadeOut();     
    });
});

$(function() {
    $("a").click(function () { 
    
        $(this).css({
        "text-decoration":"none",
        "color": "black"
        });
        $(".hairdresser_tag").css({
        "text-decoration":"none",
        "color": "#DEB887" 
        });
        $(".cursor").css({
        "text-decoration":"none"
        });
        $(".reservation_hairdresser_name").css({
        "text-decoration":"none"
        });
        $(".decoration_none").css({
        "text-decoration":"none",
        "color": "#DEB887" 
        });
    });
  
});

//pay.jp  クレジットカード登録 決済
// $(function() {
//     //gon.keyはpay.jpの公開鍵 環境変数はjsでは使えなかった
//     Payjp.setPublicKey(gon.key);

//     $(document).on("click", "#token_submit", function (e) {  
//         e.preventDefault();
//         var card = {
//             number: $("#card_number").val(),
//             exp_month: $("#exp_month").val(),
//             exp_year: $("#exp_year").val(),
//             cvc: $("#cvc").val()
//         };
//         var number = $("#card_number").val();
//         var user_request = $(".request").val();
//         if(number != 4242424242424242) {
//             alert("カード番号は4242424242424242と入力してください。このサイトではこのテストコードでしか決済できません。")
//         }
//         //createToken でトークンを申込を発行してpayjp側に送る => payjp側でトークンが作成されresponseでpayjp側で作成されたトークンが帰ってくる　作成されない可能性もある　トークンが作成されるだけで保存はされていない statusはトークンが作成されたかどうか200は成功
//         Payjp.createToken(card, function(status, response) {
//             if (status === 200) {                    
//                 $("#card_number").removeAttr("name");  //card_numberの値はコントローラーに送らなくていい  Payjp.createToken(card...  のcardでpayjp側にデータが送られている
//                 $("#exp_month").removeAttr("name");
//                 $("#exp_year").removeAttr("name");
//                 $("#cvc").removeAttr("name");
//                 var token = response.id;               //tokenにはトークン(number exp_month exp_yearのデータが入っている)
//                 $("#charge-form").append(`<input type="hidden" name="payjp-token" value=${token}></input>`)
//                 $("#charge-form").append(`<input type="hidden" name="user_request" value=${user_request}></input>`)
//                 $("#charge-form").submit();
//             } 
//             else if (status === 429) {
//                 alert("pay.jp側で処理ができませんでした。通信を軽くしてください。")
//             }
//             else {
//                 alert("正しい有効期限またはセキリュティコードを入力してください。");
//             }
//         });
        
//     });
// });




//勝手にstyleがついていた
$(function(){
    $(".link_menus_index").attr('style', '');
});

//bxslider
$(function(){
    $('.bxslider_cut').bxSlider({
        slideWidth: 300,
        minSlides: 3,
        maxSlides: 3,
        moveSlides: 1,
        nextSelector: "#feed-next-btn-cut",
        prevSelector: "#feed-prev-btn-cut",
        nextText: ">",
        prevText: "<",
        touchEnabled: true,
        infiniteLoop: true,
    });
    $('.bxslider_color').bxSlider({
        slideWidth: 300,
        minSlides: 3,
        maxSlides: 3,
        moveSlides: 1,
        nextSelector: "#feed-next-btn-color",
        prevSelector: "#feed-prev-btn-color",
        nextText: ">",
        prevText: "<",
        touchEnabled: true,
        infiniteLoop: true,
    });
    $('.bxslider_parma').bxSlider({
        slideWidth: 300,
        minSlides: 3,
        maxSlides: 3,
        moveSlides: 1,
        nextSelector: "#feed-next-btn-parma",
        prevSelector: "#feed-prev-btn-parma",
        nextText: ">",
        prevText: "<",
        touchEnabled: true,
        infiniteLoop: true,
    });
    $('.bxslider_curly').bxSlider({
        slideWidth: 300,
        minSlides: 3,
        maxSlides: 3,
        moveSlides: 1,
        nextSelector: "#feed-next-btn-curly",
        prevSelector: "#feed-prev-btn-curly",
        nextText: ">",
        prevText: "<",
        touchEnabled: true,
        infiniteLoop: true,
    });
});