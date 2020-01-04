FactoryBot.define do
  factory :user do
    name {"Ryosei Yoshikawa"}
    email {"exapmle@example.com"}
    password { "paassword" }
    
    trait :invalid do
      name nil
    end
  end
  
  factory :abc ,class: User do
    name {"abc"}
    email { "abc@example.com" }
    password { "password" }
  end
  
  factory :def ,class: User do
    name { "def" }
    email { "def@example.com" }
    password { "password" }
  end
end
