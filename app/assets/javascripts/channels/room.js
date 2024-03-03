App.room = App.cable.subscriptions.create("RoomChannel", {
    connected: function() { //フロントをしっかりと監視できているとき発動 更新やブラウザバックで発動
        //App.room.report("fdafda");
        
    },

    disconnected: function() {

    },

    received: function(data) {//バックエンドから送れられてきたデータをここで受け取る //ハッシュで送られてくる //アプリを開いている全てのユーザーがここを通る
        // data_number = Object.keys(data).length
        //メッセージが送信された時
        if (data["type"] == "メッセージ送信") {
            //まず送られてきたデータを整理
            var room_token = data["room_token"];
            var user_or_hairdresser = data["user_or_hairdresser"] //誰に送信したか
            var digest = data["digest"]
            var message = data["message"]
            var time = data["time"]

            //送信先の人がチャットルームにいるとき
            if ($(`#room-${room_token}`).hasClass(`${digest}`) && $(`#room-${room_token}`).hasClass(`${user_or_hairdresser}`)) {
                $.ajax({ 
                    type:'POST', 
                    url: '/receive_message', 
                    data: {data: data}, // コントローラへフォームの値を送信します
                    dataType: 'jsonp' // データの型はjsonpでjsになる jsonでjson
                });
            }
            //送信先の人がチャットルームにいないとき でもチャットのページにはいる
            else if ($(`#chat_room_${room_token}`).hasClass(`${digest}`) && $(`#chat_room_${room_token}`).hasClass(`${user_or_hairdresser}`) && !$(`#chat_room_${room_token}`).hasClass("responsive")) {
                //未読の番号を更新する
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
                
                //最後のメッセージ更新する
                if (1 <= message.length && message.length <= 32) {
                    var last_message = message
                }
                else if (33 <= message.length) {
                    var last_message = message.substr(0, 32); + "..."
                }
                else {
                    var last_message = "画像を送信しました"
                }
                $(`#chat_room_${room_token}`).find(".chat_last_message").text(`${last_message}`);

                //時間を更新する
                $(`#chat_room_${room_token}`).find(".chat_room_time").text(`${time}`);

                //ルームの並び順を変える
                $("#search_form").after($(`#chat_${room_token}`));
            }
            //チャットページを開いていなくてログインしている状態
            else if ($(".instead_session").hasClass(`${digest}`) && $(".instead_session").hasClass(`${room_token}`)) {
                $.ajax({ 
                    type:'POST', 
                    url: '/notice/message', 
                    data: {data: data}, // コントローラへフォームの値を送信します
                    dataType: 'jsonp' // データの型はjsonpでjsになる jsonでjson
                });
            }
        }
        //既読をつけるために相手がルームに入ったとき ルームにいるときメッセージを受診したとき
        else if (data["type"] == "既読をつける") {
            //受け取ったデータを整理
            console.log("fasjifjasiofjai")
            var room_token = data["room_token"];
            var user_or_hairdresser = data["user_or_hairdresser"] //誰に送信したか
            var digest = data["digest"]

            //送信してきた人のメッセージの横に既読の文字をつける
            if ($(`#room-${room_token}`).hasClass(`${digest}`) && $(`#room-${room_token}`).hasClass(`${user_or_hairdresser}`)) {
                $('.not_read').each(function(){ 
                    $(this).prepend(`<div class="notice"><p>既読</p></div>`)           //fadeinクラスすべて順番に
                });
                $(".not_read").removeClass("not_read");
            }
        }
        //予約が入ったことを美容師に知らせる
        else if (data["type"] == "予約が入ったことを知らせる") {
            //受け取ったデータを整理
            var digest = data["digest"]
            var reservation_token = data["reservation_token"]

            if ($(".instead_session").hasClass(`${digest}`) && $(".instead_session_reservation").hasClass(`${reservation_token}`)) {
                $.ajax({ 
                    type:'POST', 
                    url: '/notice/reservation', 
                    data: {data: data}, // コントローラへフォームの値を送信します
                    dataType: 'jsonp' // データの型はjsonpでjsになる jsonでjson
                });
            }
        }
        //キャンセルが入ったことを美容師に知らせる
        else if (data["type"] == "キャンセルが入ったことを知らせる") {
            //受け取ったデータを整理
            var digest = data["digest"]
            var reservation_token = data["reservation_token"]

            if ($(".instead_session").hasClass(`${digest}`) && $(".instead_session_reservation").hasClass(`${reservation_token}`)) {
                $.ajax({ 
                    type:'POST', 
                    url: '/notice/cancel', 
                    data: {data: data}, // コントローラへフォームの値を送信します
                    dataType: 'jsonp' // データの型はjsonpでjsになる jsonでjson
                });
            }
        }
    },

    speak: function(data1, data2, data3, data4) { //フロントエンドからバックエンドにデータを送信できる
        return this.perform("speak", {html: data1, room_token: data2, user_or_hairdresser: data3, digest: data4}); //room_channel.rbのspeakアクションにいく
    }
    //使い方 App.room.speak(html, "aaa")
});
