class Unit < ActiveRecord::Base

  include Redify
  after_save :relate

  def teacher
    User.find(self.teacher_id)
  end

  def book
    Book.find(self.book_id)
  end

  def users
    User.where(id: self.rsmembs(:user_ids).map(&:to_i)).load
  end

  def chapters
    Chapter.where(id: self.rsmembs(:chapter_ids).map(&:to_i)).load
  end

  def questions
    Question.where(id: self.rsmembs(:question_ids).map(&:to_i)).load
  end

  private
    def relate
      self.rbridge(Book)
    end
end
