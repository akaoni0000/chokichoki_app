class SearchController < ApplicationController

    def search_index
        if params[:turn] == "2"
            gon.turn = 2            #jsで要素の順番を変える
        elsif params[:turn] == "3"
            gon.turn = 3            #jsで要素の順番を変える         
        elsif params[:turn] == "4" 
            gon.turn = 4            #jsで要素の順番を変える             
        elsif params[:turn] == "5"
            gon.turn = 5            #jsで要素の順番を変える
        elsif params[:turn] == "6"
            gon.turn = 6            #jsで要素の順番を変える
        end

        #select_formで使う配列を作る 要素は今日の日付から2ヶ月の日にち」
        @select_day_arry = []
        for i in 0..60 do
            @day = Date.today + i
            @select_day_arry.push("#{@day.month}月#{@day.day}日 (#{%w(日 月 火 水 木 金 土)[@day.wday]})")
        end
        @select_day_arry.unshift("指定しない")
        
        #単純に都道府県のように打ち込むのは面倒なので工夫した
        @select_time_arry_start = []
        for i in 0..34 do 
            @time = Time.local(2000,1,1) + 3600*6    
            @time += 60 * 30 * i  
            if @time.hour.to_s.length == 1
                @time_hour = 0.to_s + @time.hour.to_s
            else
                @time_hour = @time.hour
            end
            if @time.min == 0
                @time_min = "00"
            else
                @time_min = @time.min
            end
            @select_time_arry_start.push("#{@time_hour}:#{@time_min}")
        end

        @select_time_arry_finish = []
        for i in 1..35 do 
            @time = Time.local(2000,1,1) + 3600*6    
            @time += 60 * 30 * i  
            if @time.hour.to_s.length == 1
                @time_hour = 0.to_s + @time.hour.to_s
            else
                @time_hour = @time.hour
            end
            if @time.min == 0
                @time_min = "00"
            else
                @time_min = @time.min
            end
            @select_time_arry_finish.push("#{@time_hour}:#{@time_min}")
        end


        @select_prefecture_arry = [
            "都道府県",
            "北海道","青森県","秋田県","岩手県","山形県","宮城県","福島県",
            "群馬県","栃木県","茨城県","埼玉県","東京都","千葉県","神奈川県",
            "新潟県","富山県","石川県","福井県","山梨県","長野県",
            "岐阜県","静岡県","愛知県","三重県",
            "滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県",
            "鳥取県","島根県","岡山県","広島県","山口県",
            "徳島県","香川県","愛媛県","高知県",
            "福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"
        ]

        @select_rate_start = [
            0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5
        ]

        @select_rate_finish = [
            0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5
        ]
    end

    def search_data #小さい検索フォームから送られる時
        @keyword = params[:search_keyword]
        if @keyword == ""
            @hairdressers = Hairdresser.page(params[:page]).per(35)
        else
            @keyword = @keyword.tr('　+',' +') #全角スペースを半角スペースにする
            @keyword.strip! #スペースを削除
            @hairdressers = Hairdresser.where(['name LIKE ?', "%#{@keyword}%"]).page(params[:page]).per(35)
            @menus_arry = []
            if @keyword.include?("カット")
                @menus_arry1 = Menu.all.select {|menu| menu.category.slice(0,1) == "1" && menu.status == true}
            end
            if @keyword.include?("カラー")
                @menus_arry2 = Menu.all.select {|menu| menu.category.slice(1,1) == "1" && menu.status == true}
            end
            if @keyword.include?("縮毛")
                @menus_arry3 = Menu.all.select {|menu| menu.category.slice(2,1) == "1" && menu.status == true}
            end
            if @keyword.include?("パーマ")
                @menus_arry4 = Menu.all.select {|menu| menu.category.slice(3,1) == "1" && menu.status == true}
            end
            @menus_arry5 = Menu.where(['name LIKE ?', "%#{@keyword}%"]) & Menu.where(status: true)

            @menus_arry = @menus_arry.push(@menus_arry1).push(@menus_arry2).push(@menus_arry3).push(@menus_arry4).push(@menus_arry5)
            @menus_arry.flatten!
            @menus_arry.uniq!
            @menus_arry.delete(nil)
            @menus = Kaminari.paginate_array(@menus_arry).page(params[:page]).per(10)
        end
        if @hairdressers.blank? && @menus.blank?
            @none = "該当する情報がありません"
        end
        render "hairdressers/index"
    end

    def top_hairdresser
        @hairdressers = Hairdresser.select {|hairdresser| hairdresser.hairdresser_comments.length >= 5 && hairdresser.reputation_point/hairdresser.hairdresser_comments.length >= 4.5}
        @hairdressers = Kaminari.paginate_array(@hairdressers).page(params[:page]).per(10)
        if @hairdressers.blank? 
            @none = "該当する情報がありません"
        end
        render "hairdressers/index"
    end

    def today_hairdresser_and_menu
        @reservations = Reservation.where(start_time: Time.now .. Time.now.end_of_day, user_id: nil).joins(:menu).where(menus: { status: true })
        if @reservations.present?
            @menus = @reservations.map {|reservation| reservation.menu}.uniq!
            @hairdressers = @menus.map {|menu| menu.hairdresser}
            @menus = Kaminari.paginate_array(@menus).page(params[:page]).per(10)
            @hairdressers = Kaminari.paginate_array(@hairdressers).page(params[:page]).per(35)
            render "hairdressers/index"
        else
            @menus = []
            @hairdressers = []
            @none = "該当する情報がありません"
            render "hairdressers/index"
        end
    end

    def tomorrow_hairdresser_and_menu
        @reservations = Reservation.where(start_time: (Time.now + 3600*24) .. (Time.now + 3600*24).end_of_day, user_id: nil).joins(:menu).where(menus: { status: true })
        if @reservations.present?
            @menus = @reservations.map {|reservation| reservation.menu}.uniq!
            @hairdressers = @menus.map {|menu| menu.hairdresser}
            @menus = Kaminari.paginate_array(@menus).page(params[:page]).per(10)
            @hairdressers = Kaminari.paginate_array(@hairdressers).page(params[:page]).per(35)
            render "hairdressers/index"
        else
            @menus = []
            @hairdressers = []
            @none = "該当する情報がありません"
            render "hairdressers/index"
        end
    end
    
    #二つの緯度経度を入力すれば距離(km)がでる
    module GetDistance
        def self.distance(lat1, lng1, lat2, lng2)
          # ラジアン単位に変換
          x1 = lat1.to_f * Math::PI / 180
          y1 = lng1.to_f * Math::PI / 180
          x2 = lat2.to_f * Math::PI / 180
          y2 = lng2.to_f * Math::PI / 180
     
          # 地球の半径 (km)
          radius = 6378.137
     
          # 差の絶対値
          diff_y = (y1 - y2).abs
     
          calc1 = Math.cos(x2) * Math.sin(diff_y)
          calc2 = Math.cos(x1) * Math.sin(x2) - Math.sin(x1) * Math.cos(x2) * Math.cos(diff_y)
     
          # 分子
          numerator = Math.sqrt(calc1 ** 2 + calc2 ** 2)
     
          # 分母
          denominator = Math.sin(x1) * Math.sin(x2) + Math.cos(x1) * Math.cos(x2) * Math.cos(diff_y)
     
          # 弧度
          degree = Math.atan2(numerator, denominator)
     
          # 大円距離 (km)
          degree * radius
        end
    end 

    def strong_search #それぞれの条件にあうデータを配列で取得して最後に共通な要素で配列を作る
        #メニューカテゴリー #メニューが優先 メニューから絞る
        @menu_number = params[:category1] + params[:category2] + params[:category3] + params[:category4]
        if @menu_number == "0000"
            @menus_from_category = Menu.where(status: true)
            @hairdressers_from_category = Hairdresser.all
        else
            @menus_from_category = []
            if params[:category1] == "1" 
                @menus_from_category1 = Menu.all.select {|menu| menu.category.slice(0,1) == "1" && menu.status == true}
            else
                @menus_from_category1 = []
            end
            if params[:category2] == "1" 
                @menus_from_category2 = Menu.all.select {|menu| menu.category.slice(1,1) == "1" && menu.status == true}
            else 
                @menus_from_category2 = []
            end
            if params[:category3] == "1" 
                @menus_from_category3 = Menu.all.select {|menu| menu.category.slice(2,1) == "1" && menu.status == true}
            else 
                @menus_from_category3 = []
            end
            if params[:category4] == "1" 
                @menus_from_category4 = Menu.all.select {|menu| menu.category.slice(3,1) == "1" && menu.status == true}
            else 
                @menus_from_category4 = []
            end
            @menus_from_category = @menus_from_category.push(@menus_from_category1).push(@menus_from_category2).push(@menus_from_category3).push(@menus_from_category4)
            @menus_from_category.flatten!
            @menus_from_category.uniq!
            @hairdressers_from_category = @menus_from_category.map {|a| a.hairdresser}
        end

        #予約時間 #メニューが優先 メニューから絞る
        if params[:day] != "指定しない"
            @date =  Date.today.year.to_s + "-" + params[:day].delete("日").sub(/月/, '-')
            @date = @date.to_date
            if params[:start_time] == nil #ブラウザバックしてそのまま検索ボタンを押した時
                @start_time = "06:00".to_time
                @finish_time = "23:00".to_time
            else
                @start_time = params[:start_time].to_time
                @finish_time = params[:finish_time].to_time
            end
            if Date.today <= @date
                @min_time = Time.new(Date.today.year, @date.month, @date.day, @start_time.hour, @start_time.min)
                @max_time = Time.new(Date.today.year, @date.month, @date.day, @finish_time.hour, @finish_time.min)
            else
                @min_time = Time.new(Date.today.year+1, @date.month, @date.day, @start_time.hour, @start_time.min)
                @max_time = Time.new(Date.today.year+1, @date.month, @date.day, @finish_time.hour, @finish_time.min)
            end
            @reservations = Reservation.where(start_time: @min_time..@max_time).joins(:menu).where(menus: { status: true }) #親モデルのmenuのstatusがtrueのreservationを検索
            @menus_from_time = @reservations.map {|a| a.menu}
            @hairdressers_from_time = @menus_from_time.map {|a| a.hairdresser}
        else
            @menus_from_time = Menu.where(status: true)
            @hairdressers_from_time = Hairdresser.all
        end
    
        #現在地 #人が優先 人から絞る
        if params[:current_lat].present? && params[:current_lng].present? 
            @current_lat = params[:current_lat].to_f
            @current_lng = params[:current_lng].to_f
            @range = params[:range].to_i
            
            @hairdresser_arry = Hairdresser.all.select {|hairdresser| GetDistance.distance(@current_lat, @current_lng, hairdresser.shop_latitude, hairdresser.shop_longitude).round(2) <= @range}
            @hairdressers_from_area = @hairdresser_arry
            @menus_from_area = @hairdresser_arry.map {|a| a.menus}
            @menus_from_area.flatten!
            @menus_from_area = @menus_from_area.select {|menu| menu.status == true}
        else #エリア #人が優先 人から絞る
            @prefecture = params[:prefectures]
            @place_name = params[:place_name]
            @hairdressers1 = Hairdresser.where(['address LIKE ?', "%#{@prefecture}%"])
            @hairdressers2 = Hairdresser.where(['address LIKE ?', "%#{@place_name}%"]) #@place_name=""のときはHairdresser.all
            if params[:prefectures] == "都道府県"
                @hairdressers1 = Hairdresser.all
            end
            @hairdressers_from_area = @hairdressers1 & @hairdressers2
            @menus_from_area = @hairdressers_from_area.map {|a| a.menus}
            @menus_from_area.flatten!
            @menus_from_area = @menus_from_area.select {|menu| menu.status == true}
        end

        #評価 #人が優先 人から絞る
        @min_rate = params[:start_rate].to_i
        @max_rate = params[:finish_rate].to_i
        @hairdressers_from_reputation = Hairdresser.select {|hairdresser| @min_rate <= hairdresser.reputation_point/hairdresser.hairdresser_comments.where.not(rate: 0.0).length && hairdresser.reputation_point/hairdresser.hairdresser_comments.where.not(rate: 0.0).length <= @max_rate}
        if @min_rate == 0
            @hairdressers_from_reputation.push(Hairdresser.where(reputation_point: 0.0))
            @hairdressers_from_reputation.flatten!
        end
        @menus_from_reputation = @hairdressers_from_reputation.map {|a| a.menus}
        @menus_from_reputation.flatten!
        @menus_from_reputation = @menus_from_reputation.select {|menu| menu.status == true}

        #性別 #人が優先 人から絞る
        if params[:sex].present?
            @hairdressers_from_sex = Hairdresser.where(sex: params[:sex])
            @menus_from_sex = @hairdressers_from_sex.map {|a| a.menus}
            @menus_from_sex.flatten!
            @menus_from_sex = @menus_from_sex.select {|menu| menu.status == true}
        else
            @hairdressers_from_sex = Hairdresser.all
            @menus_from_sex = Menu.where(status: true)
        end
   
        #キーワード
        @keyword = params[:search_keyword]
        if @keyword == ""
            @hairdressers_from_keyword = Hairdresser.all
            @menus_from_keyword = Menu.where(status: true)
        else
            @keyword = @keyword.tr('　+',' +')  #全角スペースを半角スペースにする
            @keyword.strip! #半角スペースを削除
            @hairdressers_from_keyword = Hairdresser.where(['name LIKE ?', "%#{@keyword}%"])
            @menus_from_keyword = []
            if @keyword.include?("カット")
                @menus_from_keyword1 = Menu.all.select {|menu| menu.category.slice(0,1) == "1" && menu.status == true}
            end
            if @keyword.include?("カラー")
                @menus_from_keyword2 = Menu.all.select {|menu| menu.category.slice(1,1) == "1" && menu.status == true}
            end
            if @keyword.include?("縮毛")
                @menus_from_keyword3 = Menu.all.select {|menu| menu.category.slice(2,1) == "1" && menu.status == true}
            end
            if @keyword.include?("パーマ")
                @menus_from_keyword4 = Menu.all.select {|menu| menu.category.slice(3,1) == "1" && menu.status == true}
            end
            @menus_from_keyword5 = Menu.where(['name LIKE ?', "%#{@keyword}%"]) & Menu.where(status: true)
            @menus_from_keyword = @menus_from_keyword.push(@menus_from_keyword1).push(@menus_from_keyword2).push(@menus_from_keyword3).push(@menus_from_keyword4).push(@menus_from_keyword5)
            @menus_from_keyword.flatten!
            @menus_from_keyword.uniq!
        end

        @hairdressers = @hairdressers_from_category & @hairdressers_from_time & @hairdressers_from_area & @hairdressers_from_reputation & @hairdressers_from_sex & @hairdressers_from_keyword
        @menus = @menus_from_category & @menus_from_time & @menus_from_area & @menus_from_reputation & @menus_from_sex & @menus_from_keyword
        
        @hairdressers.delete(nil)
        @menus.delete(nil)
        @hairdressers = Kaminari.paginate_array(@hairdressers).page(params[:page]).per(35)
        @menus = Kaminari.paginate_array(@menus).page(params[:page]).per(10)

        if @hairdressers.blank? && @menus.blank?
            @none = "該当する情報がありません"
        end

        render "hairdressers/index"
    end

end
