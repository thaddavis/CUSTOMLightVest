require 'rails_helper'

RSpec.describe "payment_profiles/index", type: :view do
  before(:each) do
    assign(:payment_profiles, [
      PaymentProfile.create!(),
      PaymentProfile.create!()
    ])
  end

  it "renders a list of payment_profiles" do
    render
  end
end
