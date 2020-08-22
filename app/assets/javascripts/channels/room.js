App.room = App.cable.subscriptions.create("RoomChannel", {
    connected: function() { //フロントをしっかりと監視できているとき発動 更新やブラウザバックで発動
        //App.room.report("fdafda");
    },

    disconnected: function() {

    },

    received: function(data) {//バックエンドから送れられてきたデータをここで受け取る
        data_number = Object.keys(data).length
        if (data_number == 5) {
            var room_token = data["room_token"];
            var html = data["html"]
            var user_or_hairdresser = data["user_or_hairdresser"]
            var img_html = data["img_html"]
            $(`#room-${room_token}`).append(html);

            if (user_or_hairdresser == "user") { //送信した人がuser
                if ($(`#room-${room_token}`).hasClass("hairdresser")) {
                    $(".create1").removeClass("myself"); 
                    $(".create1").addClass("opponent");
                    $(".create2").removeClass("myself_chat"); 
                    $(".create2").addClass("opponent_chat"); 
                    $(".create1").prepend(`${img_html}`);
                    $('.time_create').before($('.create2'));
                }
                if ($(`#room-${room_token}`).hasClass("user")) {
                    $(`#room-${room_token}`).scrollTop($(`#room-${room_token}`)[0].scrollHeight);
                }
            }
            else if (user_or_hairdresser == "hairdresser") { //送信した人がhairdresser
                if ($(`#room-${room_token}`).hasClass("user")) {
                    $(".create1").removeClass("myself"); 
                    $(".create1").addClass("opponent");
                    $(".create2").removeClass("myself_chat"); 
                    $(".create2").addClass("opponent_chat");
                    $(".create1").prepend(`${img_html}`);
                    $('.time_create').before($('.create2'));   
                }
                if ($(`#room-${room_token}`).hasClass("hairdresser")) {
                    $(`#room-${room_token}`).scrollTop($(`#room-${room_token}`)[0].scrollHeight);
                }
            }
            $(".create1").removeClass("create1"); 
            $(".create2").removeClass("create2"); 
            $('.time_create').removeClass("time_create");


            var message = data["message"];
            if ( 1 <= message.length && message.length <= 32 ) {
                $(`.chat_last_message_room_${room_token}`).text(message);
            }
            else if ( 33 <= message.length ) {
                $(`.chat_last_message_room_${room_token}`).text(message.substr(0, 32));
            }
            else {
                $(`.chat_last_message_room_${room_token}`).text("写真を送信しました");
            }
        }
    },

    speak: function(data1, data2, data3, data4, data5) { //フロントエンドからバックエンドにデータを送信できる
        return this.perform("speak", {html: data1, user_or_hairdresser: data2, room_token: data3, message: data4, img_html: data5}); //room_channel.rbのspeakアクションにいく
    }
});
