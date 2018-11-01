FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    password "ferrari458"
    email { Faker::Internet.email }
  end
end
