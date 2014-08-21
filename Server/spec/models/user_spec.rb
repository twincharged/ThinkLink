require 'rails_helper'

RSpec.describe User, :type => :model do

  before(:all) do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @chapter1 = FactoryGirl.create(:chapter)
    @quiz = FactoryGirl.create(:chapter)
    @unit1 = FactoryGirl.create(:unit)
    @unit2 = FactoryGirl.create(:unit)
    @exam = FactoryGirl.create(:unit)
    @book1 = FactoryGirl.create(:book)
    @book2 = FactoryGirl.create(:book)
    @comment1 = FactoryGirl.create(:comment)
    @qq1 = FactoryGirl.create(:question, chapter_id: @quiz.id)
    @qq2 = FactoryGirl.create(:question, chapter_id: @quiz.id)
    @eq1 = FactoryGirl.create(:question, unit_id: @exam.id)
    @eq2 = FactoryGirl.create(:question, unit_id: @exam.id)
    @assembly1 = FactoryGirl.create(:assembly)
    @assembly2 = FactoryGirl.create(:assembly)
  end

  it "is a new user" do
    expect(User.new).to be_a_new(User)
  end

  it "should create User" do
    expect(@user1.id).to be_a(Integer)
  end

  it "should add and relate units" do
    @user1.rsbuild(@comment1)
    expect(@user1.comments).to include(@comment1)
  end

  it "should complete and relate chapters" do
    @unit1.rsbuild([@chapter1])
    @user1.complete_module!(:chapter, @unit1, [@chapter1.id])
    expect(@user1.module_ids(:chapter, @unit1)).to include(@chapter1.id)
    expect(@user1.module_rating(:chapter, @unit1)).to eq(1)
  end

  it "should complete and relate units" do
    @book1.rsbuild([@unit2])
    @user2.complete_module!(:unit, @book1, [@unit2.id])
    expect(@user2.module_ids(:unit, @book1)).to include(@unit2.id)
    expect(@user2.module_rating(:unit, @book1)).to eq(1)
  end

  it "should answer and relate exam questions" do
    @user2.complete_module!(:question, @exam, [@eq2.id])
    expect(@user2.module_ids(:question, @exam)).to include(@eq2.id)
    expect(@user2.module_rating(:question, @exam)).to eq(0.5)
  end

  it "should answer and relate quiz questions" do
    @user2.complete_module!(:question, @quiz, [@qq1.id])
    expect(@user2.module_ids(:question, @quiz)).to include(@qq1.id)
    expect(@user2.module_rating(:question, @quiz)).to eq(0.5)
  end

  it "should build many to many relationships" do
    User.class_eval do attr_accessor :assembly_ids end
    user = FactoryGirl.create(:user, assembly_ids: [@assembly1.id,@assembly2.id])
    expect(user.assemblies).to include(@assembly1, @assembly2)
    expect(@assembly1.users).to include(user)
    expect(@assembly2.users).to include(user)
  end
end
