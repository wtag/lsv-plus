require 'lsv_plus/base_container'
require 'lsv_plus/errors'

module LSVplus
  class Record < LSVplus::BaseContainer
    class InvalidProcessingDate < LSVplus::Errors::InvalidAttribute
      @@attribute = :processing_date
    end
    class InvalidAmount < LSVplus::Errors::InvalidAttribute
      @@attribute = :amount
    end

    ATTRIBUTES = %i(
      type version
      creditor_bank_clearing_number creditor_iban creditor_address
      debitor_bank_clearing_number debitor_account debitor_address
      amount message processing_date
      reference_type reference esr_member_id
    )

    TYPE = '875'
    VERSION = '0'
    MAX_AMOUNT = BigDecimal.new('99_999_999.99')
    PROCESSING_MAX_IN_FUTURE = 30
    PROCESSING_MAX_IN_PAST = 10

    attr_reader(*ATTRIBUTES)

    def initialize(attributes)
      attributes = attributes.merge type: TYPE, version: VERSION
      validate attributes
      super attributes
    end

    def validate(attributes)
      validate_presence_of_required_attributes(attributes)
      validate_processing_date(attributes)
      validate_amount(attributes)
    end

    def validate_processing_date(attributes)
      if Date.today + PROCESSING_MAX_IN_FUTURE < attributes[:processing_date]
        raise InvalidProcessingDate, "Max #{PROCESSING_MAX_IN_FUTURE} days in future"
      end
      if Date.today - PROCESSING_MAX_IN_PAST > attributes[:processing_date]
        raise InvalidProcessingDate, "Max #{PROCESSING_MAX_IN_PAST} days in past"
      end
    end

    def validate_amount(attributes)
      if attributes[:amount] > MAX_AMOUNT
        raise InvalidAmount, "Must not be higher than #{MAX_AMOUNT}"
      end
    end

    def validate_presence_of_required_attributes(attributes)
      ATTRIBUTES.each do |attribute|
        raise LSVplus::Errors::MissingAttribute, attribute unless attributes.key?(attribute)
      end
    end
  end
end
