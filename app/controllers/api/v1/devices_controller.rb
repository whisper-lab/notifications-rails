class Api::V1::DevicesController < ApplicationController
  before_action :authenticate

  def destroy
    @user = User.friendly.find(params[:user_id].friendlyerize)
    if @user.nil? or @user.id != @current_user.id then return render json: { message: 'Forbidden' }, status: :forbidden end

    @device = @user.device
    if @device.nil? or @device.id.to_s != params[:id] then return render json: { message: 'Forbidden' }, status: :forbidden end

    if @device.token == device_destroy_params[:token] && @device.destroy
      render json: { status: :ok }
    else
      render json: @device, status: :unprocessable_entity
    end
  end

  def update
    @user = User.friendly.find(params[:user_id].friendlyerize)
    if @user.nil? or @user.id != @current_user.id then return render json: { message: 'Forbidden' }, status: :forbidden end

    @device = @user.device
    if @device.nil? or @device.id.to_s != params[:id] then return render json: { message: 'Forbidden' }, status: :forbidden end

    @device.assign_attributes(device_params)
    if @user.save
      render json: @user, status: :ok
    else
      render json: @user.errors.to_json, status: :unprocessable_entity
    end
  end

  def index
    @user = User.friendly.find(params[:user_id].friendlyerize)
    if @user.nil? or @user.id != @current_user.id then return render json: { message: 'Forbidden' }, status: :forbidden end

    @device = @user.device

    respond_to do |format|
      format.json { render json: @device }
    end
  end

  def show
    @user = User.friendly.find(params[:user_id].friendlyerize)
    if @user.nil? or @user.id != @current_user.id then return render json: { message: 'Forbidden' }, status: :forbidden end

    @device = @user.device
    if @device.nil? or @device.id.to_s != params[:id] then return render json: { message: 'Forbidden' }, status: :forbidden end

    respond_to do |format|
      format.json { render json: @device }
    end
  end

  def device_destroy_params
    params.require(:device).require(:token)
    params.require(:device).permit(:token)
  end

  def device_params
    params.require(:device).permit(:token, :platform)
  end
end
