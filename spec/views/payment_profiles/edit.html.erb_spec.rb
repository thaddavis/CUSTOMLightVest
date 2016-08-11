require 'rails_helper'

RSpec.describe "payment_profiles/edit", type: :view do
  before(:each) do
    @payment_profile = assign(:payment_profile, PaymentProfile.create!())
  end

  it "renders the edit payment_profile form" do
    render

    assert_select "form[action=?][method=?]", payment_profile_path(@payment_profile), "post" do
    end
  end
end
