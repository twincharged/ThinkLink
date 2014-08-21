# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :book do |f|
    f.title {Faker::Lorem.characters(10)}
    f.assembly_id {FactoryGirl.create(:assembly).id}
  end
end
