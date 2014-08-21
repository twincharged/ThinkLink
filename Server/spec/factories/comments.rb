# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do |f|
  	f.user_id {FactoryGirl.create(:user).id}
  	f.chapter_id {FactoryGirl.create(:chapter).id}
  	f.content {Faker::Lorem.characters(50)}
  end
end
