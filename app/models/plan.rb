class Plan < ApplicationRecord
  has_paper_trail
  validates :stripe_id, uniqueness: true
end
