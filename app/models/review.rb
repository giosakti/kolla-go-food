class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  validates :reviewer_name, :title, :description, presence: true
end
