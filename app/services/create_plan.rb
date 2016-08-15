class CreatePlan
  def self.call(options={})

    # begin
    #   plan = Stripe::Plan.retrieve(options[:stripe_id])
    #   plan.delete if !plan.nil?
    # rescue Stripe::StripeError => e
    # end

    # plan = Plan.find_by_stripe_id(options[:stripe_id])
    # plan.delete if plan
    binding.pry

    plan = Plan.new(options)
    if !plan.valid?
      return plan
    end


    binding.pry

    begin
      Stripe::Plan.create(
        id: options[:stripe_id],
        amount: options[:amount],
        currency: 'usd',
        interval: options[:interval],
        name: options[:name]
      )

      binding.pry

    rescue Stripe::StripeError => e
      binding.pry

      plan = Plan.new(options)
      plan.errors[:base] << e.message
      return plan
    end

    binding.pry

    plan.save
    return plan
  end
end

