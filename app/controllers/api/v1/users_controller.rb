require 'core_ext/string'

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_app_from_token!, only: [:create]
      before_action :authenticate, except: [:create]
      before_action :set_user, only: [:show, :update, :destroy]

      def destroy
        if @user.nil? or @user.id != @current_user.id
          return render json: { message: 'Forbidden' }, status: :forbidden
        end

        if @user.destroy
          render json: { status: :ok }
        else
          render json: @user, status: :unprocessable_entity
        end
      end

      def update
        if @user.nil? or @user.id != @current_user.id
          return render json: { message: 'Forbidden' }, status: :forbidden
        end

        @user.assign_attributes(user_params)
        if @user.save
          render json: @user, status: :ok
        else
          render json: @user.errors.to_json, status: :unprocessable_entity
        end
      end

      def index
        @user = @current_user #User.all.load

        respond_to do |format|
          format.json { render json: @user }
        end
      end

      def show
        if @user.nil? or @user.id != @current_user.id
          return render json: { message: 'Forbidden' }, status: :forbidden
        end

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

      private

        def set_user
          @user = User.friendly.find(params[:id].friendlyerize)
        end

        def user_params
          params.require(:user).permit(:name, :email, :password, :sex, :lat, :lng, device_attributes: [:token, :platform])
        end
    end
  end
end
