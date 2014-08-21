# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do |f|
  	f.chapter_id {FactoryGirl.create(:chapter).id}
    f.content {Faker::Lorem.characters(50)}
    f.a {Faker::Lorem.characters(20)}
    f.b {Faker::Lorem.characters(30)}
    f.c {Faker::Lorem.characters(25)}
    f.d {Faker::Lorem.characters(35)}
    f.answer "d"
  end
end
