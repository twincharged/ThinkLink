class Book < ActiveRecord::Base

  include Redify
  after_save :relate

  def assembly
    Assembly.find(self.assembly_id)
  end

  def users
    User.where(id: self.rsmembs(:user_ids).map(&:to_i)).load
  end

  def units
    Unit.where(id: self.rsmembs(:unit_ids).map(&:to_i)).load
  end

  private
    def relate
      self.rbridge(Assembly)
    end
end
