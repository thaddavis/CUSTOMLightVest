class PaymentProfilePolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @model = model
  end

  def index?
    @current_user.admin?
  end

  def show?
    @current_user.admin? || @model.user_id == @current_user.id
  end

  def update?
    @current_user.admin? || @model.user_id == @current_user.id
  end

  def destroy?
    @current_user.admin?
  end

end
