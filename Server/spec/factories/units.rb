# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :unit do |f|
    f.title {Faker::Lorem.characters(10)}
    f.content {Faker::Lorem.characters(50)}
    f.book_id {FactoryGirl.create(:book).id}
    f.teacher_id {FactoryGirl.create(:user).id}
  end
end
