class HomeController < ApplicationController
    def user_top
        #人気美容師 口コミが5件以上あり、評価平均が4.5以上の美容師のデータを取得
        @hairdressers = Hairdresser.select {|hairdresser| hairdresser.hairdresser_comments.length >= 5 && hairdresser.reputation_point/hairdresser.hairdresser_comments.where.not(rate: 0.0).length >= 4.5}

        #評判の美容師 口コミが3件以上あり、評価平均が4以上の美容師のデータをメニューのカテゴリーごとに取得
        # @hairdressers_for_reputation = Hairdresser.select {|hairdresser| hairdresser.hairdresser_comments.length >= 3 && hairdresser.reputation_point/hairdresser.hairdresser_comments.where.not(rate: 0.0).length >= 4}.sample(10)
        # @menus = @hairdressers_for_reputation.map {|hairdresser| hairdresser.menus}
        # @menus.flatten!

        # @cut_menus = @menus.select {|menu| menu.category[0,1] == "1"}
        # @color_menus = @menus.select {|menu| menu.category[1,1] == "1"}
        # @curly_menus = @menus.select {|menu| menu.category[2,1] == "1"}
        # @parma_menus = @menus.select {|menu| menu.category[3,1] == "1"}

        # @hairdresser_cut_id_arry = @cut_menus.map {|menu| menu.hairdresser_id}.uniq
        # @hairdresser_color_id_arry = @color_menus.map {|menu| menu.hairdresser_id}.uniq
        # @hairdresser_curly_id_arry = @curly_menus.map {|menu| menu.hairdresser_id}.uniq
        # @hairdresser_parma_id_arry = @parma_menus.map {|menu| menu.hairdresser_id}.uniq

        @menus = Menu.all
        @cut_menus = @menus.select {|menu| menu.category[0,1] == "1"}
        @hairdresser_cut_id_arry = @cut_menus.map {|menu| menu.hairdresser_id}.uniq
        #gon
        gon.body = "white" #jsで背景を変える
        gon.fix = "header" #jsでheaderを固定する
        
        #alertを出現させる
        if session[:double] == true
            gon.double = true
            session[:double] = nil
        end
    end

    def hairdresser_top
        #gon
        gon.body ="white"
        gon.fix = "header"
        gon.display_none = "none"
    end

    def about #aboutページ
        #FAQまでスクロールさせる
        if params[:faq]
            gon.faq = true
        end
    end

    def deadline #URLの有効期限が切れています のページ
    end

end
