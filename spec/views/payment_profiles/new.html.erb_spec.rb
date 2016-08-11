require 'rails_helper'

RSpec.describe "payment_profiles/new", type: :view do
  before(:each) do
    assign(:payment_profile, PaymentProfile.new())
  end

  it "renders new payment_profile form" do
    render

    assert_select "form[action=?][method=?]", payment_profiles_path, "post" do
    end
  end
end
