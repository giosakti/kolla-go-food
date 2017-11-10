class Review < ApplicationRecord
  validates :reviewer_name, :title, :description, presence: true
end
