# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :homework do |f|
    f.user_id {FactoryGirl.create(:user).id}
    f.book_id {FactoryGirl.create(:book).id}
    f.book_title {Faker::Lorem.characters(10)}
    f.due_date Time.now + 5.hours
  end
end
