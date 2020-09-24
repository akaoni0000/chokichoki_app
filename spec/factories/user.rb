FactoryBot.define do
    factory :user do 
        id {1}
        name {"あいこ"}
        email {"aaa@gmail.com"}
        password {"chokichoki"}
        sex {"女性"}
        activation_status {true}
    end
end