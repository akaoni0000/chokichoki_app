FactoryBot.define do
    factory :hairdresser_comment do 
        id {1}
        hairdresser_id {1}
        user_id {1}
        comment {"最高でした"}
        menu_id {1}
        start_time {"2020-09-07 15:30:00 +0900".to_time}
        rate {0.0}
    end
end