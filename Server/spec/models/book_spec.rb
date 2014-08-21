require 'rails_helper'

RSpec.describe Book, :type => :model do
  before(:all) do
    @book1 = FactoryGirl.create(:book)
    @book2 = FactoryGirl.create(:book)
    @assembly1 = FactoryGirl.create(:assembly)
    @assembly2 = FactoryGirl.create(:assembly)
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @unit1 = FactoryGirl.create(:unit)
    @unit2 = FactoryGirl.create(:unit)
  end

  it "is a new book" do
    expect(Book.new).to be_a_new(Book)
  end

  it "should create book" do
     expect(@book1.id).to be_a(Integer)
  end

  it "should relate assembly" do
    curr = FactoryGirl.create(:book, assembly_id: @assembly1.id)
    expect(curr.assembly).to eq(@assembly1)
  end

  it "should add and relate users" do
    @book1.rsbuild(@user2)
    expect(@book1.users).to include(@user2)
  end

  it "should add and relate units" do
    @book1.rsbuild([@unit2, @unit1])
    expect(@book1.units).to include(@unit2, @unit1)
  end

end
