class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]

  def index
    @subscriptions = current_user.subscriptions.all
  end

  def show
    # unless @subscription == current_user
    #   redirect_to :back, :alert => "Access denied."
    # end
  end

  def new
    @subscription = current_user.subscriptions.new
  end

  # def edit
  # end

  def create
    @subscription = current_user.subscriptions.new(subscription_params)

    respond_to do |format|
      if @subscription.save
        format.html { redirect_to @subscription, flash: { notice: 'Subscription was successfully created.' } }
        format.json { render :show, status: :created, location: @subscription }
      else
        format.html { render :new }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # def update
  #   respond_to do |format|
  #     if @subscription.update(subscription_params)
  #       format.html { redirect_to @subscription, flash: { notice: 'Subscription was successfully updated.' } }
  #       format.json { render :show, status: :ok, location: @subscription }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @subscription.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def destroy
    @subscription.destroy
    respond_to do |format|
      format.html { redirect_to subscriptions_url, flash: { notice: 'Subscription was successfully destroyed.' } }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscription
      @subscription = current_user.subscriptions.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subscription_params
      params.require(:subscription).permit(:channel_id)
    end
end
