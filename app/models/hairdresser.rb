class Hairdresser < ApplicationRecord
    
    #nameカラム
    validates :name,
        length: { in: 2..20, message: "は2文字以上20文字以内で入力してください" },
        uniqueness: { message: "はすでに存在します" }
    
    #emailカラム
    validates :email,
        uniqueness: { message: "はすでに存在します" },
        format: { with: /\A\S+@\S+\.\S+\z/, message: "と認識されませんでした" }

    #shop_nameカラム
    validates :shop_name,
        length: { in: 2..20, message: "は2文字以上20文字以内で入力してください" }
    
    #post_numberカラム
    validates :post_number, format: { with: /\A\d{7}\z/, message: "は半角でハイフンなしの7桁の数字を入力してください"}

    #confirm_image_idカラム
    validates :confirm_image, presence: { message: "を入力してください" }

    #passoword_digestカラム
    has_secure_password    #パスワードを暗号化して保存するにはこの記述が必要 presenceとpasswordとpassword_confirmationの一致のバリデーションも兼ねている
    validates :password, length: { in: 6..20, message: "は6文字以上20文字以内で入力してください" }, on: :create #これをしないとpasswordを更新しないupdateのときも求められる 

    #sexカラム
    validates :sex, presence: { message: "を選択してください" }
    
    #gem refile を使う時
    attachment :confirm_image 
    attachment :hairdresser_image 
    

    #モデルの関連付け
    has_many :menus
    has_many :reservations, through: :menus
    has_many :hairdresser_comments
    has_many :chats
    #has_many :style_images

end
