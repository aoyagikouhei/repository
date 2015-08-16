class PasswordsController < ApplicationController
  include ControllerUtil
  before_action :authenticate_user!
  before_action :set_user

  def new
  end

  def create 
    respond_to do |format|
      if @user.update(password_params)
        # 自分で変更した場合はログアウトを防ぐ
        sign_in(@user, bypass: true)
        format.html { redirect_to main_index_path, notice: 'Password was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def password_params
      params.require(:user).permit(
        :password,
        :password_confirmation
      )
    end

    def set_user
      @user = User.find_for_available_id(current_user.id)
    end
end
