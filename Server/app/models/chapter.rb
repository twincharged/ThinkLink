class Chapter < ActiveRecord::Base

  include Redify
  after_save :relate

  def unit
    Unit.find(self.unit_id)
  end

  def comments
    Comment.where(id: self.rsmembs(:comment_ids).map(&:to_i)).load
  end

  def questions
    Question.where(id: self.rsmembs(:question_ids).map(&:to_i)).load
  end

  private
    def relate
      self.rbridge(Unit)
    end
end