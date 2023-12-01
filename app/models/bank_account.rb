# frozen_string_literal: true

class BankAccount < ApplicationRecord
  has_many :transactions,
           class_name: 'BankTransaction',
           dependent: :destroy
end
