// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require jquery.jposta
//= require bootstrap-sprockets
//= require activestorage
//= require jquery.raty
// require turbolinks
//= require_tree .

//turbolinksがあるとjsが発動しないことがあるので消した
//topページ
$(function() {
　//会員の新規会員登録
  $('#new_user').click(function() {
    $('#user_sign_up').fadeIn();     
  });

  //会員ログイン
  $('#login_user').click(function() {
    $('#user_sign_in').fadeIn();      
  });

  //美容師の新規登録　
  $('#new_hairdresser').click(function() {
    $('#hairdresser_sign_up').fadeIn();     
  });

  //美容師ログイン
  $('#login_hairdresser').click(function() {
    $('#hairdresser_sign_in').fadeIn();      
  });
  
  //ご希望ありをクリックする
  $(document).on("click", ".user_hope", function () { 
    $(this).next("div").fadeIn(); 
  });
  
  //バツアイコンでモーダルを閉じる
  $('.glyphicon-remove').click(function() {
    $('.sign_up_in').fadeOut();
    setTimeout(function(){
      $('.error').html(""); 
      $("input").css({
        "border-width":"0px"
      });
    },1000);  
  });

  $(document).on("click", ".glyphicon-remove", function () { 
    $('.sign_up_in').fadeOut();
  });

  
    $('.hairdresser_open_modal').click(function() {
      $('#hairdresser_login_modal').fadeIn();      //login_modalのdisplayをnoneをブロックにする     
    });
    



    $('#user_close_modal').click(function() {
      $('#user_login_modal').fadeOut();         //login_modalのdisplayをnoneにする     
    });
  
    $('#hairdresser_close_modal').click(function() {
      $('#hairdresser_login_modal').fadeOut();      //login_modalのdisplayをnoneにする     
    });


    
    $('.login').click(function() {
      if($(".answer").hasClass('open')) { 
        $(".answer").removeClass('open');
        $(".answer").slideUp();  //answerのdisplayをnoneにする  
      } else {
        $(".answer").addClass('open'); 
        $(".answer").slideDown();  //answerのdisplayをblockにする 
      }
    });
    
  $('.sign_up').click(function() {
    if($(".answer2").hasClass('open2')) { 
      $(".answer2").removeClass('open2');
      $(".answer2").slideUp();  //answerのdisplayをnoneにする     
    } else {
      $(".answer2").addClass('open2'); 
      $(".answer2").slideDown();  //answerのdisplayをblockにする
    }
  });

  //FAQ
  $('.question').click(function() {
    if($(this).next().hasClass('open')) { 
      $(this).next().removeClass("open");
      $(this).next().slideUp(); 
    } else {
      $(this).next().addClass('open'); 
      $(this).next().slideDown(); 
    }
  });

  //ナビゲーション
  $('.scroll-btn').click(function(){
    var id = $(this).attr('href');      //id属性には#が入っている     
    var position = $(id).offset().top;  //topからの距離を取得
    $('html').animate({
      'scrollTop': position - 300
    }, 1500);
  });


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
  $(window).scroll(function (){
    if (gon.fix == "header") {
      $("header").css({
        "position":"fixed"
      });
    }
});
});



