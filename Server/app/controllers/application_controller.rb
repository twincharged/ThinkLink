class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  skip_before_filter :verify_authenticity_token
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json'}
  respond_to :json
  before_filter :authenticate_user_from_token!
  before_action :authenticate_user!

protected

  def authenticate_user_from_token!
    id = params["reqs_id"]
    user = id && User.find(id)
    if user && Devise.secure_compare(user.auth_token, params["reqs_token"])
      sign_in user, store: false
    end
  end

end
