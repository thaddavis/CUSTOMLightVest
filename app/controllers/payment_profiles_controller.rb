class PaymentProfilesController < ApplicationController
  before_action :set_payment_profile, only: [:show, :edit, :update, :destroy]

  # GET /payment_profiles
  # GET /payment_profiles.json
  def index
    @payment_profiles = PaymentProfile.all
    authorize PaymentProfile
  end

  # GET /payment_profiles/1
  # GET /payment_profiles/1.json
  def show

    authorize @payment_profile
  end

  # GET /payment_profiles/new
  def new
    @payment_profile = PaymentProfile.new
  end

  # GET /payment_profiles/1/edit
  def edit
  end

  # POST /payment_profiles
  # POST /payment_profiles.json
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

  # PATCH/PUT /payment_profiles/1
  # PATCH/PUT /payment_profiles/1.json
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

  # DELETE /payment_profiles/1
  # DELETE /payment_profiles/1.json
  def destroy
    @payment_profile.destroy
    respond_to do |format|
      format.html { redirect_to payment_profiles_url, notice: 'Payment profile was successfully destroyed.' }
      format.json { head :no_content }
    end
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
