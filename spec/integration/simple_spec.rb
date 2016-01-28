require 'bigdecimal'
require 'lsv-plus'

RSpec.describe 'Simple LSV+ file' do
  let(:record_type) { '875' }
  let(:version) { '0' }
  let(:processing_type) { 'P' }
  let(:processing_date) { '20160115' }
  let(:creditor_bank_clearing_number) { '1337 ' }
  let(:creation_date) { '20160105' }
  let(:debitor_bank_clearing_number) { '42   ' }
  let(:creator_identification) { 'YOLO1' }
  let(:record_number) { '0000001' }
  let(:lsv_identification) { 'YOLO1' }
  let(:currency) { 'CHF' }
  let(:amount) { '000001337,42' }
  let(:creditor_iban) { 'CH9300762011623852957             ' }
  let(:creditor_address) do
    'Fancy AG                           '\
    'Funnystreet 42                     '\
    '                                   '\
    '                                   '
  end
  let(:debitor_account) { '123.456-78XY                      ' }
  let(:debitor_address) do
    'Debit AG                           '\
    'Other Street 1337                  '\
    'Somewhere City                     '\
    '                                   '
  end
  let(:message) do
    'Invoice 133 via BDD                '\
    '                                   '\
    '                                   '\
    '                                   '
  end
  let(:reference_type) { 'A' }
  let(:reference) { '200002000000004443332000061' }
  let(:esr_member_id) { '133742   ' }
  let(:record_string) do
    [
      record_type, version, processing_type, processing_date,
      debitor_bank_clearing_number, creation_date, creditor_bank_clearing_number,
      creator_identification, record_number, lsv_identification,
      currency, amount,
      creditor_iban, creditor_address,
      debitor_account, debitor_address,
      message, reference_type, reference, esr_member_id
    ].join('')
  end

  let(:total_record_type) { '890' }
  let(:total_record_version) { '0' }
  let(:total_amount) { '000001337,42' }
  let(:total_record) do
    [
      total_record_type, total_record_version,
      creation_date, creator_identification, record_number, currency, total_amount
    ].join('')
  end
  let(:valid_output) do
    [record_string, total_record].join('')
  end

  let(:file_attributes) do
    {
      creator_identification: creator_identification,
      currency: currency,
      processing_type: 'P',
      creation_date: Date.new(2016, 1, 5),
      lsv_identification: 'YOLO1',
    }
  end

  let(:record_attributes) do
    {
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
    }
  end

  it 'returns a valid LSV+ file' do
    Timecop.travel(Date.new(2016, 1, 10)) do
      file = LSVplus::File.new(file_attributes)
      file.add_record LSVplus::Record.new(record_attributes)
      expect(file.to_s).to eq(valid_output)
    end
  end
end
