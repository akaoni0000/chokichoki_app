class UserCardsController < ApplicationController
    skip_before_action :verify_authenticity_token  #『Can't verify CSRF token authenticity』エラー対策

    def create
        Payjp.api_key = ENV['SECRET_KEY'] #秘密鍵
        begin
            customer = Payjp::Customer.create(   #Payjp::Customerはモデル カラムはpayjpサイトの顧客詳細でみれる 顧客idは自動で作成
                description: '登録テスト',             #payjpのサイトの顧客詳細の備考に登録される なくてもいい 顧客情報を保存
                email: @current_user.email,           #payjpのサイトの顧客詳細の備考に登録される なくてもいい 顧客情報を保存
                card: params['payjp-token'],         #絶対に必要 カード情報を保存
                metadata: {user_id: @current_user.id} #payjpのサイトのmetadataに登録される なくてもいい 顧客情報を保存
            )
            @card = UserCard.new(user_id: @current_user.id, customer_id: customer.id, card_id: customer.default_card)  #customer.idはpayjpサイトの顧客id customer.default_cardはpayjpサイトのカードID
            @card.save
            flash[:notice] = "カード情報を登録しました"
        rescue
            flash[:notice_red] = "カード番号は424242424242に設定してください。"
        end
        redirect_to edit_user_path(@current_user.id)
    end

    def destroy #PayjpとCardデータベースを削除する
        card = UserCard.find_by(user_id: @current_user.id)
        Payjp.api_key = ENV['SECRET_KEY']   #秘密鍵
        customer = Payjp::Customer.retrieve(card.customer_id)  #payjpサイトの顧客情報を取得
        customer.delete
        card.delete
        flash[:notice] = "カード情報を削除しました"
        redirect_to edit_user_path(@current_user.id)
    end

end
