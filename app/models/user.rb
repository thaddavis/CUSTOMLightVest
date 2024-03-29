class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  has_many :subscriptions, :dependent => :destroy
  has_many :invoices, :dependent => :destroy
  has_many :charges, :dependent => :destroy
  has_one :payment_profile, :dependent => :destroy

  validates :first_name, presence: true
  validates :middle_name, presence: false
  validates :last_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true

  validates :password, presence: true, length: { minimum: 6 },   allow_nil: true
  validates :username, presence: true, length: { minimum: 6 }

  enum role: [:user, :editor, :admin]

  after_validation :StripeCustomerOnSignupError, :if => :new_record?
  before_save :set_default_role, :if => :new_record?
  before_save :set_default_currency, :if => :new_record?
  after_save :set_default_payment_profile
  after_save :set_default_subscription


  private
    def set_default_role
      self.role ||= :user
    end

    def set_default_currency
      self.role ||= :USD
    end

    def set_default_subscription
      if !Subscription.find_by_user_id(self.id)
        plan = Plan.find_by_stripe_id('starter_plan')

        customer = FetchStripeCustomer.call(self)
        if self.payment_profile.errors.any?
          return false
        end
        customerJSON = JSON.parse(customer.to_s)

        subscription = Subscription.new(
            plan_id: plan.id,
            user_id: self.id,
            stripe_id: customerJSON['subscriptions']['data'].first['id']
        )
        subscription.save!
      end
    end

    def set_default_payment_profile
      if !PaymentProfile.find_by_user_id(self.id)
        payment_profile = PaymentProfile.new( user_id: self.id )
        payment_profile.save!
      end
    end

    def StripeCustomerOnSignupError
      customer = CreateStripeCustomerOnSignup.call(self)

      if customer.errors[:stripe].nil?
        self.stripe_customer_id = customer.stripe_customer_id
      end

      if self.stripe_customer_id.nil?
        self.errors[:base] << "An error occurred with our payment provider. Please try signing up later."
        return false
      end
    end

end
