class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end
  # POST /user_sessions
  # POST /user_sessions.json
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful"
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end

  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.json
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful"
    redirect_back_or_default new_user_session_url
  end
end
