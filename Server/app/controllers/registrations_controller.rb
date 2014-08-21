class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :authenticate_user_from_token!
  skip_before_action :authenticate_user!

  def create
    user = User.new(register_params)
    if user.save
      @user = {auth_token: user.reset_auth_token, email: user.email, id: user.id}
      render json: @user
    else
      render json: {error: user.errors}
    end
  end


  private

  def register_params
  	params.require(:registration).require(:user).permit(:name, :email, :password)
  end
end