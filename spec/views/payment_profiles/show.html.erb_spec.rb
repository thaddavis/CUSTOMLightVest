require 'rails_helper'

RSpec.describe "payment_profiles/show", type: :view do
  before(:each) do
    @payment_profile = assign(:payment_profile, PaymentProfile.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
