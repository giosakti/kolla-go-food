require 'rails_helper'

describe Review do
  it "has a valid factory" do
    expect(build(:review)).to be_valid
  end

  it "is valid with a reviewer name, title, and description" do
    expect(build(:review)).to be_valid
  end

  it "is invalid without a reviewer name" do
    review = build(:review, reviewer_name: nil)
    review.valid?
    expect(review.errors[:reviewer_name]).to include("can't be blank")
  end

  it "is invalid without a title" do
    review = build(:review, title: nil)
    review.valid?
    expect(review.errors[:title]).to include("can't be blank")
  end

  it "is invalid without a description" do
    review = build(:review, description: nil)
    review.valid?
    expect(review.errors[:description]).to include("can't be blank")
  end
end