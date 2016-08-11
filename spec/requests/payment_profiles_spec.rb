require 'rails_helper'

RSpec.describe "PaymentProfiles", type: :request do
  describe "GET /payment_profiles" do
    it "works! (now write some real specs)" do
      get payment_profiles_path
      expect(response).to have_http_status(200)
    end
  end
end
