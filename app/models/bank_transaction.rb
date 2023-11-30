# frozen_string_literal: true

class BankTransaction < ApplicationRecord
  belongs_to :bank_account
end
