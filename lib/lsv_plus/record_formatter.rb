module LSVplus
  class RecordFormatter
    DATE_FORMAT = '%Y%m%d'

    attr_reader :file, :record, :output

    def self.call(file, record, index)
      new(file, record, index).call
    end

    def initialize(file, record, index)
      @file = file
      @record = record
      @index = index
      @output = StringIO.new
    end

    def call
      [
        type, version, processing_type, processing_date,
        creditor_bank_clearing_number, creation_date, debitor_bank_clearing_number,
        creator_identification, record_number,
        currency, amount,
        creditor_iban, creditor_address,
        debitor_account, debitor_address,
        message, reference_type, reference, esr_member_id
      ].join('')
    end

    def type
      record.type
    end

    def version
      record.version
    end

    def processing_type
      file.processing_type
    end

    def processing_date
      record.processing_date.strftime DATE_FORMAT
    end

    def creditor_bank_clearing_number
      format '%-5s', record.creditor_bank_clearing_number
    end

    def creation_date
      file.creation_date.strftime DATE_FORMAT
    end

    def debitor_bank_clearing_number
      format '%-5s', record.debitor_bank_clearing_number
    end

    def creator_identification
      file.creator_identification
    end

    def record_number
      format '%07d', @index
    end

    def currency
      file.currency
    end

    def amount
      format('%012.2f', record.amount).sub('.', ',')
    end

    def creditor_iban
      format '%-34s', record.creditor_iban
    end

    def creditor_address
      format_multiline record.creditor_address
    end

    def debitor_account
      format '%-34s', record.debitor_account
    end

    def debitor_address
      format_multiline record.debitor_address
    end

    def message
      format_multiline record.message
    end

    def reference_type
      record.reference_type
    end

    def reference
      format '%-27s', record.reference
    end

    def esr_member_id
      format '%-9s', record.esr_member_id
    end

    def format_multiline(lines)
      lines_string = StringIO.new
      4.times do |index|
        lines_string.write format('%-35s', lines[index])
      end
      lines_string.rewind
      lines_string.read
    end
  end
end
