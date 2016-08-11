class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  validates :user_id, uniqueness: true

  has_paper_trail
end
