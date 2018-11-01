FactoryBot.define do
  factory :event do
    adr = Faker::Address
    description { Faker::GameOfThrones.quote }
    address { adr.street_address }
    name { Faker::Book.title }
    lat { adr.latitude }
    lng { adr.longitude }
    association :owner, factory: :user
  end
end
