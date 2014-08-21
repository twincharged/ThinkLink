require 'rails_helper'

RSpec.describe Unit, :type => :model do
  before(:all) do
    @book1 = FactoryGirl.create(:book)
    @book2 = FactoryGirl.create(:book)
    @assembly1 = FactoryGirl.create(:assembly)
    @assembly2 = FactoryGirl.create(:assembly)
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @unit1 = FactoryGirl.create(:unit)
    @unit2 = FactoryGirl.create(:unit)
    @unit3 = FactoryGirl.create(:unit)
  end

  it "is a new unit" do
    expect(Unit.new).to be_a_new(Unit)
  end

  it "should create unit" do
     expect(@unit1.id).to be_a(Integer)
  end

  it "should relate teacher" do
    co = FactoryGirl.create(:unit, teacher_id: @user2.id)
    expect(co.teacher).to eq(@user2)
  end

  it "should relate book" do
    co = FactoryGirl.create(:unit, book_id: @book1.id)
    expect(co.book).to eq(@book1)
  end

  it "should add and relate users" do
    @unit1.rsbuild([@user1, @user2])
    expect(@unit1.users).to include(@user1, @user2)
  end

  it "should add and relate chapters" do
    @chapter1 = FactoryGirl.create(:chapter, unit_id: @unit1.id)
    @chapter2 = FactoryGirl.create(:chapter, unit_id: @unit1.id)
    expect(@unit1.chapters).to include(@chapter1, @chapter2)
  end

  it "should add and relate questions" do
    @question1 = FactoryGirl.create(:question, unit_id: @unit3.id)
    @question2 = FactoryGirl.create(:question, unit_id: @unit3.id)
    expect(@unit3.questions).to include(@question1, @question2)
    expect(@question1.unit).to eq(@unit3)
    expect(@question2.unit).to eq(@unit3)
  end
end
