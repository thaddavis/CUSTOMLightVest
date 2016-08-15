class StripeMailer < ActionMailer::Base
  default from: 'you@example.com'

  def charge_succeeded(event)
  end

  def charge_failed(event)
  end

  def invoice_payment_succeeded(event)

    if User.find_by_email(Subscription.find_by_stripe_id(event.lines.first.id).user.email).confirmed?

      @current_plan = event.lines.first.plan.name
      @currency = User.find_by_stripe_customer_id(event.customer).currency
      @amount = Money.new(event.lines.first.plan.amount, @currency).format
      @interval = event.lines.first.plan.interval
      @current_period_end = DateTime.strptime(event.lines.first.period.end.to_s,'%s')
      @to = User.find_by_stripe_customer_id(event.customer).email

      mail(to: @to, subject: "LightVest Invoice").deliver

    end

  end

  def invoice_payment_failed(event)

  end

  def customer_subscription_deleted(event)
  end



end
