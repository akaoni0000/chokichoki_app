class User < ApplicationRecord
    #バリデーション
    #nameカラム
    validates :name,
        length: { in: 2..20, message: "は2文字以上20文字以内で入力してください" },
        uniqueness: { message: "はすでに存在します" }
    
    #emailカラム
    validates :email,
        uniqueness: { message: "はすでに存在します" },
        format: { with: /\A\S+@\S+\.\S+\z/, message: "と認識されませんでした" }
    
    #phone_numberカラム
    validates :phone_number, format: { with: /\A\d{10,11}\z/, message: "は10桁または11桁の半角数字で入力してください" }

    #passoword_digestカラム
    has_secure_password    #パスワードを暗号化して保存するにはこの記述が必要 presenceとpasswordとpassword_confirmationの一致のバリデーションも兼ねている
    validates :password, length: { in: 6..20, message: "は6文字以上20文字以内で入力してください" } 

    #sexカラム
    validates :sex, presence: { message: "を選択してください" }


    #モデルの関連付け
    has_many :reservations
    has_many :hairdresser_comments
    has_many :cancel_reservations
end
