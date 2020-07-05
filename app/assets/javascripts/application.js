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

//topページ
$(function() {
    $('.user_open_modal').click(function() {
      $('#user_login_modal').fadeIn();      //login_modalのdisplayをnoneをブロックにする    
    });
  
    $('.hairdresser_open_modal').click(function() {
      $('#hairdresser_login_modal').fadeIn();      //login_modalのdisplayをnoneをブロックにする     
    });

    $('.new_user').click(function() {
      $('#user_sign_up').fadeIn();      //login_modalのdisplayをnoneをブロックにする     
    });

    $('.glyphicon').click(function() {
      $('#user_sign_up').fadeOut();         //login_modalのdisplayをnoneにする     
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
});
  













































//userの予約確定するかどうかページ
$(function() {
  $(".point_check").click(function(){
    if ($(this).hasClass("check")) {
      $(this).removeClass("check");
      $(this).prop('checked', false); 
    } else {
      $('.checkbox').prop('checked', false);  
      $('.checkbox').removeClass('check'); 
      $(this).addClass("check");
      $(this).prop('checked', true); 
    }
  });

  $(".card_check").click(function(){
    if ($(this).hasClass("check")) {
      $(this).removeClass("check");
      $(this).prop('checked', false);
    } else {
      $('.checkbox').prop('checked', false);  
      $('.checkbox').removeClass('check'); 
      $(this).addClass("check");
      $(this).prop('checked', true);  
    }
  });

  $(".registered_card_check").click(function(){
    if ($(this).hasClass("check")) {
      $(this).removeClass("check");
      $(this).prop('checked', false);
    } else {
      $('.checkbox').prop('checked', false);  
      $('.checkbox').removeClass('check'); 
      $(this).addClass("check");
      $(this).prop('checked', true);  
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



//美容師の登録ページ 美容師のメニュー作成ページ
$(function () {
    // 画像を呼び出すためのコールバック関数 関数を定義している
    function readURL(input) {　
      // データが存在していることを確認 type="file"
      if (input.files) {
        // 非同期で読み込むためにFileReader()を呼び出す
        var reader = new FileReader();
        reader.readAsDataURL(input.files[0]);
        // onload はファイルの読み込みが完了したタイミングで発火する
        reader.onload = function (e) {
        //   // avatar_img_prevのimg srcの部分を画像のパラメータとして設定
        $('#prev_img').attr('src', e.target.result);
        }

      }
    }

    $("#post_img").change(function () {
      readURL(this);
      console.log("fhaf");
      });
    

});
  //varはグローバル変数といいどこでもその変数が使える 関数を定義した中で使うとローカル変数になる




  //美容師のヘアスタイル画像投稿ページで使う
$(function () {
  //生成されたhtml要素にはこの形じゃないとイベントが発生しない  既存の要素でも反応する
  $(document).on("change", ".image_input", function () { 
    size = $('img').length;
    console.log(size);
    var image_input =  $(this)
    var reader = new FileReader();
    reader.readAsDataURL(this.files[0]);
    reader.onload = function(e){
      var src = e.target.result
      var html = 
            `
              <div class="hair_box hair">
                <img src="${src}" class="image_box" width="80%" height="250">
                <div class="delete cursor" style="font-size: 20px;">削除</div>
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
        var src = e.target.result
        if ( size == 9) { 
          $('.image_label').addClass(`display_none`);
        }
      } 
      $('.image_label').before(html);
      image_input.appendTo(".hair");
      $(".hair_box").removeClass("hair");
      $(".image_label").append('<input class="hidden image_input" type="file" name="style_image[hair_images][]">');
    }
  });
  
  //生成されたhtml要素にはこの形じゃないとイベントが発生しない
  $(document).on("click", ".delete", function(){
    size = $('img').length;
    $(this).parent().remove();
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

window.onload = function () {
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
};
 







//バリデーション
$(function() {
  $(".login_btn").on("click", function(e) {
    e.preventDefault();
    i = 0
    size = $("#name").val().length;
    email = $("#email").val();
    phone_number =  $("#phone_number").val();
    password = $("#password").val();
    password_confirmation = $("#password_confirmation").val()
    password_size = $("#password").val().length;
    element_man = document.getElementById("sex_man");      //中はid
    element_woman = document.getElementById("sex_woman");
    gon.user_data.push($("#name").val())
    console.log(gon.user_data);
    function FindSameValue(a){
      var s = new Set(a);         //同じ要素を一つにする
      return s.size != a.length;  //元の配列と変化した後の配列の要素の数が違うかどうか　
    }                             //falseは重複なし trueは重複あり
    var duplication = FindSameValue(gon.user_data);
    var phone = /^[0-9]{9}$/;              //電話番号
    var address = /^[0-9]{3}-[0-9]{4}$/;　　　//郵便番号
    var email_check = /^[A-Za-z0-9]{1}[A-Za-z0-9_.-]*@{1}[A-Za-z0-9_.-]{1,}\.[A-Za-z0-9]{1,}$/;　　//メールアドレス
    if (duplication == true) {
      $(".name_error").html("その名前は既に登録されています");
      $(".name").css({
        'border-color':'red',
        "border-width":"2px"
      });
      i += 1
    } else {
      $(".name_error").html("");
      $(".name").css({
        "border-width":"0px"
      });
    }
    if (size < 1 || 7 < size) {
      $(".name_error2").html("1文字以上7文字以内で入力してください");
      $(".name").css({
        'border-color':'red',
        "border-width":"2px"
      });
      i += 1
    } else {
      if (duplication == true) {
        $(".name_error2").html("");
      } else {
        $(".name_error2").html("");
        $(".name").css({
          "border-width":"0px"
        });
      }
    }
    if (email_check.test(email)){
      $(".email_error").html("");
      $(".email").css({
        "border-width":"0px"
      });
    } else {
      $(".email_error").html("正しいメールアドレスを入力してください");
      $(".email").css({
        'border-color':'red',
        "border-width":"2px"
      });
      i += 1
    } 
    if (phone.test(phone_number)) {
      $(".phone_error").html("");
      $(".phone_number").css({
        "border-width":"0px"
      });
    } else {
      $(".phone_error").html("ハイフンなし半角で9桁の数字を入力してください");
      $(".phone_number").css({
        'border-color':'red',
        "border-width":"2px"
      });
      i += 1
    }
    if (password != password_confirmation) {
      $(".password_error").html("パスワードが一致しません");
      $(".password").css({
        'border-color':'red',
        "border-width":"2px"
      });
      i += 1
    } else {
      $(".password_error").html("");
      $(".password").css({
        "border-width":"0px"
      });
    }
    if (password_size < 6 || 15 < password_size ) {
      $(".password_error2").html("パスワードは6文字以上15文字以下で入力してください");
      $(".password").css({
        'border-color':'red',
        "border-width":"2px"
      });
      i += 1
    } else {
      if (password != password_confirmation) {
        $(".password_error2").html("");
      } else {
        $(".password_error2").html("");
        $(".password").css({
          "border-width":"0px"
        });
      }
    }
    if (element_man.checked == false && element_woman.checked == false) {
      $(".sex_error").html("どちらかにチェックしてください");
      i += 1
    } else {
      $(".sex_error").html("");
    }
    if (i != 0) {
      $(".total_error").html(`<h2>${i}件のエラーがあります</h2>`); 
    } else if (i == 0) {
      $(".user_form").submit();
    }
    gon.user_data.pop();　//配列の一番最後の要素を削除
 })
});


































$(function () {
  $(".input5").change(function () {
   number = $(this).get(0).files.length
   if (number > 5) {
     alert("登録できるのは登録できる写真は5枚までです。")
   } else {
    $(".image_form").submit();
  }
  });

  $(".input4").change(function () {
    number = $(this).get(0).files.length
    if (number > 4) {
      alert("登録できるのは登録できる写真は5枚までです。")
    }
  });

  $(".input3").change(function () {
    number = $(this).get(0).files.length
    if (number > 3) {
      alert("登録できるのは登録できる写真は5枚までです。")
    }
  });

  $(".input2").change(function () {
    number = $(this).get(0).files.length
    if (number > 2) {
      alert("登録できるのは登録できる写真は5枚までです。")
    }
  });

  $(".input1").change(function () {
    number = $(this).get(0).files.length
    if (number > 1) {
      alert("登録できるのは登録できる写真は5枚までです。")
    }
  });
});

//userのマイページ
$(function() {
  $('.cancel_fail').click(function() { 
     alert("予約日から24時間以内なのでこのサイトからキャンセルできません。直接、担当美容師にお問い合わせください");
  });
});

$(function() {
  $('.form_close_modal').click(function() { 
    $('.card_modal').fadeOut();     
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
        $("#charge-form").submit();
      } else {
        alert("有効期限またはセキリュティコードを入力してください");
        $("#token_submit").prop('disabled', false);　//ボタンを有効化する
      }
    });
  });
});







