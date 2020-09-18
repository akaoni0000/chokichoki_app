$(function () {
    var width = $(window).width();

    //写真を選択したときに発生
    $(document).on("change", ".image_input", function () { 
        var image_input =  $(this);
        var reader = new FileReader();
        reader.readAsDataURL(this.files[0])
        reader.onload = function(e){
            var image_size = $('.hair_box').length;
            var src = e.target.result
            var html = `
                        <div class="hair_box made_box arry${image_size}" href="${image_size}">
                            <img src="${src}" class="image_box" width="80%" height="250">
                            <h4><a class="delete cursor">削除</a></h4>
                        </div>
                        `
            if ($(".image_label").hasClass(`width_100`)) {
                $(".image_label").removeClass("width_100");
                $('.image_label').addClass(`width_80`);
                if (width<=425) {
                    $(".image_label").removeClass("res_width_100");
                    $(".image_label").addClass("res_width_49");
                    if (image_size==5) {
                        $(".image_label").removeClass("res_width_49");
                        $(".image_label").addClass("res_width_100");
                    }
                }
            }
            else if ($(".image_label").hasClass("width_80")) {
                $(".image_label").removeClass("width_80");
                $('.image_label').addClass(`width_60`);
                if (width<=425) {
                    $(".image_label").removeClass("res_width_49");
                    $(".image_label").addClass("res_width_100");
                    if (image_size==6) {
                        $(".image_label").removeClass("res_width_100");
                        $(".image_label").addClass("res_width_49");
                    }
                }
            }
            else if ($(".image_label").hasClass("width_60")) {
                $(".image_label").removeClass("width_60");
                $('.image_label').addClass(`width_40`);
                if (width<=425) {
                    $(".image_label").removeClass("res_width_100");
                    $(".image_label").addClass("res_width_49");
                    if (image_size==7) {
                        $(".image_label").removeClass("res_width_49");
                        $(".image_label").addClass("res_width_100");
                    }
                }
            }
            else if ($(".image_label").hasClass("width_40")) {
                $(".image_label").removeClass("width_40");
                $('.image_label').addClass(`width_20`);
                if (width<=425) {
                    $(".image_label").removeClass("res_width_49");
                    $(".image_label").addClass("res_width_100");
                    if (image_size==8) {
                        $(".image_label").removeClass("res_width_100");
                        $(".image_label").addClass("res_width_49");
                    }
                }
            }
            else if ($(".image_label").hasClass("width_20")) {
                $(".image_label").removeClass("width_20");
                console.log(20);
                $('.image_label').addClass(`width_100`);
                if (image_size==9) { 
                    $('.image_label').addClass(`display_none`);
                }
                if (width<=425 && image_size==4) {
                    $(".image_label").removeClass("res_width_100");
                    $(".image_label").addClass("res_width_49");
                }
            } 
            $('.image_label').before(html);
        }
        image_input.appendTo(".image_form_save");
        $(".image_label").append('<input class="hidden image_input" type="file" name="style_image[hair_images][]" id="style_image_hair_images" accept="image/*">');

    });

    //生成されたhtml要素にはこの形じゃないとイベントが発生しない 削除して配列番号を調整
    $(document).on("click", ".delete", function(){

        id = $(this).parent().parent().attr('href'); 
        $(".image_form").append(`<input name="[arry][]", value=${id} class="hidden">`)
        $(this).prop('disabled',true); //連打を防ぐ
        $(this).parent().parent().remove();
        var image_size = $('.hair_box').length;

        if ($(".image_label").hasClass("width_80")) {
            $(".image_label").removeClass("width_80");
            $(".image_label").addClass("width_100");
            if (width<=425) {
                $(".image_label").removeClass("res_width_49");
                $(".image_label").addClass("res_width_100");
                if (image_size==5) {
                    $(".image_label").removeClass("res_width_100");
                    $(".image_label").addClass("res_width_49");
                }
            }
        } 
        else if ($(".image_label").hasClass("width_60")) {
            $(".image_label").removeClass("width_60");
            $(".image_label").addClass("width_80");
            if (width<=425) {
                $(".image_label").removeClass("res_width_100");
                $(".image_label").addClass("res_width_49");
                if (image_size==6) {
                    $(".image_label").removeClass("res_width_49");
                    $(".image_label").addClass("res_width_100");
                }
            }
        }
        else if ($(".image_label").hasClass("width_40")) {
            $(".image_label").removeClass("width_40");
            $(".image_label").addClass("width_60");
            if (width<=425) {
                $(".image_label").removeClass("res_width_49");
                $(".image_label").addClass("res_width_100");
                if (image_size==7) {
                    $(".image_label").removeClass("res_width_100");
                    $(".image_label").addClass("res_width_49");
                }
            }
        }
        else if ($(".image_label").hasClass("width_20")) {
            $(".image_label").removeClass("width_20");
            $(".image_label").addClass("width_40");
            if (width<=425) {
                $(".image_label").removeClass("res_width_100");
                $(".image_label").addClass("res_width_49");
                if (image_size==8) {
                    $(".image_label").removeClass("res_width_49");
                    $(".image_label").addClass("res_width_100");
                }
            }
        }
        else if ($(".image_label").hasClass("width_100")) {
            $(".image_label").removeClass("width_100");
            $(".image_label").removeClass("display_none");
            $(".image_label").addClass("width_20");
            if (width<=425) {
                $(".image_label").removeClass("res_width_49");
                $(".image_label").addClass("res_width_100");
                if (image_size==9) {
                    $(".image_label").removeClass("res_width_100");
                    $(".image_label").addClass("res_width_49");
                }
            }
        }
    });

    if (gon.image_number == 0) {
        $(".image_label").addClass("width_100");
    }
    else if (gon.image_number == 1) {
        $(".image_label").addClass("width_80");
        if (width<=425) {
            $(".image_label").addClass("res_width_49");
        }
    }
    else if (gon.image_number == 2) {
        $(".image_label").addClass("width_60");
        if (width<=425) {
            $(".image_label").addClass("res_width_100");
        }
    }
    else if (gon.image_number == 3) {
        $(".image_label").addClass("width_40");
        if (width<=425) {
            $(".image_label").addClass("res_width_49");
        }
    }
    else if (gon.image_number == 4) {
        $(".image_label").addClass("width_20");
        if (width<=425) {
            $(".image_label").addClass("res_width_100");
        }
    }
    else if (gon.image_number == 5) {
        $(".image_label").addClass("width_100");
        if (width<=425) {
            $(".image_label").addClass("res_width_49");
        }
    }
    else if (gon.image_number == 6) {
        $(".image_label").addClass("width_80");
        if (width<=425) {
            $(".image_label").addClass("res_width_100");
        }
    }
    else if (gon.image_number == 7) {
        $(".image_label").addClass("width_60");
        if (width<=425) {
            $(".image_label").addClass("res_width_49");
        }
    }
    else if (gon.image_number == 8) {
        $(".image_label").addClass("width_40");
        if (width<=425) {
            $(".image_label").addClass("res_width_100");
        }
    }
    else if (gon.image_number == 9) {
        $(".image_label").addClass("width_20");
        if (width<=425) {
            $(".image_label").addClass("res_width_49");
        }
    }
    else if (gon.image_number == 10) {
        $(".image_label").addClass("width_100");
        $('.image_label').addClass(`display_none`);
    }

});
