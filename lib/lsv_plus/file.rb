require 'lsv_plus/errors'
require 'lsv_plus/base_container'
require 'lsv_plus/record_formatter'
require 'lsv_plus/total_record_formatter'

module LSVplus
  class File < LSVplus::BaseContainer
    class InvalidCreatorIdentification < LSVplus::Errors::InvalidAttribute
      @@attribute = :creator_identification
    end
    class InvalidLSVIdentification < LSVplus::Errors::InvalidAttribute
      @@attribute = :lsv_identification
    end

    ATTRIBUTES = %i(processing_type creation_date creator_identification currency lsv_identification)
    FIVE_CHARS_UPPERCASE = /\A[A-Z0-9]{5}\z/

    attr_reader(*ATTRIBUTES)

    def add_record(record)
      records << record
    end

    def records
      @records ||= []
    end

    def to_s
      records_as_string + total_record
    end

    def records_as_string
      output = StringIO.new
      records.each_with_index do |record, index|
        index += 1
        output.write RecordFormatter.call(self, record, index)
      end
      output.rewind
      output.read
    end

    def total_record
      TotalRecordFormatter.call(self)
    end

    def total
      records.inject(BigDecimal.new(0)) { |sum, record| sum + record.amount }
    end

    def validate(attributes)
      super(attributes)
      validate_creator_identification(attributes)
      validate_lsv_identification(attributes)
    end

    def validate_creator_identification(attributes)
      unless attributes[:creator_identification] =~ FIVE_CHARS_UPPERCASE
        raise InvalidCreatorIdentification, "Does not match #{FIVE_CHARS_UPPERCASE}"
      end
    end

    def validate_lsv_identification(attributes)
      unless attributes[:lsv_identification] =~ FIVE_CHARS_UPPERCASE
        raise InvalidLSVIdentification, "Does not match #{FIVE_CHARS_UPPERCASE}"
      end
    end
  end
end
