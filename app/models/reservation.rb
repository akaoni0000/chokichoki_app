class Reservation < ApplicationRecord
    
    belongs_to :menu, optional: true     #rollback transaction対策
    belongs_to :hairdresser, optional: true     #rollback transaction対策
    belongs_to :user, optional: true  #関連づけるとreservationsテーブルのデータを保存するときuser_idも必ず保存しなければならない
end
