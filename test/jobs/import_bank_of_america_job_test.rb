# frozen_string_literal: true

require 'test_helper'
require 'tempfile'

class ImportBankOfAmericaJobTest < ActiveJob::TestCase
  def setup
    @account = BankAccount.create

    @io = Tempfile.new
    @io.write <<~DATA
      10/27/2023  Payroll        3,714.51     13,875.70
      10/30/2023  Amex Payment  -2,044.11     11,831.59
      10/30/2023  COMCAST          -45.00     11,786.59
      11/01/2023  APPLECARD     -4,000.00      7,786.59
    DATA
    @io.rewind
  end

  test 'retry' do
    ImportBankOfAmericaJob.perform_now @account.id, @io.path
    @io.rewind
    ImportBankOfAmericaJob.perform_now @account.id, @io.path
    assert_equal 4, @account.transactions.count
  end

  test 'latest cache' do
    @account.transactions.create(issued_at: '2023-12-01', description: 'ACME, Inc', amount: 10_000, balance: 10_000)
    @account.update(balance: 10_000)

    ImportBankOfAmericaJob.perform_now @account.id, @io.path
    @account.reload
    assert_equal '10000.0', @account.balance.to_s
  end
end
