
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

    //背景色を変える
    if (gon.body == "white"){
      $("body").css({
        "background-color":"white"
      });
    }

    //headerを固定する headerを固定するviewと固定しないviewで分けている
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
   