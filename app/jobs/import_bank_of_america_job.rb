# frozen_string_literal: true

class ImportBankOfAmericaJob < ApplicationJob
  queue_as :default

  def perform(id, path)
    account = BankAccount.find(id)
    File.open(path) do |io|
      BankAccount.transaction do
        balance = nil
        io.each do |line|
          next unless line =~ %r{(?<date>\d\d/\d\d/\d\d\d\d)\s+(?<desc>.*)\s+(?<amount>[-.,0-9]+)\s+(?<bal>[-.,0-9]+)}

          date = $LAST_MATCH_INFO[:date]
          description = $LAST_MATCH_INFO[:desc]
          amount = $LAST_MATCH_INFO[:amount]
          balance = $LAST_MATCH_INFO[:bal]

          logger.info line
          account.transactions
                 .create(
                   issued_at: self.class.date(date),
                   amount: self.class.decimal(amount),
                   balance: self.class.decimal(balance),
                   description: description.strip
                 )
        end
        account.update balance: self.class.decimal(balance) if balance
      end
    end
  end

  class << self
    def date(str)
      # US financial account is based in EST
      Time.strptime(str.strip, '%m/%d/%Y')
          .in_time_zone('Eastern Time (US & Canada)')
    end

    def decimal(str)
      BigDecimal(str.delete(','))
    end
  end
end
