class ChannelsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @channels = current_user.channels.all
  end

  def show
    @channel = current_user.channels.find(params[:id])
    # unless @channel == current_user
    #   redirect_to :back, :alert => "Access denied."
    # end
  end

end
