class User < ActiveRecord::Base

  include Redify
  include Tokenize
  devise :registerable, :database_authenticatable, :recoverable, :rememberable, :trackable
  before_save :ensure_auth_token
  after_save :relate

  def assemblies
    Assembly.where(id: self.rsmembs(:assembly_ids).map(&:to_i)).load
  end

  def comments
    Comment.where(id: self.rsmembs(:comment_ids).map(&:to_i)).load
  end

  def homeworks
    Homework.where(id: self.rsmembs(:homework_ids).map(&:to_i)).load
  end

  def module_ids(type, mod)
    self.rsmembs(self.rdoublekey(type, mod)).map(&:to_i)
  end

  def module_rating(type, mod)
    self.module_ids(type, mod).length/mod.send("#{type}s").length.to_f
  end

  def complete_module!(type, mod, children)
    self.rsadd(self.rdoublekey(type, mod), [*children])
  end

  def become_user_for(assembly)
    assembly.rsbuild(self)
    self.rsbuild(assembly)
  end

  def become_teacher_for(assembly)
    assembly.rsadd(:teacher_ids, self.id)
    self.rsadd(:teacher_for_assembly_ids, assembly.id)
  end

  private
    def relate
      self.rbridge(Assembly)
    end
end