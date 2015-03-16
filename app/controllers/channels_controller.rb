class ChannelsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_channel, only: [:show, :edit, :update, :destroy]

  def index
    @channels = current_user.channels.all
  end

  def show
    # unless @channel == current_user
    #   redirect_to :back, :alert => "Access denied."
    # end
  end

  def new
    @channel = Channel.new
  end

  def edit
  end

  def create
    @channel = current_user.channels.new(channel_params)

    respond_to do |format|
      if @channel.save
        format.html { redirect_to @channel, flash: { notice: 'Channel was successfully created.' } }
        format.json { render :show, status: :created, location: @channel }
      else
        format.html { render :new }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @channel.update(channel_params)
        format.html { redirect_to @channel, flash: { notice: 'Channel was successfully updated.' } }
        format.json { render :show, status: :ok, location: @channel }
      else
        format.html { render :edit }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @channel.destroy
    respond_to do |format|
      format.html { redirect_to channels_url, flash: { notice: 'Channel was successfully destroyed.' } }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel
      @channel = current_user.channels.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def channel_params
      params.require(:channel).permit(:name, :description)
    end

end
