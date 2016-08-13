Step #1 Setup Devise
  1. gem 'devise'
  2. rails generate devise:install
  3. place:   config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
      in config/environments/development.rb
  4. rails generate devise User (then comment out lines in migration and add custom fields)

Step #2 Setup Rspec (Testing Environment)

  1. add gems

    group :development, :test do
      gem 'rspec-rails', '~> 3.0.0'
      gem 'factory_girl_rails'
      gem 'capybara'
      gem 'database_cleaner'
      gem 'shoulda-matchers'
      gem 'faker'
    end

  2. rails g rspec:install

  3. add the following to spec/rails_helper.rb

    require 'capybara/rails'
    require 'shoulda/matchers'
    require 'database_cleaner'
    require 'pundit/rspec

  4. add the following to config block in spec/rails_helper.rb
    config.include FactoryGirl::Syntax::Methods

  5. mkdir spec/features
     touch spec/features/sign_in_spec.rb
     mkdir spec/support
     touch spec/support/features/session_helper.rb

  6. Configure rails_helper.rb

    config.include FactoryGirl::Syntax::Methods
    config.include Features::SessionHelpers, type: :feature

Step #3 Install Pundit
  1. gem 'pundit'
  2. rails g pundit:install

Step #4 Install Bootstrap and Customize Devise Views

Step #5 Install Papertrail
  1. rails generate paper_trail:install
  2. rake db:migrate
  3. user in rails c ie: @sale.versions
  4. add config/initializers/paper_trail.rb
  5. place:   PaperTrail.config.track_associations = false

Step #6 Add custom services
  1. mkdir app/services
  2. add to app/config/application.rb

Step #7 Add Plans
  # Service for creating new plan on Stripe Side and Server Side
  CreatePlan.call(stripe_id: 'starter_plan', name: 'Starter Plan', amount: 0, interval: 'month', description: '<h4 class="text-center">Starter</h4><ul><li> FREE </li><li> Trial usage of our tools </li><li> Automated financial advice </li></ul>', published: true)
  CreatePlan.call(stripe_id: 'premium_plan', name: 'Premium Plan', amount: 10000, interval: 'month', description: '<h4 class="text-center">Premium</h4><ul><li> $100.00 + monthly consultation fees </li><li> Unlimited use of all our software tools </li><li> 90-day money-back guarantee </li><li> Customized financial advice </li></ul>', published: true)
  CreatePlan.call(stripe_id: 'gold_plan', name: 'Gold Plan', amount: 100000, interval: 'month', description: '<h4 class="text-center">Gold</h4><ul><li> $200.00 + monthly consultation fees </li><li> 90-day money-back guarantee </li><li> Personalized financial advice </li></ul>', published: true)

Step #8 Configure Stripe
  1. Configure config/initializers/stripe.rb initializers

Step # 9 Stripe Webhooks
  1. add gem 'ultrahook' to test webhooks
  2. create stripe_event.rb
  3. add following code for testing:

    StripeEvent.event_retriever = lambda do |params|
        if params[:livemode]
            ::Stripe::Event.retrieve(params[:id])
        elsif Rails.env.development?
            # This will return an event as is from the request (security concern in production)
        ::Stripe::Event.construct_from(params.deep_symbolize_keys)
        else
            nil
        end
    end

  4. add following code for use in production:

    StripeEvent.event_retriever = lambda do |params|
       return nil if StripeWebhook.exists?(stripe_id: params[:id])
       StripeWebhook.create!(stripe_id: params[:id])
       Stripe::Event.retrieve(params[:id])
    end

  5. mount StripeEvent::Engine, at: '/stripe-event' # provide a custom path

  6. Add custom code to respond to webhooks: in stripe_event.rb

Step #10
