require 'rails_helper'

describe Review do
  context "with food as reviewable" do
    it "has a valid factory" do
      expect(build(:food_review)).to be_valid
    end

    it "is valid with a reviewer name, title, and description" do
      expect(build(:food_review)).to be_valid
    end

    it "is invalid without a reviewer name" do
      review = build(:food_review, reviewer_name: nil)
      review.valid?
      expect(review.errors[:reviewer_name]).to include("can't be blank")
    end

    it "is invalid without a title" do
      review = build(:food_review, title: nil)
      review.valid?
      expect(review.errors[:title]).to include("can't be blank")
    end

    it "is invalid without a description" do
      review = build(:food_review, description: nil)
      review.valid?
      expect(review.errors[:description]).to include("can't be blank")
    end
  end

  context "with restaurant as reviewable" do
    it "has a valid factory" do
      expect(build(:restaurant_review)).to be_valid
    end

    it "is valid with a reviewer name, title, and description" do
      expect(build(:restaurant_review)).to be_valid
    end

    it "is invalid without a reviewer name" do
      review = build(:restaurant_review, reviewer_name: nil)
      review.valid?
      expect(review.errors[:reviewer_name]).to include("can't be blank")
    end

    it "is invalid without a title" do
      review = build(:restaurant_review, title: nil)
      review.valid?
      expect(review.errors[:title]).to include("can't be blank")
    end

    it "is invalid without a description" do
      review = build(:restaurant_review, description: nil)
      review.valid?
      expect(review.errors[:description]).to include("can't be blank")
    end
  end
end