require 'rails_helper'

RSpec.describe Chapter, :type => :model do
  before(:all) do
    @chapter1 = FactoryGirl.create(:chapter)
    @chapter2 = FactoryGirl.create(:chapter)
    @chapter3 = FactoryGirl.create(:chapter)
    @assembly1 = FactoryGirl.create(:assembly)
    @assembly2 = FactoryGirl.create(:assembly)
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @unit1 = FactoryGirl.create(:unit)
    @unit2 = FactoryGirl.create(:unit)
  end

  it "is a new chapter" do
    expect(Chapter.new).to be_a_new(Chapter)
  end

  it "should create chapter" do
     expect(@chapter1.id).to be_a(Integer)
  end

  it "should relate unit" do
    st = FactoryGirl.create(:chapter, unit_id: @unit1.id)
    expect(st.unit).to eq(@unit1)
  end

  it "should add and relate comments" do
    @comment1 = FactoryGirl.create(:comment, chapter_id: @chapter2.id)
    @comment2 = FactoryGirl.create(:comment, chapter_id: @chapter2.id)
    expect(@chapter2.comments).to include(@comment1, @comment2)
  end

  it "should add and relate questions" do
    @question1 = FactoryGirl.create(:question, chapter_id: @chapter3.id)
    @question2 = FactoryGirl.create(:question, chapter_id: @chapter3.id)
    expect(@chapter3.questions).to include(@question1, @question2)
    expect(@question1.chapter).to eq(@chapter3)
    expect(@question2.chapter).to eq(@chapter3)
  end
end