//user登録のバリデーション
$(function() {
  $("#user_btn").on("click", function(e) {
    e.preventDefault();

    //入力された値を取得　iはエラーの数を表す
    i = 0
    size = $("#user_name").val().length;
    email = $("#user_email").val();
    phone_number =  $("#user_phone_number").val();
    password = $("#user_password").val();
    password_confirmation = $("#user_password_confirmation").val()
    password_size = $("#user_password").val().length;
    element_man = document.getElementById("sex_man");      //中はid
    element_woman = document.getElementById("sex_woman");
    gon.user_name_data.push($("#user_name").val())
    gon.user_email_data.push($("#user_email").val())
    
    //入力された値が正しいかチェックするための関数と正規表現を定義
    function FindSameValue(a){    
      var s = new Set(a);         //同じ要素を一つにする
      return s.size != a.length;  //元の配列と変化した後の配列の要素の数が違うかどうか　
    }                             //falseは重複なし trueは重複あり
    var duplication_name = FindSameValue(gon.user_name_data);　　//nameに同じ要素があるかチェック
    var duplication_email = FindSameValue(gon.user_email_data);　//emailに同じ要素があるかチェック
    var phone = /^[0-9]{9}$/;                //電話番号 0から9までの数字で9個選ぶ
    var email_check = /^[A-Za-z0-9]{1}[A-Za-z0-9_.-]*@{1}[A-Za-z0-9_.-]{1,}\.[A-Za-z0-9]{1,}$/;　　//メールアドレス
    
    //nameチェック
    if (duplication_name == true) {
      $(".user_name_error").html("その名前は既に登録されています");
      $(".name").css({
        'border-color':'red',
        "border-width":"2px"
      });
      i += 1
    } else {
      $(".user_name_error").html("");
      $(".name").css({
        "border-width":"0px"
      });
    }
    if (size < 2 || 10 < size) {
      $(".user_name_error2").html("2文字以上10文字以内で入力してください");
      $(".name").css({
        'border-color':'red',
        "border-width":"2px"
      });
      i += 1
    } else {
      if (duplication_name == true) {
        $(".user_name_error2").html("");
      } else {
        $(".user_name_error2").html("");
        $(".name").css({
          "border-width":"0px"
        });
      }
    }
　   
    //emailチェック
    if (email_check.test(email)){
      $(".user_email_error").html("");
      $(".email").css({
        "border-width":"0px"
      });
    } else {
      $(".user_email_error").html("正しいメールアドレスを入力してください");
      $(".email").css({
        'border-color':'red',
        "border-width":"2px"
      });
      i += 1
    } 
    if (duplication_email == true){
      $(".user_email_error2").html("そのメールアドレスは既に登録されています");
      $(".email").css({
        'border-color':'red',
        "border-width":"2px"
      });
      i += 1
    } else {
      if (email_check.test(email)) {
        $(".user_email_error2").html("");
        $(".email").css({
          "border-width":"0px"
        });
      }
      $(".user_email_error2").html("");
    } 
　　
    //電話番号チェック
    if (phone.test(phone_number)) {
      $(".user_phone_error").html("");
      $(".phone_number").css({
        "border-width":"0px"
      });
    } else {
      $(".user_phone_error").html("ハイフンなし半角で9桁の数字を入力してください");
      $(".phone_number").css({
        'border-color':'red',
        "border-width":"2px"
      });
      i += 1
    }
    
    //パスワードチェック
    if (password != password_confirmation) {
      $(".user_password_error").html("パスワードが一致しません");
      $(".password").css({
        'border-color':'red',
        "border-width":"2px"
      });
      i += 1
    } else {
      $(".user_password_error").html("");
      $(".password").css({
        "border-width":"0px"
      });
    }
    if (password_size < 6 || 15 < password_size ) {
      $(".user_password_error2").html("パスワードは6文字以上15文字以下で入力してください");
      $(".password").css({
        'border-color':'red',
        "border-width":"2px"
      });
      i += 1
    } else {
      if (password != password_confirmation) {
        $(".user_password_error2").html("");
      } else {
        $(".user_password_error2").html("");
        $(".password").css({
          "border-width":"0px"
        });
      }
    }
　　
    //性別チェック
    if (element_man.checked == false && element_woman.checked == false) {
      $(".user_sex_error").html("どちらかにチェックしてください");
      i += 1
    } else {
      $(".user_sex_error").html("");
    }
    
    //エラーの数を表示
    if (i != 0) {
      $(".total_error").html(`<h2>${i}件のエラーがあります</h2>`); 
    } else if (i == 0) {
      $(".user_form").submit();
    }

    gon.user_name_data.pop();　//配列の一番最後の要素を削除
    gon.user_email_data.pop();　//配列の一番最後の要素を削除
  })
});




