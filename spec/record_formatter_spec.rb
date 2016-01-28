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

  around do |example|
    Timecop.travel(Date.new(2016, 1, 10)) do
      example.call
    end
  end

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
         debitor_bank_clearing_number creation_date creditor_bank_clearing_number
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
    it 'calls file.processing_type' do
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

    it 'uses LSVplus::FormattingHelper to format it' do
      expect(LSVplus::FormattingHelper).to receive(:date).with(value).and_return('value')
      expect(instance.processing_date).to eq('value')
    end
  end

  describe '#creditor_bank_clearing_number' do
    let(:value) { Date.today }
    before do
      allow(record).to receive(:creditor_bank_clearing_number).and_return(value)
    end

    it 'calls record.creditor_bank_clearing_number' do
      expect(record).to receive(:creditor_bank_clearing_number).and_return(value)
      instance.creditor_bank_clearing_number
    end

    it 'uses LSVplus::FormattingHelper to format it' do
      expect(LSVplus::FormattingHelper).to receive(:clearing_number).with(value).and_return('value')
      expect(instance.creditor_bank_clearing_number).to eq('value')
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

  describe '#debitor_bank_clearing_number' do
    let(:value) { Date.today }
    before do
      allow(record).to receive(:debitor_bank_clearing_number).and_return(value)
    end

    it 'calls record.debitor_bank_clearing_number' do
      expect(record).to receive(:debitor_bank_clearing_number).and_return(value)
      instance.debitor_bank_clearing_number
    end

    it 'uses LSVplus::FormattingHelper to format it' do
      expect(LSVplus::FormattingHelper).to receive(:clearing_number).with(value).and_return('value')
      expect(instance.debitor_bank_clearing_number).to eq('value')
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
      expect(LSVplus::FormattingHelper).to receive(:index).with(index).and_return('value')
      expect(instance.record_number).to eq('value')
    end
  end

  describe '#lsv_identification' do
    it 'calls file.lsv_identification' do
      expect(file).to receive(:lsv_identification).and_return('value')
      expect(instance.lsv_identification).to eq('value')
    end
  end

  describe '#currency' do
    it 'calls file.currency' do
      expect(file).to receive(:currency).and_return('value')
      expect(instance.currency).to eq('value')
    end
  end

  describe '#amount' do
    let(:value) { 1234 }
    before do
      allow(record).to receive(:amount).and_return(value)
    end

    it 'calls record.amount' do
      expect(record).to receive(:amount).and_return(value)
      instance.amount
    end

    it 'uses LSVplus::FormattingHelper to format it' do
      expect(LSVplus::FormattingHelper).to receive(:amount).with(value).and_return('value')
      expect(instance.amount).to eq('value')
    end
  end

  describe '#creditor_iban' do
    let(:value) { 1234 }
    before do
      allow(record).to receive(:creditor_iban).and_return(value)
    end

    it 'calls record.creditor_iban' do
      expect(record).to receive(:creditor_iban).and_return(value)
      instance.creditor_iban
    end

    it 'uses LSVplus::FormattingHelper to format it' do
      expect(LSVplus::FormattingHelper).to receive(:account).with(value).and_return('value')
      expect(instance.creditor_iban).to eq('value')
    end
  end

  describe '#creditor_address' do
    let(:value) { 1234 }
    before do
      allow(record).to receive(:creditor_address).and_return(value)
    end

    it 'calls record.creditor_address' do
      expect(record).to receive(:creditor_address).and_return(value)
      instance.creditor_address
    end

    it 'uses LSVplus::FormattingHelper to format it' do
      expect(LSVplus::FormattingHelper).to receive(:multiline).with(value).and_return('value')
      expect(instance.creditor_address).to eq('value')
    end
  end

  describe '#debitor_account' do
    let(:value) { 1234 }
    before do
      allow(record).to receive(:debitor_account).and_return(value)
    end

    it 'calls record.debitor_account' do
      expect(record).to receive(:debitor_account).and_return(value)
      instance.debitor_account
    end

    it 'uses LSVplus::FormattingHelper to format it' do
      expect(LSVplus::FormattingHelper).to receive(:account).with(value).and_return('value')
      expect(instance.debitor_account).to eq('value')
    end
  end

  describe '#debitor_address' do
    let(:value) { 1234 }
    before do
      allow(record).to receive(:debitor_address).and_return(value)
    end

    it 'calls record.debitor_address' do
      expect(record).to receive(:debitor_address).and_return(value)
      instance.debitor_address
    end

    it 'uses LSVplus::FormattingHelper to format it' do
      expect(LSVplus::FormattingHelper).to receive(:multiline).with(value).and_return('value')
      expect(instance.debitor_address).to eq('value')
    end
  end

  describe '#message' do
    let(:value) { 1234 }
    before do
      allow(record).to receive(:message).and_return(value)
    end

    it 'calls record.message' do
      expect(record).to receive(:message).and_return(value)
      instance.message
    end

    it 'uses LSVplus::FormattingHelper to format it' do
      expect(LSVplus::FormattingHelper).to receive(:multiline).with(value).and_return('value')
      expect(instance.message).to eq('value')
    end
  end

  describe '#reference_type' do
    it 'calls record.reference_type' do
      expect(record).to receive(:reference_type).and_return('value')
      expect(instance.reference_type).to eq('value')
    end
  end

  describe '#reference' do
    before do
      allow(record).to receive(:reference).and_return('value')
    end

    it 'calls record.reference' do
      expect(record).to receive(:reference).and_return('1' * 27)
      expect(instance.reference).to eq('1' * 27)
    end

    it 'fills up the missing chars with spaces' do
      expect(instance.reference).to eq('value                      ')
    end
  end

  describe '#esr_member_id' do
    before do
      allow(record).to receive(:esr_member_id).and_return('value')
    end

    it 'calls record.esr_member_id' do
      expect(record).to receive(:esr_member_id).and_return('1' * 9)
      expect(instance.esr_member_id).to eq('1' * 9)
    end

    it 'fills up the missing chars with spaces' do
      expect(instance.esr_member_id).to eq('value    ')
    end
  end
end
