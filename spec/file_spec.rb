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
end
