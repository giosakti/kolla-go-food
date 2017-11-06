class VoucherValidator < ActiveModel::Validator
  def validate(record)
    if !record.voucher.nil? && record.voucher.valid_through < Date.today
      record.errors[:base] << "must use valid voucher"
    end
  end
end