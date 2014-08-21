# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chapter do |f|
    f.title {Faker::Lorem.characters(10)}
    f.content {Faker::Lorem.characters(50)}
    f.unit_id {FactoryGirl.create(:unit).id}
    f.teacher_id {FactoryGirl.create(:user).id}
  end
end
