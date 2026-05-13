class SessionsController < ApplicationController
  before_action :require_logout, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to tasks_path, notice: 'ログインしました'
    else
      flash.now[:alert] = 'メールアドレスまたはパスワードに誤りがあります'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to new_session_path, notice: 'ログアウトしました'
  end
end
