require 'lsv_plus/base_container'
require 'lsv_plus/record_formatter'
require 'lsv_plus/total_record_formatter'

module LSVplus
  class File < LSVplus::BaseContainer
    ATTRIBUTES = %i(processing_type creation_date creator_identification currency lsv_identification)
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
  end
end
