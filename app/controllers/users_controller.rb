class UsersController < ApplicationController
  include ControllerUtil
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :admin_only

  # GET /users
  # GET /users.json
  def index
    @users = User.find_for_available
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params.merge(get_create_columns))

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      prms = user_params.merge(get_update_columns)
      key = prms[:password].present? ? :update : :update_without_password
      if @user.send(key, prms)
        format.html { redirect_to users_url, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.update_without_password(get_delete_columns)
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_for_available_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(
        :nm,
        :email,
        :password,
        :password_confirmation,
        :user_kbn
      )
    end

    def admin_only
      redirect_to main_index_path if !current_user.admin?
    end
end
