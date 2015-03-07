require 'core_ext/string'

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_app_from_token!, only: [:create]
      before_action :authenticate, except: [:create]

      def destroy
        @user = User.friendly.find(params[:id].friendlyerize)

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
        @user = User.friendly.find(params[:id].friendlyerize)

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
        @user = User.friendly.find(params[:id].friendlyerize)

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

      def user_params
        params.require(:user).permit(:name, :email, :password, :sex, :lat, :lng, device_attributes: [:token, :platform])
      end

      protected

        def authenticate_app_from_token!
          authenticate_or_request_with_http_token do |token, options|
            @permitted_app = PermittedApp.where(authentication_token: token).first
          end
        end

      private

        def authenticate
          authenticate_or_request_with_http_token do |token, options|
            email, api_key = token.split(':', 2)
            @current_user = User.where(email:email, api_key: api_key).first
          end
        end

        # NOTE: For ref
        # Manual way of authenticate request
        def authenticate_manual
          api_key = request.headers['X-Api-Key']
          @user = User.where(api_key: api_key).first if api_key

          unless @user
            head status: :unauthorized
            return false
          end
        end

        # Check request per min
        # You can add field to user table request per min or define constant.
        # Here I am just passsing some random value
        def validate_rpm
          if ApiRpmStore.threshold?(@user.id, @user.api_rpm) # 10 request per min
            render json: { help: 'http://mysite.com/plans' }, status: :too_many_requests
            return false
          end
        end
    end
  end
end
