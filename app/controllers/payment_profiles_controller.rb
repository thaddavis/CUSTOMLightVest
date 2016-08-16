class PaymentProfilesController < ApplicationController
  before_action :set_payment_profile, only: [:show, :edit, :update, :destroy, :switch_plan, :add_card, :remove_card, :set_default_card]

  def index
    @payment_profiles = PaymentProfile.all
    authorize PaymentProfile
  end

  def show
    authorize @payment_profile
    customer = FetchStripeCustomer.call(@payment_profile.user)
    if @payment_profile.user.payment_profile.errors.any?
      render 'show'
      return
    end

    @charges = []
    Charge.where(:user_id => current_user.id).each do |c|
      stripe_charge = FetchStripeCharge.call(@payment_profile.user, c.charge_stripe_id)
      if @payment_profile.user.payment_profile.errors.any?
        render 'show'
        return
      end
      @charges << stripe_charge
    end

    @invoices = []

    Invoice.where(:user_id => current_user.id).each do |c|
      stripe_invoice = FetchStripeInvoice.call(@payment_profile.user, c.invoice_stripe_id)
      if @payment_profile.user.payment_profile.errors.any?
        render 'show'
        return
      end
      @invoices << stripe_invoice
    end

    @invoices = @invoices.compact

  end

  def new
    @payment_profile = PaymentProfile.new
  end

  def edit
    authorize @payment_profile
    customer = FetchStripeCustomer.call(@payment_profile.user)
    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end

    # Sync Plan With Stripe
    customer.subscriptions.each do |s|
      sub = current_user.subscriptions.find_by_stripe_id(s.id)
      plan = Plan.find_by_stripe_id(s.plan.id)
      if !sub
        subscription = Subscription.new(plan_id: plan.id, user_id: current_user.id, stripe_id: s.id)
        subscription.save!
      else
        sub.plan_id = plan.id
        sub.save!
      end
    end
    # Sync Plan With Stripe

    @cards = []

    @default_card = customer.default_source
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

  def add_card

    stripe_customer = FetchStripeCustomer.call(@payment_profile.user)
    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end

    AddCardToStripeCustomer.call(@payment_profile.user, stripe_customer, params[:stripeToken])
    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end

    flash[:notice] = 'Successfully added card.'

    redirect_to edit_payment_profile_path(current_user.payment_profile.id)
  end

  def remove_card
    stripe_customer = FetchStripeCustomer.call(@payment_profile.user)
    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end

    RemoveCardFromStripeCustomer.call(@payment_profile.user, stripe_customer, params[:fingerprint])
    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end

    if stripe_customer.sources.count == 0
      NoCardsSoDowngradeToFreePlans.call(@payment_profile.user, stripe_customer)
      if @payment_profile.user.payment_profile.errors.any?
        render 'edit'
        return
      end
      current_user.subscriptions.each do |s|
        if s
          s.plan = Plan.find_by_stripe_id('starter_plan')
          s.save!
        end
      end
    end

    flash[:notice] = 'Successfully deleted card.'

    redirect_to edit_payment_profile_path(current_user.payment_profile.id)
  end

  def set_default_card

    stripe_customer = FetchStripeCustomer.call(@payment_profile.user)
    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end

    SetDefaultCardForStripeCustomer.call(@payment_profile.user, stripe_customer, params[:fingerprint])
    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end

    flash[:notice] = 'Successfully set card as default.'
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
