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
      if($(".answer2").hasClass('open')) { 
        $(".answer2").removeClass('open');
        $(".answer2").slideUp();  //answerのdisplayをnoneにする     
      } else {
        $(".answer2").addClass('open'); 
        $(".answer2").slideDown();  //answerのdisplayをblockにする 
      }
    });
  
});
  

$(function() {
    　　　$(".checkbox").click(function(){
        if ($(this).hasClass("check")) {
          $(this).removeClass("check");
          $(this).prop('checked', false);
          $("#time").html(""); 
        } else {
          $('.checkbox').prop('checked', false);  
          $('.checkbox').removeClass('check'); 
          $(this).addClass("check");
          $(this).prop('checked', true); 
          $("#time").html(gon.cut_time); 
        }
      });
    
      $(".checkbox").click(function(){
        if ($(this).hasClass("check")) {
          $(this).removeClass("check");
          $(this).prop('checked', false);
          $("#time").html("");
        } else {
          $('.checkbox').prop('checked', false);  
          $('.checkbox').removeClass('check'); 
          $(this).addClass("check");
          $(this).prop('checked', true);  
          $("#time").html(gon.color_time);
        }
      });
    
      $(".checkbox").click(function(){
        if ($(this).hasClass("check")) {
          $(this).removeClass("check");
          $(this).prop('checked', false);
          $("#time").html("");
        } else {
          $('.checkbox').prop('checked', false);  
          $('.checkbox').removeClass('check'); 
          $(this).addClass("check");
          $(this).prop('checked', true);  
          $("#time").html(gon.special_time);
        }
      });
});

//メニュー作成ページ
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

//美容師の登録画面
$(function () {
    // 画像を呼び出すためのコールバック関数
    function readURL(input) {
      // データが存在していることを確認
      if (input.files && input.files[0]) {
        // 非同期で読み込むためにFileReader()を呼び出す
        var reader = new FileReader();
        // onload はファイルの読み込みが完了したタイミングで発火する
        reader.onload = function (e) {
          // avatar_img_prevのimg srcの部分を画像のパラメータとして設定
          $('#prev_img').attr('src', e.target.result);
        }
        // ファイルを読み込む
        reader.readAsDataURL(input.files[0]);
      }
    }
  
    // post_imgが変更されたタイミングに発火
    $("#post_img").change(function () {
      readURL(this);
    });
});
  

