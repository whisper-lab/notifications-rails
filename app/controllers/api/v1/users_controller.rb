require 'core_ext/string'

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_app_from_token!

      def destroy
        @user = User.friendly.find(params[:id].friendlyerize)

        if @user.destroy
          render json: { status: :ok }
        else
          render json: @user, status: :unprocessable_entity
        end
      end

      def update
        @user = User.friendly.find(params[:id].friendlyerize)
        @user.assign_attributes(user_params)
        if @user.save
          render json: @user, status: :ok
        else
          render json: @user.errors.to_json, status: :unprocessable_entity
        end
      end

      def index
        @user = User.all.load

        respond_to do |format|
          format.json { render json: @user }
        end
      end

      def show
        @user = User.friendly.find(params[:id].friendlyerize)

        respond_to do |format|
          format.json { render json: @user }
        end
      end

      def create
        @user = User.new(user_params)


        if @user.save
          render json: @user
        else
          render json: @user.errors.to_json, status: :unprocessable_entity
        end
      end

      def user_params
        params.require(:user).permit(:email, :password, :lat, :lng, :sex, device_attributes: [:token, :platform])
      end

      protected
        def authenticate_app_from_token!
          authenticate_or_request_with_http_token do |token, options|
            @permitted_app = PermittedApp.where(authentication_token: token).first
          end
        end
    end
  end
end
