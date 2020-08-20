
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

    if (gon.display_none == "remove_display_none") {
      $(".display_th").removeClass();
    }

    // URLの取得
    //var url = location.href
 
    // パスの取得
    var path = location.pathname

    $('a').each(function(){
      var href = $(this).attr('href');
      if (href == path) {
        $(this).css({
          "color": "#FAF0E6"
        })
      }
    });

};
   