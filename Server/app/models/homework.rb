class Homework < ActiveRecord::Base

  include Redify
  after_save :relate

  def user
    User.find(self.user_id)
  end

  def book
    Book.find(self.book_id)
  end

  private
    def relate
      self.rbridge(User)
    end
end
