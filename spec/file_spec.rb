require 'lsv_plus/file'

RSpec.describe LSVplus::File do
  let(:attributes) do
    {
      creator_identification: 'YOLO1',
      currency: 'CHF',
      processing_type: 'P',
      creation_date: Date.new(2016, 1, 5),
      lsv_identification: 'YOLO1',
    }
  end
  let(:instance) { one_time_instance }

  def one_time_instance
    LSVplus::File.new(attributes)
  end

  describe 'validations' do
    describe '#creator_identification' do
      it 'it has to be all uppercase' do
        attributes[:creator_identification] = 'yolo1'
        expect { one_time_instance }.to raise_error(LSVplus::File::InvalidCreatorIdentification)
      end

      it 'has to be exactly 5 characters long' do
        attributes[:creator_identification] = 'ASD1'
        expect { one_time_instance }.to raise_error(LSVplus::File::InvalidCreatorIdentification)
        attributes[:creator_identification] = 'ASDASD'
        expect { one_time_instance }.to raise_error(LSVplus::File::InvalidCreatorIdentification)
        attributes[:creator_identification] = 'ASD12'
        expect { one_time_instance }.to_not raise_error
      end
    end

    describe '#lsv_identification' do
      it 'has to be all uppercase' do
        attributes[:lsv_identification] = 'yolo1'
        expect { one_time_instance }.to raise_error(LSVplus::File::InvalidLSVIdentification)
      end

      it 'has to be exactly 5 characters long' do
        attributes[:lsv_identification] = 'ASD1'
        expect { one_time_instance }.to raise_error(LSVplus::File::InvalidLSVIdentification)
        attributes[:lsv_identification] = 'ASDASD'
        expect { one_time_instance }.to raise_error(LSVplus::File::InvalidLSVIdentification)
        attributes[:lsv_identification] = 'ASD12'
        expect { one_time_instance }.to_not raise_error
      end
    end
  end

  describe '#add_record' do
    it 'adds a record to #records' do
      expect { instance.add_record('a') }.to change { instance.records }.from([]).to(%w(a))
    end
  end

  describe '#to_s' do
    it 'concatenates the records and the total record' do
      expect(instance).to receive(:records_as_string).and_return('records').ordered
      expect(instance).to receive(:total_record).and_return('total_record').ordered
      expect(instance.to_s).to eq('recordstotal_record')
    end
  end

  describe '#records_as_string' do
    it 'calls RecordFormatter for each record' do
      expect(LSVplus::RecordFormatter).to receive(:call).with(instance, 'record1', 1).once
      expect(LSVplus::RecordFormatter).to receive(:call).with(instance, 'record2', 2).once
      instance.add_record 'record1'
      instance.add_record 'record2'
      instance.records_as_string
    end

    it 'concatenates the records' do
      expect(LSVplus::RecordFormatter).to receive(:call).and_return('a', 'b').twice
      instance.add_record 'record1'
      instance.add_record 'record2'
      expect(instance.records_as_string).to eq('ab')
    end
  end

  describe '#total_record' do
    it 'calls TotalRecordFormatter' do
      expect(LSVplus::TotalRecordFormatter).to receive(:call).with(instance)
      instance.total_record
    end
  end

  describe '#total' do
    it 'sums record.amount' do
      instance.add_record OpenStruct.new(amount: BigDecimal.new('0.9'))
      instance.add_record OpenStruct.new(amount: 99)
      expect(instance.total).to eq(BigDecimal.new('99.9'))
    end
  end
end
