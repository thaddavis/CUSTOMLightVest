class PaymentProfilesController < ApplicationController
  before_action :set_payment_profile, only: [:show, :edit, :update, :destroy, :switch_plan]

  def index
    @payment_profiles = PaymentProfile.all
    authorize PaymentProfile
  end

  def show
    authorize @payment_profile
    customer = FetchStripeCustomer.call(@payment_profile.user)
    customerJSON = JSON.parse(customer.to_s)
  end

  def new
    @payment_profile = PaymentProfile.new
  end

  def edit
    authorize @payment_profile
    customer = FetchStripeCustomer.call(@payment_profile.user)
    @cards = []

    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end

    @cards = customer.sources
  end

  def create
    @payment_profile = PaymentProfile.new(payment_profile_params)
    respond_to do |format|
      if @payment_profile.save
        format.html { redirect_to @payment_profile, notice: 'Payment profile was successfully created.' }
        format.json { render :show, status: :created, location: @payment_profile }
      else
        format.html { render :new }
        format.json { render json: @payment_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @payment_profile.update(payment_profile_params)
        format.html { redirect_to @payment_profile, notice: 'Payment profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_profile }
      else
        format.html { render :edit }
        format.json { render json: @payment_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @payment_profile.destroy
    respond_to do |format|
      format.html { redirect_to payment_profiles_url, notice: 'Payment profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def switch_plan
    stripe_customer = FetchStripeCustomer.call(@payment_profile.user)

    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end

    ChangePlan.call(@payment_profile.user, stripe_customer, params[:stripe_subscription_id], params[:from_plan], params[:plan_id])

    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end

    subscription = current_user.subscriptions.find_by_stripe_id(params[:stripe_subscription_id])
    if subscription
      subscription.plan = Plan.find_by_stripe_id(params[:plan_id])
      subscription.save!
    end

    redirect_to edit_payment_profile_path(current_user.payment_profile.id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_profile
      @payment_profile = PaymentProfile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_profile_params
      params.fetch(:payment_profile, {})
    end
end
