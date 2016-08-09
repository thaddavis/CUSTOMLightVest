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
  3.
