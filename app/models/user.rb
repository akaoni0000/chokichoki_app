class User < ApplicationRecord
    attr_accessor :activation_token #仮想的にカラムをつくる
    before_create :create_column #新しくカラムがデータが保存される前に呼ばれる(saveの前)
    
    def create_new_token #ランダムにトークンを発行
        SecureRandom.urlsafe_base64
    end

    def create_activation_digest(token) #渡された文字列のハッシュ値(暗号)を返す gem 'bcrypt', '~> 3.1.7'が必要
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(token, cost: cost)
    end

    def create_column
        self.activation_token = create_new_token #accessorで作った仮想カラムに値を入れる
        self.activation_digest = create_activation_digest(self.activation_token)
        self.activation_deadline_at = Time.now + 600
    end

    #バリデーション
    #nameカラム
    validates :name,
        length: { in: 2..10, message: "は2文字以上20文字以内で入力してください" },
        uniqueness: { message: "はすでに存在します" }

    #emailカラム
    validates :email,
        format: { with: /\A\S+@\S+\.\S+\z/, message: "と認識されませんでした" },
        uniqueness: { message: "はすでに存在します" }

    #passoword_digestカラム
    has_secure_password #パスワードを暗号化して保存するにはこの記述が必要 presenceとpasswordとpassword_confirmationの一致のバリデーションも兼ねている
    validates :password, length: { in: 6..20, message: "は6文字以上20文字以内で入力してください" }, on: :create #これをしないとpasswordを更新しないupdateのときも求められる 

    #sexカラム
    validates :sex, presence: { message: "を選択してください" }

    #モデルの関連付け
    has_many :reservations
    has_many :hairdresser_comments
    has_many :cancel_reservations
    has_many :chats
    has_many :favorites

end


#gem 'bcrypt'とhas_secure_passwordにより次の機能が使える
# セキュアにハッシュ化したパスワードを、データベース内のpassword_digestという属性に保存できるようになる。
# 2つのペアの仮想的な属性（passwordとpassword_confirmation）が使えるようになる。また、存在性と値が一致するかどうかのバリデーションも追加される 。
# authenticateメソッドが使えるようになる（引数の文字列がパスワードと一致するとUserオブジェクトを、間違っているとfalseを返すメソッド）。