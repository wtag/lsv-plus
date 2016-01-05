require 'lsv_plus/formatting_helper'

module LSVplus
  class TotalRecordFormatter
    TYPE = '890'
    VERSION = '0'

    attr_reader :file

    def self.call(file)
      new(file).call
    end

    def initialize(file)
      @file = file
    end

    def call
      [TYPE, VERSION, creation_date, creator_identification, record_number, currency, total_amount].join('')
    end

    def creation_date
      LSVplus::FormattingHelper.date file.creation_date
    end

    def creator_identification
      file.creator_identification
    end

    def record_number
      LSVplus::FormattingHelper.index file.records.length
    end

    def currency
      file.currency
    end

    def total_amount
      LSVplus::FormattingHelper.amount file.total
    end
  end
end
