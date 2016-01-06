require 'lsv_plus/record_formatter'

RSpec.describe LSVplus::RecordFormatter do
  let(:file) do
    LSVplus::File.new(
      creator_identification: 'YOLO1',
      currency: 'CHF',
      processing_type: 'P',
      creation_date: Date.new(2016, 1, 5),
      lsv_identification: 'YOLO1',
    )
  end
  let(:record) do
    LSVplus::Record.new(
      processing_date: Date.new(2016, 1, 15),
      creditor_bank_clearing_number: 1337,
      amount: BigDecimal.new('1337.42'),
      debitor_bank_clearing_number: 42,
      creditor_iban: 'CH9300762011623852957',
      creditor_address: ['Fancy AG', 'Funnystreet 42'],
      debitor_account: '123.456-78XY',
      debitor_address: ['Debit AG', 'Other Street 1337', 'Somewhere City'],
      message: ['Invoice 133 via BDD'],
      reference_type: 'A',
      reference: '200002000000004443332000061',
      esr_member_id: '133742',
    )
  end
  let(:index) { 1 }
  let(:instance) { LSVplus::RecordFormatter.new(file, record, index) }

  describe '.call' do
    let(:record_formatter_double) { instance_double(LSVplus::RecordFormatter) }

    it 'initializes a new instance and calls `#call`' do
      expect(LSVplus::RecordFormatter).
        to receive(:new).with(record, file, index).and_return(record_formatter_double)
      expect(record_formatter_double).to receive(:call)
      LSVplus::RecordFormatter.call(record, file, index)
    end
  end

  describe '#call' do
    it 'returns all the formatted fields as string' do
      %i(type version processing_type processing_date
         creditor_bank_clearing_number creation_date debitor_bank_clearing_number
         creator_identification record_number lsv_identification
         currency amount
         creditor_iban creditor_address
         debitor_account debitor_address
         message reference_type reference esr_member_id).each do |meth|
           expect(instance).to receive(meth).with(no_args).and_call_original.ordered
         end
      expect(instance.call).to be_a(String)
    end
  end

  describe '#type' do
    it 'calls record.type' do
      expect(record).to receive(:type).and_return('value')
      expect(instance.type).to eq('value')
    end
  end

  describe '#version' do
    it 'calls record.version' do
      expect(record).to receive(:version).and_return('value')
      expect(instance.version).to eq('value')
    end
  end

  describe '#processing_type' do
    it 'calls record.processing_type' do
      expect(file).to receive(:processing_type).and_return('value')
      expect(instance.processing_type).to eq('value')
    end
  end

  describe '#processing_date' do
    let(:value) { Date.today }
    before do
      allow(record).to receive(:processing_date).and_return(value)
    end

    it 'calls record.processing_date' do
      expect(record).to receive(:processing_date).and_return(value)
      instance.processing_date
    end

    it 'uses LSVplus::FormattingHelper.date to format it' do
      expect(LSVplus::FormattingHelper).to receive(:date).with(value).and_return('value')
      expect(instance.processing_date).to eq('value')
    end
  end

  describe '#debitor_bank_clearing_number' do
    xit 'missing'
  end

  describe '#creation_date' do
    let(:value) { Date.today }
    before do
      allow(file).to receive(:creation_date).and_return(value)
    end

    it 'calls record.creation_date' do
      expect(file).to receive(:creation_date).and_return(value)
      instance.creation_date
    end

    it 'uses LSVplus::FormattingHelper.date to format it' do
      expect(LSVplus::FormattingHelper).to receive(:date).with(value).and_return('value')
      expect(instance.creation_date).to eq('value')
    end
  end
end
