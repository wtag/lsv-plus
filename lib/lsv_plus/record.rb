require 'lsv_plus/base_container'

module LSVplus
  class Record < LSVplus::BaseContainer
    TYPE = '875'
    VERSION = '0'

    attr_reader :type, :version
    attr_reader :creditor_bank_clearing_number, :creditor_iban, :creditor_address
    attr_reader :debitor_bank_clearing_number, :debitor_account, :debitor_address
    attr_reader :amount, :message, :processing_date
    attr_reader :reference_type, :reference, :esr_member_id

    def initialize(attributes)
      super attributes.merge type: TYPE, version: VERSION
    end
  end
end
