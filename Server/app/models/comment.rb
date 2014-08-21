class Comment < ActiveRecord::Base

  include Redify
  after_save :relate

  def user
    User.find(self.user_id)
  end

  def chapter
    Chapter.find(self.chapter_id)
  end

  private
    def relate
      self.rbridge(User)
      self.rbridge(Chapter)
    end
end
