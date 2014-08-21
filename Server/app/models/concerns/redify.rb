module Redify
  require 'redis'

  @@redis ||= $redis

  def rkey(field)
    "#{self.class.name}:#{self.id}:#{field}"
  end

  def rclasskey
    "#{self.class.name.downcase}_ids".to_sym
  end

  def rdoublekey(type, parent)
    "#{parent.class}:#{parent.id}:#{type}_ids"
  end

  def rsmembs(field)
    @@redis.smembers(self.rkey(field))
  end

  def rsadd(field, value)
    @@redis.sadd(self.rkey(field), value)
  end

  def rsrem(field, value)
    @@redis.srem(self.rkey(field), value)
  end

  def rsbuild(value)
    self.rsadd([*value][0].rclasskey, [*value].map(&:id))
  end

  def rbridge(klass)
    one_many = "#{klass.name.downcase}_id".to_sym
    many_many = "#{klass.name.downcase}_ids".to_sym
    field = self.rclasskey
    if self.respond_to?(one_many)
      attrib = self.send(one_many)
      return if attrib.nil?
      klass.new(id: attrib).rsadd(field, self.id)
    elsif self.respond_to?(many_many)
      attrib = self.send(many_many)
      return if attrib.empty?
      self.rsadd(many_many, attrib)
      attrib.map {|id| klass.new(id: id).rsadd(field, self.id)}
      attrib = nil
    end
  end
end