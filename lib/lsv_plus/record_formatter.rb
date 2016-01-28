require 'lsv_plus/formatting_helper'

module LSVplus
  class RecordFormatter
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
        debitor_bank_clearing_number, creation_date, creditor_bank_clearing_number,
        creator_identification, record_number, lsv_identification,
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
      LSVplus::FormattingHelper.date record.processing_date
    end

    def creditor_bank_clearing_number
      LSVplus::FormattingHelper.clearing_number record.creditor_bank_clearing_number
    end

    def creation_date
      LSVplus::FormattingHelper.date file.creation_date
    end

    def debitor_bank_clearing_number
      LSVplus::FormattingHelper.clearing_number record.debitor_bank_clearing_number
    end

    def creator_identification
      file.creator_identification
    end

    def record_number
      LSVplus::FormattingHelper.index @index
    end

    def lsv_identification
      file.lsv_identification
    end

    def currency
      file.currency
    end

    def amount
      LSVplus::FormattingHelper.amount record.amount
    end

    def creditor_iban
      LSVplus::FormattingHelper.account record.creditor_iban
    end

    def creditor_address
      LSVplus::FormattingHelper.multiline record.creditor_address
    end

    def debitor_account
      LSVplus::FormattingHelper.account record.debitor_account
    end

    def debitor_address
      LSVplus::FormattingHelper.multiline record.debitor_address
    end

    def message
      LSVplus::FormattingHelper.multiline record.message
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
  end
end
