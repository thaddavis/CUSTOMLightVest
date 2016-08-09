require 'rails_helper'

describe User, type: :model do
  before :each do
    @user = FactoryGirl.build(:user)
  end

  it "should not be valid without a first_name" do
    @user.first_name = nil
    expect(@user).not_to be_valid
  end

end
