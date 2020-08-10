
window.onload = function () {
    //画像投稿のとき画像しか選べなくする
    $("input").attr('accept', "image/*");
    
    //背景色を変える
    if (gon.body == "white"){
      $("body").css({
        "background-color":"white"
      });
      $("#yield").css({
        "background-color":"white"
      });
    }

    //headerを固定する headerを固定するviewと固定しないviewで分けている
    if (gon.fix == "header") {
      $("header").addClass("fix");
    }

    if (gon.display_none == "remove_display_none") {
      $(".display_th").removeClass();
    }
};
   