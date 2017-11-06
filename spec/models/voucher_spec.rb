require 'rails_helper'

describe Voucher do
  it "has a valid factory" do
    expect(build(:voucher)).to be_valid
  end

  it "is valid with a code, valid_from, valid_through, amount, unit, max_amount" do
    expect(build(:voucher)).to be_valid
  end

  it "is invalid without a code" do
    voucher = build(:voucher, code: nil)
    voucher.valid?
    expect(voucher.errors[:code]).to include("can't be blank")
  end

  it "changes non all capitals code to all capitals when saved" do
    voucher = build(:voucher, code: "gratis")
    voucher.save
    expect(voucher.code).to eq("GRATIS")
  end

  it "is invalid with a duplicate code" do
    voucher1 = create(:voucher, code: "GRATIS")
    voucher2 = build(:voucher, code: "GRATIS")

    voucher2.valid?
    expect(voucher2.errors[:code]).to include("has already been taken")
  end

  it "is invalid with a duplicate code in different case" do
    voucher1 = create(:voucher, code: "GRATIS")
    voucher2 = build(:voucher, code: "gratis")

    voucher2.valid?
    expect(voucher2.errors[:code]).to include("has already been taken")
  end

  it "is invalid without a valid_from" do
    voucher = build(:voucher, valid_from: nil)
    voucher.valid?
    expect(voucher.errors[:valid_from]).to include("can't be blank")
  end

  it "is invalid without a valid_through" do
    voucher = build(:voucher, valid_through: nil)
    voucher.valid?
    expect(voucher.errors[:valid_through]).to include("can't be blank")
  end

  it "is invalid without a amount" do
    voucher = build(:voucher, amount: nil)
    voucher.valid?
    expect(voucher.errors[:amount]).to include("can't be blank")
  end

  it "is invalid without numeric amount" do
    voucher = build(:voucher, amount: "abc")
    voucher.valid?
    expect(voucher.errors[:amount]).to include("is not a number")
  end

  it "is invalid with amount less than 0" do
    voucher = build(:voucher, amount: -0.1)
    voucher.valid?
    expect(voucher.errors[:amount]).to include("must be greater than or equal to 0")
  end

  it "is invalid without a unit" do
    voucher = build(:voucher, unit: nil)
    voucher.valid?
    expect(voucher.errors[:unit]).to include("can't be blank")
  end

  it "is invalid without max_amount" do
    voucher = build(:voucher, max_amount: nil)
    voucher.valid?
    expect(voucher.errors[:max_amount]).to include("can't be blank")
  end

  it "is invalid without numeric max_amount" do
    voucher = build(:voucher, max_amount: "abc")
    voucher.valid?
    expect(voucher.errors[:max_amount]).to include("is not a number")
  end

  it "is invalid with max_amount less than 0" do
    voucher = build(:voucher, max_amount: -0.1)
    voucher.valid?
    expect(voucher.errors[:max_amount]).to include("must be greater than or equal to 0")
  end

  it "can't be destroyed while it has order(s)" do
    voucher = create(:voucher)
    order = create(:order, voucher: voucher)

    expect { voucher.destroy }.not_to change(Voucher, :count)
  end
end