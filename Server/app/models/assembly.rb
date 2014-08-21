class Assembly < ActiveRecord::Base

  include Redify

  def teachers
    User.where(id: self.rsmembs(:teacher_ids).map(&:to_i)).load
  end

  def users
    User.where(id: self.rsmembs(:user_ids).map(&:to_i)).load
  end

  def books
    Book.where(id: self.rsmembs(:book_ids).map(&:to_i)).load
  end

end
