module Tokenize

  def as_json(options={})
    super(only: [:email, :id]).merge(options)
  end

  def ensure_auth_token
    self.auth_token ||= Devise.friendly_token
  end

  def reset_auth_token
    self.auth_token = Devise.friendly_token
  end

  def auth_token
    $redis.get("user:#{self.id}:auth_token")
  end

  def auth_token=(token)
    $redis.set("user:#{self.id}:auth_token", token)
  end
end