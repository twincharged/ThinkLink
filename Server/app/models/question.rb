class Question < ActiveRecord::Base

  include Redify
  after_save :relate

  def unit
    Unit.find(self.unit_id)
  end

  def chapter
    Chapter.find(self.chapter_id)
  end

  private
    def relate
      self.rbridge(Chapter)
      self.rbridge(Unit)
    end
end
