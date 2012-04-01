# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def create
    auth = request.env['omniauth.auth']

    unless @identity = Identity.find_or_create_with_omniauth(auth)
      redirect_to root_url, notice: "Something went wrong. Please try again."
    end

    if signed_in?
      if @identity.user == current_user
        @notice = "Already linked that account!"
      else
        @identity.user = current_user
        @notice = "Successfully linked that account!"
      end
    else
      unless @identity.user.present?
        @identity.create_user(:name => auth["info"]["name"])
        @identity.save
      end
      self.current_user = @identity.user
      @notice = "Logged in!"
    end
    render 'sessions/create', notice: @notice
    @identity.process_login(DateTime.now)
  end

  def destroy
    self.current_user = nil
    redirect_to root_url, notice: "Logged out!"
  end
end
