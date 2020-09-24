FactoryBot.define do
    factory :menu do 
        id {1}
        name {"カット"}
        time {"2020-09-07 15:30:00 +0900".to_time}
        sex_status {0}
        explanation {"絶対にカッコよくします"}
        category {"1000"}
        status {true}
    end
end