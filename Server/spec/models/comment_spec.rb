require 'rails_helper'

RSpec.describe Comment, :type => :model do
  before(:all) do
    @comment1 = FactoryGirl.create(:comment)
    @comment2 = FactoryGirl.create(:comment)
    @assembly1 = FactoryGirl.create(:assembly)
    @assembly2 = FactoryGirl.create(:assembly)
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @chapter1 = FactoryGirl.create(:chapter)
    @chapter2 = FactoryGirl.create(:chapter)
  end

  it "is a new comment" do
    expect(Comment.new).to be_a_new(Comment)
  end

  it "should create comment" do
     expect(@comment1.id).to be_a(Integer)
  end

  it "should relate user" do
    cm = FactoryGirl.create(:comment, user_id: @user1.id)
    expect(cm.user).to eq(@user1)
  end

  it "should relate chapter" do
    cm = FactoryGirl.create(:comment, chapter_id: @chapter1.id)
    expect(cm.chapter).to eq(@chapter1)
  end
end
