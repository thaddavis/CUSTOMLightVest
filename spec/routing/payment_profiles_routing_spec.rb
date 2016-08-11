require "rails_helper"

RSpec.describe PaymentProfilesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/payment_profiles").to route_to("payment_profiles#index")
    end

    it "routes to #new" do
      expect(:get => "/payment_profiles/new").to route_to("payment_profiles#new")
    end

    it "routes to #show" do
      expect(:get => "/payment_profiles/1").to route_to("payment_profiles#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/payment_profiles/1/edit").to route_to("payment_profiles#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/payment_profiles").to route_to("payment_profiles#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/payment_profiles/1").to route_to("payment_profiles#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/payment_profiles/1").to route_to("payment_profiles#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/payment_profiles/1").to route_to("payment_profiles#destroy", :id => "1")
    end

  end
end
