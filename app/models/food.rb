class Food < ApplicationRecord
  belongs_to :category
  belongs_to :restaurant, counter_cache: true
  has_many :line_items
  has_many :reviews, as: :reviewable
  has_and_belongs_to_many :tags

  validates :name, :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :name, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }
  validates_associated :category, :restaurant

  before_destroy :ensure_not_referenced_by_any_line_item

  scope :grouped_by_order, -> { joins(line_items: :order).group("foods.name").count }
  scope :grouped_by_total_price, -> { joins(line_items: :order).group("foods.name").sum("orders.total_price") }

  def self.by_letter(letter)
    where("name LIKE ?", "#{letter}%").order(:name)
  end

  def self.search(params)
    foods = self.all
    
    foods = foods.where("LOWER(name) LIKE ?", "%#{params[:name_like].downcase}%") if self.valid_search_params?(params[:name_like])
    foods = foods.where("LOWER(description) LIKE ?", "%#{params[:description_like].downcase}%") if self.valid_search_params?(params[:description_like])
    foods = foods.where("price >= ?", params[:minimum_price]) if self.valid_search_params?(params[:minimum_price])
    foods = foods.where("price <= ?", params[:maximum_price]) if self.valid_search_params?(params[:maximum_price])

    foods
  end

  def self.valid_search_params?(params)
    params.present? && !params.blank?
  end

  private
    def ensure_not_referenced_by_any_line_item
      unless line_items.empty?
        errors.add(:base, 'Line Items present')
        throw :abort
      end
    end
end
