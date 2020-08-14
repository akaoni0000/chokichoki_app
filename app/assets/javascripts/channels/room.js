App.room = App.cable.subscriptions.create("RoomChannel", {
    connected: function() { //フロントをしっかりと監視できているとき発動
      console.log("dfafa");
    },
    disconnected: function() {

    },
    received: function(data) {//バックエンドから送れられてきたデータをここで受け取る
        var room_id = data["room_id"]
        $(`#room-${room_id}`).append(data["html"]);
        //height = $(document).height()
        if (gon.user_id) {
            user_id = gon.user_id
            $(`.user-${user_id}`).scrollTop($(`.user-${user_id}`)[0].scrollHeight);
        } 
        else if (gon.hairdresser_id) {
            hairdresser_id = gon.hairdresser_id
            $(`.hairdresser-${hairdresser_id}`).scrollTop($(`.hairdresser-${hairdresser_id}`)[0].scrollHeight);
        }
    },

    speak: function(data1, data2) { //フロントエンドからバックエンドにデータを送信できる
        return this.perform("speak", {html: data1, room_id: data2}) //room_channel.rbのspeakアクションにいく
    }
});
