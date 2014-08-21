require 'rails_helper'

RSpec.describe Assembly, :type => :model do

  before(:all) do
    @assembly1 = FactoryGirl.create(:assembly)
    @assembly2 = FactoryGirl.create(:assembly)
    @assembly3 = FactoryGirl.create(:assembly)
    @assembly4 = FactoryGirl.create(:assembly)
    @assembly5 = FactoryGirl.create(:assembly)
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @book1 = FactoryGirl.create(:book)
  end

  it "is a new assembly" do
    expect(Assembly.new).to be_a_new(Assembly)
  end

  it "should create Assembly" do
     expect(@assembly1.id).to be_a(Integer)
  end

  it "should add and relate teachers" do
    @user2.become_teacher_for(@assembly1)
    assemblies_user_teachers_for = @user2.rsmembs(:teacher_for_assembly_ids).map(&:to_i)
    expect(assemblies_user_teachers_for).to include(@assembly1.id)
    expect(@assembly1.teachers).to include(@user2)
  end

  it "should add and relate users" do
    @user1.become_user_for(@assembly1)
    expect(@assembly1.users).to include(@user1)
    expect(@user1.assemblies).to include(@assembly1)
  end

  it "should add and relate books" do
    @assembly2.rsbuild(@book1)
    expect(@assembly2.books).to include(@book1)
  end
end
