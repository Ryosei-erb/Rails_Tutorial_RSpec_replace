FactoryBot.define do
  factory :user do
    name {"Ryosei Yoshikawa"}
    email {"exapmle@example.com"}
    password { "paassword" }
    
    # 99.times do |n|
    #   name {  "Rysoei Yoshikawa" }
    #   email { "exapmle#{n}@example.com" }
    #   password { "password" }
    # end
    
    
    trait :invalid do
      name nil
    end
  end
  
end
