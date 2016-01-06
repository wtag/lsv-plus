require 'lsv_plus/total_record_formatter'

RSpec.describe LSVplus::TotalRecordFormatter do
  let(:file) do
    LSVplus::File.new(
      creator_identification: 'YOLO1',
      currency: 'CHF',
      processing_type: 'P',
      creation_date: Date.new(2016, 1, 5),
      lsv_identification: 'YOLO1',
    )
  end
  let(:instance) { LSVplus::TotalRecordFormatter.new(file) }

  describe '.call' do
    let(:total_record_formatter_double) { instance_double(LSVplus::TotalRecordFormatter) }

    it 'initializes a new instance and calls `#call`' do
      expect(LSVplus::TotalRecordFormatter).
        to receive(:new).with(file).and_return(total_record_formatter_double)
      expect(total_record_formatter_double).to receive(:call)
      LSVplus::TotalRecordFormatter.call(file)
    end
  end

  describe '#call' do
    it 'returns all the formatted fields as string' do
      %i(creation_date creator_identification record_number currency total_amount).each do |meth|
        expect(instance).to receive(meth).with(no_args).and_call_original.ordered
      end
      expect(instance.call).to be_a(String)
    end
  end

  describe '#creation_date' do
    let(:value) { Date.today }
    before do
      allow(file).to receive(:creation_date).and_return(value)
    end

    it 'calls file.creation_date' do
      expect(file).to receive(:creation_date).and_return(value)
      instance.creation_date
    end

    it 'uses LSVplus::FormattingHelper to format it' do
      expect(LSVplus::FormattingHelper).to receive(:date).with(value).and_return('value')
      expect(instance.creation_date).to eq('value')
    end
  end

  describe '#creator_identification' do
    it 'calls file.creator_identification' do
      expect(file).to receive(:creator_identification).and_return('value')
      expect(instance.creator_identification).to eq('value')
    end
  end

  describe '#record_number' do
    it 'uses LSVplus::FormattingHelper to format it' do
      allow(file).to receive(:records).and_return([1, 2, 3])
      expect(LSVplus::FormattingHelper).to receive(:index).with(3).and_return('value')
      expect(instance.record_number).to eq('value')
    end
  end

  describe '#currency' do
    it 'calls file.currency' do
      expect(file).to receive(:currency).and_return('value')
      expect(instance.currency).to eq('value')
    end
  end

  describe '#total_amount' do
    let(:value) { 1234 }
    before do
      allow(file).to receive(:total).and_return(value)
    end

    it 'calls file.total_amount' do
      expect(file).to receive(:total).and_return(value)
      instance.total_amount
    end

    it 'uses LSVplus::FormattingHelper to format it' do
      expect(LSVplus::FormattingHelper).to receive(:amount).with(value).and_return('value')
      expect(instance.total_amount).to eq('value')
    end
  end
end
