module LSVplus
  class TotalRecordFormatter
    DATE_FORMAT = '%Y%m%d'
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
      file.creation_date.strftime DATE_FORMAT
    end

    def creator_identification
      file.creator_identification
    end

    def record_number
      format '%07d', file.records.length
    end

    def currency
      file.currency
    end

    def total_amount
      format('%012.2f', file.total).sub('.', ',')
    end
  end
end
