# frozen_string_literal: true

class BankTransaction < ApplicationRecord
  belongs_to :bank_account
  scope :recent, -> { order(issued_at: :desc) }
end
