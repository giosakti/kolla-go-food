class Voucher < ApplicationRecord
  has_many :orders

  validates :code, :valid_from, :valid_through, :amount, :unit, :max_amount, presence: true
  validates :code, uniqueness: { case_sensitive: false }
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :max_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :unit, inclusion: { in: %w(percent rupiah) }
  validates_each :valid_from do |record, attr, value|
    if !value.nil? && !record.valid_through.nil?
      record.errors.add(attr, "valid_from must be less than valid_through") if value > record.valid_through
    end
  end

  before_save :ensure_all_capitals_code
  before_destroy :ensure_not_referenced_by_any_order

  private
    def ensure_all_capitals_code
      code.upcase!
    end

    def ensure_not_referenced_by_any_order
      unless orders.empty?
        errors.add(:base, 'Orders present')
        throw :abort
      end
    end
end
