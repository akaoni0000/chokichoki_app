class Hairdresser < ApplicationRecord
    attr_accessor :activation_token #仮想的にカラムをつくる
    before_create :create_column #新しくカラムがデータが保存される前に呼ばれる(saveの前)
    
    def create_new_token #ランダムにトークンを発行
        SecureRandom.urlsafe_base64
    end

    def create_activation_digest(token) #渡された文字列のハッシュ値(暗号)を返す gem 'bcrypt', '~> 3.1.7'が必要
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
        BCrypt::Password.create(token, cost: cost)
    end

    def create_column
        self.activation_token  = create_new_token #accessorで作った仮想カラムに値を入れる
        self.activation_digest = create_activation_digest(self.activation_token)
        self.activation_deadline_at = Time.now + 600
    end

    #nameカラム
    validates :name,
        length: { in: 2..10, message: "は2文字以上10文字以内で入力してください" },
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

    #addressカラム
    validates :address, presence: true

    #緯度経度カラム
    validates :shop_latitude, presence: true
    validates :shop_longitude, presence: true

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
    has_many :menus, dependent: :destroy
    has_many :reservations, through: :menus
    has_many :hairdresser_comments
    has_many :chats

end
