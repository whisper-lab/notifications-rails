class Api::V1::SessionsController < ApplicationController
  before_action :authenticate_app_from_token!, only: [:create, :index]

  def create
    user = User.find_for_authentication(:email => params[:email])

    unless user.nil?
      @user = user.valid_password?(params[:password]) ? user : nil
    else
      @user = nil
    end

    respond_to do |format|
      unless @user.nil?
        format.json {
          render json: {
            id: @user.id,
            api_key: @user.api_key
          }
        }
      else
        format.json { render json: { message: 'wrong email or password' }, status: :unauthorized }
      end
    end
  end

  protected

    def authenticate_app_from_token!
      authenticate_or_request_with_http_token do |token, options|
        @permitted_app = PermittedApp.where(authentication_token: token).first
      end
    end
end
