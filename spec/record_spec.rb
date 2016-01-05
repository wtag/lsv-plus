require 'lsv_plus/record'

RSpec.describe LSVplus::Record do
  let(:attributes) do
    {
      processing_date: Date.today + 1,
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
    }
  end
  let(:instance) { LSVplus::Record.new(attributes) }

  describe 'defaults' do
    it 'has a type of 875' do
      expect(instance.type).to eq('875')
    end

    it 'has a version of 0' do
      expect(instance.version).to eq('0')
    end
  end

  describe 'validations' do
    describe '#processing_date' do
      it 'it prevents 31 days in future' do
        attributes[:processing_date] = Date.today + 31
        expect { instance }.to raise_error(LSVplus::Record::InvalidProcessingDate)
      end

      it 'allows 30 days in future' do
        attributes[:processing_date] = Date.today + 30
        expect { instance }.to_not raise_error
      end

      it 'prevents 11 days in past' do
        attributes[:processing_date] = Date.today - 11
        expect { instance }.to raise_error(LSVplus::Record::InvalidProcessingDate)
      end

      it 'allows 10 days in past' do
        attributes[:processing_date] = Date.today - 10
        expect { instance }.to_not raise_error
      end
    end

    describe '#amount' do
      it "prevents amounts higher than 99'999'999.99" do
        attributes[:amount] = BigDecimal.new('99_999_999.99') + BigDecimal.new('0.01')
        expect { instance }.to raise_error(LSVplus::Record::InvalidAmount)
      end
    end
  end
end