//hairdresser登録のバリデーション
$(function() {
  $("#hairdresser_btn").on("click", function(e) {
    e.preventDefault();

    //入力された値を取得　iはエラーの数を表す
    i = 0
    size = $("#hairdresser_name").val().length;
    email = $("#hairdresser_email").val();
    hairdresser_shop_name = $("#hairdresser_shop_name").val();
    hairdresser_post_number = $("#hairdresser_post_number").val();
    hairdresser_address = $("#hairdresser_address").val();
    password = $("#hairdresser_password").val();
    password_confirmation = $("#hairdresser_password_confirmation").val()
    password_size = $("#hairdresser_password").val().length;
    element_man = document.getElementById("hairdresser_sex_man");      //中はid
    element_woman = document.getElementById("hairdresser_sex_woman");
    gon.hairdresser_name_data.push($("#hairdresser_name").val())
    gon.hairdresser_email_data.push($("#hairdresser_email").val())
    
    //入力された値が正しいかチェックするための関数と正規表現を定義
    function FindSameValue(a){    
      var s = new Set(a);         //同じ要素を一つにする
      return s.size != a.length;  //元の配列と変化した後の配列の要素の数が違うかどうか　
    }                             //falseは重複なし trueは重複あり
    var duplication_name = FindSameValue(gon.hairdresser_name_data);　　//nameに同じ要素があるかチェック
    var duplication_email = FindSameValue(gon.hairdresser_email_data);　//emailに同じ要素があるかチェック
    var address = /^[0-9]{3}[0-9]{4}$/;　　　//郵便番号
    var email_check = /^[A-Za-z0-9]{1}[A-Za-z0-9_.-]*@{1}[A-Za-z0-9_.-]{1,}\.[A-Za-z0-9]{1,}$/;　　//メールアドレス
    
    //nameチェック
    if (duplication_name == true && $("#hairdresser_name").val() != "") {
        $(".hairdresser_name_error").html("その名前は既に登録されています");
        $(".hairdresser_name").css({
          'border-color':'red',
          "border-width":"2px"
        });
        i += 1
    } else {
      $(".hairdresser_name_error").html("");
      $(".hairdresser_name").css({
        "border-width":"0px"
      });
    }
    if (size < 2 || 10 < size) {
      $(".hairdresser_name_error2").html("2文字以上10文字以内で入力してください");
      $(".hairdresser_name").css({
        'border-color':'red',
        "border-width":"2px"
      });
      i += 1
    } else {
      $(".hairdresser_name_error2").html("");
      if (duplication_name == true) {
      } else {
        $(".hairdresser_name").css({
          "border-width":"0px"
        });
      }
    }
    
    //emailチェック
    if (email_check.test(email)){
      $(".hairdresser_email_error").html("");
      $(".hairdresser_email").css({
        "border-width":"0px"
      });
    } else {
      $(".hairdresser_email_error").html("正しいメールアドレスを入力してください");
      $(".hairdresser_email").css({
        'border-color':'red',
        "border-width":"2px"
      });
      i += 1
    } 
    if (duplication_email == true){
      if ($("#hairdresser_email").val() != "") {
        $(".hairdresser_email_error2").html("そのメールアドレスは既に登録されています");
        $(".hairdresser_email").css({
          'border-color':'red',
          "border-width":"2px"
        });
        i += 1
      }
    } else {
      if (email_check.test(email)) {
        $(".hairdresser_email_error2").html("");
        $(".hairdresser_email").css({
          "border-width":"0px"
        });
      }
      $(".hairdresser_email_error2").html("");
    } 
    
    //店舗名チェック
    if (hairdresser_shop_name != "") {
      $(".hairdresser_shop_name_error").html("");
      $(".hairdresser_shop_name").css({
        "border-width":"0px"
      });
      } else {
        $(".hairdresser_shop_name_error").html("店舗名を入力してください");
        $(".hairdresser_shop_name").css({
          'border-color':'red',
          "border-width":"2px"
        });
        i += 1
        };
    
    //郵便番号チェック
    if (address.test(hairdresser_post_number)){
      $(".hairdresser_post_number_error").html("");
      $(".hairdresser_address_number").css({
        "border-width":"0px"
      });
      } else {
        $(".hairdresser_post_number_error").html("半角7桁の数字を入力してください");
        $(".hairdresser_address_number").css({
          'border-color':'red',
          "border-width":"2px"
        });
        i += 1
        };
    
    //住所チェック
    if (hairdresser_address != "") {
      $(".hairdresser_address_error").html("");
      $(".hairdresser_address").css({
        "border-width":"0px"
      });
      } else {
        $(".hairdresser_address_error").html("住所を入力してください");
        $(".hairdresser_address").css({
          'border-color':'red',
          "border-width":"2px"
        });
        i += 1
        };
    
    //パスワードチェック
    if (password != password_confirmation) {
      $(".hairdresser_password_error").html("パスワードが一致しません");
      $(".hairdresser_password").css({
        'border-color':'red',
        "border-width":"2px"
      });
      i += 1
    } else {
      $(".hairdresser_password_error").html("");
      $(".hairdresser_password").css({
        "border-width":"0px"
      });
    }
    if (password_size < 6 || 15 < password_size ) {
      $(".hairdresser_password_error2").html("6文字以上15文字以下で入力してください");
      $(".hairdresser_password").css({
        'border-color':'red',
        "border-width":"2px"
      });
      i += 1
    } else {
      if (password != password_confirmation) {
        $(".hairdresser_password_error2").html("");
      } else {
        $(".hairdresser_password_error2").html("");
        $(".password").css({
          "border-width":"0px"
        });
      }
    }
　　
    //性別チェック
    if (element_man.checked == false && element_woman.checked == false) {
      $(".hairdresser_sex_error").html("どちらかにチェックしてください");
      i += 1
    } else {
      $(".hairdresser_sex_error").html("");
    }

    //写真があるかどうか
    if ($(".confirm_label").hasClass("exist_img")) {
      $(".img_error").html("");
    } else {
      $(".img_error").html("写真を選択してください");
      i += 1
    }
　  
    //エラーの数を表示
    if (i != 0) {
      $(".total_hairdresser_error").html(`<h2>${i}件のエラーがあります</h2>`); 
    } else if (i == 0) {
      $(".hairdresser_form").submit();
    }

    gon.hairdresser_name_data.pop();　//配列の一番最後の要素を削除
    gon.hairdresser_email_data.pop();　//配列の一番最後の要素を削除
  })
});

