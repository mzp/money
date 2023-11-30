# frozen_string_literal: true

class ImportBankOfAmericaJob < ApplicationJob
  queue_as :default

  def perform(path)
    File.open(path) do |io|
      io.each do |line|
        if line =~ %r|(?<date>\d\d/\d\d/\d\d\d\d)\s{2}(?<desc>.*)\s+(?<amount>[-.,0-9]+)\s+(?<bal>[-.,0-9]+)|
          logger.debug line
          date = $~[:date]
          description = $~[:desc]
          amount = $~[:amount]
          balance = $~[:bal]

          BankTransaction.new(description: description)

#          p Time.strptime($~[:date].strip, '%m/%d/%Y').in_time_zone('Eastern Time (US & Canada)' )
#          p $~[:desc].strip
#          p BigDecimal.new($~[:amount])
#          p BigDecimal($~[:bal])
        end
      end
    end
  end
end
