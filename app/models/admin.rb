class Admin < ApplicationRecord
    has_secure_password #パスワードを暗号化して保存するにはこの記述が必要 presenceとpasswordとpassword_confirmationの一致のバリデーションも兼ねている
    validates :password, length: { in: 6..20, message: "は6文字以上20文字以内で入力してください" }, on: :create #これをしないとpasswordを更新しないupdateのときも求められる 
end
