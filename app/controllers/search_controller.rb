class SearchController < ApplicationController

    def search_index
        if params[:turn] == "2"
            gon.turn = 2
        elsif params[:turn] == "3"
            gon.turn = 3
        elsif params[:turn] == "4"
            gon.turn = 4
        elsif params[:turn] == "5"
            gon.turn = 5
        end

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
            0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5
        ]

        @select_rate_finish = [
            1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5
        ]
    end

    def search_data
        @keyword = params[:search_keyword]
        if @keyword == ""
            @hairdressers = Hairdresser.all
        else
            @keyword = @keyword.tr('　+',' +')
            @keyword.strip!
            @hairdressers = Hairdresser.where(['name LIKE ?', "%#{@keyword}%"])
            @menus = []
            if @keyword.include?("カット")
                @menu_all = Menu.all
                @menu_all.each do |menu|
                    if menu.category.slice(0,1).include?("1")
                        @menus.push(menu)
                    elsif menu.name.include?("#{@keyword}")
                        @menus.push(menu)
                    end
                end
            elsif @keyword.include?("カラー")
                @menu_all = Menu.all
                @menu_all.each do |menu|
                    if menu.category.slice(1,1).include?("1")
                        @menus.push(menu)
                    elsif menu.name.include?("#{@keyword}")
                        @menus.push(menu)
                    end
                end
            elsif @keyword.include?("縮毛")
                @menu_all = Menu.all
                @menu_all.each do |menu|
                    if menu.category.slice(2,1).include?("1")
                        @menus.push(menu)
                    elsif menu.name.include?("#{@keyword}")
                        @menus.push(menu)
                    end
                end
            elsif @keyword.include?("パーマ")
                @menu_all = Menu.all
                @menu_all.each do |menu|
                    if menu.category.slice(3,1).include?("1")
                        @menus.push(menu)
                    elsif menu.name.include?("#{@keyword}")
                        @menus.push(menu)
                    end
                end
            else
                @menus = Menu.where(['name LIKE ?', "%#{@keyword}%"])
            end
        end
        if @hairdressers.blank? && @menus.blank?
            @none = "該当する情報がありません"
        end
        render "hairdressers/index"
    end



end
