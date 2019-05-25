class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        flash[:welcome] = "Congratulations #{@user.name}! You are now registered and logged in."
        redirect_to user_profile_path
      elsif User.find_by(email: user_params[:email])
        flash[:message] = "Email address is already in use"
        @user.email = ""
        render :new
      else
        flash[:message] = "Unable to register user. Missing required fields"
        render :new
      end
  end

  def show

  end

  def edit

  end

  def update
    @user = User.find(current_user.id)
    @user.update(user_update_params)
    if @user.save
      redirect_to user_profile_path
    else
      flash[:notice] = "This email is already in use"
      render :edit
    end
  end

  def checkout

    cart.clear_cart
    @order = current_user.orders[0]
    flash[:message] = "Your order was created."
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :address, :city, :state, :zip, :password)
    end

    def user_update_params
      params.require(:user).permit(:name, :email, :address, :city, :state, :zip).merge(password: params[:user][:password].empty? ? current_user.password_digest : params[:user][:password])
    end
end