//画像プレビュー表示
$(function () {
  
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

  $(".img_delete").click(function(){
    $("#prev_img").remove();
    $(".hairdresser_label").append('<img src="/assets/no_image-1d7230a86ae81ad3d79bc59c93ae5633d4560e4cfe469a82eb1a0fae86d27bee.png" alt="" id="prev_img" style="width: 150px; height: 150px; border-radius: 20px;"></img>');
    $(".img_save").empty();
  });

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





//美容師のメニュー作成ページ
$(function() {

  $('.make').click(function() {
    name = $('#menu_name').val();
    explanation = $('#menu_explanation').val();
    if (name == "" || explanation == "" ) {
      $('#error-message').text('メニュー名と説明を入力してください');
      $(".save_card").removeClass("arrive");
    } else {
      $('.title').text(name);
      $('.explanation').text(explanation);
      $(".save_card").addClass("arrive");
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

  //メニュー名
  $(document).on("change", "#menu_name", function () { 
    var name = $(this).val();
    if (name.length>12) {
      $(".name_error").html("12文字以内で入力してください");
    } else {
      $(".title").html(name);
      $(".name_error").html("");
    }
  });
  
  //メニュー説明
  $("#menu_explanation").change(function(){
    var explanation = $(this).val();
    if (explanation.length>160) {
      $(".explain_error").html("160文字以内で入力してください");
    } else {
      $(".explain").html(explanation);
      $(".explain_error").html("");
    }
  });

  //menu施術時間
  $("#menu_time").change(function(){
    var time = $(this).val();
    $(".menu_time").html(time+"分");
  });

  //メニューカテゴリー
  $(".category1").click(function(){
    if ($(this).hasClass("check")) {
      $(this).removeClass("check");
      $(this).addClass("not_category");
      $(".cut_category").html("");
    } else {
      $(this).addClass("check");
      $(this).removeClass("not_category");
      $(".cut_category").html("カット");
    }
  });

  $(".category2").click(function(){
    if ($(this).hasClass("check")) {
      $(this).removeClass("check");
      $(this).addClass("not_category");
      $(".color_category").html("");
    } else {
      $(this).addClass("check");
      $(this).removeClass("not_category");
      $(".color_category").html("カラー");
    }
  });

  $(".category3").click(function(){
    if ($(this).hasClass("check")) {
      $(this).removeClass("check");
      $(this).addClass("not_category");
      $(".curly_category").html("");
    } else {
      $(this).addClass("check");
      $(this).removeClass("not_category");
      $(".curly_category").html("縮毛矯正");
    }
  });

  $(".category4").click(function(){
    if ($(this).hasClass("check")) {
      $(this).removeClass("check");
      $(this).addClass("not_category");
      $(".perm_category").html("");
    } else {
      $(this).addClass("check");
      $(this).removeClass("not_category");
      $(".perm_category").html("パーマ");
    }
  });

  $(".save_card").on("click", function(e) {
    
    var name = $("#menu_name").val();
    var explanation = $("#menu_explanation").val();
    var time = $("#menu_time").val();
    console.log(name.length)
    if (3<=name.length && name.length<=12) {
      $(".name_error").html("");
    } else {
      $(".name_error").html("3文字以上12文字以内で入力してください");
    }
    if (5<=explanation.length && explanation.length<=160) {
      $(".explain_error").html("");
    } else {
      $(".explain_error").html("5文字以上160文字以内で入力してください");
    }
    if (time == "") {
      $(".time_error").html("時間を設定してください");
    } else {
      $(".time_error").html("");
    }
    if ($(".category1").hasClass("not_category") && $(".category2").hasClass("not_category") && $(".category3").hasClass("not_category") && $(".category4").hasClass("not_category")) {
      $(".category_error").html("最低一つチェックしてください");
    } else {
      $(".category_error").html("");
    }
  });
  
});


window.onload = function () {
  //複数画像投稿ページ
  $("input").attr('accept', "image/*");
  if (gon.image_number == 0) {
    $(".image_label").addClass("width_100");
  }
  else if (gon.image_number == 1) {
    $(".image_label").addClass("width_80");
  }
  else if (gon.image_number == 2) {
    $(".image_label").addClass("width_60");
  }
  else if (gon.image_number == 3) {
    $(".image_label").addClass("width_40");
  }
  else if (gon.image_number == 4) {
    $(".image_label").addClass("width_20");
  }
  else if (gon.image_number == 5) {
    $(".image_label").addClass("width_100");
  }
  else if (gon.image_number == 6) {
    $(".image_label").addClass("width_80");
  }
  else if (gon.image_number == 7) {
    $(".image_label").addClass("width_60");
  }
  else if (gon.image_number == 8) {
    $(".image_label").addClass("width_40");
  }
  else if (gon.image_number == 9) {
    $(".image_label").addClass("width_20");
  }
  else if (gon.image_number == 10) {
    $(".image_label").addClass("width_100");
    $('.image_label').addClass(`display_none`);
  }
  if (gon.body == "white"){
    $("body").css({
      "background-color":"white"
    });
  }
  if (gon.fix == "header") {
    $("header").addClass("fix");
  }
  if (gon.reverse == "reverse") {
    $(".raty").children().remove();
    $('.index_user_reservations').html($('.index_user_reservations').find('.re_index').get().reverse());
    $(".raty").css({
      "position": "relative",
      "right": "10px"
    });
  }
  if (gon.display_none == "remove_display_none") {
    $(".display_th").removeClass();
  }
  
};
 

$(function () {
      $(document).on("change", ".image_input", function () { 
        var image_input =  $(this)
        //var size = $('.hair_box').length;
        //var number = $(this).get(0).files.length
        // if (size + number >10) {
        //   alert("投稿できる画像は10枚までです。")
        //   $(this).val("");
        // } else {

        //for (i = 0; i < this.files.length; i+=1) {
          var reader = new FileReader();
          reader.readAsDataURL(this.files[0])
          console.log(this.files[0])
          //ここで折り返す

          //この後input.files.length(選択した画像の数)だけ繰り返す i=input.files.lengthとなる
          reader.onload = function(e){
            var image_size = $('.hair_box').length;
            var src = e.target.result
            var html = `
                        <div class="hair_box made_box arry${image_size}" href="${image_size}">
                          <img src="${src}" class="image_box" width="80%" height="250">
                          <h4><a class="delete cursor">削除</a>
                        </div>
                        `
            if ($(".image_label").hasClass(`width_100`)) {
              $(".image_label").removeClass("width_100");
              console.log(100);
              $('.image_label').addClass(`width_80`);
            }
            else if ($(".image_label").hasClass("width_80")) {
              $(".image_label").removeClass("width_80");
              console.log(80);
              $('.image_label').addClass(`width_60`);
            }
            else if ($(".image_label").hasClass("width_60")) {
              $(".image_label").removeClass("width_60");
              console.log(60);
              $('.image_label').addClass(`width_40`);
            }
            else if ($(".image_label").hasClass("width_40")) {
              $(".image_label").removeClass("width_40");
              console.log(40);
              $('.image_label').addClass(`width_20`);
            }
            else if ($(".image_label").hasClass("width_20")) {
              $(".image_label").removeClass("width_20");
              console.log(20);
              $('.image_label').addClass(`width_100`);
              if ( image_size == 9) { 
                $('.image_label').addClass(`display_none`);
              }
            } 
            $('.image_label').before(html);
          //}
        }
        image_input.appendTo(".image_form_save");
        $(".image_label").append('<input class="hidden image_input" type="file" name="style_image[hair_images][]" id="style_image_hair_images" accept="image/*">');
      //}
      });

     //生成されたhtml要素にはこの形じゃないとイベントが発生しない
      $(document).on("click", ".delete", function(){
        image_size = $('.hair_box').length;
        id = $(this).parent().parent().attr('href'); 
        for (i = 0; i < 10; i+=1) {
          var target = $(`.arry${i}`);
          var href_number = target.attr('href');
          if (href_number>id) {
            href_number -= 1
            target.removeClass();
            target.addClass(`hair_box made_box arry${href_number}`);
            target.attr('href', `${href_number}`);
          }
        }
        $(".image_form").append(`<input name="[arry][]", value=${id} class="hidden">`)
        $(this).prop('disabled',true); //連打を防ぐ
        $(this).parent().parent().remove();

        if ($(".image_label").hasClass("width_80")) {
          $(".image_label").removeClass("width_80");
          $(".image_label").addClass("width_100");
        } 
        else if ($(".image_label").hasClass("width_60")) {
          $(".image_label").removeClass("width_60");
          $(".image_label").addClass("width_80");
        }
        else if ($(".image_label").hasClass("width_40")) {
          $(".image_label").removeClass("width_40");
          $(".image_label").addClass("width_60");
        }
        else if ($(".image_label").hasClass("width_20")) {
          $(".image_label").removeClass("width_20");
          $(".image_label").addClass("width_40");
        }
        else if ($(".image_label").hasClass("width_0")) {
          $(".image_label").removeClass("width_0");
          $(".image_label").addClass("width_20");
        }
        else if ($(".image_label").hasClass("width_100")) {
          $(".image_label").removeClass("width_100");
          $(".image_label").removeClass("display_none");
          $(".image_label").addClass("width_20");
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
      "color": "#DEB887" 
    });
  });
  
});



//pay.jp  クレジットカード登録 決済
$(function() {
  //gon.keyはpay.jpの公開鍵 環境変数はjsでは使えなかった
  Payjp.setPublicKey(gon.key);

  $("#token_submit").on("click", function(e) {
    $(this).prop('disabled',true);//ボタンを無効化する
    e.preventDefault();
    var card = {
        number: $("#card_number").val(),
        exp_month: $("#exp_month").val(),
        exp_year: $("#exp_year").val(),
        cvc: $("#cvc").val()
    };
    var number = $("#card_number").val();
    if(number != 4242424242424242) {
      alert("カード番号は4242424242424242と入力してください。このサイトではこのテストコードでしか決済できません。")
    }
   //createToken でトークンを申込を発行してpayjp側に送る => payjp側でトークンが作成されresponseでpayjp側で作成されたトークンが帰ってくる　作成されない可能性もある　トークンが作成されるだけで保存はされていない statusはトークンが作成されたかどうか200は成功
   Payjp.createToken(card, function(status, response) {
      if (status === 200) {                    
        $("#card_number").removeAttr("name");  //card_numberの値はコントローラーに送らなくていい  Payjp.createToken(card...  のcardでpayjp側にデータが送られている
        $("#exp_month").removeAttr("name");
        $("#exp_year").removeAttr("name");
        $("#cvc").removeAttr("name");
        var token = response.id;               //tokenにはトークン(number exp_month exp_yearのデータが入っている)
        $("#charge-form").append(`<input type="hidden" name="payjp-token" value=${token}></input>`)
        var user_request = $("#user_request").val();
        $("#charge-form").append(`<input type="hidden" name="user_request" value=${user_request}></input>`)
        $("#charge-form").submit();
      } else {
        alert("正しい有効期限またはセキリュティコードを入力してください。");
        $("#token_submit").prop('disabled', false);　//ボタンを有効化する
      }
    });
  });
});



$(function() {
  if (gon.user == null) {
    $(".user_reservation").on("click", function(e) {
      e.preventDefault();
      $('#user_sign_in').fadeIn(); 
      $(".error").html("ログインする必要があります");  
      var id = $(this).attr("id")
      $("#user_login_form").append(`<input type="hidden" name="reservation_id" value=${id}></input>`)
    });
  }
});


// $(function() {
// $('#btnrev').click(function(){
//   $(".raty").children().remove();
//   $('.index_user_reservations').html($('.index_user_reservations').find('.re_index').get().reverse());
//   $(".raty").css({
//     "position": "relative",
//     "right": "10px"
//   });
//   });
// });





$(function() {
  // var ctx = document.getElementById("myLineChart");
  // myLineChart = new Chart(ctx, {
  //         type: 'line',
  //         data: {
  //              if (3 == 3) {
  //                  //labels: ['8月1日', '8月2日', '8月3日', '8月4日', '8月5日', '<%= @Time.month - 1 %>月<%= @Time.day %>日', '<%= @Time.month %>月<%= @Time.day %>日'],
  //              } else {
  //                  //labels: ['8月1日', '8月2日', '8月3日', '8月4日', '8月5日', '<%= @Time.month - 1 %>月<%= @Time.day %>日', '<%= @Time.month %>月<%= @Time.day %>日'],
  //              }
  //             datasets: [
  //                 {
  //                 label: '最高気温(度）',
  //                 data: [35, 34, 37, 35, 34, 35, 34, 25],
  //                 borderColor: "rgba(255,0,0,1)",
  //                 backgroundColor: "rgba(0,0,0,0)"
  //                 },
  //                 {
  //                 label: '最低気温(度）',
  //                 data: [25, 27, 27, 25, 26, 27, 25, 21],
  //                 borderColor: "rgba(0,0,255,1)",
  //                 backgroundColor: "rgba(0,0,0,0)"
  //                 }
  //             ],
  //         },
  //         options: {
  //             title: {
  //                 display: true,
  //                 text: '気温（8月1日~8月7日）'
  //             },
  //             scales: {
  //                 yAxes: [{  //y軸の設定
  //                 ticks: {
  //                     //suggestedMax: 80,    //データがこの値を超えたらその値がmaxに自動でなる
  //                     suggestedMin: 0,
  //                     //stepSize: 0,
  //                     callback: function(value, index, values){
  //                     return  value +  '度'
  //                     }
  //                 }
  //             }]
  //         },
  //     }
  // });
});