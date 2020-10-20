FactoryBot.define do
    factory :menu do 
        id {1}
        hairdresser_id {1}
        name {"カラー"}
        time {30}
        explanation {"絶対にカッコよくします"}
        category {"1000"}
        status {true}
    end
end