$(function() {
    //検索画面のviewに来た時に現在地を取得できるかチェック
    if (gon.turn == 4) {
        if(navigator.geolocation) {
        }
        else {
            alert("あなたの端末では、現在位置を取得できません。") ;
        }       
    }

    //現在地から探すをクリックした時に現在地を取得できるかチェック
    $("#current").click(function(){
        if(navigator.geolocation) {
        }
        else {
            alert("あなたの端末では、現在位置を取得できません。") ;
        }     
    })
    
    //検索するをクリックした時に現在地を取得できるかチェック
    $(".search_btn").on("click", function(e) {
        if ($("#current").hasClass("check")) {
            e.preventDefault();
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition( //現在地を取得しようとする
                    function( position ){ // [第1引数] 取得に成功した場合の関数
                        var data = position.coords ; 
                        var lat = data.latitude ; //緯度
                        var lng = data.longitude ; //経度
                        $("#strong_search_form").append(`<input type="hidden" name="current_lat" value=${lat} class="lat"></input>`)
                        $("#strong_search_form").append(`<input type="hidden" name="current_lng" value=${lng} class="lng"></input>`)
                    },
                    function(){ // [第2引数] 取得に失敗した場合の関数
                        alert("申し訳ありません。あなたの端末の位置情報を取得することができませんでした。")
                    } 
                ) ;
            }
            else {
                alert("申し訳ありません。あなたの端末の位置情報を取得することができませんでした。");
            }
            $(this).prop('disabled',true);//ボタンを無効化する
            setTimeout(function(){ //現在地を取得するのに少し時間がかかるので送信するタイミングを少しずらす 3.5秒たっても見つからない時があった
                $("#strong_search_form").submit(); 
                if (!$("input").hasClass("lat")) {
                    alert("申し訳ありません。あなたの端末の位置情報を取得することができませんでした。");
                }
            },3500);  
        }   
    })
})

$(function() {
    //正確な緯度経度を調べるための関数を定義
    function getLatLng(place) {
        var geocoder = new google.maps.Geocoder();
        geocoder.geocode({address: place}, 
            function(results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                var shop_lat = results[0].geometry.location.lat();
                var shop_lng = results[0].geometry.location.lng();
                $("#hairdresser_register_form").append(`<input type="hidden" name="hairdresser[shop_latitude]" value="${shop_lat}"></input>`);
                $("#hairdresser_register_form").append(`<input type="hidden" name="hairdresser[shop_longitude]" value="${shop_lng}"></input>`);
                setTimeout(function(){ //緯度経度を取得するのに少し時間がかかるので送信するタイミングを少しずらす
                    //$("#hairdresser_register_form").submit(); //これだとhtmlをリクエストすることになる
                    Rails.fire($("#hairdresser_register_form")[0], 'submit'); // application.jsでrequrireする必要がある
                },500);  
            } 
            else {
                //$("#hairdresser_register_form").submit(); 
                Rails.fire($("#hairdresser_register_form")[0], 'submit');
            }
        });
    }
    $("#hairdresser_btn").on("click", function(e) {
        e.preventDefault();
        var shop_address = $(".hairdresser_shop_address").val();
        getLatLng(shop_address);
    })
})
