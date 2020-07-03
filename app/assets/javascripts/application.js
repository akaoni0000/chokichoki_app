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
//= require_tree .

//topページ
$(function() {
    $('.user_open_modal').click(function() {
      $('#user_login_modal').fadeIn();      //login_modalのdisplayをnoneをブロックにする    
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
    //readURLsという関数を定義
    function readURLs(input) {
      for (i = 0; i < input.files.length; i+=1) {
        var reader = new FileReader();
        reader.readAsDataURL(input.files[i]);
        //ここで折り返す
        //この後input.files.length(選択した画像の数)だけ繰り返す i=input.files.lengthとなる
        reader.onload = function(e){
          var src = e.target.result
          var html = `
          <div class="hair_box">
            <img src="${src}" class="box_" width="80%" height="250">
            <div>
              <label class="image_">
                <input multiple="multiple" class="hidden image_input2" type="file" name="style_image[hair_images][]" id="style_image_hair_images">
              </label>
              <span style="font-size: 20px;">編集</span> <span style="font-size: 20px;">削除</span>
            </div>
          </div>
          `
          $('.image_label').before(html);
          //stop_数字 は周回(input.files.lengthだけ繰り返す)のための対策
          if ($(".image_label").hasClass(`stop_4`)) {
            $(".image_label").removeClass(`stop_4`)
            $(".image_label").addClass(`stop_3`)
          }
          else if ($(".image_label").hasClass(`stop_3`)) {
            $(".image_label").removeClass(`stop_3`)
            $(".image_label").addClass(`stop_2`)
          }
          else if ($(".image_label").hasClass(`stop_2`)) {
            $(".image_label").removeClass(`stop_2`)
            $(".image_label").addClass(`stop_1`)
          }
          else if ($(".image_label").hasClass(`stop_1`)) {
            $(".image_label").removeClass(`stop_1`)
            $(".image_input").val("");  //.val("")により画像選択で同じ画像を連続で選べるようにする
          }
          else if ($(".image_label").hasClass(`width_100`)) {
            $(".image_label").removeClass("width_100");
            var file_number = input.files.length;
            var number = 100-file_number*20;
            var stop_number = input.files.length-1;
            console.log(100);
            if (stop_number == 0) {
              $('.image_label').addClass(`width_${number}`);
              $(".image_input").val(""); //.val("")により画像選択で同じ画像を連続で選べるようにする
            } else {
              $('.image_label').addClass(`width_${number} stop_${stop_number}`);  //例えばwidth_80だと横幅が80%になる
            }
          } 
          else if ($(".image_label").hasClass("width_80")) {
            $(".image_label").removeClass("width_80");
            var file_number = input.files.length;
            var number = 80-file_number*20;
            var stop_number = input.files.length-1;
            console.log(80);
            if (stop_number == 0) {
              $('.image_label').addClass(`width_${number}`);
              $(".image_input").val(""); //.val("")により画像選択で同じ画像を連続で選べるようにする
            } else {
              $('.image_label').addClass(`width_${number} stop_${stop_number}`);
            }
          } 
          else if ($(".image_label").hasClass("width_60")) {
            $(".image_label").removeClass("width_60");
            var file_number = input.files.length;
            var number = 60-file_number*20;
            var stop_number = input.files.length-1;
            console.log(60);
            if (stop_number == 0) {
              $('.image_label').addClass(`width_${number}`);
              $(".image_input").val("");     //.val("")により画像選択で同じ画像を連続で選べるようにする
            } else {
              $('.image_label').addClass(`width_${number} stop_${stop_number}`);
            }
          } 
          else if ($(".image_label").hasClass("width_40")) {
            $(".image_label").removeClass("width_40");
            var file_number = input.files.length;
            var number = 40-file_number*20;
            var stop_number = input.files.length-1;
            console.log(40);
            if (stop_number == 0) {
              $('.image_label').addClass(`width_${number}`);
              $(".image_input").val("");   //.val("")により画像選択で同じ画像を連続で選べるようにする
            } else {
              $('.image_label').addClass(`width_${number} stop_${stop_number}`);
            }
          } 
          else if ($(".image_label").hasClass("width_20")) {
            $(".image_label").removeClass("width_20");
            var file_number = input.files.length;
            var number = 20-file_number*20;
            var stop_number = input.files.length-1;
            console.log(20);
            if (stop_number == 0) {
              $('.image_label').addClass(`width_${number}`);
              $(".image_input").val("");    //.val("")により画像選択で同じ画像を連続で選べるようにする
            } else {
              $('.image_label').addClass(`width_${number} stop_${stop_number}`);
            }
          } 
        }
      }
    }

      $(".image_input").change(function () {
        readURLs(this);
      });


      //生成されたhtml要素にはこの形じゃないとイベントが発生しない
      $(document).on("change", ".image_input2", function(){
        var reader = new FileReader();
        reader.readAsDataURL(this.files[0]);
        reader.onload = function (e) {
          $(".box_").attr('src', e.target.result);
        } 
        $(".image_input2").val("");
    });
  
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







