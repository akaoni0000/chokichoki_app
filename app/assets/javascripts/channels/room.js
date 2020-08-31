App.room = App.cable.subscriptions.create("RoomChannel", {
    connected: function() { //フロントをしっかりと監視できているとき発動 更新やブラウザバックで発動
        //App.room.report("fdafda");
        
    },

    disconnected: function() {

    },

    received: function(data) {//バックエンドから送れられてきたデータをここで受け取る //ハッシュで送られてくる //アプリを開いている全てのユーザーがここを通る
        data_number = Object.keys(data).length
        if (data_number == 5) { //チャットでメッセージが送られてきた時
            var room_token = data["room_token"];
            var html = data["html"]
            var user_or_hairdresser = data["user_or_hairdresser"]
            var img_html = data["img_html"]
            var message = data["message"];
            $.ajax({ //送ったメッセージを既読にする
                type:'POST', 
                url: '/notification', 
                data: {data: data}, // コントローラへフォームの値を送信します
                dataType: 'jsonp' // データの型はjsonpでjsになる jsonでjson
            });
            $(`#room-${room_token}`).append(html);

            if ($(`#chat_room_${room_token}`).children("div").hasClass(`unread_number_${room_token}`)) {
                pre_num = $(`.unread_number_${room_token}`).children("p").text();
                num = Number(pre_num);
                var new_num = num + 1;
                var num_html =  `
                                    <div class="inline_block unread_number unread_number_${room_token}">
                                        <p>${new_num}</p>
                                    </div>
                                `
            } 
            else {
                var num_html =  `
                                    <div class="inline_block unread_number unread_number_${room_token}">
                                        <p>1</p>
                                    </div>
                                `
            }
            $(`.unread_number_${room_token}`).remove(); //viewにある要素を削除
            $(`#chat_room_${room_token}`).append(num_html) //新しい要素を入れる

            if (user_or_hairdresser == "user") { //送信した人がuser
                if ($(`#room-${room_token}`).hasClass("hairdresser")) { //userが送信した相手(美容師)がチャットルームにいた時
                    $(".create1").removeClass("myself"); 
                    $(".create1").addClass("opponent");
                    $(".create2").removeClass("myself_chat"); 
                    $(".create2").addClass("opponent_chat"); 
                    $(".create1").prepend(`${img_html}`);
                    $('.time_create').before($('.create2'));
                    $.ajax({ //送ったメッセージを既読にする
                        type:'POST', 
                        url: '/notification', 
                        data: {room_token: room_token}, // コントローラへフォームの値を送信します
                        dataType: 'jsonp' // データの型はjsonpでjsになる jsonでjson
                    });
                    $(`.unread_number_${room_token}`).remove();

                    var scroll_from_top = $(`#room-${room_token}`).scrollTop();     //上からスクロールした距離
                    var windowHeight = $(`#room-${room_token}`)[0].scrollHeight   //画面の高さ
                    var scroll_from_bottom = windowHeight - scroll_from_top
                    if (650<=scroll_from_bottom && scroll_from_bottom<= 750) {
                        $(`#room-${room_token}`).scrollTop($(`#room-${room_token}`)[0].scrollHeight);
                    }
                    else {
                        $(`#room-${room_token}`).prepend(`<p class="chat_insert">新しいメッセージ：${message}</p>`)
                        setTimeout(function(){ 
                            $(".chat_insert").remove();
                        },6500);  
                    }
                    
                }
                if ($(`#room-${room_token}`).hasClass("user")) { //送信したときにチャットルームにいるかどうか   送信するにはチャットルームにいなくてはいけないので必ず起こる
                    $(`#room-${room_token}`).scrollTop($(`#room-${room_token}`)[0].scrollHeight);
                    $(`.unread_number_${room_token}`).remove();
                }
            }
            else if (user_or_hairdresser == "hairdresser") { //送信した人がhairdresser
                if ($(`#room-${room_token}`).hasClass("user")) {  //美容師が送信した相手(客)がチャットルームにいた時
                    $(".create1").removeClass("myself"); 
                    $(".create1").addClass("opponent");
                    $(".create2").removeClass("myself_chat"); 
                    $(".create2").addClass("opponent_chat");
                    $(".create1").prepend(`${img_html}`);
                    $('.time_create').before($('.create2')); 
                    $.ajax({
                        type:'POST', 
                        url: '/notification', 
                        data: {room_token: room_token}, // コントローラへフォームの値を送信します
                        dataType: 'jsonp' // データの型はjsonpでjsになる jsonでjson
                    });  
                    $(`.unread_number_${room_token}`).remove();
                    var scroll_from_top = $(`#room-${room_token}`).scrollTop();     //上からスクロールした距離
                    var windowHeight = $(`#room-${room_token}`)[0].scrollHeight   //画面の高さ
                    var scroll_from_bottom = windowHeight - scroll_from_top
                    if (650<=scroll_from_bottom && scroll_from_bottom<= 750) {
                        $(`#room-${room_token}`).scrollTop($(`#room-${room_token}`)[0].scrollHeight);
                    }
                    else {
                        $(`#room-${room_token}`).prepend(`<p class="chat_insert">新しいメッセージ：${message}</p>`)
                        setTimeout(function(){ 
                            $(".chat_insert").remove();
                        },6500);  
                    }
                    
                }
                if ($(`#room-${room_token}`).hasClass("hairdresser")) {
                    $(`#room-${room_token}`).scrollTop($(`#room-${room_token}`)[0].scrollHeight);
                    $(`.unread_number_${room_token}`).remove();
                }
            }
            $(".create1").removeClass("create1"); 
            $(".create2").removeClass("create2"); 
            $('.time_create').removeClass("time_create");

            if ( 1 <= message.length && message.length <= 32 ) {
                $(`.chat_last_message_room_${room_token}`).text(message);
            }
            else if ( 33 <= message.length ) {
                $(`.chat_last_message_room_${room_token}`).text(message.substr(0, 32)+"...");
            }
            else {
                $(`.chat_last_message_room_${room_token}`).text("写真を送信しました");
            }
        }
        else {
            var user_or_hairdresser = data["user_or_hairdresser"];
            var room_token = data["room_token"];
            if (user_or_hairdresser == "user") { //最後にメッセージを送信した人がuser(客)
                if ($(`#room-${room_token}`).hasClass("user")) {
                    $('.not_read').each(function(){ 
                        $(this).prepend(`<div class="notice"><p>既読</p></div>`)           //fadeinクラスすべて順番に
                    });
                    $(".not_read").removeClass("not_read");
                } 
            }
            else if (user_or_hairdresser == "hairdresser") { //最後にメッセージを送信した人がhairdrsser(美容師)
                if ($(`#room-${room_token}`).hasClass("hairdresser")) {
                    $('.not_read').each(function(){ 
                        $(this).prepend(`<div class="notice"><p>既読</p></div>`)           //fadeinクラスすべて順番に
                    });
                    $(".not_read").removeClass("not_read");
                } 
            }
        }
    },

    speak: function(data1, data2, data3, data4, data5) { //フロントエンドからバックエンドにデータを送信できる
        return this.perform("speak", {html: data1, user_or_hairdresser: data2, room_token: data3, message: data4, img_html: data5}); //room_channel.rbのspeakアクションにいく
    }
});
