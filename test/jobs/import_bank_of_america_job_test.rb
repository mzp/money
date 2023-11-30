# frozen_string_literal: true

require 'test_helper'

class ImportBankOfAmericaJobTest < ActiveJob::TestCase
  test 'the truth' do
    ImportBankOfAmericaJob.perform_now '/app/tmp/BofA_Checking.txt'
  end
end
