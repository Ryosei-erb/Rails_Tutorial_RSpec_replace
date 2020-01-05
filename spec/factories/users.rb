FactoryBot.define do
  factory :user do
    name {"Ryosei Yoshikawa"}
    email {"exapmle@example.com"}
    password { "paassword" }
    
    trait :invalid do
      name nil
    end
  end
  
end
