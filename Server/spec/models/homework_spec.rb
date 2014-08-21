require 'rails_helper'

RSpec.describe Homework, :type => :model do
  before(:all) do
    @homework1 = FactoryGirl.create(:homework)
    @homework2 = FactoryGirl.create(:homework)
    @assembly1 = FactoryGirl.create(:assembly)
    @assembly2 = FactoryGirl.create(:assembly)
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @book1 = FactoryGirl.create(:book)
    @unit1 = FactoryGirl.create(:unit)
  end

  it "is a new homework" do
    expect(Homework.new).to be_a_new(Homework)
  end

  it "should create homework" do
     expect(@homework1.id).to be_a(Integer)
  end

  it "should relate user" do
    tk = FactoryGirl.create(:homework, user_id: @user1.id)
    expect(tk.user).to eq(@user1)
  end

  it "should relate book" do
    tk = FactoryGirl.create(:homework, book_id: @book1.id)
    expect(tk.book).to eq(@book1)
  end
end
